require 'rubygems'
require 'mechanize'

module Purevolume
  VERSION = '0.1.1'
  
  class Client
    SITE      = 'http://www.purevolume.com'
    LOGIN     = '/login'
    POSTS     = '/dashboard?s=posts&tab='
    ADD       = 'add_post'
    LIST      = 'posts'
    CATEGORY  = 'General'
    SUCCESS   = 'div.success_message'
    DASHBOARD = '/dashboard'
    
    attr_reader   :valid
  
    def initialize username, password
      @agent      = WWW::Mechanize.new
      @username   = username
      @password   = password
      # Make sure I need these!
      @dashboard  = @type = @profile = @blog = @name = nil
      @valid      = authenticated?
    end

    def can_post?
      !add_post_page.search(   "form[action='#{POSTS}#{ADD}']" ).empty?
    end
    
    def login_page?
      !login_page.search(      "form[action='#{LOGIN}']"       ).empty?
    end
    
    def post title, body
      response                = false
      if post_form            = add_post_page.forms_with( :action =>  POSTS + ADD ).first
        category              = post_form.field_with( :name => 'category' )
        category.options.each { |opt| opt.select if opt.value == CATEGORY } if category
        post_form.blog_title  = title
        post_form.blog_post   = body
        response              = !@agent.submit( post_form, post_form.buttons.first ).search( SUCCESS ).empty?
      end
      response
    end
    
    def profile_url
      @dashboard.search(".dashboard_link_dropdown_item a").each do |link|
        @profile = link['href'] if link.content == "Profile"
      end
      @profile
    end

    def profile_name
      @name = @dashboard.at( "a[href='#{DASHBOARD}'] span" ).content.sub( "Logged in as ", "" ) rescue nil
    end
    
    def account_info
      if @valid
        {"rsp"=>{"site"=>{ "name"=>@name, "blog"=>@blog, "type"=>@type , "profile"=>@profile }, "stat"=>"ok"}}
      end
    end
    
  private
    
    def authenticated?
      if login_form         = login_page.forms_with( :action => LOGIN ).first
        login_form.username = @username
        login_form.password = @password
        response_page       = @agent.submit( login_form )
        @dashboard          = response_page if response_page.uri.to_s == SITE + DASHBOARD
      end
      # Raise if you can't login?
      can_post?
    end
    
    def add_post_page;       @agent.get( SITE + POSTS + ADD );    end
    def login_page;          @agent.get( SITE + LOGIN );          end
    
  end
end
