require 'rails_helper'

RSpec.describe User, type: :model do

  before(:all) do
    @user = User.create(email: "amruta.jadhav1@gmail.com", password: "amruta")
  end

  describe "checks id user is valid" do
    it "is not valid without a email" do
      user = User.new(email: nil)
      expect(user).to_not be_valid
    end

    it "is not valid without a password" do
      user = User.new(password_digest: nil)
      expect(user).to_not be_valid
    end
end

describe "checks validates presence of" do
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }
  it { is_expected.to validate_uniqueness_of :email }
end

describe "checks alowed values" do
  it { should allow_value("email@addresse.com").for(:email) }
  it { should_not allow_value("invalid").for(:email) }
  it { should_not allow_value("invalid.com").for(:email) }
  it { should_not allow_value("email#addresse").for(:email) }
end  

describe "associations" do
  it { should have_many(:reminders) }
end
end