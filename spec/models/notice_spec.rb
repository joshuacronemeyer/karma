# == Schema Information
#
# Table name: notices
#
#  id                  :integer         not null, primary key
#  user_id             :integer
#  doers               :string(255)
#  timestamp_completed :datetime
#  open                :boolean
#  created_at          :datetime
#  updated_at          :datetime
#  description         :string(255)
#  self_doer           :boolean
#

require 'spec_helper'

describe Notice do

  before(:each) do
    @user = Factory(:user)
    @attr = { :content => "notice notice", :user => @user, :doers => "foo bar"}
  end

  it "should create a new instance given valid attributes" do
    Notice.create!(@attr)
  end
  
  it "should destroy all associated comments" do
    @notice = Notice.create!(@attr)
    @second_user = Factory(:user, :name => "second", :email => "second@example.com")
    @comment = Factory(:comment, :notice => @notice, :user => @second_user)
    lambda do
      @notice.destroy
    end.should change(Comment, :count).by(1)
  end
  
  it "should destroy all associated karma_grants" do
    @notice = Notice.create!(@attr)
    @second_user = Factory(:user, :name => "second", :email => "second@example.com")
    @karma_grant = Factory(:karma_grant, :notice => @notice, :user => @second_user)
    lambda do
      @notice.destroy
    end.should change(KarmaGrant, :count).by(1)
  end
  
  describe "associations" do
  
    before(:each) do
      @notice = Notice.create(@attr)
    end
    
    it "should have a user attribute" do
      @notice.should respond_to(:user)
    end

    it "should have the right associated user" do
      @notice.user.should == @user
    end
    
  end
  
  describe "open notices" do

    before(:each) do
      @notice = Notice.create(@attr)
    end
    
    it "should have an open_notices class method" do
      @notice.should respond_to(:open_notices)
    end
    
    describe "open_notices method" do
      
      before(:each) do
        @notice_open1 = Factory(:notice, :user => @user, :open => true)
        @notice_open2 = Factory(:notice, :user => @user, :open => true)
        @notice_closed = Factory(:notice, :user => @user, :open => false)
      end
      
      it "should return all open notices" do
        Notice.open_notices.should == [@notice_open1, @notice_open2]
      end
      
      it "should not return closed notices" do
        Notice.open_notices.should_not include(@notice_closed)
      end
      
    end
    
  end
  
  describe "closed notices" do
    
    it "should have a closed_notices class method" do
      User.should respond_to(:closed_notices)
    end
    
    describe "closed_notices method" do

      before(:each) do
        @notice_open = Factory(:notice, :user => @user, :open => true)
        @notice_closed1 = Factory(:notice, :user => @user, :open => false)
        @notice_closed2 = Factory(:notice, :user => @user, :open => false)
      end
            
      it "should return all closed notices" do
        Notice.closed_notices.should == [@notice_closed1, @notice_closed2]
      end
      
      it "should not return open notices" do
        Notice.closed_notices.should_not include(@notice_open)
      end
    
    end
    
  end
  
  describe "karma_grants" do
    
    before(:each) do
      @notice = Notice.create(@attr)
    end
    
    it "should have a karma_grants method" do
      @notice.should respond_to(:karma_grants)
    end
    
    it "should have a total_karma method" do
      @notice.should respond_to(:total_karma)
    end
    
    it "should include karma_grants in the karma_grant array" do
      @second_user = Factory(:user, :name => "second", :email => "second@example.com")
      @third_user = Factory(:user, :name => "third", :email => "third@example.com")
      @second_karma_grant = Factory(:karma_grant, :notice => @notice, :user => @second_user)
      @third_karma_grant = Factory(:karma_grant, :notice => @notice, :user => @third_user)
      @notice.karma_grants.should include(@second_karma_grant)
      @notice.karma_grants.should include(@third_karma_grant)
    end
            
  end
  
  describe "comments" do
    
    before(:each) do
      @notice = Notice.create(@attr)
    end
    
    it "should have a comments method" do
      @notice.should respond_to(:comments)
    end
    
    it "should include comments in the comments array" do
      @comment = Factory(:comment, :notice => @notice)
      @notice.comments.should include(@comment)
    end
        
  end
        
  describe "validations" do
    
    it "should reject notices with blank content" do
      blank_notice = Notice.new(@attr.merge(:content => " "))
      blank_notice.should_not be_valid
    end
    
    it "should reject notices with no users identified" do
      no_users_notice = Notice.new(@attr.merge(:doers => " ", :self_doer => false))
      no_users_notice.should_not be_valid
    end
    
    it "should require a user id" do
      no_user_id_notice = Notice.new(@attr.merge(:user_id => nil))
      no_user_id_notice.should_not be_valid
    end
        
  end

end
