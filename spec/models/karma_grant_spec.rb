# == Schema Information
#
# Table name: karma_grants
#
#  id           :integer         not null, primary key
#  user_id      :integer
#  karma_points :integer
#  created_at   :datetime
#  updated_at   :datetime
#  notice_id    :integer
#

require 'spec_helper'

describe KarmaGrant do
  
  before(:each) do
    @user = Factory(:user)
    @second_user = Factory(:user, :name => "Second", :email => "second@example.com")
    @second_notice = Factory(:notice, :user => @second_user)
    @attr = {:notice_id => @second_notice.id, :user_id => @user.id, :karma_points => 2}
  end
  
  it "should create a new instance given valid attributes" do
    KarmaGrant.create!(@attr)
  end
    
  describe "associations" do
    
    before(:each) do
      @karma_grant = KarmaGrant.create(@attr)
    end
    
    it "should have a user attribute" do
      @karma_grant.should respond_to(:user)
    end

    it "should have the right associated user" do
      @karma_grant.user.should == @user
    end

    it "should have a notice attribute" do
      @karma_grant.should respond_to(:notice)
    end

    it "should have the right associated notice" do
      @karma_grant.notice.should == @second_notice
    end
    
  end
  
  describe "validations" do
    
    it "should require a user id" do
      no_user_kg = KarmaGrant.new(@attr.merge(:user_id => nil))
      no_user_kg.should_not be_valid
    end
    
    it "should require a notice id" do
      no_notice_kg = KarmaGrant.new(@attr.merge(:notice_id => ""))
      no_notice_kg.should_not be_valid
    end
    
    it "should only allow karma points between 1 and 3" do
      four_point_kg = KarmaGrant.new(@attr.merge(:karma_points => 4))
      four_point_kg.should_not be_valid
    end
    
    it "should not allow users to grant karma to their own notices" do
      @notice = Factory(:notice, :user => @user)
      self_kg = KarmaGrant.new(@attr.merge(:notice_id => @notice.id))
      self_kg.should_not be_valid
    end
    
    it "should not allow users to grant karma to the same notice twice" do
      kg1 = Factory(:karma_grant, :notice_id => @second_notice.id, 
                    :user_id => @user.id)
      kg2 = KarmaGrant.new(@attr)
      kg2.should_not be_valid
    end
    
  end




end
