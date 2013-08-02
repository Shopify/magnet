require File.expand_path("../.gemspec", __FILE__)
require File.expand_path("../lib/magnet/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name        = "magnet"
  gem.authors     = ["Samuel Kadolph"]
  gem.email       = ["samuel@kadolph.com"]
  gem.description = readme.description
  gem.summary     = readme.summary
  gem.homepage    = "http://samuelkadolph.github.com/magnet/"
  gem.version     = Magnet::VERSION

  gem.files       = Dir["lib/**/*"]
  gem.test_files  = Dir["test/**/*_test.rb"]

  gem.required_ruby_version = ">= 1.9.2"

  gem.add_development_dependency "minitest", "~> 5.0.6"
  gem.add_development_dependency "mocha", "~> 0.14.0"
  gem.add_development_dependency "rake", "~> 10.0.3"
end
