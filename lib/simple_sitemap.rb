
require 'simple_sitemap/generator'
require 'simple_sitemap/version'
require 'simple_sitemap/writers/gzip_writer'
require 'simple_sitemap/writers/plain_writer'


module SimpleSitemap

  MAX_LINKS_PER_FILE = 10
  MAX_FILE_SIZE = 10*1024*1024 # 10 megabytes

  class << self

    attr_accessor :config, :hooks

    def configure(&block)
      @config = OpenStruct.new
      @config.gzip = true
      yield @config
    end

    def build(opts={}, &block)
      start_time = Time.now
      generator = Generator.new @config, @hooks
      generator.instance_eval &block
      generator.write!
      puts "Time taken: #{Time.now - start_time}"
    end

    def after_write(&block)
      @hooks ||= {}
      @hooks[:after_write] = block
    end
  end

end
