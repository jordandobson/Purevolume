require 'rubygems'
require 'mechanize'

module Purevolume
  VERSION = '0.1.1'

  class AuthError < StandardError; end
  # class PostError < StandardError; end
  # class HostError < StandardError; end
  # class TagsError < StandardError; end
  
  # TODO
  # * type of account
  # * Profile Page
  
  
  class Client
    SITE     = 'http://purevolume.com'
    LOGIN    = '/login'
    POSTS    = '/dashboard?s=posts&tab='
    ADD      = 'add_post'
    LIST     = 'posts'
    CATEGORY = 'General'
    
    attr_reader   :valid
  
    def initialize username, password
      @agent    = WWW::Mechanize.new
      @agent.user_agent_alias = 'Mac Safari'
      @username = username
      @password = password
      @valid    = authenticate
    end

  # private

    def can_post?
      !add_page.search(   "form[action='#{POSTS}#{ADD}']" ).empty?
    end
    
    def login_page?
      !login_page.search( "form[action='#{LOGIN}']"       ).empty?
    end
    
    def post title, body
      response = nil
      if post_form = add_page.forms_with( :action =>  POSTS + ADD ).first
        puts "POST FORM EXISTS"
        post_form.field_with( :name => 'category' ).options.each { |opt| opt.select if opt.value == CATEGORY } if post_form.field_with( :name => 'category' )
        post_form.blog_title = title
        
#         post_form.blog_t  = body
        page = @agent.submit(post_form)
        puts page.search("alert_message")
        puts "-------"
      end
      response
    end
    
    def authenticate
      if login_form         = login_page.forms_with( :action => LOGIN ).first
        login_form.username = @username
        login_form.password = @password
        @agent.submit         login_form
      end
      can_post?
    end
    
    def add_page;     @agent.get( SITE + POSTS + ADD );       end
    def login_page;   @agent.get( SITE + LOGIN );             end
    
    def posts_list_page
      # @agent.get(SITE+POSTS+LIST);
    end
  end
end
