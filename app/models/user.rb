# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  name                   :string(255)
#  email                  :string(255)
#  encrypted_password     :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  password_salt          :string(255)
#  failed_attempts        :integer         default(0)
#  unlock_token           :string(255)
#  locked_at              :datetime
#  admin                  :boolean
#


class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :name, :email, :password, :password_confirmation, 
                  :remember_me, :admin, :created_at

  has_many :notices, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :karma_grants, :dependent => :destroy

  validates :name, :presence => true,
            :length => { :maximum => 50 },
            :uniqueness => {:case_sensitive => false} 
      
  PostItem = Struct.new(:notice, :comment, :karma_grant, :type, :timestamp)    
      
  def private_posts
    posts = []

    notices.each do |n|
      posts << PostItem.new(n, nil, nil, :notice, n.time_completed) if !n.open
    end

    comments.each do |c|
      pnc = posts.detect{ |p| p.notice.id == c.notice.id }
      if pnc
        pnc.comment = c
        pnc.type = :notice_with_comment
      else
        posts << PostItem.new(c.notice, c, nil, :comment, c.created_at)
      end
    end

    karma_grants.each do |k|
      pkc = posts.detect{ |p| p.notice.id == k.notice.id}
      if pkc
        pkc.karma_grant = k
        pkc.type = :comment_with_karma_grant
        pkc.timestamp = (pkc.timestamp < k.created_at ? pkc.timestamp : k.created_at)
      else
        posts << PostItem.new(k.notice, nil, k, :karma_grant, k.created_at)
      end
    end
    
   posts.sort! { |b,a| a.timestamp <=> b.timestamp }
  
  end
  
  def public_posts
   posts = []

   notices.each do |n|
     posts << PostItem.new(n, nil, nil, :notice, n.time_completed) if !n.open
   end

   comments.each do |c|
     pn = posts.detect{ |p| p.notice.id == c.notice.id }
     if pn
       pn.comment = c
       pn.type = :notice_with_comment
     else
       posts << PostItem.new(c.notice, c, nil, :comment, c.created_at)
     end
   end
   
   posts.sort! { |b,a| a.timestamp <=> b.timestamp }
     
  end

end
