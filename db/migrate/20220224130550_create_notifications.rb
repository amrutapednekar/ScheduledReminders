class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.date :date
      t.time :time
      t.references :reminder, null: false, foreign_key: true
      t.boolean :is_sent, default: false
      t.boolean :is_active, default: true
      t.timestamps
    end
  end
end
