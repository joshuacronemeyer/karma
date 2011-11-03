Factory.define :user do |user|
  user.name                   "Andrew Dollard"
  user.email                  "andrewdollard@gmail.com"
  user.password               "foobar"
  user.password_confirmation  "foobar"
  
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end
