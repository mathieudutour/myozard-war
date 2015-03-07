Template.road.events
  'click #challenges-button' : (e, t) ->
    e.preventDefault()
    Session.set('showChallenges', true)
    return false
  'click #settings-button' : (e, t) ->
    e.preventDefault()
    Session.set('page', 'house')
    return false
  'click .requestChallenge': (e, t) ->
    e.preventDefault()
    Challenges.update(e.currentTarget.id,
      $set:
        acceptedAt: new Date()
        playing: true
    )
    return false

Template.road.helpers
  showChallenges: () ->
    Session.get('showChallenges') is true
  requestChallenges: () ->
    Challenges.find({user2Id: @userId, acceptedAt: { $exists : false }} ).map (challenge) ->
      challenge.username = Meteor.users.findOne(challenge.user1Id).profile.username
      return challenge

Template.listChallenges.helpers
  availableUsers: () ->
    Meteor.users.find({"profile.online" : true, "profile.playing": false, "_id": {$not: Meteor.userId()}}, {limit: 10})

Template.listChallenges.events
  'click .myozard' : (e, t) ->
    e.preventDefault()
    Challenges.insert
      user1Id: Meteor.userId()
      user2Id: e.currentTarget.id
      createdAt: new Date()
      playing: false
      player1Life: 5
      player2Life: 5
    return false
