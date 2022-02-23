require "application_system_test_case"

class RemindersTest < ApplicationSystemTestCase
  setup do
    @reminder = reminders(:one)
  end

  test "visiting the index" do
    visit reminders_url
    assert_selector "h1", text: "Reminders"
  end

  test "creating a Reminder" do
    visit reminders_url
    click_on "New Reminder"

    fill_in "Body", with: @reminder.body
    fill_in "Day before eom", with: @reminder.day_before_eom
    fill_in "Day of month", with: @reminder.day_of_month
    fill_in "End date", with: @reminder.end_date
    check "Last day month" if @reminder.last_day_month
    fill_in "Start date", with: @reminder.start_date
    fill_in "Time", with: @reminder.time
    fill_in "Title", with: @reminder.title
    fill_in "User", with: @reminder.user_id
    click_on "Create Reminder"

    assert_text "Reminder was successfully created"
    click_on "Back"
  end

  test "updating a Reminder" do
    visit reminders_url
    click_on "Edit", match: :first

    fill_in "Body", with: @reminder.body
    fill_in "Day before eom", with: @reminder.day_before_eom
    fill_in "Day of month", with: @reminder.day_of_month
    fill_in "End date", with: @reminder.end_date
    check "Last day month" if @reminder.last_day_month
    fill_in "Start date", with: @reminder.start_date
    fill_in "Time", with: @reminder.time
    fill_in "Title", with: @reminder.title
    fill_in "User", with: @reminder.user_id
    click_on "Update Reminder"

    assert_text "Reminder was successfully updated"
    click_on "Back"
  end

  test "destroying a Reminder" do
    visit reminders_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Reminder was successfully destroyed"
  end
end
