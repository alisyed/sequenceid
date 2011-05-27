# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sequenceid/version"

Gem::Specification.new do |s|
  s.name        = "sequenceid"
  s.version     = Sequenceid::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Syed Ali"]
  s.email       = ["info@7vals.com"]
  s.homepage    = ""
  s.summary     = %q{Create resource URL's starting from 1 for each SaaS company}
  s.description = %q{For SaaS applications, there are times when we dont want to show the resource id to the user since its being shared with multiple companies that have signed up. And for scenarios where we want the URL to show numbers and not worded URL's like what friendly_id provide, this is the gem for you! It'll create id's sequentially starting from 1 for each relation parent/nested resource relation definedi\n Feel free to get in touch for any specific questions until the help, support group and readme are not done at info@7vals.com \n http://www.7vals.com}

  s.rubyforge_project = "sequenceid"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
