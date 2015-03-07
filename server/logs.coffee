Accounts.onLogin (info) ->
  Meteor.users.update(info.user._id, {$set: {'profile.online': true}})
  info.connection.onClose () ->
    Meteor.users.update(info.user._id, {$set: {'profile.online': false}})

Accounts.onCreateUser (options, user) ->
  user.profile =
    avatar: 'emerald'
    color: '#300'
  return user
