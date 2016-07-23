# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'api_banking/version'

Gem::Specification.new do |spec|
  spec.name          = "api_banking"
  spec.version       = ApiBanking::VERSION
  spec.authors       = ["akil"]
  spec.email         = ["hello@quantiguous.com"]

  spec.summary       = %q{Ruby SDK to Connect to Banks}
  spec.homepage      = "http://apibanking.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"

  spec.add_dependency "typhoeus"
  spec.add_dependency "nokogiri"
end
