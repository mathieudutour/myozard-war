@Moves = new Meteor.Collection("moves")

@Moves.allow
  insert: (userId, doc) ->
    # the user must be logged in
    userId? and doc.userId is userId
  update: (userId, doc, fields, modifier) ->
    no
  remove: (userId, doc) ->
    no

###
{
  "_id": ObjectId,
  "player1": String,
  "player2": String,
  "playerToPlay": Number (1 or 2),
  "type": String,
  "createdAt": Date
  "playedAt": Date
  "finishedAt": Date,
  "challengeId": ObjectId
}
###
