json.extract! reminder, :id, :title, :body, :user_id, :time, :start_date, :end_date, :day_of_month, :day_before_eom, :last_day_month, :created_at, :updated_at
json.url reminder_url(reminder, format: :json)
