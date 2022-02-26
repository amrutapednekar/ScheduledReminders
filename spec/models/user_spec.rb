require 'rails_helper'

RSpec.describe User, type: :model do

  before(:all) do
    @user = User.create(email: "amruta.jadhav1@gmail.com", password: "amruta")
  end

  it "is not valid without a email" do
    user = User.new(email: nil)
    expect(user).to_not be_valid
  end

  it "is not valid without a password" do
    user = User.new(password_digest: nil)
    expect(user).to_not be_valid
  end

  it 'checks that a user can be created' do
   # expect(@user).to be_valid
  end

  it 'checks that a user can be read' do
    #expect(User.find_by_email("amruta.jadhav1@gmail.com")).to eq(@user)
  end
end

RSpec.describe User, type: :model do
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }
  it { is_expected.to validate_uniqueness_of :email }
end

# Validates format of email
RSpec.describe User, type: :model do
  it { should allow_value("email@addresse.com").for(:email) }
  it { should_not allow_value("invalid").for(:email) }
  it { should_not allow_value("invalid.com").for(:email) }
  it { should_not allow_value("email#addresse").for(:email) }
end  

RSpec.describe User, type: :model do
  it { should have_many(:reminders) }
end
