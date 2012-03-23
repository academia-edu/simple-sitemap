# SimpleSitemap

A simple sitemap generator

## Basic Usage

### Configure

```ruby
SimpleSitemap.configure do |config|
  config.local_path = 'public/sitemaps/'
  config.default_path = 'http://yoursite.com'
  config.sitemap_location = 'http://yoursite.com/sitemaps'
end
```

### Build your sitemap

```ruby
SimpleSitemap.build do
  add_path 'home'
  add_path 'about'
  sitemap 'ryan' do
    6.times do |i|
      add_url i, priority: 0.5
    end
  end
  sitemap 'lower' do
    5.times do |i|
      add_url i
    end
  end
  sitemap 'ryan' do
    6.times do |i|
      add_path i, priority: 1.0
    end
  end
  add_url 'http://signup.yoursite.com'
  add_path 'login'
end
```

## Hooks

SimpleSitemap gives you a after_write hook for easy access to sitemap files as they are written.

For example, to upload sitmaps to S3

```ruby
require 'fog'
SimpleSitemap.after_write do |filename|
  s3 = Fog::Storage.new({
    provider: 'AWS',
    aws_access_key_id: 'YOUR_AWS_KEY',
    aws_secret_access_key: 'YOUR_AWS_SECRET'
  })
  bucket = s3.directories.first
  bucket.files.create(
    :key => File.basename(filename),
    :body => open(filename),
    :public => true
  )
end
```
