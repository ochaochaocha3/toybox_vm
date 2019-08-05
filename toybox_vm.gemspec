lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "toybox_vm/version"

Gem::Specification.new do |spec|
  spec.name          = "toybox_vm"
  spec.version       = ToyboxVm::VERSION
  spec.authors       = ["ocha"]
  spec.email         = ["ochaochaocha3@gmail.com"]

  spec.summary       = 'Evaluates dice rolls and stores the result for tabletop RPG tools.'
  spec.homepage      = "https://github.com/ochaochaocha3/toybox_vm"
  spec.license       = "MIT"

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ochaochaocha3/toybox_vm"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'treetop', '~> 1.6'

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "test-unit", "~> 3.2"
  spec.add_development_dependency 'pry'
end
