require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should login" do
    admin = users(:admin)
    post :create, username: admin.username, password: 'doe'
    #logging in with user: john pass: doe
    assert_redirected_to admin_url
    assert_equal admin.id, session[:user_id]
  end
  
  test "should fail login with wrong password" do
    one = users(:one)
    post :create, username: one.username, password: 'wrong'
    assert_redirected_to login_url
  end
  
  test "should logout" do
    delete :destroy
    assert_redirected_to welcome_url
  end
end
