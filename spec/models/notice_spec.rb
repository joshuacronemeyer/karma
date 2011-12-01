# == Schema Information
#
# Table name: notices
#
#  id                  :integer         not null, primary key
#  user_id             :integer
#  doers               :string(255)
#  timestamp_completed :datetime
#  open                :boolean
#  created_at          :datetime
#  updated_at          :datetime
#  description         :string(255)
#  self_doer           :boolean
#

require 'spec_helper'

describe Notice do

 it "should create a new instance given valid attributes"
  
  describe "associations" do
    
    it "should have a user attribute"

    it "should have the right associated user"
    
  end
  
  describe "validations" do
    
    it "should reject notices with blank descriptions"
    
    it "should reject notices with no users identified"
    
    it "should require a user id"
    
    it "should require a notice id"
    
  end
end
