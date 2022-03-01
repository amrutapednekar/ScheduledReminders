require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  fixtures :users
  #before(:all) do
  #p  @user = users(:one)
  #p  @current_user = @user # FIXME: Why isn't the session method accessible?!
   # session[:user_id] =users(:one)
 #end

  describe "GET /welcome" do
    it "gets welcome" do
      get welcome_url
      assert_response :success
      expect(response).to render_template(:welcome)
    end
  end

  describe "GET /new" do
     it "gets login page" do
      get login_url
      assert_response :success
      expect(response).to render_template(:new)
      expect(response).to render_template("sessions/new")
   end
end

describe "login" do
  it "authenticates successfully with valid credentials" do
    test_user = users(:one)
    post "/login", :params => { email: test_user.email, user_password: test_user.password_digest}
    expect(response).to have_http_status(200)
  end

  it "logouts successfully " do
    test_user = users(:one)
   post "/login", :params => { email: test_user.email, user_password: test_user.password_digest}
   expect(response).to have_http_status(200)
  end

  it "goes to login if password doen not match" do
    test_user = users(:one)
    post "/login", :params => { email: test_user.email, user_password: 'wrongpassword'}
    get logout_url
    assert_redirected_to(:welcome)
  end

  it "goes to login if email doen not match" do
    test_user = users(:one)
    post "/login", :params => { email: 'wrongemail', user_password: test_user.password_digest}
    expect(response).to render_template(:new)
  end
end


end
