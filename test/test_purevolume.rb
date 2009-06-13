require "test/unit"
require "purevolume"

class TestPurevolume < Test::Unit::TestCase

  def setup
    @artist         = 'glueartist'
    @listener       = 'gluelistener'
    @password       = 'password'
    @artist_good    = Purevolume::Client.new( @artist,   @password )
    @listener_good  = Purevolume::Client.new( @listener, @password )
    @login_bad      = Purevolume::Client.new( @artist,    'bad'     )
  end

  def test_can_not_post
    assert_equal false, @login_bad.can_post?
  end

  def test_is_login_page
    assert_equal true, @artist_good.login_page?
  end

  def test_account_valid
    assert_equal  true, @artist_good.valid
  end
  
  def test_account_invalid
    assert_equal  false,  @login_bad.valid
  end
  
#   def test_post_success
#     assert_equal true, @listener_good.post("My Title", "Body Text")
#   end

end
