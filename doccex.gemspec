$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "doccex/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "doccex"
  s.version     = Doccex::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Doccex."
  s.description = "TODO: Description of Doccex."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.1.4"
  s.add_dependency "haml"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "capybara"
  s.add_development_dependency "rspec-rails"
end
