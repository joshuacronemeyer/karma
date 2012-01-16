require 'spec_helper'

describe NoticesController do

  render_views
  
  describe "access control" do
    
    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(new_user_session_path)
    end
    
    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(new_user_session_path)
    end
    
  end
  
  describe "POST 'create'" do
    
    before(:each) do
      @user = test_sign_in(Factory(:user))
    end
  
    describe "failure" do
  
      before(:each) do
        @attr = { :content => ""}
      end
      
      it "should not create a notice" do
        lambda do
          post :create, :notice => @attr
        end.should_not change(Notice, :count)
      end
      
      it "should render the home page" do
        post :create, :notice => @attr
        response.should redirect_to(root_path)
      end  

    end
    
    describe "success" do
      
      before(:each) do
        @attr = { :content => "gabba gabba gabba hey", :user => @user }
        @comment_attr = {:content => "hey ho lets go"}
      end
      
      it "should create a notice" do
        lambda do
          post :create, :notice => @attr, :comment => @comment_attr
        end.should change(Notice, :count).by(1)
      end

      it "should create a correct display title" do
        post :create, :notice => @attr, :comment => @comment_attr
        Notice.find_by_content("gabba gabba gabba hey").display_title.should == "gabba gabba gabba..."
      end
        
      
      it "should render the home page" do
        post :create, :notice => @attr, :comment => @comment_attr
        response.should redirect_to(root_path)
      end

      
    end
    
  end

  describe "GET 'show'" do
    
    before (:each) do
      @user = Factory(:user)
      test_sign_in(@user)
      @notice = Factory(:notice, :user_id => @user.id,
                                 :content => "this is a new notice",
                                 :display_title => "this is a...")
    end
   
    describe "for closed notices" do
      
      before(:each) do
        @notice.update_attribute(:open, false)
      end
    
      it "should be successful" do
        get :show, :id => @notice
        response.should be_success
      end
    
      it "should have the right title" do
        get :show, :id => @notice
        response.should have_selector("title", :content => "this is a...")
      end
    
      it "should show the notice" do
        get :show, :id => @notice
        response.should have_selector("div.closed_notice_item",
                                      :content => @notice.content)
      end
                                  
      it "should show the notice's doers" do
        get :show, :id => @notice
        response.should have_selector("div.closed_notice_doers")
      end
                                    
      it "should show the notice's poster" do
        get :show, :id => @notice
        response.should have_selector("div.closed_notice_posted_by")
      end
    
      it "should show the notice's poster as a doer, if self_doer" do
        @notice.self_doer = true
        @notice.save
        get :show, :id => @notice
        response.should have_selector("div.closed_notice_doers", :content => @user.name)
      end
    
      it "should show a link to the poster's page" do
        get :show, :id => @notice
        response.should have_selector("a", :href => "/users/#{@user.id}")
      end

      it "should show karma points" do
        get :show, :id => @notice
        response.should have_selector("div.closed_notice_karma_points", :content => "total karma")
      end

      it "should show revoke links for a user's own karma_grants" do
        @second_user = Factory(:user, :name => "second", :email => "second@example.com")
        @second_notice = Factory(:notice, :user_id => @second_user.id)
        @karma_grant = Factory(:karma_grant, :user_id => @user.id, :notice_id => @second_notice.id)
        get :show, :id => @second_notice
        response.should have_selector("a", :class=>"karma_revoke_link", :content => "revoke")
      end
  
      it "should show a new comment form" do
        get :show
        response.should have_selector("form.new_comment")
      end
      
      it "should show a re-open link for authorized users" do
        get :show
        response.should have_selector("a.notice_reopen_link")
      end
      
      describe "for same user" do

        it "should not show the karma grant form" do
          get :show, :id => @notice
          response.should_not have_selector("form", :class => "new_karma_grant")
        end

      end

      describe "for different user" do

        it "should show the karma grant form" do
          @second_user = Factory(:user, :name => Faker::Name.name, 
                                        :email => "second_user@example.com")
          @second_notice = Factory(:notice, :user_id => @second_user.id)
          get :show, :id => @second_notice
          response.should have_selector("form", :class => "new_karma_grant")
        end

      end

    end
  
    describe "for open notices" do

      before(:each) do
        @notice.update_attribute(:open, true)
      end
      
      it "should be successful" do
        get :show, :id => @notice
        response.should be_success
      end
    
      it "should have the right title" do
        get :show, :id => @notice
        response.should have_selector("title", :content => "this is a...")
      end
    
      it "should show the notice" do
        get :show, :id => @notice
        response.should have_selector("div.open_notice_item",
                                      :content => @notice.content)
      end
      
      it "should show the notice's poster" do
        get :show, :id => @notice
        response.should have_selector("div.open_notice_posted_by")
      end
      
      it "should show a link to the poster's page" do
        get :show, :id => @notice
        response.should have_selector("a", :href => "/users/#{@user.id}")
      end

      it "should show a 'Mark as completed' link" do
        get :show
        response.should have_selector("a", :content => "Mark as completed")
      end
      
      it "should show a new comment form" do
        get :show
        response.should have_selector("form.new_comment")
      end
 
    end
  
    describe "comments" do
      
      before(:each) do
        @comment = Factory(:comment, :user_id => @user.id, :notice_id => @notice)
      end
      
      it "should show comments" do
        get :show, :id => @notice
        response.should have_selector("div.closed_notice_comments", :content => @comment.content)
      end
    
      it "should show a link to the commenter's page" do
        get :show, :id => @notice
        response.should have_selector("a", :href => "/users/#{@user.id}")
      end

      it "should have a comment form" do
        get :show, :id => @notice
        response.should have_selector("form", :class => "new_comment")
      end
      
    end
  
  end

  describe "GET 'index/open'" do
    
    describe "for non-signed-in users" do

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
        get 'notices/open'
        response.should  be_success
      end
      
      it "should have the right title" do
        get 'notices/open'
        response.should have_selector("title", :content => "All users")
      end
      
      it "should show notices with due dates" do
        @notice = Factory(:notice, :due_date => 3.days.from_now)
        get 'notices/open'
        response.should have_selector("div.open_notice_current_due_date")
      end
      
      it "should show notices without due dates"  do
        @notice = Factory(:notice, :due_date => nil)
        get 'notices/open'
        response.should have_selector("div.open_notice_no_due_date")
      end
      
      it "should paginate notices" do
        @notices = []
        (0..32).each do |n|
          @notices[n] = Factory(:notice, :open => true)
        end
        get 'notices/open'
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :href => "/?page=2", 
                                           :content => "2")
        response.should have_selector("a", :href => "/?page=2", 
                                           :content => "Next")
      end

      it "should show repeating tasks" do
        @task = Factory(:repeating_task)
        get 'notices/open'
        response.should have_selector("div.repeating_task_item")
      end

    end
  
  end

  describe "GET 'new'" do
    
    describe "for signed-in users" do
      
        before(:each) do
          @user = Factory(:user)
          test_sign_in(@user)
        end
    
      describe "for open notices" do
        
        before(:each) do
          @notice = Factory(:notice, :open => true, :user_id => @user.id)
        end
        
        it "should show a new notice form" do
          get "new/open"
          response.should have_selector("form.new_open_notice")
        end
      
        it "should have a description field" do
          get "new/open"
          response.should have_selector("input", :id => :notice_content)
        end
      
        it "should have due-date fields" do
          get "new/open"
          response.should have_selector("input", :id => :notice_due_day)
          response.should have_selector("input", :id => :notice_due_month)
          response.should have_selector("input", :id => :notice_due_year)
        end
      
        it "should have repeating radio buttons" do
          get "new/open"
          response.should have_selector("input", :type => "radio", :id => :notice_repeating)
        end

        it "should have a description field" do
          get "new/open"
          response.should have_selector("input", :id => "notice_content")
        end

        it "should have a comment field" do
          get "new/open"
          response.should have_selector("textarea", :id => "comment")
        end
      
      end
    
      describe "for closed notices" do
      
        it "should be successful" do
          get "new/closed"
          response.should be_success
        end

        it "should have the right title" do
          get "new/closed"
          response.should have_selector("title", :content => "New task")
        end

        it "should have a self-doer checkbox" do
          get "new/closed"
          response.should have_selector("input", :id => "notice_self_doer")
        end

        it "should have an other doers field" do
          get "new/closed"
          response.should have_selector("input", :id => "notice_doers")
        end

        it "should have a description field" do
          get "new/closed"
          response.should have_selector("input", :id => "notice_content")
        end

        it "should have a comment form" do
          get "new/closed"
          response.should have_selector("textarea", :id => "comment")
        end

      end
    
    end
    
    describe "for non-signed-in users" do
      
      it "should deny access" do
        get :index
        response.should redirect_to(new_user_session_path)
      end

    end
    
  end
    
  describe "GET 'claim'" do
    
    before (:each) do
      @user = Factory(:user)
      test_sign_in(@user)
      @notice = Factory(:notice, :user_id => @user.id,
                                 :content => "this is a new notice",
                                 :display_title => "this is a...")
    end

    describe "for open notices" do
    
      before(:each) do
        @notice.update_attribute(:open, true)
      end
    
      it "should be successful" do
        get :show
        response.should be_success
      end
    
      it "should show the notice claim page" do
        get :show
        response.should render_template 'notice/claim'
      end
    
      it "should have the right title" do
        get :show
        response.should have_selector("title", :content => "Claim task")
        response.should have_selector("title", :content => "this is a...")
      end
    
      it "should show the claim notice form" do
        get :show
        response.should have_selector("form.claim_notice")
      end
    
      it "should have a self-doer checkbox" do
        get :show
        response.should have_selector("input", :id => "notice_self_doer")
      end
    
      it "should have an other doers field" do
        get :show
        response.should have_selector("input", :id => "notice_doers")
      end
    
      it "should have a description field with the description already entered" do
        get :show
        response.should have_selector("input", :id => "notice_content", 
                                               :value => "this is a new notice")
      end
      
      it "should have a comment form" do
        get :show
        response.should have_selector("textarea", :id => "comment")
      end
    
    end

    describe "for closed notices" do
      
      it "should redirect to the last viewed page" do
        @notice.update_attribute(:open, false)
        get root_path
        get :show
        response.should redirect_to root_path
      end
      
    end
  
  end
  
  describe "PUT 'claim'" do
  
    before (:each) do
      @user = Factory(:user)
      test_sign_in(@user)
      @notice = Factory(:notice, :user_id => @user.id,
                                 :content => "this is a new notice",
                                 :display_title => "this is a...")
      @attr = { :self_doer => true, :doers => "jane, jim" }
    end
    
    describe "for open notices" do
      
      before(:each) do
        @notice.update_attribute(:open, true)
      end
   
      it "should close the notice" do
        put :claim
        @notice = Notice.find(@notice.id)
        @notice.open.should be_false
      end
        
      it "should update the notice's completed time stamp" do
        lambda do
          put :claim
          @notice = Notice.find(@notice.id)
          @notice.open.should be_false
        end.should change(@notice, :time_completed)
      end
      
      it "should update the notice's complete by user" do
        put :claim
        @notice = Notice.find(@notice.id)
        @notice.completed_by_id.should == @user.id
      end
      
      it "should update the notice's doers string" do
        put :claim
        @notice = Notice.find(@notice.id)
        @notice.doers.should == "jane, jim"
      end

    end

    describe "for closed notices" do
      
      before(:each) do
        @notice.update_attribute(:open, false)
      end
      
      describe "for authorized users" do
    
        it "should open the notices" do
          put :claim
          @notice = Notice.find(@notice.id)
          @notice.open.should be_true
        end
      
        it "should destroy associated karma_grants" do
          @second = Factory(:user, :name => "second", :email => "second@example.com")
          @karma_grant = Factory(:karma_grant, :user_id => @second.id, :notice_id => @notice.id)
          lambda do
            put :claim
          end.should change(KarmaGrant, :count).by(-1)
        end
      
        it "should set the notice's completed time stamp to nil" do
          put :claim
          @notice = Notice.find(@notice.id)
          @notice.time_completed.should be_nil
        end
      
        it "should set the notice's completed by user to nil" do
          put :claim
          @notice = Notice.find(@notice.id)
          @notice.completed_by_id.should be_nil
        end
      
        it "should set the notice's doers string to nil" do
          put :claim
          @notice = Notice.find(@notice.id)
          @notice.doers.should be_nil
        end

      end
      
      describe "for unauthorized users" do
        
        before(:each) do
          @notice.update_attribute(:open, false)
          @second = Factory(:user, :name => "second", :email => "second@example.com")
          test_sign_in(@second)
        end
        
        it "should not update the notice" do
          put :claim
          Notice.find(@notice.id).should == @notice
        end
          
        
        it "should redirect to the last page" do
          get root_path
          put :claim
          response.should redirect_to root_path
        end
        
      end

    end
    
  end
  
  describe "DELETE 'destroy'" do
    
    before(:each) do
      @user = Factory(:user)
      @notice = Factory(:notice, :user_id => @user.id)
    end
    
    describe "as a non-signed-in user" do
      
      it "should deny access" do
        delete :destroy, :id => @notice
        response.should redirect_to(new_user_session_path)
      end
      
    end    
    
    describe "as a signed-in user" do
      
      describe "as the poster of the notice" do
      
      before(:each) do
        test_sign_in(@user)
        @notice = Factory(:notice, :user_id => @user.id)
      end
      
        it "should destroy the notice" do
          lambda do
            delete :destroy, :id => @notice.id
          end.should change(Notice, :count).by(-1)
        end
          
        it "should redirect to the last page viewed" do
          session[:return_to] = root_path
          delete :destroy, :id => @notice
          response.should redirect_to root_path
        end
            
      end
      
      describe "as another user" do
        
        before(:each) do
          @second_user = Factory(:user, :name => Faker::Name.name, 
                                 :email => "another_user@example.com")
          test_sign_in(@second_user)
        end
        
        it "should not destroy the notice" do
          lambda do
            delete :destroy, :id => @notice
          end.should_not change(Notice, :count)
        end  
      end
      
    end
    
    describe "as an admin" do
    
      before(:each) do
        @admin = Factory(:user, :admin => true,
                         :name => "admin", :email => "admin@example.com")
        test_sign_in(@admin)
      end
      
      it "should destroy the notice" do
        lambda do
          delete :destroy, :id => @notice
        end.should change(Notice, :count).by(-1)
      end
      
      it "should redirect to the admin control panel" do
        delete :destroy, :id => @notice
        response.should render_template('pages/admin')
      end
      
    end
    
  end
  
    
end
