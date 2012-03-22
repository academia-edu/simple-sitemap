
module SimpleSitemap

  module Writers

    class PlainWriter
      def write(filename, xml)
        File.open(filename, 'w') do |file|
          file.write xml
        end
      end
    end

  end

end

