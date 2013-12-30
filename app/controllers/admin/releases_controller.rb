class Admin::ReleasesController < ApplicationController

  before_filter :check_login

  def new
    @release = Release.new do |r|
      r.website_id = current_website.id
    end
  end

  def create
  end

end