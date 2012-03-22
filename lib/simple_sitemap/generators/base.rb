
require 'nokogiri'

module SimpleSitemap

  module Generators

    class Base

      attr_writer :config, :hooks

      def initialize(config, hooks)
        @config = config
        @hooks = hooks
      end

      private

      def write_file(filename, xml)
        path = File.expand_path filename, @config.local_path
        if @config.gzip
          Writers::GzipWriter.new.write path, xml
        else
          Writers::PlainWriter.new.write path, xml
        end
      end

    end

  end

end
