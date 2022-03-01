require 'rails_helper'

RSpec.describe "Reminders", type: :request do
  fixtures :reminders
  describe '#index' do
    it "renders the index" do
      get reminders_url
      assert_response :redirect
     end
  end

  describe '#new' do
    it "redirects to new" do
    get new_reminder_url
    assert_response :redirect
     end
  end

  describe '#show' do
   it "should show reminder" do
    reminder = reminders(:first_reminder)
    get reminder_url(reminder)
    assert_response :redirect
    end
  end
end
