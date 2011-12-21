# == Schema Information
#
# Table name: comments
#
#  id               :integer         not null, primary key
#  original_comment :boolean
#  notice_id        :integer
#  comment          :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  user_id          :integer
#

require 'spec_helper'

describe Comment do
  
  before(:each) do
    @user = Factory(:user)
    @notice = Factory(:notice)
    @attr = { :comment => "Comment comment", :notice => @notice, :user => @user }
  end
  
  it "should create a new instance given valid attributes" do
    Comment.create!(@attr)
  end
  
  describe "associations" do
    
    before(:each) do
      @comment = Comment.create(@attr)
    end
    
    it "should have a user attribute" do
      @comment.should respond_to(@user)
    end

    it "should have the right associated user" do
      @comment.user.should == @user
    end

    it "should have a notice attribute" do
      @comment.should respond_to(@notice)
    end

    it "should have the right associated notice" do
      @comment.notice.should == @notice
    end
    
  end
  
  describe "validations" do
    
    it "should require a user id" do
      no_user_comment = Comment.new(@attr.merge(:user => nil))
      no_user_comment.should_not be_valid
    end
    
    it "should require a notice id" do
      no_notice_comment = Comment.new(@attr.merge(:notice => nil))
      no_notice.comment.should_not be_valid
    end
    
    it "should require nonblank content" do
      no_content_comment = Comment.new(@attr.merge(:comment => " "))
      no_content_comment.should_not be_valid
    end
    
  end



end
