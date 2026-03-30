require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "fixture user remains valid under devise" do
    assert users(:archivist).valid?
  end
end
