
require 'nokogiri'

module SimpleSitemap

  module Generators

    class Index < Base

      attr_accessor :sitemaps

      def initialize(config, hooks)
        super
        @sitemaps = []
      end

      def add_sitemap(name)
        url = if @config.sitemap_location[-1,1] == '/'
          "#{@config.sitemap_location}#{name}"
        else
          "#{@config.sitemap_location}/#{name}"
        end
        @sitemaps << url
      end

      def write!
        xml = to_xml
        index_filename = 'index.xml'
        if @config.prefix
          index_filename = "#{@config.prefix}_#{index_filename}"
        end
        if @config.gzip
          index_filename << '.gz'
        end
        write_file index_filename, xml
      end

      def to_xml
        builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
          xml.sitemapindex(xmlns: 'http://www.sitemaps.org/schemas/sitemap/0.9') do
            @sitemaps.each do |sitemap_url|
              xml.sitemap do
                xml.loc sitemap_url
              end
            end
          end
        end
        builder.to_xml
      end

    end

  end

end
