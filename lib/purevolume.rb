require 'rubygems'
require 'mechanize'

module Purevolume
  VERSION = '0.1.2'

  class Client
    SITE      = 'http://www.purevolume.com'
    LOGIN     = '/login'
    POSTS     = '/dashboard?s=posts&tab='
    ADD       = 'add_post'
    LIST      = 'posts'
    GENERAL   = 'General'
    SUCCESS   = 'div.success_message'
    DASHBOARD = '/dashboard'

    def initialize username, password
      @agent      = WWW::Mechanize.new
      @username   = username
      @password   = password
      @login_pg = @add_post_pg = @dashboard  = @profile_url = @blog_url = @type = @valid = nil
    end

    def valid_user?
      @valid || authenticate
    end

    def authenticate
      @login_pg || login_page
      login_form = @login_pg.forms_with( :action => LOGIN ).first
      
      if login_form
        login_form.username = @username
        login_form.password = @password
        response_page       = @agent.submit( login_form )
        @dashboard          = response_page if response_page.uri.to_s == "#{SITE}#{DASHBOARD}"
      end
      @valid = can_post?
    end

    def post title, body
      @add_post_pg || add_post_page
      post_form = @add_post_pg.forms_with( :action =>  "#{POSTS}#{ADD}" ).first
      
      if post_form
        category              = post_form.field_with( :name => 'category' )
        category.options.each { |opt| opt.select if opt.value == GENERAL } if category
        post_form.blog_title  = title
        post_form.blog_post   = body
        response              = !@agent.submit( post_form, post_form.buttons.first ).search( SUCCESS ).empty?
      end
      response ? success_response(title) : error_response(title)
    end

    def account_info
      { "rsp" => { "site" => {
        "name"     => profile_name,
        "profile"  => profile_url,
        "type"     => profile_type,
        "blog"     => profile_blog_url },
        "stat"     => "ok" }
      } if @valid
    end

  private
    def add_post_page;  @add_post_pg = @agent.get( "#{SITE}#{POSTS}#{ADD}" );    end
    def login_page;     @login_pg    = @agent.get( "#{SITE}#{LOGIN}" );          end

    def success_response title
      pid = latest_post_id
      url = "#{profile_blog_url}/#{pid}"
      { "rsp" => { "post" => {
        "title"    => title,
        "url"      => url,
        "id"       => pid    },
        "stat"     => "ok"   }
      }
    end

    def error_response title
      { "rsp" => { "err" => {
        "msg"      => "Post was unsuccessful.",
        "title"    => "#{title}" },
        "stat"     => "fail"     }
      }
    end

    def latest_post_id
      @agent.get( "#{SITE}#{POSTS}#{POSTS}" ).at("#posts table tr td strong a")['href'].sub(/.+id=/, '')
    end

    def profile_name
      @dashboard.at( "a[href='#{DASHBOARD}'] span" ).content.sub( "Logged in as ", "" ) rescue nil
    end

    def profile_url
      @dashboard.search(".dashboard_link_dropdown_item a").each do |link|
        return @profile_url = "#{SITE}#{link['href']}" if link.content == "Profile"
      end
    end

    def profile_type
      @profile_url || profile_url
      @type = @profile_url =~ /http:\/\/.*\/(\w*)\// ? $1.sub("listeners", "listener").to_sym : :artist
    end

    def profile_blog_url
      @profile_url || profile_url
      @type        || profile_type
      @blog_url = @profile_url + (@type == :listener ? "/blog" : "/posts")
    end

    def can_post?
      @add_post_pg || add_post_page
      !@add_post_pg.search( "form[action='#{POSTS}#{ADD}']" ).empty?
    end

  end
end
