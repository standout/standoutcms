class ContentItemsController < ApplicationController
  def show
    render json: ContentItem.find(params[:id]).to_json(only: [:text_content])
  end
end
