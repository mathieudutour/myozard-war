Accounts.onLogin (info) ->
  Meteor.users.update(info.user._id, {$set: {'profile.online': true}})
  info.connection.onClose () ->
    Meteor.users.update(info.user._id, {$set: {'profile.online': false}})

Accounts.onCreateUser (options, user) ->
  if !options.profile?
    options.profile = {}
  options.profile.character = 'emerald'
  options.profile.color = '#300'
  user.profile = options.profile
  return user
