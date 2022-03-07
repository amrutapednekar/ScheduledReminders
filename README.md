# README 

This README is a  document whatever steps are necessary to get the
application up and running.

##### Prerequisites

The setups steps expect following tools installed on the system.

- Github
- Ruby [ruby 2.7.2p137]
- Rails [6.1.3.1]
- PostgreSQL14 - To launch it run pgAdmin

##### 1. Check out the repository

```
git clone https://github.com/amrutapednekar/ScheduledReminders.git
cd ScheduledReminders
bundle install
```

##### 2. Create database.yml file

Copy the sample database.yml file and edit the database configuration as required.

 File location : config/database.yml.sample config/database.yml


##### 3. Create and setup the database

Run the following commands to create and setup the database.

```ruby
bundle exec rake db:create
bundle exec rake db:setup
bundle exec rake db:migrate
bundle exec rake db:seed
```

##### 4. Start the Rails server

You can start the rails server using the command given below.

```ruby
rails s
```

And now you can visit the site with the URL http://localhost:3000

##### 4. Login 

You can login with already created users.
 Email address : user1@gmail.com
 password : user1

 Email address : user2@gmail.com
 password : user2

 ##### 5. Create reminder 
 Corrosponding notifications will be automatically created in database.



 ##### 6. Check email notification in dev mode 
 
```ruby
rake send_reminder_email:my_task
```

 ##### 7. To set crontab 
 
```ruby
bundle exec wheneverize .
bundle exec whenever
whenever --update-crontab
```
The whenever gem only runs on *nix systems (Linux, Mac OSX, BSD, ...) and not on windows.
For Windows, schedule it through Task Scheduler.

##### 8. Run Rspec 
 
```ruby
bundle exec rspec spec
