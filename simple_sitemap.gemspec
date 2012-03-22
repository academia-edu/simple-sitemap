# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'simple_sitemap/version'

Gem::Specification.new do |gem|

  gem.name          = 'simple_sitemap'
  gem.version       = SimpleSitemap::VERSION

  gem.add_dependency 'nokogiri', '~> 1.5.0'

  gem.authors       = ['ryanlower']
  gem.email         = ['rpjlower@gmail.com']
  gem.description   = 'A simple sitemap generator'
  gem.summary       = 'Simple sitemap generator'
  gem.homepage      = ''

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

end
