require "minitest"
require "minitest/autorun"
require "test_helper"

class DirectoryItemTest < Minitest::Test

	def setup
	end

	def teardown
	end

	def test_intialize
		dir_item = Overcast::DirectoryItem.new({ path: "fake/path" })
		assert_kind_of Overcast::DirectoryItem, dir_item
	end

	def test_files
		dir_item = Overcast::DirectoryItem.new({ path: "test/overcast/tmp/sample" })
		assert File.file?(dir_item.files.first)
	end

	def test_file_count
		dir_item = Overcast::DirectoryItem.new({ path: "test/overcast/tmp/sample" })
		assert_equal dir_item.files_count, 1
	end

	def test_size
		dir_item = Overcast::DirectoryItem.new({ path: "test/overcast/tmp/sample" })
		assert_equal dir_item.size, "9.3 KiB"
	end
end