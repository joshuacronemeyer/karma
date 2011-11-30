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
  pending "add some examples to (or delete) #{__FILE__}"
end
