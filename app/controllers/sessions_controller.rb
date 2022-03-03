class SessionsController < ApplicationController
  skip_before_action :authorized, only: [:new, :create, :welcome,:logout]
  def new
     @user = User.new
  end

 # Authenticates user - Login
 # If usewr created, redirects to wecome pahe.
 # If uswer is not created, redirects again to login page. 
 # Displays errors in creating user 
  def create
    @user = User.find_by(email: params[:email])

    respond_to do |format|
      if @user && @user.authenticate(params[:password])
        session[:user_id] = @user.id
        format.html { redirect_to '/welcome'}
        format.json { render :welcome}
      else
        @error_message = "Invalid authentication.Please enter correct email address and password"
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
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
