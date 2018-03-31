require "test_helper"

class ToyboxVmTest < Test::Unit::TestCase
  test 'has_a_version_number' do
    refute_nil ::ToyboxVm::VERSION
  end
end
