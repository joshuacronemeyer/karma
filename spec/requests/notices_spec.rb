require 'spec_helper'

describe "Notices" do
  
  before(:each) do
    user = Factory(:user)
    integration_sign_in(user)
  end
  
  describe "creation" do
  
    describe "failure" do
      
      it "should not create a new notice" do
        lambda do
          visit root_path
          fill_in :notice_doers, :with => "kidA kidB"
          fill_in :notice_content, :with => ""
          click_button
        end.should_not change(Notice, :count)
      end
      
    end
    
    describe "success" do
      
      it "should create a new notice" do
        lambda do
          visit root_path
          fill_in :notice_doers, :with => "kidA kidB"
          fill_in :notice_content, :with => "stuff"
          click_button
        end.should change(Notice, :count).by(1)
      end
      
    end
    
  end  
  
end
