require "test_helper"

class Admin::RecordsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_records_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_records_show_url
    assert_response :success
  end

  test "should get update" do
    get admin_records_update_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_records_destroy_url
    assert_response :success
  end
end
