Template.over.helpers
  challenge: () ->
    Challenges.findOne(Session.get('challenge'))
  player1Life: () ->
    currentChallenge = Challenges.findOne(Session.get('challenge'))
    life = [{life: false}, {life: false}, {life: false}, {life: false}, {life: false}]
    i = 0
    while i < currentChallenge.player1Life
      life[i].life = true
      ++i
    return life
  player2Life: () ->
    currentChallenge = Challenges.findOne(Session.get('challenge'))
    life = [{life: false}, {life: false}, {life: false}, {life: false}, {life: false}]
    i = 0
    while i < currentChallenge.player2Life
      life[i].life = true
      ++i
    life
  player1: () ->
    currentChallenge = Challenges.findOne(Session.get('challenge'))
    Meteor.users.findOne(currentChallenge.user1Id)
  player2: () ->
    currentChallenge = Challenges.findOne(Session.get('challenge'))
    Meteor.users.findOne(currentChallenge.user2Id)
  win: () ->
    currentChallenge = Challenges.findOne(Session.get('challenge'))
    currentChallenge.player1Life > 0 and currentChallenge.user1Id is Meteor.userId() or currentChallenge.player2Life > 0 and currentChallenge.user2Id is Meteor.userId()

Template.over.rendered = () ->
  Meteor.setTimeout( () ->
    Challenges.update(Session.get('challenge'), {$set: {finishedAt : new Date()}})
    Session.set('challenge', null)
  , 5000)
