
module SimpleSitemap

  module Writers

    class GzipWriter
      def write(filename, xml)
        require 'zlib'
        Zlib::GzipWriter.open(filename) do |gz_file|
          gz_file.write xml
        end
      end
    end

  end

end

