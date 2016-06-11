require 'minitest_helper'

class TestApiBanking < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::ApiBanking::VERSION
  end
end
