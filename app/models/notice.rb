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

class Notice < ActiveRecord::Base
  
  attr_accessible :description
  attr_accessible :doers
  attr_accessible :self_doer
  attr_accessible :open
  
  belongs_to :user
  
  has_many :karma_grants
  has_many :comments
  
  validates :description, :presence => true
  validates :user_id, :presence => true
  
  default_scope :order => 'notices.created_at DESC'
  
  # need before_filter signed_in?
  
  def total_karma
    @karma_points = 0
    karma_grants.each do |k|
      @karma_points += k.karma_points
    end
    @karma_points    
  end
  
end
