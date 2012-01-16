# == Schema Information
#
# Table name: notices
#
#  id                     :integer         not null, primary key
#  user_id                :integer
#  doers                  :string(255)
#  time_completed         :datetime
#  open                   :boolean
#  content                :string(255)
#  display_title          :string(255)
#  self_doer              :boolean
#  description_comment_id :integer
#  due_date               :datetime
#  completed_by_id        :integer
#  created_at             :datetime
#  updated_at             :datetime
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

  describe "destruction" do
  
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
     
    describe "open_notices class method" do

      before(:each) do
        @notice_open1 = Factory(:notice, :user => @user, :open => true,
                                :due_date => Time.now)
        @notice_open2 = Factory(:notice, :user => @user, :open => true,
                                :due_date => 3.days.from_now)
        @notice_open3 = Factory(:notice, :user => @user, :open => true,
                                :due_date => 3.days.ago)
        @notice_closed = Factory(:notice, :user => @user, :open => false)
      end
            
      it "should have an open_notices class method" do
        Notice.should respond_to(:open_notices)
      end
      
      it "should return all open notices" do
        Notice.open_notices.should include(@notice_open1)
        Notice.open_notices.should include(@notice_open2)
      end
      
      it "should not return closed notices" do
        Notice.open_notices.should_not include(@notice_closed)
      end
     
      it "should return notices sorted by their due date" do
        Notice.open_notices.should == [@notice_open3, @notice_open1, @notice_open2]
      end
        
    end
  
    describe "set_open object method" do
      
      before(:each) do
        @notice_closed = Factory(:notice, :user => @user, :open => false)
      end
      
      it "should have an set_open method" do
        @notice_closed.should respond_to(:set_open)
      end
      
      it "should open the notices" do
        lambda do
          @notice_closed.set_open
        end.should change(@notice_closed, :open).to(true)
      end
      
      it "should destroy associated karma_grants" do
        @second_user = Factory(:user, :name => "second", :email => "second@example.com")
        @karma_grant = Factory(:karma_grant, :user_id => @second_user.id, 
                               :notice_id => @notice_closed.id)
        lambda do
          @notice_closed.set_open
        end.should change(KarmaGrant, :count).by(-1)
      end
      
      it "should set the notice's completed time stamp to nil" do
        @notice_closed.set_open
        @notice_closed.reload
        @notice_closed.time_completed.should == nil
      end
      
      it "should set the notice's completed by user to nil" do
        @notice_closed.set_open
        @notice_closed.reload
        @notice_closed.completed_by_id.should == nil
      end
        
      it "should set the notice's doers string to nil" do
        @notice_closed.set_open
        @notice_closed.reload
        @notice_closed.doers.should == nil
      end

    end
    
  end
  
  describe "closed notices" do
    
    describe "closed_notices method" do
      
      before(:each) do
        @notice_open = Factory(:notice, :user => @user, :open => true)
        @notice_closed1 = Factory(:notice, :user => @user, :open => false,
                                  :time_completed => 3.days.ago)
        @notice_closed2 = Factory(:notice, :user => @user, :open => false,
                                  :time_completed => 4.days.ago)
        @notice_closed3 = Factory(:notice, :user => @user, :open => false,
                                  :time_completed => Time.now)
        
      end
      
      it "should have a closed_notices class method" do
        Notice.should respond_to(:closed_notices)
      end
           
      it "should return all closed notices" do
        Notice.closed_notices.should include(@notice_closed1)
        Notice.closed_notices.should include(@notice_closed2)
        Notice.closed_notices.should include(@notice_closed3)
      end
      
      it "should return closed notices in the right order" do
        Notice.closed_notices.should == [@notice_closed3, @notice_closed1, @notice_closed2]
      end
        
      it "should not return open notices" do
        Notice.closed_notices.should_not include(@notice_open)
      end
    
    end
 
    describe "set_closed object method" do
      
      it "should have a set_closed method" do
        @notice_open.should respond_to(:set_closed)
      end
      
      it "should close the notice" do
        lambda do
          @notice_open.set_closed(@user, true, "x y z")
        end.should change(@notice_open, :open).to(false)
      end

      it "should update the notice's completed time stamp" do
        lambda do
          @notice_open.set_closed(@user, true, "x y z")
        end.should change(@notice_open, :time_completed)
      end

      it "should update the notice's complete by user when self_doer" do
        @notice_open.set_closed(@user, true, "x y z")
        @notice_open.reload
        @notice_open.completed_by_id.should == @user.id
      end

      it "should not update the notice's complete by user when not self_doer" do
        @notice_open.set_closed(@user, false, "x y z")
        @notice_open.reload
        @notice_open.completed_by_id.should_not == @user.id
      end


      it "should update the notice's doers string" do
        @notice_open.set_closed(@user, true, "x y z")
        @notice_open.reload
        @notice_open.doers.should == "x y z"
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
            
    it "should have a comments method" do
      @notice.should respond_to(:comments)
    end
    
    it "should include comments in the comments array" do
      @comment = Factory(:comment, :notice_id => @notice.id, :user_id => @user.id)
      @notice.comments.should include(@comment)
    end

    it "should have a description_comment attribute" do
      @notice.should respond_to(:description_comment)
    end
    
    it "should have the right description comment" do
      @comment = Factory(:comment, :user_id => @user.id)
      @notice.description_comment_id = @comment.id
      @notice.description_comment.should == @comment
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
