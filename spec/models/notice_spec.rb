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
    @notice = Factory(:notice, :user_id => @user.id)
    @attr = { :content => "notice notice", :user_id => @user.id, :doers => "foo bar"}
  end

  it "should create a new instance given valid attributes" do
    Notice.create(@attr)
  end
  
  it "should destroy all associated comments" do
    @second_user = Factory(:user, :name => "second", :email => "second@example.com")
    @comment = Factory(:comment, :notice_id => @notice.id, :user_id => @second_user.id)
    lambda do
      @notice.destroy
    end.should change(Comment, :count).by(-1)
  end
  
  it "should destroy all associated karma_grants" do
    @second_user = Factory(:user, :name => "second", :email => "second@example.com")
    @karma_grant = Factory(:karma_grant, :notice => @notice, :user => @second_user)
    lambda do
      @notice.destroy
    end.should change(KarmaGrant, :count).by(-1)
  end
  
  describe "associations" do
      
    it "should have a user attribute" do
      @notice.should respond_to(:user)
    end

    it "should have the right associated user" do
#      puts @notice.inspect
      @notice.user.should == @user
    end
    
  end
  
  describe "open notices" do
    
    it "should have an open_notices class method" do
      Notice.should respond_to(:open_notices)
    end
    
    describe "open_notices method" do
      
      before(:each) do
        @notice_open1 = Factory(:notice, :user => @user, :open => true)
        @notice_open2 = Factory(:notice, :user => @user, :open => true)
        @notice_closed = Factory(:notice, :user => @user, :open => false)
      end
      
      it "should return all open notices" do
        Notice.open_notices.should include(@notice_open1)
        Notice.open_notices.should include(@notice_open2)
      end
      
      it "should not return closed notices" do
        Notice.open_notices.should_not include(@notice_closed)
      end
      
    end
    
  end
  
  describe "closed notices" do
    
    it "should have a closed_notices class method" do
      Notice.should respond_to(:closed_notices)
    end
    
    describe "closed_notices method" do

      before(:each) do
        @notice_open = Factory(:notice, :user => @user, :open => true)
        @notice_closed1 = Factory(:notice, :user => @user, :open => false)
        @notice_closed2 = Factory(:notice, :user => @user, :open => false)
      end
            
      it "should return all closed notices" do
        Notice.closed_notices.should include(@notice_closed1)
        Notice.closed_notices.should include(@notice_closed2)
      end
      
      it "should not return open notices" do
        Notice.closed_notices.should_not include(@notice_open)
      end
    
    end
    
  end
  
  describe "karma_grants" do
    

    it "should have a karma_grants method" do
      @notice.should respond_to(:karma_grants)
    end
    
    it "should have a total_karma method" do
      @notice.should respond_to(:total_karma)
    end
    
 #   it "should have a grant_karma method" do
#      @notice.should respond_to(:grant_karma)
#    end
    
#    it "grant_karma should create a new karma_grant" do
#      @second_user = Factory(:user, :name => "second", :email => "second@example.com")
#      lambda do
#        @notice.grant_karma(2, @second_user)
#      end.should change(KarmaGrant, :count).by(1)
#    end
    
#    it "should have a revoke_karma method" do
#      @notice.should respond_to(:revoke_karma)
#    end
    
#    it "revoke_karma should destroy the karma_grant" do
#      u2 = Factory(:user, :name => "second", :email => "second@example.com")
#      n2 = Factory(:notice, :user_id => u2.id)
#      kg = Factory(:karma_grant, :user_id => @user.id, :notice_id => n2.id)
#      lambda do
#        @notice.revoke_karma
#     end.should change(KarmaGrant, :count).by(1)
#    end
    
    
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
    
 #   it "should have an add_comment method" do
#      @notice.should respond_to(:add_comment)
#    end
    
#    it "should create a new comment" do
#      lambda do
#        @notice.add_comment("comment comment")
#      end.should change(Comment, :count).by(10)
#    end
    
        
    it "should have a comments method" do
      @notice.should respond_to(:comments)
    end
    
    it "should include comments in the comments array" do
      @comment = Factory(:comment, :notice_id => @notice.id, :user_id => @user.id)
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
