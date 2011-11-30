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

require 'spec_helper'

describe Notice do
  pending "add some examples to (or delete) #{__FILE__}"
end
