# -*- encoding: utf-8 -*-
require File.expand_path('../lib/nephelae/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Stuart Eccles"]
  gem.email         = ["stuart@madebymany.co.uk"]
  gem.description   = %q{Nephelae is a daemon process that will upload custom cloud watch metrics in AWS}
  gem.summary       = %q{Poll for server metrics and post them to AWS as custom CloudWatch metrics}
  gem.homepage      = "https://github.com/madebymany/nephelae"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "nephelae"
  gem.require_paths = ["lib"]
  gem.version       = Nephelae::VERSION

  gem.add_dependency('excon', '~>0.14')
  gem.add_dependency('eventmachine')
  gem.add_dependency('rufus-scheduler')
  gem.add_dependency('daemons')
  gem.add_dependency('aws-sdk')

end
