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

  def already_granted?
    Notice.find(notice_id).karma_grants.each do |k|
      if k.user_id == user_id then return true end
    end
    false
  end
  
  def self_grant?
    if Notice.find(notice_id).user_id == user_id then return true end
    false
  end

end
