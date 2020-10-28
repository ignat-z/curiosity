require "test_helper"

class HomeTest < ActiveSupport::TestCase
  test ".index" do
    id = any_id
    mock = Minitest::Mock.new.expect(:order, [id], [id: :desc])

    assert_equal Arcadia::Home.index(order_class: mock), [id]
  end
end
