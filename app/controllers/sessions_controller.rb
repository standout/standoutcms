class SessionsController < ApplicationController
  skip_before_filter :check_login, :only => [:new, :create, :destroy]

  def new
    render :layout => 'login'
  end

  def create
    user = User.authenticate(params[:login], params[:password])
    if user
      session[:user_id] = user.id
      if current_website
        logger.debug "Current website: #{current_website.inspect}"
        redirect_to_target_or_default [:admin, :pages], :notice => "Logged in successfully."
      else
        redirect_to_target_or_default root_url, :notice => "Logged in successfully."
      end
    else
      flash.now[:alert] = t('invalid_login')
      render :action => 'new', :layout => 'login'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, :notice => "You have been logged out."
  end
end
