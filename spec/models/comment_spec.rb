# == Schema Information
#
# Table name: comments
#
#  id               :integer         not null, primary key
#  original_comment :boolean
#  notice_id        :integer
#  comment          :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  user_id          :integer
#

require 'spec_helper'

describe Comment do
  
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
    
    it "should require nonblank content"
    
  end



end
