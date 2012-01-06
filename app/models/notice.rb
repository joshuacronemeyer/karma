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
#  content             :string(255)
#  self_doer           :boolean
#  display_title       :string(255)
#

class Notice < ActiveRecord::Base
  
  attr_accessible :content, :doers, :self_doer, :open, :display_title
  
  belongs_to :user
  
  has_many :karma_grants, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  
  validates :content, :presence => true
  validates :user_id, :presence => true
  
  after_initialize :set_defaults
  before_save :create_display_title
  
  default_scope :order => 'notices.created_at DESC'
  
  
  def self.open_notices
    self.where(:open => true)
  end
  
  def self.closed_notices
    self.where(:open => false)
  end

  def total_karma
    karma_grants.map{ |k| k.karma_points }.sum
  end
  
private

  def set_defaults
    self.open ||= false
    self.timestamp_completed ||= self.created_at
  end

  def create_display_title
    words = self.content.split(/\W+/)
    if words.count >= 3
      self.display_title = words[0..2].join(' ') + "..."
    else
      self.display_title = words[0..words.count - 1].join(' ')
    end     
  end
  
end
