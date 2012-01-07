# == Schema Information
#
# Table name: comments
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  notice_id  :integer
#  content    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Comment < ActiveRecord::Base
  
  belongs_to :notice
  belongs_to :user
  
  attr_accessible :id, :original_comment, :notice_id, :content, :user_id
  
  validates( :user_id, :presence => true)
  validates( :notice_id, :presence => true)
  validates( :content, :presence => true)
  
end
