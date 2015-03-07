Accounts.onLogin (info) ->
  Meteor.users.update(info.user._id, {$set: {'profile.online': true}})
  info.connection.onClose () ->
    Meteor.users.update(info.user._id, {$set: {'profile.online': false, 'profile.playing': false}})
    # clear challenges on disconnection
    Challenges.remove({$and: [ {$or: [ {user1Id: @userId}, {user2Id: @userId} ] }, {acceptedAt: { $exists : false }} ] })
    Challenges.update({user1Id: @userId, playing: true }, {$set: {playing: false, player1Life: 0}})
    Challenges.update({user2Id: @userId, playing: true }, {$set: {playing: false, player2Life: 0}})

Accounts.onCreateUser (options, user) ->
  if !options.profile?
    options.profile = {}
    options.profile.username = new Mongo.ObjectID().toHexString()
  else
    options.profile.username = options.profile.name
  options.profile.character = 'emerald'
  options.profile.color = '#300'
  options.profile.playing = false
  user.profile = options.profile
  return user
