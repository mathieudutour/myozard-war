currentChallenge = null
TIME_PER_TURN = 5000

Template.challenge.helpers
  challenge: () ->
    if !currentChallenge
      currentChallenge = Challenges.findOne({$and: [ {$or: [ {user1Id: Meteor.userId()}, {user2Id: Meteor.userId()} ] }, {acceptedAt: { $exists : true }}, {finishedAt: { $exists : false }} ] })
    currentChallenge
  player1Life: () ->
    if !currentChallenge
      currentChallenge = Challenges.findOne({$and: [ {$or: [ {user1Id: Meteor.userId()}, {user2Id: Meteor.userId()} ] }, {acceptedAt: { $exists : true }}, {finishedAt: { $exists : false }} ] })
    life = [{life: false}, {life: false}, {life: false}, {life: false}, {life: false}]
    i = 0
    while i < currentChallenge.player1Life
      life[i].life = true
      ++i
    return life
  player2Life: () ->
    if !currentChallenge
      currentChallenge = Challenges.findOne({$and: [ {$or: [ {user1Id: Meteor.userId()}, {user2Id: Meteor.userId()} ] }, {acceptedAt: { $exists : true }}, {finishedAt: { $exists : false }} ] })
    life = [{life: false}, {life: false}, {life: false}, {life: false}, {life: false}]
    i = 0
    while i < currentChallenge.player2Life
      life[i].life = true
      ++i
    life
  player1: () ->
    if !currentChallenge
      currentChallenge = Challenges.findOne({$and: [ {$or: [ {user1Id: Meteor.userId()}, {user2Id: Meteor.userId()} ] }, {acceptedAt: { $exists : true }}, {finishedAt: { $exists : false }} ] })
    Meteor.users.findOne(currentChallenge.user1Id)
  player2: () ->
    if !currentChallenge
      currentChallenge = Challenges.findOne({$and: [ {$or: [ {user1Id: Meteor.userId()}, {user2Id: Meteor.userId()} ] }, {acceptedAt: { $exists : true }}, {finishedAt: { $exists : false }} ] })
    Meteor.users.findOne(currentChallenge.user2Id)
  player1Spell: () ->
    if !currentChallenge
      currentChallenge = Challenges.findOne({$and: [ {$or: [ {user1Id: Meteor.userId()}, {user2Id: Meteor.userId()} ] }, {acceptedAt: { $exists : true }}, {finishedAt: { $exists : false }} ] })
    currentMoves = Moves.findOne({challengeId: currentChallenge._id, finishedAt: {$exists: false}})
    if currentMoves?
      currentMoves.player1
  player2Spell: () ->
    if !currentChallenge
      currentChallenge = Challenges.findOne({$and: [ {$or: [ {user1Id: Meteor.userId()}, {user2Id: Meteor.userId()} ] }, {acceptedAt: { $exists : true }}, {finishedAt: { $exists : false }} ] })
    currentMoves = Moves.findOne({challengeId: currentChallenge._id, finishedAt: {$exists: false}})
    if currentMoves?
      currentMoves.player2


Template.challenge.rendered = () ->
  currentChallenge = Challenges.findOne({$and: [ {$or: [ {user1Id: Meteor.userId()}, {user2Id: Meteor.userId()} ] }, {acceptedAt: { $exists : true }}, {finishedAt: { $exists : false }} ] })
  @autorun () ->
    deamon()

###
#
#
# Everytime we have a change in the move, check if it's our turn to play
#
###
deamon = () ->
  if !currentChallenge
    currentChallenge = Challenges.findOne({$and: [ {$or: [ {user1Id: Meteor.userId()}, {user2Id: Meteor.userId()} ] }, {acceptedAt: { $exists : true }}, {finishedAt: { $exists : false }} ] })
  if currentChallenge
    currentMove = Moves.findOne({challengeId: currentChallenge._id, finishedAt: {$exists: false}})
    if (!currentMove.player1 and currentMove.playerToPlay is 1 and currentChallenge.user1Id is Meteor.userId()) or (!currentMove.player2 and currentMove.playerToPlay is 2 and currentChallenge.user2Id is Meteor.userId())
      Session.set("currentMove", currentMoves._id)
      Meteor.setTimeout(
        () ->
          failTurn(currentMove._id)
      , TIME_PER_TURN)
    else
      Session.set("currentMove", null)


###
#
#
# When the user don't draw anything after 5s
#
###
failTurn = (moveId) ->
  if Session.get("currentMove") is moveId # check if we are still in the same turn
    currentMove = Moves.findOne(moveId)

    if currentMove.playerToPlay is 1 and currentMove.player2 or currentMove.playerToPlay is 2 and currentMove.player1 # means that we miss the counter spell
      if currentMove.playerToPlay is 1
        Challenges.update(currentMove.challengeId, {$inc: {player1Life : -1}})
      else
        Challenges.update(currentMove.challengeId, {$inc: {player2Life : -1}})

      Moves.update(moveId, {$set: {finishedAt: new Date()}})
      if Challenges.findOne(currentMove.challengeId).player1Life isnt 0 or Challenges.findOne(currentMove.challengeId).player2Life isnt 0 # if we haven't finish, then new move
        Moves.insert
          playerToPlay: currentMove.playerToPlay
          createdAt: new Date()
          challengeId: currentMove.challengeId
    else # means that we miss the spell
      Moves.update(moveId, {$set: {finishedAt: new Date()}})
      Moves.insert
        playerToPlay: (currentMove.playerToPlay % 2) + 1
        createdAt: new Date()
        challengeId: currentMove.challengeId

    Session.set("currentMove", null)

damage = (attackSpell, counterSpell) ->
  attackSpell is 0 or attackSpell >= 1 and attackSpell <= 5 and counterSpell >= 6 and counterSpell <= 10 and counterSpell - attackSpell is 5
