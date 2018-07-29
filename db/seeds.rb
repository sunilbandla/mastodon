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
#   account_id: 1,
#   name: 'Sports'
# }, {
#   account_id: 1,
#   name: 'Abuse'
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

unless QualifierCategory.any?
  QualifierCategory.create([{
    code: 'abuse',
    name: 'Abuse'
  }, {
    code: 'business',
    name: 'Business'
  }, {
    code: 'food',
    name: 'Food'
  }, {
    code: 'entertainment',
    name: 'Entertainment'
  }, {
    code: 'politics',
    name: 'Politics'
  }, {
    code: 'religion',
    name: 'Religion'
  }, {
    code: 'science',
    name: 'Science'
  }, {
    code: 'sports',
    name: 'Sports'
  }, {
    code: 'technology',
    name: 'Technology'
  }, {
    code: 'travel',
    name: 'Travel'
  }])
end

unless ActionType.any?
  ActionType.create([{
    code: 'skipInbox',
    name: 'Skip Inbox'
  }, {
    code: 'moveToFolder',
    name: 'Move to folder'
  }])
end

unless FilterCondition.any?
  FilterCondition.create([{
    value: true,
    name: 'True'
  }, {
    value: false,
    name: 'False'
  }])
end
