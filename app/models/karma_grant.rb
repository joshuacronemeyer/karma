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

class KarmaGrant < ActiveRecord::Base

  attr_accessible :user_id, :karma_points, :notice_id

  belongs_to :notice
  belongs_to :user
  
  validates :notice_id, :presence => true 
  validates :user_id, :presence => true 
  validates :karma_points, :presence => true, 
             :numericality => {:greater_than => 0, :less_than => 4} 
             
  validate :not_already_granted
  validate :not_self_grant

private

  def not_already_granted
    if !notice_id.blank? && Notice.find(notice_id).karma_grants.map{ |k| k.user_id}.include?(user_id)
      errors.add(:already_granted, "Can't grant karma to the same notice twice.")
    end
  end
  
  def not_self_grant
    if !notice_id.blank? && Notice.find(notice_id).user_id == user_id
      errors.add(:self_grant, "Users can't grant karma to themselves.") 
    end
  end
  
end
