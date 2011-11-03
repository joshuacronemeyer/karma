# == Schema Information
#
# Table name: notices
#
#  id                  :integer         not null, primary key
#  poster_id           :integer
#  named_non_users     :string(255)
#  timestamp_completed :datetime
#  open                :boolean
#  created_at          :datetime
#  updated_at          :datetime
#

require 'spec_helper'

describe Notice do
  pending "add some examples to (or delete) #{__FILE__}"
end
