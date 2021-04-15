require "test_helper"

class ContextTest < ActiveSupport::TestCase
  def setup
    @context = Context.new
  end

  test "define an error message" do
    @context.fail!("An error occurred")
    assert_equal @context.success?, false
  end

  test "when dont call fail! it should be successful" do
    assert_equal @context.success?, true
  end
end
