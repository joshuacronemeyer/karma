Factory.define :user do |user|
  user.name                   "Andrew Dollard"
  user.email                  "andrewdollard@gmail.com"
  user.password               "foobar"
  user.password_confirmation  "foobar"
  
end

Factory.define :notice do |notice|
  notice.content             "Notice notice notice"
  notice.doers               "KidA KidB"
  notice.user_id             1
  notice.open                false
end

Factory.define :comment do |comment|
  comment.user_id           1
  comment.notice_id         1
  comment.comment           "Comment comment commment"

end

Factory.define :karma_grant do |karma_grant|
  karma_grant.karma_points  2
  karma_grant.user_id       1
  karma_grant.notice_id     1
  
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
  
end


