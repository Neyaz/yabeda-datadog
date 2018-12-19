# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "yabeda/datadog/version"

Gem::Specification.new do |spec|
  spec.name    = "yabeda-datadog"
  spec.version = Yabeda::DataDog::VERSION
  spec.authors = ["Nikolay Malinin"]
  spec.email   = ["ne9zzz@gmail.com"]

  spec.summary = "DataDog adapter for reporting metrics from Yabeda suite"
  spec.description = <<~DESCRIPTION
    Adapter for reporting custom metrics from Yabeda to DataDog.
  DESCRIPTION
  spec.homepage = "https://github.com/Neyaz/yabeda-datadog"
  spec.license  = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Neyaz/yabeda-datadog"
  spec.metadata["changelog_uri"] = "https://github.com/Neyaz/yabeda-datadog/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "dogapi"
  spec.add_dependency "yabeda", "~> 0.1.0"

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end