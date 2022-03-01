require 'rails_helper'

RSpec.describe Notification, type: :model do
    fixtures :notifications
    it { should belong_to(:reminder) }

    describe "checks if notification is sent or not" do
        it "checks not sent" do
            test_notification = notifications(:one)
            expect(test_notification.is_pending) == true
        end

        it "checks sent" do
            test_notification = notifications(:two)
            expect(test_notification.is_pending) == false
        end
    end
    describe "Check if notifications time is in between current time and 5 minutes from now" do
        it "checks" do
            test_notification = notifications(:one)
            expect(test_notification.is_set_to_send_now) == false
        end
    end       
end  