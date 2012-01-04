require 'spec_helper'

describe "Comments" do
  
  before(:each) do
    @user = Factory(:user)
    second = Factory(:user, :name => "second", :email => "second@example.com")
    @notice = Factory(:notice, :user_id => second.id)
    visit sign_in_path
    fill_in 'Email', :with => @user.email
    fill_in 'Password', :with => @user.password
    click_button "Sign in"
  end
  
  describe "creation" do
  
    describe "failure" do
      
      it "should not create a new comment" do
        lambda do
          visit root_path
          fill_in :comment_comment, :with => ""
          click_button "Post"
        end.should_not change(Comment, :count)
      end
      
      it "should render the last viewed page" do
        visit root_path
        fill_in :comment_comment, :with => ""
        click_button "Post"
        response.should render_template('pages/home')
      end
    end
    
    describe "success" do
      
      it "should create a new comment" do
        lambda do
          visit root_path
          fill_in :comment_comment, :with => "gabba gabba"
          click_button "Post"
        end.should_not change(Comment, :count)
      end
      
      it "should render the last viewed page" do
        visit root_path
        fill_in :comment_comment, :with => "gabba gabba"
        click_button "Post"
        response.should render_template('pages/home')
      end
    end
    
  end
  
  describe "destruction" do
    
    
    describe "success" do
      
#     before(:each) do
#       comment = Factory(:comment, :notice_id => @notice.id, :user_id => @user.id)
#     end
#     
#     it "should destroy the comment" do
#       lambda do
#         visit root_path
#         click_link "Delete comment"
#       end.should change(Comment, :count).by(-1)
#     end
#     
#     it "should render the last viewed page" do
#       visit root_path
#       click_link "delete"
#       response.should render_template('pages/home')
#     end
      
    end
    
  end
  
  
end
