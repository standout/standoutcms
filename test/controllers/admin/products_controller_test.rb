require 'test_helper'

class Admin::ProductsControllerTest < ActionController::TestCase

  def setup
    @controller = Admin::ProductsController.new
    request.host = "standout.standoutcms.dev"
  end

  test 'Duplicating a product with URL should work' do
    session[:user_id] = users(:david).id
    product = products(:product_with_variants)
    assert_difference('Product.count', 1) do
      post :duplicate, id: product.id
    end
    assert_response :redirect
    assert_redirected_to([:edit, :admin, Product.last])
  end

end