# -*- encoding: utf-8 -*-
require File.expand_path('../lib/shopscan/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Rob Esris"]
  gem.email         = ["robesris@gmail.com"]
  gem.description   = %q{A simple demo api for scanning/totaling products}
  gem.summary       = %q{A simple demo api for scanning/totaling products}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "shopscan"
  gem.require_paths = ["lib"]
  gem.version       = Shopscan::VERSION
end
