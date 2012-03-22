
require 'simple_sitemap/generators/base'
require 'simple_sitemap/generators/index'
require 'simple_sitemap/generators/sitemap'
require 'simple_sitemap/writers/gzip_writer'
require 'simple_sitemap/writers/plain_writer'

require 'simple_sitemap/version'


module SimpleSitemap

  MAX_LINKS_PER_FILE = 50000
  MAX_FILE_SIZE = 10*1024*1024 # 10 megabytes

  class << self

    attr_accessor :config, :hooks

    def configure(&block)
      @config = OpenStruct.new
      @config.gzip = true
      @config.verbose = false
      yield @config
    end

    def build(opts={}, &block)
      start_time = Time.now
      generator = Generators::Sitemap.new @config, @hooks
      generator.instance_eval &block
      generator.write!
      puts "Time taken: #{Time.now - start_time}" if @config.verbose
    end

    def after_write(&block)
      @hooks ||= {}
      @hooks[:after_write] = block
    end
  end

end
