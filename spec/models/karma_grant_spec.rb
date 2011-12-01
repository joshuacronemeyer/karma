# == Schema Information
#
# Table name: karma_grants
#
#  id           :integer         not null, primary key
#  user_id      :integer
#  karma_points :integer
#  created_at   :datetime
#  updated_at   :datetime
#  notice_id    :integer
#

require 'spec_helper'

describe KarmaGrant do
  
  it "should create a new instance given valid attributes"
  
  describe "associations" do
    
    it "should have a user attribute"

    it "should have the right associated user"

    it "should have a notice attribute"

    it "should have the right associated notice"
    
  end
  
  describe "validations" do
    
    it "should require a user id"
    
    it "should require a notice id"
    
  end




end
