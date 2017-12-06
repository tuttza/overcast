require 'yaml'
require 'logger'
require 'date'
require_relative 'helpers.rb'

module Overcast
  class Configuration
    include Overcast::Helpers

    attr_reader :logger, :conf_dir_path, :directories_yaml_path, :directories_yaml_file, :locations

    def initialize(options = {})
      options = options.dup
      init_logger
      @conf_dir_path = options[:configuration_path] || File.join(File.expand_path('~'), '.overcast')
      @directories_yaml_path = File.join(conf_dir_path, 'directories.yml')
      init_config_setup
      @directories_yaml_file = YAML.load_file(directories_yaml_path) if config_ready?
      @locations = directories_yaml_file[:locations] if config_ready?
    end

    def init_config_setup
      create_config_dir
      create_directories_conf
    end

    def is_subdir?(subdir_path)
      found_flag = false
      if is_valid_path?(subdir_path)
        locations.each do |loc|
          dir_array = Dir.glob("#{loc}/**/*")
          if dir_array.include?(subdir_path)
            found_flag = true
          end
        end
      end
      found_flag
    end

    def add_directory(dir)
      added = false
      return added if !dir.is_a? String
      if is_valid_path?(dir)
        locations.push(dir)
        File.write(directories_yaml_path, YAML.dump({ locations: locations.uniq }))
        logger.info "Successfully added path: '#{dir}'"
        added = true
      else
        logger.fatal "Path provided: '#{dir}' is not a valid path."
        return added
      end
      added
    end
   
    def remove_directory(dir)
      removed = false
      if is_valid_path?(dir)
        if locations.include?(dir)
          locations.delete(dir)
          logger.info "removing #{dir} from directories.yml"
          write_to_config(directories_yaml_file)
          removed = true
        end
      end
      removed
    end
    
    def config_ready?
      config_dir? && config?
    end

    def config_dir?
      Dir.exist? conf_dir_path
    end

    def config?
      File.exist? directories_yaml_path
    end

    def write_to_config(locations_hash)
      File.open(directories_yaml_path, 'w') { |file|
        file.write(
          YAML::dump(locations_hash)
        )
      }
    end

    private

    def init_logger
      @logger = Logger.new(STDOUT)
      @logger.level = Logger::INFO
      @logger.datetime_format = '%Y-%m-%d %H:%M:%S'
    end

    def create_config_dir
      if Dir.exist? conf_dir_path
        logger.warn "#{conf_dir_path} already exists..."
        return
      else
        Dir.mkdir conf_dir_path
        logger.info "creating #{conf_dir_path}..."
      end
    end

    def create_directories_conf
      if Dir.exist?(conf_dir_path) && !File.exist?(directories_yaml_path)
        File.open(directories_yaml_path, 'w') { |file|
          file.write(YAML::dump({ locations: [] }))
        }
        logger.info "creating #{directories_yaml_path}..."
      else
        logger.warn "#{directories_yaml_path} already exists..."
        return
      end
    end
  end
end
