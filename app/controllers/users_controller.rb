class UsersController < ApplicationController
  before_action :login_check, only: [:new]

  def new
    @user = User.new
    render :new
  end

  def create
    user = User.new(user_params)
    if user.save
      login(user)
      redirect_to cats_url
    else
      flash.now[:messages] = user.errors.full_messages
      render :new
    end
  end


  private
  def user_params
    params.require(:user).permit(:username, :password)
  end

  def login_check
    if current_user
      flash[:messages] = ["You are already logged in"]
      redirect_to cats_url
    end
  end
end
