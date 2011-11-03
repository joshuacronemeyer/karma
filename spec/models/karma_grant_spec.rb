# == Schema Information
#
# Table name: karma_grants
#
#  id           :integer         not null, primary key
#  from_user    :integer
#  to_user      :integer
#  karma_points :integer
#  created_at   :datetime
#  updated_at   :datetime
#

require 'spec_helper'

describe KarmaGrant do
  pending "add some examples to (or delete) #{__FILE__}"
end
