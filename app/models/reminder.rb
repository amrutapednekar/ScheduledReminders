class Reminder < ApplicationRecord
  belongs_to :user
  validates :title, presence: true
  validates :body, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :day_of_month, numericality: { less_than_or_equal_to: 25}, :allow_nil => true
  validates :day_before_eom, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5}, :allow_nil => true
  validate :start_and_end_date_validation
  validate :only_one_relative_day
  
  private
  # Validates if end date is greater than start date. 
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
end
