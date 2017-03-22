require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get multiple_notes" do
    get static_pages_multiple_notes_url
    assert_response :success
  end

  test "should get multiple_notes2" do
    get static_pages_multiple_notes2_url
    assert_response :success
  end
end
