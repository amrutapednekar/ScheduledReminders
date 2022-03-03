namespace :send_reminder_email do
    desc "Send am email to user for his reminder"
    task my_task: :environment do
    Notification.find_each  do |notification|
        if notification.is_pending && notification.is_set_to_send_now
        NotificationMailer.with(notification: notification).notification_for_remider_email.deliver_now
        notification.is_sent = true
        notification.save
        p "email sent"
        end
    end
end
end    