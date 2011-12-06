require 'faker'

namespace :db do
  desc "fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_notices
  end
  
  def make_users
    admin = User.create!(:name => "amd",
                         :email => "amd@amd.com",
                         :password => "123456",
                         :password_confirmation => "123456")
    admin.toggle!(:admin)
    
    99.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@example.org"
      password = "123456"
      User.create!(:name => name,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)
    end
  end
  
  def make_notices
    User.all(:limit => 6).each do |user|
      10.times do
        @notice = user.notices.new
        @notice.description = Faker::Lorem.sentence(3)
        @notice.self_doer = (user.id < 4)
        @notice.doers = Faker::Name.name + " " + Faker::Name.name
        @notice.save
      end
    end
  end
  

  
end
