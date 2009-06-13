require "test/unit"
require "purevolume"

class TestPurevolume < Test::Unit::TestCase

  # NEED TO TEST
  # Authenticated?
  # account_info
  
  # NEED TO ADD
  # Blog url
  # Type Detection
  # Response Hash
  
  # IN FUTURE VERSIONS
  # Ability to specify a category for a post
  # Posting to billboard or promo Area
  # Reading in Posts
  # Posting an image for artist posts

  def setup
    @artist         = 'glueartist'
    @listener       = 'gluelistener'
    @password       = 'password'
    @artist_good    = Purevolume::Client.new( @artist,   @password )
    @listener_good  = Purevolume::Client.new( @listener, @password )
    @artist_bad     = Purevolume::Client.new( @artist,   'bad'     )
    @title          = "My Title"
    @body           = "Body Text"
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
    assert_equal "/GlueArtist",             @artist_good.profile_url
  end

  def test_listener_account_url
    assert_equal "/listeners/GlueListener", @listener_good.profile_url
  end
  
  def test_artist_account_name
    assert_equal "Glue Artist",             @artist_good.profile_name
  end
  
  def test_listener_account_name
    assert_equal "Glue Listener",           @listener_good.profile_name
  end

end
