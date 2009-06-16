= purevolume

* http://github.com/jordandobson/Purevolume/tree/master

== DESCRIPTION:

The Purevolume gem enables posting to Purevolume.com using your email/login-name, password and your blog title & body content. You can also access some basic info about a users account.

== FEATURES/PROBLEMS:

* Title & Body text is required 
* Provides info about an account:
  * Profile Name
  * Profile URL
  * Account Type (artist/listener)
  * Blog URL
* Can Check if login info is a valid user
* This Gem is throughly tested
* Image files are not yet implemented
* Listeners posts are defaulted to General Category
* Posting Only, Editing, Deleting & Reading in posts are included

== SYNOPSIS:

1. Instantiate your account

    * Provide the email and password
    
        account = Purevolume::Client.new( 'hello@gluenow.com', 'password' )
      
    * Or Provide login-name and password

        account = Purevolume::Client.new( 'glue', 'password' )
        
2. Get more info about the user's account & check if they are a valid user

    * Check if the user is valid
    
        account.valid_user?

    * Get some info about this account - and recieve a hash or nil back
    
        response = account.account_info
        
        response #=> {"rsp"=>{"site"=>{"name"=>"Glue Artist", "profile"=>"http://www.purevolume.com/GlueArtist", "type"=>:artist, "blog"=>"http://www.purevolume.com/GlueArtist/posts"}, "stat"=>"ok"}}
        
3. Post your Content

    * Both Title and Body are required - Set to a variable to check the response
    
        response = account.post("My Title", "My Body")

4. Get a success or error hash back

    * A Successful response would look like this
    
        response #=> {"rsp"=>{"post"=>{"title"=>"My Title", "url"=>"http://www.purevolume.com/GlueArtist/posts/228991", "id"=>"228991"}, "stat"=>"ok"}}
    
    * A Error response would look like this
    
        response #=> {"rsp"=>{"err"=>{"msg"=>"Post was unsuccessful.", "title"=>"My Title"}, "stat"=>"fail"}}
        
        
== REQUIREMENTS:

* Mechanize & Mocha (for tests)

== INSTALL:

* sudo gem install posterous -include-dependencies

== LICENSE:

(The MIT License)

Copyright (c) 2009 Jordan Dobson

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
