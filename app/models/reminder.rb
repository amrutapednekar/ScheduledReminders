class Reminder < ApplicationRecord
  belongs_to :user
  validates :title, presence: true
  validates :body, presence: true
  validates :time, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :day_of_month, numericality: { less_than_or_equal_to: 25}, :allow_nil => true
  validates :day_before_eom, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5}, :allow_nil => true
  validate :start_and_end_date_validation
  validate :only_one_relative_day
  has_many :notifications, :dependent => :destroy
  after_save :create_notifications_for_reminder
  
  private
  # Validates if the end date is greater than the start date. 
  # If not, displays an error message. 
  def start_and_end_date_validation()
    errors.add(:end_date, "End date can not be greater than start date") if (!end_date.blank?) && (end_date.before? start_date)
  end

  # Checks if only one relative day is selected among
  # 1. day of the month
  # 2. days before end of the month
  # 3. Last day of the month
  # If not, displays an error message.
  def only_one_relative_day
    unless day_of_month? ^ day_before_eom? ^ last_day_month
      errors.add(:base, "Select one relative day")
    end
  end

  # Creates notifications table entries for reminder
  # 1. Delete old notification for reminder. This is called only on Reminder edit
  # 2. Calculates number of months for reminder
  # 3. For every month, it calculates a reminder date. 
  # 4. Creates entry in notification table with date = calculated date 
  def create_notifications_for_reminder
    delete_old_notifications_on_edit
    reminder_months = find_number_of_months_between(self.start_date, self.end_date)
    month_count = 0
    until month_count > reminder_months
     reminderdate = find_date_for_reminder_notification(month_count)
    self.notifications.create({ :time => self.time, :date => reminderdate}) unless reminderdate.blank?
     month_count += 1
    end
  end

  def find_number_of_months_between(date1,date2)
    return (date2.year * 12 + date2.month) - (date1.year * 12 + date1.month)
  end

   # Gives a date of last day of month OR
   # Gives date for nth day of month OR
   # Gives date for n days before end of the month
   # Returns a date for reminder
  def find_date_for_reminder_notification(month_count)
    reminderdate = (self.start_date + month_count.month).end_of_month unless self.last_day_month.blank?
    reminderdate = (self.start_date + month_count.month).beginning_of_month + ( self.day_of_month- 1) unless self.day_of_month.blank? 
    reminderdate = (self.start_date + month_count.month).end_of_month - self.day_before_eom unless self.day_before_eom.blank?
    date_out_of_limit = (reminderdate.before? Date.today) ||  (reminderdate.after? self.end_date)
    return (reminderdate && date_out_of_limit) ? nil : reminderdate
  end

  # Delete all old notifications on reminder edit
  def delete_old_notifications_on_edit
    if self.notifications
    self.notifications.destroy_all if self.created_at != self.updated_at
    end
  end  
end
