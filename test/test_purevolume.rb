require "test/unit"
require "purevolume"

class TestPurevolume < Test::Unit::TestCase

  # NEED TO TEST
  # Authenticated?
  
  # NEED TO ADD
  # Response Hash
  
  # IN FUTURE VERSIONS
  # Ability to specify a category for a post
  # Posting to billboard or promo Area
  # Reading in Posts
  # Posting an image for artist posts

  def setup
    artist         = 'glueartist'
    listener       = 'gluelistener'
    password       = 'password'

    @artist_good    = Purevolume::Client.new( artist,   password )
    @listener_good  = Purevolume::Client.new( listener, password )
    @artist_bad     = Purevolume::Client.new( artist,   'bad'     )

    @title          = "My Title"
    @body           = "Body Text"
    
    @listener_name  = "Glue Listener"
    @listener_type  = :listener
    @listener_url   = "http://www.purevolume.com/listeners/GlueListener"
    @listener_blog  = "http://www.purevolume.com/listeners/GlueListener/blog"
    
    @artist_name    = "Glue Artist"
    @artist_type    = :artist
    @artist_url     = "http://www.purevolume.com/GlueArtist"
    @artist_blog    = "http://www.purevolume.com/GlueArtist/posts"
  end

  def test_can_not_post
    assert_equal false,                     @artist_bad.can_post?
  end
  
  def test_can_post
    assert_equal true,                      @artist_good.can_post?
  end

  def test_is_login_page
    assert_equal true,                      @artist_good.login_page?
  end

  def test_account_valid
    assert_equal true,                      @artist_good.valid
  end
  
  def test_account_invalid
    assert_equal false,                     @artist_bad.valid
  end
  
  def test_post_success_artist
    assert_equal true,                      @artist_good.post( @title, @body )
  end
  
  def test_post_success_listener
    assert_equal true,                      @listener_good.post( @title, @body )
  end

  def test_artist_account_url
    assert_equal @artist_url,               @artist_good.profile_url
  end

  def test_listener_account_url
    assert_equal @listener_url,             @listener_good.profile_url
  end
  
  def test_artist_account_name
    assert_equal @artist_name,              @artist_good.profile_name
  end
  
  def test_listener_account_name
    assert_equal @listener_name,            @listener_good.profile_name
  end

  def test_bad_account_name
     assert_equal nil,                        @artist_bad.profile_name
  end
  
  def test_listener_account_type
    assert_equal @listener_type,            @listener_good.profile_type
  end
  
  def test_artist_account_type
    assert_equal @artist_type,              @artist_good.profile_type
  end

  def test_bad_account_type
    assert_raise NoMethodError do
      @artist_bad.profile_type
    end
  end

  def test_listener_blog_url
    assert_equal @listener_blog,            @listener_good.profile_blog_url
  end
  
  def test_artist_blog_url
    assert_equal @artist_blog,              @artist_good.profile_blog_url
  end

  def test_bad_blog_url
    assert_raise NoMethodError do
      @artist_bad.profile_blog_url
    end
  end

  
  def test_artist_account_info
    expected = { :rsp => { :site => { 
            :name     => @artist_name,
            :profile  => @artist_url, 
            :type     => @artist_type, 
            :blog     => @artist_blog }, 
            :stat     => "ok" }}
    assert_equal expected,                  @artist_good.account_info
  end
  
  def test_listener_account_info
    expected = { :rsp => { :site => { 
            :name     => @listener_name,
            :profile  => @listener_url, 
            :type     => @listener_type, 
            :blog     => @listener_blog }, 
            :stat     => "ok" }}
    assert_equal expected,                  @listener_good.account_info
  end
  
  def test_bad_artist_account_info
    assert_equal nil,                      @artist_bad.account_info
  end

end
