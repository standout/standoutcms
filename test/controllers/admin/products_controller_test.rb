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

  test "as admin i can change category" do
    login_as :david
    product = products(:product_with_variants)
    category = product_categories(:one)

    refute_includes product.product_categories, category

    put :update, id: product.id, product: {
      product_category_ids: [category.id]
    }
    assert_response :redirect

    product.reload
    assert_includes product.product_categories, category
  end
end
