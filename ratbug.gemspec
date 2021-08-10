require_relative 'lib/ratbug/version'

Gem::Specification.new do |spec|
  github_repo_url = 'https://github.com/rnitta/ratbug'
  spec.name          = "ratbug"
  spec.version       = Ratbug::VERSION
  spec.authors       = ["rnitta"]
  spec.email         = ["attinyes@gmail.com"]

  spec.summary       = %q{Generate typescript type definitions and jbuilder templates from schema.rb and model files.}
  spec.description   = %q{poor utility}
  spec.homepage      = github_repo_url
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.0")

  spec.metadata["homepage_uri"] = github_repo_url
  spec.metadata["source_code_uri"] = github_repo_url
  spec.metadata["changelog_uri"] = "#{github_repo_url}/releases"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.executables   = ["ratbug"]
  spec.bindir = "bin"
  spec.require_paths = ["lib"]
end
