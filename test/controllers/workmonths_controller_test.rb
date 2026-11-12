require "test_helper"

class WorkmonthsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @workmonth = workmonths(:one)
  end

  test "should get index" do
    get workmonths_url
    assert_response :success
  end

  test "should get new" do
    get new_workmonth_url
    assert_response :success
  end

  test "should create workmonth" do
    assert_difference("Workmonth.count") do
      post workmonths_url, params: { workmonth: { comment: @workmonth.comment, entries: @workmonth.entries, month: @workmonth.month, workplace_id: @workmonth.workplace_id } }
    end

    assert_redirected_to workmonth_url(Workmonth.last)
  end

  test "should show workmonth" do
    get workmonth_url(@workmonth)
    assert_response :success
  end

  test "should get edit" do
    get edit_workmonth_url(@workmonth)
    assert_response :success
  end

  test "should update workmonth" do
    patch workmonth_url(@workmonth), params: { workmonth: { comment: @workmonth.comment, entries: @workmonth.entries, month: @workmonth.month, workplace_id: @workmonth.workplace_id } }
    assert_redirected_to workmonth_url(@workmonth)
  end

  test "should destroy workmonth" do
    assert_difference("Workmonth.count", -1) do
      delete workmonth_url(@workmonth)
    end

    assert_redirected_to workmonths_url
  end
end
