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

class Comment < ActiveRecord::Base
  
  belongs_to :notice
  belongs_to :user
  
  attr_accessible :id, :original_comment, :notice_id, :comment, :user_id
  
end
