require 'yaml'

module Overcast
  module IO
    class YamlWriter
      attr_accessor :file_path, :file

      def initialize(file_path, file_name)
        @file_path = file_path
        @file = File.join(@file_path, file_name)
      end

      def create
        created = false
        if Dir.exist?(@file_path) && !File.exist?(@file)
          File.open(@file, 'w') {}
          created = true
        end
        created
      end

      def create_dir
        Dir.mkdir @file_path unless Dir.exist? @file_path
      end

      def write(data)
        File.open(@file, 'w') { |file|
          file.write(
              YAML::dump(data)
          )
        }
      end

      def load
        YAML.load_file(@file)
      end
    end
  end
end
