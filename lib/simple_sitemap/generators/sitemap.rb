
require 'nokogiri'

module SimpleSitemap

  module Generators

    class Sitemap < Base

      attr_accessor :sitemap_name, :sitemap_data

      def initialize(config, hooks)
        super
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
        write_index
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

      def write_index
        index = Generators::Index.new @config, @hooks
        @sitemap_data.keys.each do |name|
          (1...sitemap_data[name][:index]).each do |i|
            index.add_sitemap sitemap_filename(name, i)
          end
        end
        index.write!
      end

      def write(name)
        puts "Writing sitemap #{name}#{@sitemap_data[name][:index]}\t [#{@sitemap_data[name][:size]} urls]" if @config.verbose
        xml = to_xml name
        write_file sitemap_filename(name), xml
        if @hooks and @hooks[:after_write]
          @hooks[:after_write].call sitemap_filename(name)
        end
        reset_sitemap_data name
        @sitemap_data[name][:index] += 1
        enter_sitemap name
      end

      def reset_sitemap_data(name)
        default_sitemap_data = {
          links: [],
          size: 0,
          bytesize: 110
        }
        @sitemap_data[name].merge! default_sitemap_data
      end

      def sitemap_filename(name, index=nil)
        index ||= @sitemap_data[name][:index]
        filename = if name
          "#{name}_#{index}.xml"
        else
          "sitemap_#{index}.xml"
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

end
