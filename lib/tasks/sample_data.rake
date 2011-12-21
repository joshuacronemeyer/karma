require 'faker'

# Fills the database with sample users, notices, comments, and karma_grants

namespace :db do

  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_content
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
  
  def make_content    
    10.times do |n|
      @user = User.find(1+rand(15))
      make_notice(@user)
      sleep(1)
      puts "first loop"
    end
    
    250.times do |n|
      case (n % 9)
      when 0,2,4,6,8
        make_karma_grant()
      when 1,3,5
        make_comment(User.find(1+rand(15)))
      when 7 
        make_notice(User.find(1+rand(15)))
      end   
      sleep(1)
    end
    
    8.times do |n|
      make_notice(User.first)
      sleep(1)
    end
    
  end
  
  def make_notice(user)
    @notice = user.notices.new
    @notice.content = Faker::Lorem.sentence(3)
    @notice.self_doer = (user.id < 4)
    @notice.doers = Faker::Name.name + " " + Faker::Name.name
    @notice.save
  end
  
  def make_comment(user)
    @notice_ids = Notice.all.each.collect {|x| x.id }
    @comment = user.comments.new
    @comment.comment = Faker::Lorem.sentence(6)
    @comment.notice_id = @notice_ids[rand(@notice_ids.count)]
    @comment.save
  end
  
  def make_karma_grant()
    @user = User.find(1+rand(30))
    @notice_ids = Notice.all.each.collect {|n| n.id }
    
    #make sure we don't double-grant or self-grant
    loop {
      @notice = Notice.find(@notice_ids[rand(@notice_ids.count)])  
      break if ((@notice.karma_grants.map{|kg| kg.user_id}.include?(@user.id) == false) && (@notice.user_id != @user.id))              
    }

    @karma_grant = @user.karma_grants.new
    @karma_grant.karma_points = 1+rand(3)
    @karma_grant.notice_id = @notice.id
    @karma_grant.save
  end

  
  



end
