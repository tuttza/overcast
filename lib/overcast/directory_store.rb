require 'yaml'
require 'logger'
require 'date'
require_relative 'helpers.rb'
require_relative 'io/yaml_writer'

module Overcast
  class DirectoryStore
    include Overcast::Helpers

    attr_reader :directories

    def initialize(options = {})
      options = options.dup
      @path = options[:path] || File.join(File.expand_path("~"), '/.overcast')
      @file_name = "directories.yml"
      @file = Overcast::IO::YamlWriter.new(@path, @file_name)
      init_storage
      directories_yaml = @file.load if storage_ready?
      @directories = directories_yaml[:directories] if storage_ready?
    end

    def add_directory(dir)
      added = false
      return added if !dir.is_a? String
      if is_valid_path?(dir)
        @directories.push(dir)
        data = { directories: @directories.uniq }
        puts "data to be saved: #{data.inspect}"
        @file.write(data)
        added = true
      else
        puts "Path provided: '#{dir}' is not a valid path."
        return added
      end
      added
    end

    def is_subdir?(subdir_path)
      found_flag = false
      if is_valid_path?(subdir_path)
        @directories.each do |dir|
          dir_array = Dir.glob("#{dir}/**/*")
          if dir_array.include?(subdir_path)
            found_flag = true
          end
        end
      end
      found_flag
    end

    def remove_directory(dir)
      removed = false
      if is_valid_path?(dir)
        if @directories.include?(dir)
          @directories.delete(dir)
          puts "removing #{dir} from directories.yml"
          @file.write({ directories: @directories })
          removed = true
        end
      end
      removed
    end
    
    def storage_ready?
      storage_dir? && storage_file?
    end

    def storage_dir?
      Dir.exist? @file.file_path
    end

    def storage_file?
      File.exist? @file.file
    end

    private

    def create_storage_directory
      @file.create_dir unless Dir.exist? @file.file_path
    end

    def create_storage_file
      directories_yaml_structure = { directories: [] }.freeze
      @file.create
      @file.write(directories_yaml_structure)
    end

    def init_storage
      create_storage_directory unless storage_ready?
      create_storage_file unless storage_ready?
    end
  end
end
