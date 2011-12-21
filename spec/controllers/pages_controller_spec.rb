require 'spec_helper'

describe PagesController do

  render_views
  
  describe "GET 'home'" do
    
    it "should be successful" do
      get :home
      response.should be_success
    end
    
    it "should have the right title" do
      get :home
      response.should have_selector("title", :content => "Home")
    end
    
    it "should show the navigation bar" do
      get :home
      response.should have_selector("nav")
    end

    describe "for signed-in users" do

      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        @notice = Factory(:notice, :user_id => @user.id)
      end
      
      it "should show a new notice form" do
        get :home
        response.should have_selector("form", :class => "new_notice")
      end

      it "should paginate posts" do
        @notices = []
        (0..32).each do |n|
          @notices[n] = Factory(:notice)
        end
        get :home
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :href => "/?page=2", 
                                           :content => "2")
        response.should have_selector("a", :href => "/?page=2", 
                                           :content => "Next")
      end
                                           
      it "should show a notice feed" do
        get :home
        response.should have_selector("div.feed")
      end
       
      it "should show the notice" do
        get :home
        response.should have_selector("div.notice_item")
        response.should have_selector("div.notice_description")
      end
        
      it "should show the notice's doers" do
        get :home
        response.should have_selector("div.notice_doers")
      end

      it "should show the notice's poster" do
        get :home
        response.should have_selector("div.notice_posted_by", :content => "Posted by:")
      end

      it "should show the notice's poster as a doer, if self_doer" do
        @notice.self_doer = true
        @notice.save
        get :home
        response.should have_selector("div.notice_doers", :content => @user.name)
      end

      it "should show a link to the poster's page" do
        get :home
        response.should have_selector("a", :href => user_path(@user), :content => @user.name,
                                                             :class => "user_show_link")
      end

      describe "comments" do
        
        before(:each) do
          @second_user = Factory(:user, :name => "second", :email => "second@example.com")
          @comment = Factory(:comment, :user_id => @second_user.id, :notice_id => @notice)
        end
        
        it "should show comments" do 
          get :home
          response.should have_selector("div.notice_comments")
          response.should have_selector("div.comment_item")
        end
      
        it "should show a link to the commenter's page" do
          get :home
          response.should have_selector("a", :href => user_path(@second_user), 
                                             :content => @second_user.name)
        end
        
        it "should only show the 3 most recent comments" do
          @second_comment = Factory(:comment, :user_id => @second_user.id, 
                                              :notice_id => @notice, :comment => "second comment")
          @third_comment = Factory(:comment, :user_id => @user.id, 
                                              :notice_id => @notice, :comment => "third comment")
          @fourth_comment = Factory(:comment, :user_id => @second_user.id, 
                                              :notice_id => @notice, :comment => "fourth comment")
          get :home
          response.should have_selector("div.comment_item", :content => @comment.comment)
          response.should have_selector("div.comment_item", :content => @second_comment.comment)
          response.should have_selector("div.comment_item", :content => @third_comment.comment)
          response.should_not have_selector("div.comment_item", :content => @fourth_comment.comment)                                       
        end
          
      end
      
      it "should show a link to the notice's show page" do
        get :home
        response.should have_selector("a", :class => "notice_show_link")
      end
      
      it "should show delete links for a user's own notices" do
        get :home
        response.should have_selector("a", :class => "notice_delete_link",
                                           :content => "delete")
      end
      
      it "should show delete links for a user's own comments" do
        @comment = Factory(:comment, :user_id => @user.id, :notice_id => @notice.id)
        get :home
        response.should have_selector("a", :class => "comment_delete_link",
                                           :content => "delete")
      end
                                         
      describe "karma" do
        
        before(:each) do
          @second_user = Factory(:user, :name => "second", :email => "Second@example.com")
          @second_notice = Factory(:notice, :user_id => @second_user.id)
          @karma_grant = Factory(:karma_grant, :user_id => @user.id, 
                                 :notice_id => @second_notice.id)
        end
        
        it "should show a user's own karma grants" do
          get :home
          response.should have_selector("div.notice_description", 
                                        :content => "You granted")
        end
      
        it "should show revoke links for a user's own karma_grants" do
          get :home
          response.should have_selector("a", :class => "karma_revoke_link",
                                             :content => "revoke")
        end

        it "should show karma points" do
          @second_karma_grant = Factory(:karma_grant, :user_id => @second_user.id,
                                        :notice_id => @notice.id, :karma_points => 1 )
          get :home                              
          response.should have_selector("div.notice_karma_points", 
                                        :content => "total karma: 1 point")
        end
                                      
      end

      it "should have a comment form" do
        get :home
        response.should have_selector("form", :class => "new_comment")
      end
      
      it "should show a sidebar" do
        get :home
        response.should have_selector("section", :class => "sidebar")
        response.should render_template('layouts/_sidebar')
      end
      
      it "should show open notices" do
        get :home
        response.should have_selector("div.open_notice_item")
      end

      describe "for same user" do

        it "should not show the karma grant form" do
          get :home
          response.should_not have_selector("form", :class => "new_karma_grant")
        end
        
      end

      describe "for different user" do

        it "should show the karma grant form" do
          @second_user = Factory(:user, :name => "second", :email => "Second@example.com")
          @second_notice = Factory(:notice, :user_id => @second_user.id)
          get :home
          response.should have_selector("form", :class => "new_karma_grant")
        end
        
      end
      
    end
    
    describe "for non-signed-in users" do
      
      it "show a sign-in form" do
        get :home
        response.should have_selector("form", :class => "user_new")
      end
      
    end
    
  end
  
  describe "GET 'about'" do
    
    it "should be successful" do
      get :about
      response.should be_success
    end
    
    it "should have the right title" do
      get :about
      response.should have_selector("title", :content => "About")
    end

  end
  
  describe "GET 'help'" do
    
    it "should be successful" do
      get :help
      response.should be_success
    end
    
    it "should have the right title" do
      get :help
      response.should have_selector("title", :content => "Help")
    end
    
  end

end
