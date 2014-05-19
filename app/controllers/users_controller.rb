class UsersController < ApplicationController
  before_filter :login_required, :except => [:new, :create, :send_password_reset, :password_reset]

  def send_password_reset
    @user = User.find_by(email: params[:email])
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
    @user = User.new(user_params)
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
    if @user.update(user_params)
      redirect_to root_url, :notice => "Your profile has been updated."
    else
      render :action => 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit %i(
      email
      password
      password_confirmation
      locale
    )
  end
end
