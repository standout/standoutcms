class Admin::PicturesController < ApplicationController

  before_filter :check_login
  before_filter :load_website

  def load_website
    @website = current_website
  end

  def index
    @pictures = @website.assets.where(:type => 'Picture').order("created_at desc")
  end

  def show
    @picture = Picture.find(params[:id])
  end

  def edit
    @picture = Picture.find(params[:id])
  end

  def create
    @picture = Picture.new(picture_params)
    @picture.website_id = @website.id
    if @picture.save
      redirect_to :back, :notice => I18n.t('notices.picture.created')
    else
      redirect_to :back, :alert => I18n.t('notices.picture.upload_failed')
    end
  rescue ::ActionController::RedirectBackError
    redirect_to [:admin, :pictures]
  end

  def destroy
    @picture = Picture.find(params[:id])
    if @picture && @picture.website_id == current_website.id
      @picture.destroy
      redirect_to :back, :notice => I18n.t('notices.picture.destroyed')
    else
      redirect_to :back, :notice => I18n.t('notices.picture.not_allowed_to_destroy')
    end
  end

  def update
    @picture = Picture.find(params[:id])
    if @picture && @picture.website_id == current_website.id
      @picture.update(picture_params)
      redirect_to :back, :notice => I18n.t('notices.picture.saved')
    end
  end

  private

  def picture_params
    params.require(:picture).permit %i(
      data
      title
      url
    )
  end

end
