# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "any_sms/backend/aws/version"

# rubocop:disable Metrics/BlockLength
Gem::Specification.new do |spec|
  spec.name          = "any_sms-backend-aws"
  spec.version       = AnySMS::Backend::AWS_VERSION
  spec.authors       = ["Fedcomp"]
  spec.email         = ["aglergen@gmail.com"]

  spec.summary       = "AnySMS backend for using amazon web services sms delivery"
  spec.homepage      = "https://github.com/Fedcomp/any_sms-backend-aws"
  spec.license       = "MIT"

  unless spec.respond_to?(:metadata)
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "any_sms"
  spec.add_dependency "aws-sdk", "~> 3"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 2.1"
  spec.add_development_dependency "guard", "~> 2.14"
  spec.add_development_dependency "guard-rspec", "~> 4.7"
  spec.add_development_dependency "guard-yard"
  spec.add_development_dependency "pry-byebug", "~> 3.4"
end
