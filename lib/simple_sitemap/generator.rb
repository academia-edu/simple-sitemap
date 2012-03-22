
require 'nokogiri'

module SimpleSitemap

  class Generator

    attr_writer :config, :hooks

    attr_accessor :sitemap_name, :sitemap_data

    def initialize(config, hooks)
      @config = config
      @hooks = hooks
      @sitemap_data = {}

      @sitemap_links = {}
      @sitemap_size = {}
      @sitemap_bytesize = {}
      @sitemap_data = {}
      enter_sitemap nil
    end

    def add_url(url, opts={})
      link = { url: url }
      link.merge! opts
      @sitemap_data[@sitemap_name][:links] << link
      @sitemap_data[@sitemap_name][:size] += 1
      ## TODO, add correct bytesize (this is an overestimate)
      @sitemap_data[@sitemap_name][:bytesize] += 200
      if @sitemap_data[@sitemap_name][:size] >= SimpleSitemap::MAX_LINKS_PER_FILE
        write @sitemap_name
      end
      if @sitemap_data[@sitemap_name][:bytesize] >= SimpleSitemap::MAX_FILE_SIZE
        write @sitemap_name
      end
    end

    def add_path(path, opts={})
      if @config.default_path
        if @config.default_path[-1,1] != '/' && path[0] != '/'
          path = "/#{path}"
        end
        add_url "#{@config.default_path}#{path}", opts
      else
        raise "Can't add a path without configuring default_path"
      end
    end

    def sitemap(name, &block)
      enter_sitemap name
      yield
      exit_sitemap
    end

    def write!
      @sitemap_data.keys.each do |name|
        if @sitemap_data[name][:links].size > 0
          write name
        end
      end
    end

    private

    def enter_sitemap(name)
      unless @sitemap_data.has_key? name
        @sitemap_data[name] = { index: 1 }
        reset_sitemap_data name
      end
      @sitemap_name = name
    end

    def exit_sitemap
      @sitemap_name = nil
    end

    def write(name)
      puts "Write sitemap #{name}#{@sitemap_data[name][:index]} [#{@sitemap_size[name]} links]"
      xml = to_xml name
      write_file name, xml
      if @hooks and @hooks[:after_write]
        @hooks[:after_write].call xml
      end
      reset_sitemap_data name
      @sitemap_data[name][:index] += 1
      enter_sitemap name
    end

    def write_file(name, xml)
      if @config.gzip
        Writers::GzipWriter.new.write sitemap_filename(name), xml
      else
        Writers::PlainWriter.new.write sitemap_filename(name), xml
      end
    end

    def reset_sitemap_data(name)
      default_sitemap_data = {
        links: [],
        size: 0,
        bytesize: 110
      }
      @sitemap_data[name].merge! default_sitemap_data
    end

    def sitemap_filename(name)
      filename = if name
        "#{name}_#{@sitemap_data[name][:index]}.xml"
      else
        "sitemap_#{@sitemap_data[name][:index]}.xml"
      end
      if @config.gzip
        filename << '.gz'
      end
      filename
    end

    def to_xml(name)
      builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
        xml.urlset(xmlns: 'http://www.sitemaps.org/schemas/sitemap/0.9') do
          @sitemap_data[name][:links].each do |url|
            xml.url do
              xml.loc url[:url]
              # xml.lastmod url[:lastmod].utc if url[:lastmod]
              xml.changefreq url[:changefreq] if url[:changefreq]
              xml.priority url[:priority] if url[:priority]
            end
          end
        end
      end
      builder.to_xml
    end

  end

end
