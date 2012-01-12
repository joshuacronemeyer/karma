require 'spec_helper'

describe KarmaGrantsController do

  render_views
  
  describe "access control" do
    
    it "should deny access to 'create'" do
      get :create
      response.should redirect_to(new_user_session_path)
    end
    
    it "should deny access to 'destroy'" do
      @notice = Factory(:notice, :user_id => 2)
      @karma_grant = Factory(:karma_grant, :notice_id => @notice.id)
      delete :destroy, :id => @karma_grant.id
      response.should redirect_to(new_user_session_path)
    end
    
  end
  
  describe "POST 'create'" do
    
    before(:each) do
      @user = Factory(:user)
      @notice = Factory(:notice, :user_id => @user.id)
      test_sign_in(@user)
      @second_user = Factory(:user, :name => "second", :email => "second@example.com")
      @second_notice = Factory(:notice, :user_id => @second_user.id)
    end
     
    it "should not allow more than one karma grant per notice" do
      @karma_grant = Factory(:karma_grant, :notice_id => @second_notice.id, :user_id => @user.id)
      lambda do
        @attr = { :notice_id => @second_notice.id }
        post :create, :karma_grant => @attr
      end.should_not change(KarmaGrant, :count)
    end
    
    it "should not allow users to grant themselves karma" do
      @notice = Factory(:notice, :user_id => @user.id)
      lambda do
        @attr = { :user_id => @user.id, :karma_points => 2, :notice_id => @notice.id}
        post :create, :karma_grant => @attr
      end.should_not change(KarmaGrant, :count)
    end
    
    it "should not allow more than 3 karma points to be granted" do
      @attr = { :notice_id => @second_notice.id, :user_id => @user.id, :karma_points => 5}
      lambda do
        post :create, :karma_grant => @attr
      end.should_not change(KarmaGrant, :count)
    end
    
    it "should not grant karma to an open notice" do
      @second_notice.open = true
      @second_notice.save
      @attr = { :notice_id => @second_notice.id, :user_id => @user.id, :karma_points => 2}
      lambda do
        post :create, :karma_grant => @attr
      end.should_not change(KarmaGrant, :count)
    end
        
    
    describe "failure" do
      
      before(:each) do
        @attr = { :karma_points => 6, :notice_id => @second_notice.id, :user_id => @user.id }
      end
      
      it "should not grant karma" do
        lambda do
          post :create, :karma_grant => @attr
        end.should_not change(KarmaGrant, :count).by(1)
      end
      
      it "shoud display a flash error message" do
        post :create, :karma_grant => @attr.merge(:notice_id => @notice.id)
        flash[:error].should =~ /error/i
      end
      
      it "should return to the previous page" do
        session[:return_to] = root_path
        post :create, :karma_grant => @attr
        response.should redirect_to(root_path)
      end
      
    end
    
    describe "success" do
      
      before(:each) do
        @attr = {:notice_id => @second_notice.id, :user_id => @user.id, :karma_points => 2}
      end
      
      it "should grant karma" do
        lambda do
          post :create, :karma_grant => @attr
        end.should change(KarmaGrant, :count).by(1)
      end
      
      it "should display a flash success message" do
        post :create, :karma_grant => @attr
        flash[:success].should =~ /granted/i
      end
      
      it "should redirect to the last viewed page" do
        post :create, :karma_grant => @attr
        response.should redirect_to(root_path)
      end
      
    end
    
  end
   
  describe "DELETE 'destroy'" do
  
    before(:each) do
      @user = Factory(:user)
      @second = Factory(:user, :name => "second", :email => "second@example.com")
      test_sign_in(@user)
      @notice = Factory(:notice, :user_id => @user.id )
      @second_notice = Factory(:notice, :user_id => @second.id)
    end
  
    describe "for the same user" do
      it "should delete the karma_grant" do
        @karma_grant = Factory(:karma_grant, :user_id => @user.id, :notice_id => @second_notice.id)
        lambda do
          delete :destroy, :id => @karma_grant
        end.should change(KarmaGrant, :count).by(-1)
      end

    end
    
    describe "for a different user" do
      
      it "should not delete the karma_grant" do
        @second_grant = Factory(:karma_grant, :user_id => @second.id, :notice_id => @notice.id)
        lambda do
          delete :destroy, :id => @second_grant
        end.should_not change(KarmaGrant, :count)
      end
      
      
    end
    
  end
  
end
