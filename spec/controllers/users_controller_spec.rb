require 'spec_helper'

describe UsersController do

  render_views

  describe "GET 'index'" do
  
    describe "for non-signed-in users" do

      before(:each) do
        @user = Factory(:user)
      end

      it "should deny access" do
        get :index
        response.should redirect_to(new_user_session_path)
      end
      

    end
    
    describe "for signed-in users" do
      
      before(:each) do
        @user = test_sign_in(Factory(:user))
        second = Factory(:user, :name => Faker::Name.name, :email => "another@example.com")
        third = Factory(:user, :name => Faker::Name.name, :email => "another@example.net")
        
        @users = [@user, second, third]

        
      end
        
      it "should be successful" do
        get :index
        response.should  be_success
      end
      
      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => "All users")
      end
      
      it "should have an element for each user" do
        get :index
        @users[0..2].each do |user|
          response.should have_selector("li", :content => user.name)
        end
      end
      
      it "should paginate users" do
        30.times do
          @users << Factory(:user, :name => Faker::Name.name, :email => Factory.next(:email))
        end
        get :index
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :href => "/users?page=2", 
                                           :content => "2")
        response.should have_selector("a", :href => "/users?page=2", 
                                           :content => "Next")
      end

      it "should not show delete links to non-admins" do
        get :index
        response.should_not have_selector("a", :content => "delete")
      end
      
      it "should not show make admin links" do
        get :index
        response.should_not have_selector("a", :content => "Make admin")
      end
      
      it "should not show revoke admin links" do
        get :index
        response.should_not have_selector("a", :content => "Revoke")
      end
            
    end
   
    describe "for admins" do
      
      before(:each) do
        @admin = Factory(:user, :name => "admin", :email => "admin@example.com", :admin => true)
        test_sign_in(@admin)
        second = Factory(:user, :name => Faker::Name.name, :email => "another@example.com", :admin => true)
        third = Factory(:user, :name => Faker::Name.name, :email => "another@example.net", :admin => false)
      end
      
      it "should show delete links" do
        get :index
        response.should have_selector("a", :content => "delete")
      end
      
      it "should show make admin links" do
        get :index
        response.should have_selector("a", :content => "Make admin")
      end
      
      it "should show revoke admin links" do
        get :index
        response.should have_selector("a", :content => "Revoke")
      end
      
    end
     
     
  end

  describe "GET 'show'" do
    
    describe "for non-signed-in users" do

      before(:each) do
        @user = Factory(:user)
      end
      
      it "should deny access" do
        get :show, :id => @user
        response.should redirect_to(new_user_session_path)
      end
      
    end
    
    describe "for signed-in users" do
      
      before(:each) do
           @user = Factory(:user)
           test_sign_in(@user)
           @notice = Factory(:notice, :user_id => @user.id,
                             :open => false, :content => "first notice")
           @second_user = Factory(:user, :name => "second", :email => "second@example.com")
           @second_notice = Factory(:notice, :user_id => @second_user.id,
                                    :content => "second notice")
      end
    
      it "should be successful" do
          get :show, :id => @user
          response.should be_success
      end
    
      it "should find the right user" do
          get :show, :id => @user
          assigns(:user).should == @user
      end
    
      it "should have the right title" do
        get :show, :id => @user
        response.should have_selector("title", :content => @user.name)
      end
    
      it "should paginate the user's feed items" do
        @notices = []
        30.times do
           @notices << Factory(:notice, :user_id => @user.id, 
                                        :content => Faker::Lorem.sentence(3),
                                        :self_doer => true)
        end
        @comments = []
        @notices.each do |n|
          2.times do
            @comments << Factory(:comment, :user_id => @user.id,
                                           :content => Faker::Lorem.sentence(5),
                                           :notice_id => n.id)
          end
        end
        get :show, :id => @user
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :href => "/users/1?page=2", 
                                           :content => "2")
        response.should have_selector("a", :href => "/users/1?page=2", 
                                           :content => "Next")
      end
                                         
      it "should include the user's name" do
        get :show, :id => @user
        response.should have_selector("span", :content => @user.name)
      end
    
      it "should have a profile image" do
        get :show, :id => @user
        response.should have_selector("img", :class => "gravatar")
      end

      it "should show the user's notices" do
        @notice.update_attribute(:self_doer, true)
        get :show, :id => @user
        response.should have_selector("div.closed_notice_description",
                                      :content => @notice.content )
        response.should have_selector("div.closed_notice_doers", :content => @user.name)
      end
      
      it "should show a karma grant form for the user's notices" do
        get :show, :id => @second_user
        response.should have_selector("form", :class => "new_karma_grant")
      end
      
      it "should show a comment form for the user's notices" do
        get :show, :id => @second_user
        response.should have_selector("form", :class => "new_comment")
      end
      
      it "should show a 'Claim this task' link for the user's open notices" do
        @notice.update_attribute(:open, true)
        get :show, :id => @user
        response.should have_selector("a", :url => notice_claim_path(@notice),
                                           :content => "Claim this task")
      end
      
      it "should show a re-open link for the user's closed notices" do
        get :show, :id => @user
        response.should have_selector("a", :url => notice_claim_path(@notice),
                                           :content => "Mark this task as uncompleted")
      end
      
      it "should show notices the user has completed" do
        @second_notice.update_attribute(:completed_by_id => @user.id)
        get :show, :id => @user
        response.should have_selector("div.closed_notice_description", 
                                      :content => @second_notice.content)
      end

      it "should show a re-open link for notices the user has completed" do
        @second_notice.update_attribute(:completed_by_id => @user.id)
        get :show, :id => @user
        response.should have_selector("a", :url => notice_claim_path(@second_notice))
      end
      
      it "should show the user's comments" do
        @comment = Factory(:comment, :user_id => @user.id, :notice_id => @notice.id)
        get :show, :id => @user
        response.should have_selector("div.notice_comments")
        response.should have_selector("div.comment_item", :content => @user.name)
      end
    
      it "should combine comments with their notices" do
        @comment = Factory(:comment, :user_id => @user.id, :notice_id => @notice.id)
        get :show, :id => @user.id
        response.should_not have_selector("div.user_show_item_description", :content => "posted a notice")
        response.should have_selector("div.user_show_item_description", :content => "posted and commented on")
      end
      
      it "should show delete links for a user's own notices" do 
        get :show, :id => @user
        response.should have_selector("a", :class=>"notice_delete_link", :content => "delete")
      end
    
      it "should show delete links for a user's own comments" do
        @comment = Factory(:comment, :user_id => @user.id, :notice_id => @notice.id)
        get :show, :id => @user
        response.should have_selector("a", :class=>"comment_delete_link", :content => "delete")
      end
    
      describe "karma points" do
      
        before(:each) do
          @second_user = Factory(:user, :name => Faker::Name.name, :email => "another@example.com")
        
          @second_user_notice = Factory(:notice, :user_id => @second_user.id, 
                                        :content => Faker::Lorem.sentence(3),
                                        :self_doer => true)
                                      
          @karma_grant = Factory(:karma_grant, :user_id => @user.id,
                                               :notice_id => @second_user_notice.id)
        end
      
        it "should show karma grants for the user's notices" do 
          get :show, :id => @second_user
          response.should have_selector("div.closed_notice_karma_points", :content => "total karma")
        end
      
        describe "for a user's own page" do

          it "should show a user's own karma grants" do
            get :show, :id => @user
            response.should have_selector("div.user_show_item_description", :content => "granted")
          end
        
          it "should show revoke links for a user's own karma_grants" do
            get :show, :id => @user
            response.should have_selector("a", :class=>"karma_revoke_link", :content => "revoke")
          end

        end
    
        describe "for another user's page" do

          it "should not show another user's karma grants" do
            third_user = Factory(:user, :name => Faker::Name.name, :email => "another@example.mil")
            third_karma_grant = Factory(:karma_grant, :user_id => third_user.id,
                                                        :notice_id => @user.notices.first)
            get :show, :id => third_user
            response.should_not have_selector("div.user_show_item_description", :content => "granted")
          end

        end

      end 
    
    end
  
  end
   
  describe "GET 'edit'" do 
   
    describe "for non-signed-in users" do

      before(:each) do
        @user = Factory(:user)
      end
      
      it "should deny access" do
        get :edit, :id => @user
        response.should redirect_to(new_user_session_path)
      end
      
    end
    
    describe "for the correct user" do
      
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end
    
      it "should be successful" do
        get :edit, :id => @user
        response.should have_selector("title", :content => "Edit")
      end
    
      it "should have a link to change the Gravatar" do
        get :edit, :id => @user
        gravatar_url = "http://gravatar.com/emails"
        response.should have_selector("a", :href => gravatar_url,
                                           :content => "change")
      end
    
    end
  
    describe "for the incorrect user" do
    
       before (:each) do
          @user = Factory(:user)
       end

        describe "when not signed-in" do

          it "should deny access" do
            get :edit, :id => @user
            response.should redirect_to(new_user_session_path)
          end

        end

        describe "when signed-in" do

          before (:each) do
            wrong_user = Factory(:user, :name => "Wrong User", :email => "user@example.net")
            test_sign_in(wrong_user)
          end

          it "should not allow users to edit others' profiles" do
            get :edit, :id => @user
            response.should redirect_to(root_path)
          end
          
        end
    end
  
  end
  
  describe "POST 'toggle_admin'" do
    
    before(:each) do
      @user = Factory(:user, :admin => false)
    end
    
    describe "for admins" do
      
      before(:each) do
        @admin = Factory(:user, :admin => true, :name => "admin", :email => "admin@example.com") 
      end
      
      it "should change the user's admin status" do
        test_sign_in(@admin)
        post :toggle_admin, :user_id => @user.id
        User.find(@user.id).admin?.should be_true
      end
    
      it "should not allow admin to change their own status" do
        test_sign_in(@admin)
        post :toggle_admin, :user_id => @admin.id
        User.find(@admin.id).admin?.should be_true
      end
      
    end
    
    describe "for non-admins" do
      
     it "should not change the user's admin status" do
        test_sign_in(@user)
        post :toggle_admin, :user_id => @user.id
        User.find(@user.id).admin?.should_not be_true
     end

    end
    
  end
   
  describe "DELETE 'destroy'" do
    
    before(:each) do
      @user = Factory(:user)
    end
    
    describe "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(new_user_session_path)
      end
    end
    
    describe "as a non-admin user" do
      it "should protect the page" do
        test_sign_in(@user)
        delete :destroy, :id => @user
        response.should redirect_to(user_path)
      end
    end
    
    describe "as an admin user" do
      
      before(:each) do
        @admin = Factory(:user, :name => "admin", :email => "admin@example.com", :admin => true)
        test_sign_in(@admin)
      end
      
      it "should destroy the user" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end
      
      it "should redirect to the users page" do
        delete :destroy, :id => @user
        response.should redirect_to(users_path)
      end
      
      it "should not allow admins to destroy themselves" do
        delete :destroy, :id => @admin
        response.should redirect_to('/users')
      end
      
    end
  
  end
  
end
