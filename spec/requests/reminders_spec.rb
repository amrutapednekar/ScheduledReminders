require 'rails_helper'

RSpec.describe "Reminders", type: :request do
  fixtures :all
  before(:each) do
    # Authenticate user
    @test_user = users(:one)
    post "/login", :params => { email: @test_user.email, password: "amruta"}  
  end

  describe 'renders' do
    it "index" do
        get reminders_url
        expect(session[:user_id]).to eql(@test_user.id)
        expect(response).to render_template(:index)
    end
    it "new" do
      get new_reminder_url
      expect(session[:user_id]).to eql(@test_user.id)
      expect(response).to render_template(:new)
    end
    it "show" do
      reminder = reminders(:first_reminder)
      get reminder_url(reminder)
      expect(response).to render_template(:show)
    end
  end

  describe '#create' do
    subject { post "/reminders", :params => { :reminder => { :title => "My test reminder",:body=> 'Testing reminder',
    :user_id => users(:one).id, :time =>"2022-02-23 14:06:18",:start_date=>"2022-02-23", :end_date =>"2022-03-23",
    :day_of_month => 1} } }

    it "redirects to reminder_url(@reminder)" do
      expect(subject).to redirect_to(reminder_url(assigns(:reminder)))
    end
    it "redirects_to :action => :show" do
      expect(subject).to redirect_to :action => :show,:id => assigns(:reminder).id
    end

    it "redirects_to(@reminder)" do
      expect(subject).to redirect_to(assigns(:reminder))
    end

    it "redirects_to /reminders/:id" do
      expect(subject).to redirect_to("/reminders/#{assigns(:reminder).id}")
    end
  end

  describe "#create and #show" do
    it "creates a reminder and redirects to the reminder's page" do
      get "/reminders/new"
      expect(response).to render_template(:new)

      post "/reminders", :params =>  { :reminder => { :title => "My test reminder",:body=> 'Testing reminder',
      :user_id => users(:one).id, :time =>"2022-02-23 14:06:18",:start_date=>"2022-02-23", :end_date =>"2022-03-23",
      :day_of_month => 1} }

      expect(response).to redirect_to(assigns(:reminder))
      follow_redirect!

      expect(response).to render_template(:show)
      expect(response.body).to include("Reminder was successfully created.")
    end

    it "does not render a different template" do
      get "/reminders/new"
      expect(response).to_not render_template(:show)
    end
  end

  describe "validates" do
    it "title" do
     post "/reminders", :params =>  { :reminder => { :title => nil,:body=> 'Testing reminder',
      :user_id => users(:one).id, :time =>"2022-02-23 14:06:18",:start_date=>"2022-02-23", :end_date =>"2022-03-23",
      :day_of_month => 1} }
      expect(response).to render_template(:new)
      expect(response).to have_http_status(:unprocessable_entity)
    end
    it "body" do
      post "/reminders", :params =>  { :reminder => { :title => "My reminder",:body=> nil,
       :user_id => users(:one).id, :time =>"2022-02-23 14:06:18",:start_date=>"2022-02-23", :end_date =>"2022-03-23",
       :day_of_month => 1} }
       expect(response).to render_template(:new)
       expect(response).to have_http_status(:unprocessable_entity)
    end 
    it "time" do
      post "/reminders", :params =>  { :reminder => { :title => "My reminder",:body=> 'Testing reminder',
       :user_id => users(:one).id, :time =>nil,:start_date=>"2022-02-23", :end_date =>"2022-03-23",
       :day_of_month => 1} }
       expect(response).to render_template(:new)
       expect(response).to have_http_status(:unprocessable_entity)
    end
    it "start date and end date" do
      post "/reminders", :params =>  { :reminder => { :title => "Reminder",:body=> 'Testing reminder',
       :user_id => users(:one).id, :time =>"2022-02-23 14:06:18",:start_date=>nil, :end_date =>nil,
       :day_of_month => 1} }
       expect(response).to render_template(:new)
       expect(response).to have_http_status(:unprocessable_entity)
    end
  end
  
  describe "checks presence of while #create" do  
    it "title" do
       @test_user = users(:one)
       reminder = Reminder.create(:title => nil,:body=> 'Testing reminder',
       :user_id => @test_user.id, :time =>"2022-02-23 14:06:18",:start_date=>"2022-02-23", :end_date =>"2022-03-23",
       :day_of_month => 1)
       expect(reminder).not_to be_valid 
    end
    it "body" do
     @test_user = users(:one)
     reminder = Reminder.create(:title => "My reminder",:body=> nil,
     :user_id => @test_user.id, :time =>"2022-02-23 14:06:18",:start_date=>"2022-02-23", :end_date =>"2022-03-23",
     :day_of_month => 1)
     expect(reminder).not_to be_valid 
    end
    it "time" do
      @test_user = users(:one)
      reminder = Reminder.create(:title => "My reminder",:body=> "Testing reminder",
      :user_id => @test_user.id, :time =>nil,:start_date=>"2022-02-23", :end_date =>"2022-03-23",
      :day_of_month => 1)
      expect(reminder).not_to be_valid 
    end
    it "start date and end date" do
      @test_user = users(:one)
      reminder = Reminder.create(:title => "My reminder",:body=> 'Testing reminder',
      :user_id => @test_user.id, :time =>"2022-02-23 14:06:18",:start_date=>nil, :end_date =>nil,
      :day_of_month => 1)
      expect(reminder).not_to be_valid 
    end
  end  

