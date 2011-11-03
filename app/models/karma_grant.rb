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

class KarmaGrant < ActiveRecord::Base
end
