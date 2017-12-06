require 'minitest'
require 'minitest/autorun'
require 'test_helper'
require 'fileutils'

class ConfigurationTest < Minitest::Test
  def setup
    @app_config_path = File.join('test/overcast/tmp/overcast_test')
    FileUtils.mkdir_p(@app_config_path)
    @app_config_file = File.join(@app_config_path, '.overcast')
  end

  def teardown
   FileUtils.rm_rf @app_config_path
  end

  def test_initialize
    config = Overcast::Configuration.new
    assert_kind_of Overcast::Configuration, config
  end

  def test_is_subdir
    root_path = File.join(@app_config_path, 'rootdir')
    Dir.mkdir(root_path)

    subdir_path = File.join("#{root_path}/subdir")
    Dir.mkdir(subdir_path)

    config = Overcast::Configuration.new({ configuration_path: @app_config_file })
    config.add_directory(root_path)

    assert config.is_subdir?(subdir_path)
  end

  def test_is_subdir_with_nested_directories
    root_path = File.join(@app_config_path, 'rootdir')
    Dir.mkdir(root_path)

    subdir_path = File.join("#{root_path}/subdir")
    Dir.mkdir(subdir_path)

    subsubdir_path = File.join("#{subdir_path}/subsubdir")
    Dir.mkdir(subsubdir_path)

    config = Overcast::Configuration.new({ configuration_path: @app_config_file })
    config.add_directory(root_path)

    assert config.is_subdir?(subsubdir_path)
  end

  def test_add_directory
    root_path = File.join(@app_config_path, 'rootdir')
    Dir.mkdir(root_path)
    config = Overcast::Configuration.new({ configuration_path: @app_config_file })
    assert config.add_directory(root_path)
  end

  def test_add_directory_fails_with_number_as_path
    config = Overcast::Configuration.new({ configuration_path: @app_config_file })
    refute config.add_directory(5)
  end

  def test_add_directory_with_invalid_file_path
    config = Overcast::Configuration.new({ configuration_path: @app_config_file })
    refute config.add_directory("/foo/bar/example/path/does/not/exist")
  end

  def test_remove_directory
    root_path = File.join(@app_config_path, 'rootdir')
    Dir.mkdir(root_path)
    config = Overcast::Configuration.new({ configuration_path: @app_config_file })
    config.add_directory(root_path)
    assert config.remove_directory(root_path)
  end

end