require 'rails_helper'

RSpec.describe Reminder, type: :model do
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }
  it { is_expected.to validate_presence_of :time }
  it { is_expected.to validate_presence_of :start_date }
  it { is_expected.to validate_presence_of :end_date }
  it { should belong_to(:user) }
  it { should have_many(:notifications) }
  it { should validate_numericality_of(:day_of_month) }
  it { should validate_numericality_of(:day_of_month).is_less_than_or_equal_to(25) }
  it { should validate_numericality_of(:day_before_eom) }
  it { should validate_numericality_of(:day_before_eom).is_greater_than_or_equal_to(1) } 
  it { should validate_numericality_of(:day_before_eom).is_less_than_or_equal_to(5) } 
end  