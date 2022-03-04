require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  fixtures :users

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
    post "/login", :params => { email: test_user.email, password: "amruta"}
    assert_redirected_to(:welcome)
  end


  it "logouts successfully " do
   test_user = users(:one)
   post "/login", :params => { email: test_user.email, password: "amruta"}
   get logout_url
   assert_redirected_to(:welcome)
  end

  it "renders login  if password does not match" do
    test_user = users(:one)
    post "/login", :params => { email: test_user.email, password: 'wrongpassword'}
    expect(response).to render_template(:new)
  end

  it "renders login if email does not match" do
    test_user = users(:one)
    post "/login", :params => { email: 'wrongemail', password: test_user.password_digest}
    expect(response).to have_http_status(:unprocessable_entity)
    expect(response).to render_template(:new)
  end
end

describe 'Session access', type: :request do
 def set_session(vars = {})
  post test_session_path, params: { session_vars: vars }
 end
 
  it 'redirects to welcome if session user present' do
    #Set session for test env
    set_session(session_var_1: 'user_id')
    # Set session user_id
    session[:user_id] = users(:one).id
    # Read session
    expect(session[:user_id]).to eql(users(:one).id)
    expect(response).to be_redirect
    assert_redirected_to(:welcome)
  end
end

end
