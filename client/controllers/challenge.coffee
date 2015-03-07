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
  attack: () ->
    null

Template.challenge.rendered = () ->
  currentChallenge = Challenges.findOne({$and: [ {$or: [ {user1Id: Meteor.userId()}, {user2Id: Meteor.userId()} ] }, {acceptedAt: { $exists : true }}, {finishedAt: { $exists : false }} ] })
  @autorun () ->
    deamon()

deamon = () ->
  if !currentChallenge
    currentChallenge = Challenges.findOne({$and: [ {$or: [ {user1Id: Meteor.userId()}, {user2Id: Meteor.userId()} ] }, {acceptedAt: { $exists : true }}, {finishedAt: { $exists : false }} ] })
  currentMoves = Moves.findOne({challengeId: currentChallenge._id, finishedAt: {$exists: false}})
  if !currentMoves.player1 && currentChallenge.user1Id is Meteor.userId()
    Session.set("currentMove", currentMoves._id)
    Meteor.setTimeout(
      () ->
        if Session.get("currentMove") is currentMoves._id
          Session.set("currentMove", null)
    , TIME_PER_TURN)
  else if !currentMoves.player2 && currentChallenge.user2Id is Meteor.userId()
    Session.set("currentMove", currentMoves._id)
    Meteor.setTimeout(
      () ->
        if Session.get("currentMove") is currentMoves._id
          Session.set("currentMove", null)
    , TIME_PER_TURN)
  else
    Session.set("currentMove", null)
