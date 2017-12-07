require 'minitest'
require 'minitest/autorun'
require 'test_helper'
require 'fileutils'

class DirectoryStoreTest < Minitest::Test
  def setup
    @test_app_path = File.join('test/overcast/tmp/overcast_test')
    FileUtils.mkdir_p(@test_app_path)
    @app_path = File.join(@test_app_path, '.overcast')
    @d_store = Overcast::DirectoryStore.new({ path: @app_path})
  end

  def teardown
   FileUtils.rm_rf @test_app_path
  end

  def test_initialize
    assert_kind_of Overcast::DirectoryStore, @d_store
  end

  def test_is_subdir
    root_path = File.join(@app_path, 'root_dir')
    FileUtils.mkdir_p(root_path)

    subdir_path = File.join("#{root_path}/sub_dir")
    FileUtils.mkdir_p(subdir_path)

    @d_store.add_directory(root_path)

    assert @d_store.is_subdir?(subdir_path)
  end

  def test_is_subdir_with_nested_directories
    root_path = File.join(@app_path, 'root_dir')
    Dir.mkdir(root_path)

    subdir_path = File.join("#{root_path}/sub_dir")
    Dir.mkdir(subdir_path)

    subsubdir_path = File.join("#{subdir_path}/subsub_dir")
    Dir.mkdir(subsubdir_path)

    @d_store.add_directory(root_path)

    assert @d_store.is_subdir?(subsubdir_path)
  end

  def test_add_directory
    root_path = File.join(@app_path, 'root_dir')
    Dir.mkdir(root_path)
    assert @d_store.add_directory(root_path)
  end

  def test_add_directory_fails_with_non_string_path
    refute @d_store.add_directory(5)
    refute @d_store.add_directory(true)
    refute @d_store.add_directory({add_directory: "foo/bar"})
  end

  def test_add_directory_with_invalid_file_path
    refute @d_store.add_directory("/foo/bar/example/path/does/not/exist")
  end

  def test_remove_directory
    root_path = File.join(@app_path, 'root_dir')
    Dir.mkdir(root_path)
    @d_store.add_directory(root_path)
    assert @d_store.remove_directory(root_path)
  end

end