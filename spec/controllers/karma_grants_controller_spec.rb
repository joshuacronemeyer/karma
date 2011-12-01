require 'spec_helper'

describe KarmaGrantsController do

  render_views
  
  describe "access control" do
    
    it "should deny access to 'create'" 
    
    it "should deny access to 'destroy'"
    
  end
  
  describe "POST 'create'" do
    
    it "should not allow more than one karma grant per notice"
    
    it "should not allow users to grant themselves karma"
    
    it "should not allow more than 3 karma points to be granted"
    
    describe "failure" do
      
      it "should not grant karma"
      
      it "should render the home page"
      
      it "shoud display a flash error message"
      
    end
    
    describe "success" do
      
      it "should grant karma"
      
      it "should render the home page"
      
      it "should display a flash success message"
      
    end
    
  end
    
end
