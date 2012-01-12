require 'spec_helper'

describe CommentsController do

  render_views
  
  describe "access control" do
    
    it "should deny access to 'create'" do
      get :create
      response.should redirect_to(new_user_session_path)
    end
    
    it "should deny access to 'destroy'" do
      @comment = Factory(:comment)
      delete :destroy, :id => @comment.id
      response.should redirect_to(new_user_session_path)
    end
    
  end
  
  describe "POST 'create'" do
    
    before(:each) do
      @user = Factory(:user)
      @notice = Factory(:notice)
      test_sign_in(@user)
    end
    
    describe "failure" do
      
      before(:each) do
        @attr = {:comment => ""}
      end
      
      it "should not create a comment" do
        lambda do
          post :create, :comment => @attr
        end.should_not change(Comment, :count)
      end
            
      it "should have a flash error message" do
        post :create, :comment => @attr
        flash[:error].should =~ /Error/i
      end
      
    end
    
    describe "success" do
      
      before(:each) do
        @attr = {:content => "FUBAR", :user_id => @user.id, :notice_id => @notice.id}
      end
      
      it "should create a comment" do
        lambda do
          post :create, :comment => @attr
        end.should change(Comment, :count).by(1)
      end
      
      it "should have a flash success message" do
        post :create, :comment => @attr
        flash[:success].should =~ /comment added/i
      end
      
    end
    
  end
  
  describe "DELETE 'destroy'" do
  
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
      @notice = Factory(:notice, :user_id => @user.id )
      @comment = Factory(:comment, :user_id => @user.id, :notice_id => @notice.id)
    end
  
    describe "for the same user" do
      
      it "should delete the comment" do
        lambda do
          delete :destroy, :id => @comment
        end.should change(Comment, :count).by(-1)
      end

    end
    
    describe "for a different user" do
      
      it "should not delete the comment" do
        @second_user = Factory(:user, :name => "second", :email => "second@example.com")
        @second_comment = Factory(:comment, :user_id => @second_user.id, :notice_id => @notice.id)
        lambda do
          delete :destroy, :id => @second_comment
        end.should_not change(Comment, :count)
      end
      
      
    end
    
  end
  



end
