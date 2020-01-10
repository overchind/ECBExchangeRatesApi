# frozen_string_literal: true

require_relative "lib/ecb_exchange_rates_api/version"

Gem::Specification.new do |spec|
  spec.name          = "ecb_exchange_rates_api"
  spec.version       = ECBExchangeRatesApi::VERSION
  spec.authors       = ["Roman Ovcharov"]
  spec.email         = ["overchind@gmail.com"]

  spec.summary       = "Client library for ExchangeRates API"
  spec.description   = <<-DESCRIPTION
    This is an unofficial wrapper for the awesome, free ExchangeRatesAPI,
    which provides exchange rate lookups courtesy of the Central European Bank."
  DESCRIPTION
  spec.homepage      = "https://github.com/overchind/ExchangeRatesAPI"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z`
  # loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"
  spec.add_dependency "httparty"

  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
end
