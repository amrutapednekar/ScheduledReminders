class CreateReminders < ActiveRecord::Migration[6.1]
  def change
    create_table :reminders do |t|
      t.string :title
      t.text :body
      t.references :user, null: false, foreign_key: true
      t.time :time
      t.date :start_date
      t.date :end_date
      t.integer :day_of_month
      t.integer :day_before_eom
      t.boolean :last_day_month

      t.timestamps
    end
  end
end
