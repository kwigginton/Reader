require 'test_helper'

class SupercategoriesControllerTest < ActionController::TestCase
  setup do
    @supercategory = supercategories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:supercategories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create supercategory" do
    assert_difference('Supercategory.count') do
      post :create, supercategory: { name: @supercategory.name }
    end

    assert_redirected_to supercategory_path(assigns(:supercategory))
  end

  test "should show supercategory" do
    get :show, id: @supercategory
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @supercategory
    assert_response :success
  end

  test "should update supercategory" do
    put :update, id: @supercategory, supercategory: { name: @supercategory.name }
    assert_redirected_to supercategory_path(assigns(:supercategory))
  end

  test "should destroy supercategory" do
    assert_difference('Supercategory.count', -1) do
      delete :destroy, id: @supercategory
    end

    assert_redirected_to supercategories_path
  end
end
