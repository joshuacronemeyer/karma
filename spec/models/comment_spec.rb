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

require 'spec_helper'

describe Comment do
  pending "add some examples to (or delete) #{__FILE__}"
end
