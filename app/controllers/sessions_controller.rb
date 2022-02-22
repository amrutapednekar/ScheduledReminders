class SessionsController < ApplicationController
  skip_before_action :authorized, only: [:new, :create, :welcome,:logout]
  def new
    @user = User.new
  end

 # Creates a new user - Signup
 # If usewr created, redirects to wecome pahe.
 # If uswer is not created, redirects again to login page. 
 # Displays errors in creating user 
  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
       session[:user_id] = @user.id
       redirect_to '/welcome'
    else
      render :new
       #redirect_to '/login'
    end
  end

  # Login page
  def login
  end
 
  # Logouts current user
  # Redirects to welcome page
  def logout
    session[:user_id] = nil 
    redirect_to '/welcome'
  end

  # Displays welcome page
  def welcome
  end

  def page_requires_login
  end

 def authorized
    redirect_to '/welcome' unless logged_in?
end
end
