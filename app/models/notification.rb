class Notification < ApplicationRecord
  belongs_to :reminder
 # scope :is_pending, -> { where(is_active: true, is_sent: false) }
 # scope :is_set_to_send_now, -> { where(date: Today.date, time: Time.now .. 5.minutes.from_now(Time.now)) }
  
 # Check if notificationn is active and not sent yet
  def is_pending
    self.is_active && !self.is_sent
  end

  # Check if notifications time is in between current time and 5 minutes from now
  def is_set_to_send_now
    checktime = self.time.strftime("%H:%M").between?(Time.now.strftime("%H:%M"), 5.minutes.from_now(Time.now).strftime("%H:%M"))
    (self.date == Date.today) && checktime
  end
end