describe "#edit and #show" do
  it "edits reminder and redirects to show reminder page" do
    reminder = reminders(:first_reminder)
    get reminder_url(reminder)
    expect(response).to render_template(:show)
    put "/reminders/#{reminder.id}", :params =>  { :reminder => { :title => "Changed title"} }
    expect(response).to redirect_to(assigns(:reminder))
    follow_redirect!
    expect(response).to render_template(:show)
    expect(response.body).to include("Reminder was successfully updated.")
  end
end

describe "checks start date can not be greater than end date" do
  it "on #create " do
    get "/reminders/new"
    expect(response).to render_template(:new)
    post "/reminders", :params =>  { :reminder => { :title => "My test reminder",:body=> 'Testing reminder',
    :user_id => users(:one).id, :time =>"2022-02-23 14:06:18",:start_date=>"2022-03-23", 
    :end_date =>"2022-02-23",:day_of_month => 1} }
    expect(response).to render_template(:new)
    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.body).to include("End date can not be greater than start date")
  end

  it "on #edit " do
    reminder = reminders(:first_reminder)
    get reminder_url(reminder)
    expect(response).to render_template(:show)
    put "/reminders/#{reminder.id}", :params =>  { :reminder => {:start_date=>"2022-03-23", 
    :end_date =>"2022-02-23"} }
    expect(response).to render_template(:edit)
    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.body).to include("End date can not be greater than start date")
  end
end

describe "checks only one relative day is selected" do
  it "on #create " do
    get "/reminders/new"
    expect(response).to render_template(:new)
    post "/reminders", :params =>  { :reminder => { :title => "My test reminder",:body=> 'Testing reminder',
    :user_id => users(:one).id, :time =>"2022-02-23 14:06:18",:start_date=>"2022-02-23", 
    :end_date =>"2022-03-23",:day_of_month => 1, :last_day_month => true} }
    expect(response).to render_template(:new)
    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.body).to include("Select one relative day")
  end

  it "on #edit " do
    reminder = reminders(:first_reminder)
    get reminder_url(reminder)
    expect(response).to render_template(:show)
    put "/reminders/#{reminder.id}", :params =>  { :reminder => {:start_date=>"2022-02-23", 
    :end_date =>"2022-03-23",:day_of_month => 1, :last_day_month => true} }
    expect(response).to render_template(:edit)
    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.body).to include("Select one relative day")
  end
end

