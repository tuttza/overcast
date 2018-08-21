require 'test_helper'

class OvercastTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Overcast::VERSION
  end
end
