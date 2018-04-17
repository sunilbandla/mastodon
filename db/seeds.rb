Doorkeeper::Application.create!(name: 'Web', superapp: true, redirect_uri: Doorkeeper.configuration.native_redirect_uri, scopes: 'read write follow')

if Rails.env.development?
  domain = ENV['LOCAL_DOMAIN'] || Rails.configuration.x.local_domain
  admin  = Account.where(username: 'admin').first_or_initialize(username: 'admin')
  admin.save(validate: false)
  User.where(email: "admin@#{domain}").first_or_initialize(email: "admin@#{domain}", password: 'mastodonadmin', password_confirmation: 'mastodonadmin', confirmed_at: Time.now.utc, admin: true, account: admin).save!

# QualifierCategory.destroy_all

# QualifierCategory.create!([{
#   code: 'sports',
#   name: 'Sports'
# }])

# ActionType.destroy_all

# ActionType.create([{
#   code: 'skipInbox',
#   name: 'Skip Inbox'
# }, {
#   code: 'moveToFolder',
#   name: 'Move to folder'
# }])

# FolderLabel.destroy_all

# FolderLabel.create([{
#   user_id: 1,
#   name: 'Sports'
# }, {
#   user_id: 1,
#   name: 'Movies'
# }])

# FilterCondition.destroy_all

# FilterCondition.create([{
#   value: true,
#   name: 'True'
# }, {
#   value: false,
#   name: 'False'
# }])

end
