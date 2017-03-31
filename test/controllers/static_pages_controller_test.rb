require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get multiple_notes" do
    get static_pages_multiple_notes_url
    assert_response :success
  end

  test "should get another_prototype" do
    get static_pages_another_prototype_url
    assert_response :success
  end
end