# Rspec for Reminder -> Notifications
describe "After save of Reminder" do
  it "creates notifications when dates are valid" do
    get "/reminders/new"
    reminder = Reminder.new(:title => "My reminder",:body=> 'Testing reminder',
       :user_id => @test_user.id, :time =>"2022-02-23 14:06:18",:start_date=>"2023-02-23", :end_date =>"2023-03-23",
       :last_day_month => true)   
    expect(reminder).to be_valid
    expect { reminder.save }.to change { reminder.notifications.count }.by(1)
    expect(reminder.notifications).to be_present
  end

  it "creates correct number of notifications" do
    get "/reminders/new"
    reminder = Reminder.new(:title => "My reminder",:body=> 'Testing reminder',
       :user_id => @test_user.id, :time =>"2022-02-23 14:06:18",:start_date=>"2023-02-23", :end_date =>"2023-04-23",
       :day_of_month => 1)   
    expect(reminder).to be_valid
    expect { reminder.save }.to change { reminder.notifications.count }.by(2)
    expect(reminder.notifications).to be_present
  end

  it "does not creates notification if end date is less than today" do
    get "/reminders/new"
    reminder = Reminder.new(:title => "My reminder",:body=> 'Testing reminder',
       :user_id => @test_user.id, :time =>"2022-02-23 14:06:18",:start_date=>"2021-02-23", :end_date =>"2021-03-23",
       :last_day_month => true)   
    expect { reminder.save }.not_to change{ reminder.notifications.count }
    expect(reminder.notifications).not_to be_present
  end

  it "does not creates notification if notification date is less than start date" do
    get "/reminders/new"
    reminder = Reminder.new(:title => "My reminder",:body=> 'Testing reminder',
       :user_id => @test_user.id, :time =>"2022-02-23 14:06:18",:start_date=>"2022-02-26", :end_date =>"2022-03-23",
       :day_of_month => 25)   
    expect { reminder.save }.not_to change{ reminder.notifications.count }
    expect(reminder.notifications).not_to be_present
  end

  it "does not creates notification if notification date is greater than end date" do
    get "/reminders/new"
    reminder = Reminder.new(:title => "My reminder",:body=> 'Testing reminder',
       :user_id => @test_user.id, :time =>"2022-02-23 14:06:18",:start_date=>"2022-03-01", :end_date =>"2022-03-23",
       :day_of_month => 25)   
    expect { reminder.save }.not_to change{ reminder.notifications.count }
    expect(reminder.notifications).not_to be_present
  end

  it "deletes old notificatios on reminder #edit and create new notifications" do
    #Create reminder
    get "/reminders/new"
    reminder = Reminder.new(:title => "My reminder",:body=> 'Testing reminder',
      :user_id => @test_user.id, :time =>"2022-02-23 14:06:18",:start_date=>"2023-02-23", :end_date =>"2023-03-23",
      :last_day_month => true)   
    expect(reminder).to be_valid
    expect { reminder.save }.to change { reminder.notifications.count }.by(1)
    expect(reminder.notifications).to be_present
    old_notifications = reminder.notifications

    # Edit reminder
    get reminder_url(reminder)
    expect(response).to render_template(:show)
    put "/reminders/#{reminder.id}", :params =>  { :reminder => { :end_date => "2023-06-23"} }
    expect(response).to redirect_to(assigns(:reminder))
    follow_redirect!
    expect(response).to render_template(:show)
    expect(response.body).to include("Reminder was successfully updated.")
    new_notifications = reminder.notifications

    #deletes old notificatios on reminder #edit and create new notifications 
    expect(reminder.notifications).to be_present
    expect(new_notifications).to_not include(old_notifications)
  end 
end

# Rspec dependent destroy Reminder -> Notifications
describe "Delete Reminder" do
  it "removes a record from the database" do
    reminder = Reminder.create(:title => "My reminder",:body=> 'Testing reminder',
       :user_id => @test_user.id, :time =>"2022-02-23 14:06:18",:start_date=>"2022-03-01", :end_date =>"2022-03-23",
       :day_of_month => 25) 
    expect(reminder).to be_valid
    expect { reminder.destroy }.to change { Reminder.count }.by(-1)
  end

  it "removes a dependent notifications too" do
    get "/reminders/new"
    reminder = Reminder.new(:title => "My reminder",:body=> 'Testing reminder',
       :user_id => @test_user.id, :time =>"2022-02-23 14:06:18",:start_date=>"2023-02-23", :end_date =>"2023-04-23",
       :day_of_month => 1)   
    expect(reminder).to be_valid
    expect {reminder.save }.to change { reminder.notifications.count }.by(2)
    expect(reminder.notifications).to be_present
    expect { reminder.destroy }.to change { Notification.count }.by(-2)
  end

end

end
