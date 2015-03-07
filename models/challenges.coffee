@Challenges = new Meteor.Collection("challenges")

@Challenges.allow
  insert: (userId, doc) ->
    # the user must be logged in
    userId?
  update: (userId, doc, fields, modifier) ->
    userId?
  remove: (userId, doc) ->
    no

###
{
  "_id": ObjectId,
  "user1Id": ObjectId,
  "user2Id": ObjectId,
  "createdAt": Date,
  "acceptedAt": Date,
  "playing": Boolean,
  "player1Life": Number,
  "player2Life": Number
}
###
