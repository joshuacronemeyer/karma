# == Schema Information
#
# Table name: notices
#
#  id                     :integer         not null, primary key
#  user_id                :integer
#  doers                  :string(255)
#  time_completed         :datetime
#  open                   :boolean
#  content                :string(255)
#  display_title          :string(255)
#  self_doer              :boolean
#  description_comment_id :integer
#  due_date               :datetime
#  completed_by_id        :integer
#  created_at             :datetime
#  updated_at             :datetime
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
  before_save :set_completed_by
  
  default_scope :order => 'notices.time_completed DESC'
  
  
  def self.open_notices
    self.where(:open => true)
  end
  
  def self.closed_notices
    self.where(:open => false)
  end

  def total_karma
    karma_grants.map{ |k| k.karma_points }.sum
  end
  
  def description_comment
    if !self.description_comment_id.nil?
      Comment.find(self.description_comment_id)
    else
      nil
    end
  end
  
  def regular_comments
    comments.where("id != '#{description_comment_id}'")
  end
  
private

  def set_defaults
    self.open ||= false
    (self.time_completed ||= self.created_at) if !self.open
    self.due_date ||= Time.now
  end

  def create_display_title
    words = self.content.split(/\W+/)
    if words.count >= 3
      self.display_title = words[0..2].join(' ') + "..."
    else
      self.display_title = words[0..words.count - 1].join(' ')
    end     
  end
  
  def set_completed_by
    self.completed_by_id = self.user_id if (!self.open && self.self_doer)
  end
  
end
