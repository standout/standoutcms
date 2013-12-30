class UsersController < ApplicationController
  before_filter :login_required, :except => [:new, :create, :send_password_reset, :password_reset]

  def send_password_reset
    @user = User.all(:conditions => { :email => params[:email] }).first
    if @user
      Notifier.password_reset_link(@user).deliver
      redirect_to login_path, :notice => t('password_reset_link_sent')
    else
      redirect_to login_path, :alert => t('user_not_found')
    end
  end
  
  def password_reset
    @user = User.find(params[:id])
    if @user && @user.password_reset_code == params[:code]
      if params[:password]
        @user.password = params[:password]
        if @user.save
          redirect_to login_path, :notice => t('new_password_saved')
        end
      end
    else
      redirect_to login_path, :error => t('password_reset_link_expired')
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_url, :notice => "Thank you for signing up! You are now logged in."
    else
      render :action => 'new'
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to root_url, :notice => "Your profile has been updated."
    else
      render :action => 'edit'
    end
  end
end
