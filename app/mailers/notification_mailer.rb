class NotificationMailer < ApplicationMailer
  def notification_for_remider_email
    notification = params[:notification]
    @user = notification.reminder.user
    @reminder = notification.reminder
    user_email_address = notification.reminder.user.email
    mail(to: user_email_address , subject: 'Remider notification') unless user_email_address.blank?
  end
end