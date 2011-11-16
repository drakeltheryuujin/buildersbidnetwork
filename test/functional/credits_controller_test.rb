require 'test_helper'

class CreditsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get purchase" do
    get :purchase
    assert_response :success
  end

  test "should get complete_purchase" do
    get :complete_purchase
    assert_response :success
  end

end
