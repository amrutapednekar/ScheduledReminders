require 'rails_helper'

RSpec.describe "Users", type: :request do 
describe "signup" do
  it "gets signup page" do
    get new_user_url
    assert_response :success
    expect(response).to render_template(:new)
    expect(response).to render_template("users/new")
  end
end

describe 'POST create' do
  subject(:perform) do
    post "/users", params: {
      user: {
        email: "bob@example.com",
        password: "secret"
      }
    }
  end
  it 'increments the number of Users by 1' do
    expect { perform }.to change { User.count }.by(1)
  end 
end
end
