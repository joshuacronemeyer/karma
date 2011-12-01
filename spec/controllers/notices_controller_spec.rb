require 'spec_helper'

describe NoticesController do

  render_views
  
  describe "access control" do
    
    it "should deny access to 'create'" 
    
    it "should deny access to 'destroy'"
    
  end
  
  describe "POST 'create'" do
    
    describe "failure" do
      
      it "should not create a notice"
      
      it "should render the home page"
      
      it "shoud display a flash error message"
      
    end
    
    describe "success" do
      
      it "should create a notice"
      
      it "should render the home page"
      
      it "should display a flash success message"
      
    end
    
  end

end
