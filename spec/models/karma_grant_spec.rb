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

require 'spec_helper'

describe KarmaGrant do
  pending "add some examples to (or delete) #{__FILE__}"
end
