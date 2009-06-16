require "test/unit"
require "purevolume"
require "mocha"

class Purevolume::Client
  attr_accessor   :add_post_pg, :valid, :dashboard, :agent
  public          :can_post?, :profile_url, :profile_name, :profile_type, \
                  :profile_blog_url, :latest_post_id, :success_response, :error_response
end

class TestPurevolume < Test::Unit::TestCase

  # IN FUTURE VERSIONS
  # Specify a category in listener posts
  # Post an image in artist posts
  # Add Post to billboard or promo Area
  # Reading in Posts

  def setup
    artist          = 'artist'
    listener        = 'listener'
    password        = 'password'

    @artist_good    = Purevolume::Client.new( artist,   password )
    @listener_good  = Purevolume::Client.new( listener, password )
    @artist_bad     = Purevolume::Client.new( artist,   'bad'    )

    @title          = "My Title"
    @body           = "Body Text"
    @post_id        = "228991"

    @listener_name  = "Glue Listener"
    @listener_type  = :listener
    @listener_url   = "http://www.purevolume.com/listeners/GlueListener"
    @listener_blog  = "http://www.purevolume.com/listeners/GlueListener/blog"

    @artist_name    = "Glue Artist"
    @artist_type    = :artist
    @artist_url     = "http://www.purevolume.com/GlueArtist"
    @artist_blog    = "http://www.purevolume.com/GlueArtist/posts"

    @error_response = { "rsp" => { "err" => {
                      "msg"   => "Post was unsuccessful.",
                      "title" => @title },
                      "stat"  => "fail" }}

    @error_response2= { "rsp" => { "err" => {
                      "msg"   => "Post was unsuccessful.",
                      "title" => "" },
                      "stat"  => "fail" }}

    empty_page                = "<html><body></body></html>"
    post_page                 = "<html><body><form action='#{Purevolume::Client::POSTS}#{Purevolume::Client::ADD}'><select name='category'><option value='#{Purevolume::Client::GENERAL}'>General</option><option value='invalid'>Invalid</option></select><input name='blog_title' /><input name='blog_post' /></form></body></html>"
    dashboard_artist_page     = "<html><body><a href='/dashboard'><span>Logged in as Glue Artist</span></a><div class='dashboard_link_dropdown_item'><a href='/GlueArtist'>Profile</a></div></body></html>"
    dashboard_listener_page   = "<html><body><a href='/dashboard'><span>Logged in as Glue Listener</span></a><div class='dashboard_link_dropdown_item'><a href='/listeners/GlueListener'>Profile</a></div></body></html>"
    post_list_page            = "<html><body><div id='posts'><table><tr><td><strong><a href='dashboard?s=posts&tab=posts&action=edit&id=#{@post_id}'>#{@title}</strong></td></tr></table></body></html>"
    success_page              = "<html><body><div class='success_message'></div></body></html>"

    @bad_page                 = setup_mock_mechanize empty_page
    @post_page                = setup_mock_mechanize post_page
    @artist_dashboard         = setup_mock_mechanize dashboard_artist_page
    @listener_dashboard       = setup_mock_mechanize dashboard_listener_page
    @list_page                = setup_mock_mechanize post_list_page
    @success_page             = setup_mock_mechanize success_page
  end

  def setup_mock_mechanize page
    WWW::Mechanize::Page.new(nil, {'content-type' => 'text/html'}, page, 200)
  end

  def test_can_not_post
    account = @artist_bad
    account.stubs(:authenticate ).returns( false )
    account.stubs(:add_post_page).returns( account.add_post_pg = @bad_page )
    assert_equal false,                    account.can_post?
  end

  def test_can_post
    account = @artist_good
    account.stubs(:authenticate ).returns( true )
    account.stubs(:add_post_page).returns( account.add_post_pg = @post_page )
    assert_equal true,                     account.can_post?
  end

  def test_artist_account_valid
    account = @artist_good
    account.stubs(:authenticate ).returns( account.valid = true )
    assert_equal true,                     account.valid_user?
  end

  def test_listener_account_valid
    account = @listener_good
    account.stubs(:authenticate ).returns( account.valid = true )
    assert_equal true,                     account.valid_user?
  end

  def test_account_invalid
    account = @artist_bad
    account.stubs(:authenticate ).returns( account.valid = false )
    assert_equal false,                    account.valid_user?
  end

  def test_artist_account_url
    account = @artist_good
    account.stubs(:authenticate ).returns( account.dashboard = @artist_dashboard )
    account.authenticate
    assert_equal @artist_url,              account.profile_url
  end

  def test_listener_account_url
    account = @listener_good
    account.stubs(:authenticate ).returns( account.dashboard = @listener_dashboard )
    account.authenticate
    assert_equal @listener_url,            account.profile_url
  end
  
  def test_bad_account_url
    account = @artist_bad
    account.stubs(:authenticate ).returns( account.valid = false )
    assert_raise NoMethodError do
      account.profile_url
    end
  end

  def test_artist_account_name
    account = @artist_good
    account.stubs(:authenticate ).returns( account.dashboard = @artist_dashboard )
    account.authenticate
    assert_equal @artist_name,             account.profile_name
  end

  def test_listener_account_name
    account = @listener_good
    account.stubs(:authenticate ).returns( account.dashboard = @listener_dashboard )
    account.authenticate
    assert_equal @listener_name,           account.profile_name
  end

  def test_bad_account_name
    account = @artist_bad
    account.stubs(:authenticate ).returns( false )
    account.authenticate
    assert_equal nil,                      account.profile_name
  end

  def test_listener_account_type
    account = @listener_good
    account.stubs(:authenticate ).returns( account.dashboard = @listener_dashboard )
    account.authenticate
    assert_equal @listener_type,           account.profile_type
  end

  def test_artist_account_type
    account = @artist_good
    account.stubs(:authenticate ).returns( account.dashboard = @artist_dashboard )
    account.authenticate
    assert_equal @artist_type,             account.profile_type
  end

  def test_bad_account_type
    account = @artist_bad
    account.stubs(:authenticate ).returns( false )
    account.authenticate
    assert_raise NoMethodError do
      account.profile_type
    end
  end

  def test_listener_blog_url
    account = @listener_good
    account.stubs(:authenticate ).returns( account.dashboard = @listener_dashboard )
    account.authenticate
    assert_equal @listener_blog,           account.profile_blog_url
  end

  def test_artist_blog_url
    account = @artist_good
    account.stubs(:authenticate ).returns( account.dashboard = @artist_dashboard )
    account.authenticate
    assert_equal @artist_blog,             account.profile_blog_url
  end

  def test_bad_blog_url
    account = @artist_bad
    account.stubs(:authenticate ).returns( false )
    account.authenticate
    assert_raise NoMethodError do
      account.profile_blog_url
    end
  end

  def test_artist_account_info
    account = @artist_good
    account.stubs(:authenticate ).returns( account.dashboard = @artist_dashboard )
    account.stubs(:authenticate ).returns( account.valid     = true )
    account.authenticate
    expected = { "rsp" => { "site" => {
            "name"     => @artist_name,
            "profile"  => @artist_url,
            "type"     => @artist_type,
            "blog"     => @artist_blog },
            "stat"     => "ok" }}
    assert_equal expected,                 account.account_info
  end

  def test_listener_account_info
    account = @listener_good
    account.stubs(:authenticate ).returns( account.dashboard = @listener_dashboard )
    account.stubs(:authenticate ).returns( account.valid     = true )
    account.authenticate 
    expected = { "rsp" => { "site" => {
            "name"     => @listener_name,
            "profile"  => @listener_url,
            "type"     => @listener_type,
            "blog"     => @listener_blog },
            "stat"     => "ok" }}
    assert_equal expected,                 account.account_info
  end

  def test_bad_artist_account_info
    account = @artist_bad
    account.stubs(:authenticate ).returns( false )
    account.authenticate
    assert_equal nil,                      account.account_info
  end

  def test_artist_latest_post_id
    account = @artist_good
    account.agent.stubs(:get).returns(     @list_page )
    account.stubs(:authenticate ).returns( account.valid = true )
    account.authenticate
    assert_equal @post_id,                 account.latest_post_id
  end

  def test_listener_latest_post_id
    account = @listener_good
    account.agent.stubs(:get).returns(     @list_page )
    account.stubs(:authenticate ).returns( account.valid = true )
    account.authenticate
    assert_equal @post_id,                 account.latest_post_id
  end

  def test_bad_account_latest_post_id
    account = @artist_bad
    account.agent.stubs(:get).returns(     @bad_page )
    account.stubs(:authenticate ).returns( false )
    account.authenticate
    assert_raise NoMethodError do
      account.latest_post_id
    end
  end

  def test_artist_response_success
    account  = @artist_good
    account.stubs(:authenticate ).returns( account.dashboard = @artist_dashboard )
    account.stubs(:authenticate ).returns( account.valid     = true )
    account.agent.stubs( :get   ).returns( @list_page )
    pid      = account.latest_post_id
    url      = "#{@artist_blog}/#{pid}"
    expected = { "rsp" => { "post" => {
               "title" => "#{@title}", 
               "url"   => "#{url}", 
               "id"    => "#{pid}"}, 
               "stat"  => "ok" }}
    puts @error_response.inspect

    assert_equal expected,                 account.success_response( @title )
  end

  def test_listener_response_success
    account  =  @listener_good
    account.stubs(:authenticate ).returns( account.dashboard = @listener_dashboard )
    account.stubs(:authenticate ).returns( account.valid     = true )
    account.agent.stubs(   :get ).returns( @list_page )    
    pid      = account.latest_post_id
    url      = "#{@listener_blog}/#{pid}"
    expected = { "rsp" => { "post" => {
               "title" => "#{@title}", 
               "url"   => "#{url}", 
               "id"    => "#{pid}"}, 
               "stat"  => "ok" }}

    assert_equal expected,                 @listener_good.success_response( @title )
  end

  def test_account_response_error
    expected = @error_response
               
    assert_equal expected,                 @artist_good.error_response( @title )
    assert_equal expected,                 @artist_bad.error_response( @title )
    assert_equal expected,                 @listener_good.error_response( @title )
  end

  def test_bad_account_response_success
    account  =  @artist_bad
    account.stubs(:authenticate ).returns( account.valid      = false )
    account.agent.stubs(   :get ).returns( @bad_page )
    assert_raise NoMethodError do
      account.success_response(@title)
    end
  end

  def test_post_success_artist
    account     = @artist_good

    account.stubs(:authenticate ).returns( account.dashboard   = @artist_dashboard )
    account.stubs(:authenticate ).returns( account.valid       = true )
    account.stubs(:add_post_page).returns( account.add_post_pg = @post_page )
    account.agent.stubs(:submit ).returns( @success_page )
    account.agent.stubs(   :get ).returns( @list_page )

    actual      = account.post( @title, @body )
    pid         = actual['rsp']['post']['id']
    blog        = @artist_blog

    assert        pid
    assert        actual.is_a?(Hash)
    assert_match  pid,                     actual['rsp']['post']['url']
    assert_match  blog,                    actual['rsp']['post']['url']
    assert_equal  "#{blog}/#{pid}",        actual['rsp']['post']['url']
    assert_equal  @title,                  actual['rsp']['post']['title']
    assert_equal  "ok",                    actual['rsp']['stat']
  end

  def test_post_success_listener
    account     = @listener_good

    account.stubs(:authenticate ).returns( account.dashboard   = @listener_dashboard )
    account.stubs(:authenticate ).returns( account.valid       = true )
    account.stubs(:add_post_page).returns( account.add_post_pg = @post_page )
    account.agent.stubs(:submit ).returns( @success_page )
    account.agent.stubs(   :get ).returns( @list_page )

    actual      = account.post( @title, @body )
    pid         = actual['rsp']['post']['id']
    blog        = @listener_blog

    assert        pid
    assert        actual.is_a?(Hash)
    assert_match  pid,                     actual['rsp']['post']['url']
    assert_match  blog,                    actual['rsp']['post']['url']
    assert_equal  "#{blog}/#{pid}",        actual['rsp']['post']['url']
    assert_equal  @title,                  actual['rsp']['post']['title']
    assert_equal  "ok",                    actual['rsp']['stat']
  end

  def test_post_fail_bad_account
    account = @artist_bad
    account.stubs(:authenticate ).returns( account.valid       = false )
    account.stubs(:add_post_page).returns( account.add_post_pg = @bad_page )
    assert_equal @error_response,          account.post( @title, @body )
  end

  def test_artist_post_fail_with_blank_title
    account = @artist_good
    account.stubs(:authenticate ).returns( account.dashboard   = @artist_dashboard )
    account.stubs(:authenticate ).returns( account.valid       = true )
    account.stubs(:add_post_page).returns( account.add_post_pg = @post_page )
    account.agent.stubs(:submit ).returns( @bad_page )
    assert_equal @error_response2,         account.post( "", @body )
  end

  def test_listener_post_fail_with_blank_title
    account = @listener_good
    account.stubs(:authenticate ).returns( account.dashboard   = @listener_dashboard )
    account.stubs(:authenticate ).returns( account.valid       = true )
    account.stubs(:add_post_page).returns( account.add_post_pg = @post_page )
    account.agent.stubs(:submit ).returns( @bad_page )
    assert_equal @error_response2,         account.post( "", @body )
  end

  def test_artist_post_fail_with_blank_body
    account = @artist_good
    account.stubs(:authenticate ).returns( account.dashboard   = @artist_dashboard )
    account.stubs(:authenticate ).returns( account.valid       = true )
    account.stubs(:add_post_page).returns( account.add_post_pg = @post_page )
    account.agent.stubs(:submit ).returns( @bad_page )
    assert_equal @error_response,          account.post( @title, "" )
  end

  def test_listener_post_fail_with_blank_body
    account = @listener_good
    account.stubs(:authenticate ).returns( account.dashboard   = @listener_dashboard )
    account.stubs(:authenticate ).returns( account.valid       = true )
    account.stubs(:add_post_page).returns( account.add_post_pg = @post_page )
    account.agent.stubs(:submit ).returns( @bad_page )
    assert_equal @error_response,          account.post( @title, "" )
  end

end
