# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
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

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    #spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'treetop', '~> 1.6'

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "test-unit", "~> 3.2"
  spec.add_development_dependency 'pry'
end
