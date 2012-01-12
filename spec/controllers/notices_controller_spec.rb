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
      
      it "should show a re-open link for authorized users" 
      
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
      
      it "should show the notice's poster" do
        get :show, :id => @notice
        response.should have_selector("div.closed_notice_posted_by")
      end
      
      it "should show a link to the poster's page" do
        get :show, :id => @notice
        response.should have_selector("a", :href => "/users/#{@user.id}")
      end

      it "should show a 'Mark as completed' link"
      
      it "should show a new comment form"
 
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
      
      it "should show notices with due dates"
      
      it "should show notices without due dates"
      
      it "should paginate notices"

      it "should show repeating tasks"

    end
  
  end

  describe "GET 'new'" do
    
    describe "for open notices" do
        
      it "should show a new notice form"
      
      it "should have a description field"
      
      it "should have a comment field"
      
      it "should have a due-date field"
      
      it "should have repeating radio buttons"
      
    end
    
    describe "for closed notices" do
      
      it "should show a new notice form"
      
      it "should have a self-doer checkbox"
      
      it "should have a other doers field"
      
      it "should have a comment field"
      
    end
    
  end
    
  describe "GET 'claim'" do
    
    
    it "should be successful"
    
    it "should show the notice claim page"
    
    it "should have the right title"
    
    it "should show the claim notice form"
    
    it "should have a self-doer checkbox"
    
    it "should have an other doers field"
    
    it "should have a comment form"
    
  end
  
  describe "POST 'claim'" do
  
    describe "for open notices" do
   
      it "should close the notice"

      it "should update the notice's completed time stamp"
      
      it "should update the notice's complete by user"
      
      it "should update the notice's doers string"

    end

    describe "for closed notices" do
      
      describe "for authorized users" do
    
        it "should open the notices"
      
        it "should destroy associated karma_grants"
      
        it "should set the notice's completed time stamp to nil"
      
        it "should set the notice's completed by user to nil"
      
        it "should set the notice's doers string to nil"

      end
      
      describe "for unauthorized users" do
        
        it "should not update the notice"
        
        it "should redirect to the last page"
        
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
