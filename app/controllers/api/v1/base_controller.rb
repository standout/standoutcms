class Api::V1::BaseController < ActionController::Base
  after_filter :respond_to_jsonp

  def respond_to_jsonp
    return false unless params[:jsonp]
    response.body = "#{params[:jsonp]}(#{response.body});"
  end
end
