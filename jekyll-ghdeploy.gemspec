
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jekyll-ghdeploy/version"

Gem::Specification.new do |spec|
  spec.name          = "jekyll-ghdeploy"
  spec.version       = JekyllGhDeploy::VERSION
  spec.authors       = ["Nick Garlis"]
  spec.email         = ["nickgarlis@gmail.com"]
  
  spec.rubygems_version = "2.2.2"
  spec.required_ruby_version = ">= 1.9.3"

  spec.summary       = %q{Jekyll GhDeploy is a gem that helps you push your jekyll site to Github.}
  spec.description   = %q{Provides ghdeploy subcommand}
  spec.homepage      = "https://github.com/nickgarlis/jekyll-ghdeploy"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").grep(%r!^lib/!)
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "jekyll", "~> 3.7"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
end
