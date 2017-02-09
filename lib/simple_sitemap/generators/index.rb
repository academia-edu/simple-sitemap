
require 'nokogiri'

module SimpleSitemap

  module Generators

    class Index < Base

      attr_accessor :sitemaps

      def initialize(config, hooks)
        super
        @sitemaps = []
        @index_count = 1
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
        @sitemaps.each_slice(SimpleSitemap::MAX_INDEX_SIZE) do |sitemaps|
          xml = to_xml(sitemaps)
          write_file index_filename, xml
          @index_count += 1
        end
      end

      def index_filename
        filename = "index.xml"
        filename = "index_#{@index_count}.xml" if @index_count > 1
        filename = "#{@config.prefix}_#{filename}" if @config.prefix
        filename << '.gz' if @config.gzip
        filename
      end

      def to_xml(sitemaps)
        builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
          xml.sitemapindex(xmlns: 'http://www.sitemaps.org/schemas/sitemap/0.9') do
            sitemaps.each do |sitemap_url|
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
