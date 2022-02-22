class UsersController < ApplicationController
  skip_before_action :authorized, only: [:new, :create]

  # Renders a for to create new user
  def new
    @user = User.new
  end

  # Accepts parameters from signup form
  # Creates new user.
  # Sets sessionof user.
  # Redirects to welcome page.
  def create
    @user = User.new(params.require(:user).permit(:email,:password))
    if @user.save
      session[:user_id] = @user.id
      redirect_to '/welcome'
    else
      render :new
    end
  end
end
