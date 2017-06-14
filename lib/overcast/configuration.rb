require 'yaml'
require 'logger'
require_relative 'helpers.rb'

include Overcast::Helpers

module Overcast
  class Configuration

    @@logger = Logger.new(STDOUT)
    @@logger.level = Logger::INFO
    @@logger.datetime_format = '%Y-%m-%d %H:%M:%S'

    @@conf_dir_path = File.join(File.expand_path('~'), '.overcast')
    @@directories_yaml_path = File.join(@@conf_dir_path, 'directories.yml')


    def self.execute
      create_config_dir
      create_directories_conf
    end

    def self.add_directory(dir)
      return if !dir.is_a? String
      if config_ready?
        if is_valid_path?(dir)
          @@logger.info("config ready")
        else
          @@logger.fatal("Path provided: '#{dir}' is not a valid path.")
          return
        end
        # @@logger.info("adding #{dir} to #{@@conf_dir_path}")
      end
    end

    def self.config_ready?
      config_dir? && config?
    end

    def self.config_dir?
      Dir.exist? @@conf_dir_path
    end

    def self.config?
      File.exist? @@directories_yaml_path
    end

    private
    # creates ~/.overcast directory
    #
    # return: Object -> nil
    def self.create_config_dir
      if Dir.exist?(@@conf_dir_path)
        @@logger.warn("#{@@conf_dir_path} already exists...")
        return
      else
        Dir.mkdir(@@conf_dir_path)
        @@logger.info("creating #{@@conf_dir_path}...")
      end
    end

    # create ~/.overcast/directories.yml
    #
    # return: Object: nil
    def self.create_directories_conf
      if Dir.exist?(@@conf_dir_path) && !File.exist?(@@directories_yaml_path)
        File.open(@@directories_yaml_path, 'w') { |file|
          file.write(
              YAML::dump({ locations: [] })
          )
        }
        @@logger.info("creating #{@@directories_yaml_path}...")
      else
        @@logger.warn("#{@@directories_yaml_path} already exists...")
        return
      end
    end
  end
end