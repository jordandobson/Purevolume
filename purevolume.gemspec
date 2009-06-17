# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{purevolume}
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jordan Dobson"]
  s.date = %q{2009-06-16}
  s.default_executable = %q{purevolume}
  s.description = %q{The Purevolume gem enables posting to Purevolume.com using your email/login-name, password and your blog title & body content.}
  s.email = ["jordan.dobson@madebysquad.com"]
  s.executables = []
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.txt", "Rakefile", "bin/purevolume", "lib/purevolume.rb", "test/test_purevolume.rb"]
  s.has_rdoc = false
  s.homepage = %q{http://github.com/jordandobson/purevolume/tree/master}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{purevolume}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{The Purevolume gem enables posting to Purevolume.com using your email/login-name, password and your blog title & body content. You can also access some basic info about a users account.}
  s.test_files = ["test/test_purevolume.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<hoe>, [">= 1.8.3"])
    else
      s.add_dependency(%q<hoe>, [">= 1.8.3"])
    end
  else
    s.add_dependency(%q<hoe>, [">= 1.8.3"])
  end
end

