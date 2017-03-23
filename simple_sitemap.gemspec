$:.push File.expand_path('../lib', __FILE__)
require 'simple_sitemap/version'

Gem::Specification.new do |gem|

  gem.name          = 'simple_sitemap'
  gem.version       = SimpleSitemap::VERSION

  gem.add_dependency 'nokogiri', '~> 1.7.1'

  gem.authors       = ['nate00']
  gem.email         = ['nathanielsullivan00@gmail.com']
  gem.description   = 'A simple sitemap generator'
  gem.summary       = 'Simple sitemap generator'
  gem.homepage      = 'https://github.com/academia-edu/simple-sitemap'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency "rake"
end
