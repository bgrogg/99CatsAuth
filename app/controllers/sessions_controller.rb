class SessionsController < ApplicationController
  before_action :login_check, only: [:new]

  def new
  end

  def create
    username, password = session_params.values
    user = User.find_by_credentials(username, password)

    if user
      user.reset_session_token!
      login(user)
      flash[:messages] = ['Yay you are logged in!']
      redirect_to cats_url
    else
      flash.now[:messages] = ['invalid username or password']
      render :new
    end
  end

  def destroy
    logout
    flash[:messages] = ["goodbye! forever... :("]
    redirect_to new_session_url
  end

  private
  def session_params
    params.require(:user).permit(:username, :password)
  end

  def login_check
    if current_user
      flash[:messages] = ["You are already logged in"]
      redirect_to cats_url
    end
  end

end
