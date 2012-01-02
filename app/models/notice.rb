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
#  content             :string(255)
#  self_doer           :boolean
#  display_title       :string(255)
#

class Notice < ActiveRecord::Base
  
  attr_accessible :content, :doers, :self_doer, :open, :display_title
  
  belongs_to :user
  
  has_many :karma_grants, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  
  validates :content, :presence => true
  validates :user_id, :presence => true
  
  default_scope :order => 'notices.created_at DESC'
  
  def self.open_notices
    self.where(:open => true)
  end
  
  def self.closed_notices
    self.where(:open => false)
  end

  def total_karma
    karma_grants.map{ |k| k.karma_points }.sum
  end
  

end
