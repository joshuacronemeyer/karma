# == Schema Information
#
# Table name: comments
#
#  id          :integer         not null, primary key
#  description :boolean
#  poster_id   :integer
#  comment     :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Comment < ActiveRecord::Base
end
