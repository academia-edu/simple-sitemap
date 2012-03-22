
$:.unshift '/Users/ryan/Code/simple_sitemap/lib'

require 'simple_sitemap'

SimpleSitemap.configure do |config|
  config.local_path = 'tmp/'
  config.default_path = 'http://ryanlower.com'
  config.sitemap_location = 'http://ryanlower.com/sitemap'
  config.gzip = false
end

SimpleSitemap.after_write do |filename|
  puts "Got #{file}"
  # Do something magical
end

SimpleSitemap.build do
  add_path 'home'
  add_path 'about'
  sitemap 'ryan' do
    6.times do |i|
      add_url i,
        priority: 0.5
    end
  end
  sitemap 'lower' do
    5.times do |i|
      add_url i,
        lastmod: Time.now
    end
  end
  sitemap 'ryan' do
    6.times do |i|
      add_path i,
        priority: 0.5
    end
  end
  add_url 'signup'
  add_path 'login'
end
