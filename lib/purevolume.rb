require 'rubygems'
require 'mechanize'

module Purevolume
  VERSION = '0.1.1'
  
  # TODO
  # * type of account
  # * Profile Page url
  
  
  class Client
    SITE     = 'http://purevolume.com'
    LOGIN    = '/login'
    POSTS    = '/dashboard?s=posts&tab='
    ADD      = 'add_post'
    LIST     = 'posts'
    CATEGORY = 'General'
    SUCCESS  = 'div.success_message'
    
    attr_reader   :valid
  
    def initialize username, password
      @agent    = WWW::Mechanize.new
      @agent.user_agent_alias = 'Mac Safari'
      @username = username
      @password = password
      @valid    = authenticate
      # @type     = nil
    end

    def can_post?
      !add_page.search(   "form[action='#{POSTS}#{ADD}']" ).empty?
    end
    
    def login_page?
      !login_page.search( "form[action='#{LOGIN}']"       ).empty?
    end
    
    def post title, body
      response = false
      if post_form = add_page.forms_with( :action =>  POSTS + ADD ).first
        category              = post_form.field_with( :name => 'category' )
        category.options.each { |opt| opt.select if opt.value == CATEGORY } if category
        post_form.blog_title  = title
        post_form.blog_post   = body
        response              = !@agent.submit( post_form, post_form.buttons.first ).search( SUCCESS ).empty?
      end
      response
    end
    
  private
    
    def authenticate
      if login_form         = login_page.forms_with( :action => LOGIN ).first
        login_form.username = @username
        login_form.password = @password
        @agent.submit         login_form
        # Consider checking for account URL type here?
      end
      can_post?
    end
    
    def add_page;     @agent.get( SITE + POSTS + ADD );       end
    def login_page;   @agent.get( SITE + LOGIN );             end
    
  end
end
