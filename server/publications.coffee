Meteor.publish("challenges", () ->
  if @userId
    Challenges.find({$and: [ {$or: [ {user1Id: @userId}, {user2Id: @userId} ] }, {$or: [{playing: true}, {acceptedAt: { $exists : false }}, {finishedAt: { $exists : true }}]} ] })
  else
    @ready()
)

Meteor.publish("moves", (challengeId) ->
  if @userId and challengeId?
    Moves.find({challengeId: challengeId})
  else
    @ready()
)

Meteor.publish("users", () ->
  if @userId
    Meteor.users.find({"profile.online" : true, "profile.playing": false}, {limit: 100})
  else
    @ready()
)
