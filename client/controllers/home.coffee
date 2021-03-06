Template.main.helpers
  menu_house: () ->
    Session.get('page') is 'house'
  menu_road: () ->
    Session.get('page') is 'road'
  menu_over: () ->
    Challenges.findOne({$and: [ {$or: [ {user1Id: Meteor.userId()}, {user2Id: Meteor.userId()} ] }, {$or: [ {player1Life: 0}, {player2Life: 0} ] }, {acceptedAt: { $exists : true }}, {finishedAt: { $exists : false }} ] })?
  menu_challenge: () ->
    challenge = Challenges.findOne({$and: [ {$or: [ {user1Id: Meteor.userId()}, {user2Id: Meteor.userId()} ] }, {acceptedAt: { $exists : true }}, {finishedAt: { $exists : false }} ] })
    if challenge?
      Session.set('challenge', challenge._id)
    return challenge?
