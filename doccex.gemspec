$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "doccex/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "doccex"
  s.version     = Doccex::VERSION
  s.authors     = ["Les Nightingill"]
  s.email       = ["info@mustardseeddatabase.org"]
  s.homepage    = "http://www.mustardseeddatabase.org"
  s.summary     = "Lightweight Rails engine to emit MSWord documents"
  s.description = "Mounts as an engine in a Rails application"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 3.2.5"
  s.add_dependency "haml"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "capybara"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "rspec-rails", "~> 2.8.1"
end
