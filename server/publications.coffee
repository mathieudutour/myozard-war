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

Meteor.publish("users0", () ->
  if @userId
    Meteor.users.find({"profile.online" : true, "profile.playing": false})
  else
    @ready()
)
Meteor.publish("users1", () ->
  if @userId
    firstChallenges = Challenges.find({user1Id: @userId}).map( (challenge) -> return challenge.user2Id)
    Meteor.users.find({_id: {$in: firstChallenges}})
  else
    @ready()
)
Meteor.publish("users2", () ->
  if @userId
    secondChallenges = Challenges.find({user2Id: @userId}).map( (challenge) -> return challenge.user1Id)
    Meteor.users.find({_id: {$in: secondChallenges}})
  else
    @ready()
)
