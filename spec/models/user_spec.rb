# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  name                   :string(255)
#  email                  :string(255)
#  encrypted_password     :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  password_salt          :string(255)
#  failed_attempts        :integer         default(0)
#  unlock_token           :string(255)
#  locked_at              :datetime
#
require 'spec_helper'

describe User do
  
  before( :each ) do
    @attr = {
      :name => "Example User",
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"      }
  end
  
  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end
  
  describe "validations" do
  
    it "should require a name" do
      no_name_user = User.new(@attr.merge(:name => ""))
      no_name_user.should_not be_valid
    end
  
    it "should require an email address" do
      no_email_user = User.new(@attr.merge(:email => ''))
      no_email_user.should_not be_valid
    end
  
    it "should reject names that are too long" do
      long_name = "a" * 51
      long_name_user = User.new(@attr.merge(:name => long_name))
      long_name_user.should_not be_valid
    end
  
    it "should accept valid email addresses" do
      addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
      addresses.each do |address|
        valid_email_user = User.new(@attr.merge(:email => address))
        valid_email_user.should be_valid
      end
    end
  
    it "should reject invalid email addresses" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
      addresses.each do |address|
        valid_email_user = User.new(@attr.merge(:email => address))
        valid_email_user.should_not be_valid
      end
    end
  
    it "should reject duplicate email addresses" do
      #Put a user with given email address into the database
      User.create!(@attr)
      user_with_duplicate_email = User.new(@attr)
      user_with_duplicate_email.should_not be_valid
    end
  
    it "should reject email addresses identical up to case" do
      upcased_email = @attr[:email].upcase
      User.create!(@attr.merge(:email => upcased_email))
      user_with_duplicate_email = User.new(@attr)
      user_with_duplicate_email.should_not be_valid
    end
  
  end

  describe "admin attribute" do
    
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it "should respond to admin" do
      @user.should respond_to(:admin)
    end
    
    it "should not be an admin by default" do
      @user.should_not be_admin
    end
    
    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  
  end
  
  describe "notice associations" do
    
    before(:each) do
      @user = User.create(@attr)
      @notice1 = Factory(:notice, :user => @user)
      @notice2 = Factory(:notice, :user => @user)
    end
    
    it "should have a notices attribute" do 
      @user.should respond_to(:notices)
    end
    
#    it "should have a post_notice method" do
#      @user.should respond_to(:post_notice)
#    end
    
#    it "should have create a new notice" do
#      lambda do
#        @user.post_notice("notice something", "foo and bar", true, "comment comment")
#      end.should change(Notice, :count).by(1)
#    end
        
    it "should return the notices" do
      @user.notices.include?(@notice1).should be_true
    end
    
    it "should destroy associated notices when the user is destroyed" do
      @user.destroy
      [@notice1, @notice2].each do |n|
        Notice.find_by_id(n.id).should be_nil
      end
    end
 
  end

  describe "comment associations" do
    
    before(:each) do
      @user = User.create(@attr)
      @second_user = User.create(@attr.merge(:name => "second", 
                                      :email => "second@example.com"))
      @notice = Factory(:notice, :user => @second_user)
      @comment1 = Factory(:comment, :user => @user,
                                   :notice => @notice)
      @comment2 = Factory(:comment, :user => @user,
                                    :notice => @notice)
    end
    
    it "should have a comments attribute" do 
      @user.should respond_to(:comments)
    end
    
    it "should return the right comments" do
      @user.comments.should == [@comment1, @comment2] 
    end
    
    it "should destroy associated comments when the user is destroyed" do
      @user.destroy
      [@comment1, @comment2].each do |c|
        Comment.find_by_id(c.id).should be_nil
      end
    end
    
  
  end
 
  describe "karma_grant associations" do
    
    before(:each) do
      @user = User.create(@attr)
      @second_user = User.create(@attr.merge(:name => "second", 
                                      :email => "second@example.com"))
      @notice1 = Factory(:notice, :user_id => @second_user.id)
      @notice2 = Factory(:notice, :user_id => @second_user.id)
      @karma_grant1 = Factory(:karma_grant, :user_id => @user.id,
                             :notice_id => @notice1.id)
      @karma_grant2 = Factory(:karma_grant, :user_id => @user.id,
                             :notice_id => @notice2.id)
    end
                             
    it "should have a karma_grants attribute" do
      @user.should respond_to(:karma_grants)
    end
    
    it "should return the right karma_grants" do
      @user.karma_grants.should == [@karma_grant1, @karma_grant2]
    end
    
    it "should destroy associated karma_grants when the user is destroyed" do
      @user.destroy
      [@karma_grant1, @karma_grant2].each do |kg|
        KarmaGrant.find_by_id(kg.id).should be_nil
      end
    end
       
  end

  describe "posts feed" do

    before(:each) do
      @user = User.create(@attr)
      @second_user = Factory(:user, :name => "Second", :email => "second@example.com")
      @third_user = Factory(:user, :name => "third", :email => "third@example.com")
      
      @notice = Factory(:notice, :user => @user, :created_at => 6.hours.ago)
      @second_notice = Factory(:notice, :user => @second_user)
      @third_notice = Factory(:notice, :user => @third_user)
      
      @comment = Factory(:comment, :user => @user, :notice => @second_notice, :created_at => 3.hours.ago)
      @second_comment = Factory(:comment, :user => @second_user, :notice => @notice)
      
      @karma_grant = Factory(:karma_grant, :user => @user, 
                             :notice => @third_notice, :created_at => 1.hour.ago)
      @second_karma_grant = Factory(:karma_grant, :user => @second_user, 
                                    :notice => @notice)
    end
    
    it "public_posts should have the posts in the right order" do
      @comment2 = Factory(:comment, :user => @user, :notice => @third_notice, :created_at => 4.hours.ago)
      @user.public_posts.map{ |p| p.timestamp }.should == [@comment.created_at, @comment2.created_at, @notice.created_at]
    end
    
    it "private_posts should have the posts in the right order" do
      @user.private_posts.map{ |p| p.timestamp }.should == [@karma_grant.created_at, @comment.created_at, @notice.created_at]
    end

    it "should have a private_posts method" do
      @user.should respond_to(:private_posts)
    end
    
    it "should have a public_posts method" do
      @user.should respond_to(:public_posts)
    end
    
    it "public_posts should include the users notices" do
      @user.public_posts.map{|p| p.notice }.include?(@notice).should be_true
    end

    it "private_posts should include the users notices" do
      @user.public_posts.map{|p| p.notice }.include?(@notice).should be_true
    end

    it "public_posts should not include other users notices alone" do
      @user.public_posts.map{|p| p.notice if p.type == :notice }.include?(@second_notice).should_not be_true
    end
    
    it "private_posts should not include other users notices alone" do
      @user.private_posts.map{|p| p.notice if p.type == :notice }.include?(@second_notice).should_not be_true
    end    

    it "public_posts should include the users comments" do
      @user.public_posts.map{ |p| p.comment }.include?(@comment).should be_true
    end
    
    it "private_posts should include the users comments" do
      @user.private_posts.map{ |p| p.comment }.include?(@comment).should be_true
    end
    
    it "public_posts should not include other users comments" do
      @user.public_posts.map{ |p| p.comment }.include?(@second_comment).should_not be_true
    end

    it "private_posts should not include other users comments" do
      @user.private_posts.map{ |p| p.comment }.include?(@second_comment).should_not be_true
    end
    
    it "public_posts should not include the users karma_grants" do
      @user.public_posts.map{ |p| p.karma_grant }.include?(@karma_grant).should_not be_true
    end

    it "private_posts should include the users karma_grants" do
      @user.private_posts.map{ |p| p.karma_grant }.include?(@karma_grant).should be_true
    end
    
    it "public_posts should not include other users karma_grants" do
      @user.public_posts.map{ |p| p.karma_grant }.include?(@second_karma_grant).should_not be_true
    end
    
    it "private_posts should not include other users karma_grants" do
      @user.private_posts.map{ |p| p.karma_grant }.include?(@second_karma_grant).should_not be_true
    end
 
  end
  

end

# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  name                   :string(255)
#  email                  :string(255)
#  encrypted_password     :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  password_salt          :string(255)
#  failed_attempts        :integer         default(0)
#  unlock_token           :string(255)
#  locked_at              :datetime
#  admin                  :boolean
#

