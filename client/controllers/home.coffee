Template.main.helpers
  menu_house: () ->
    Session.get('page') is 'house'
  menu_road: () ->
    Session.get('page') is 'road'
  menu_challenge: () ->
    Challenges.findOne({$and: [ {$or: [ {user1Id: @userId}, {user2Id: @userId} ] }, {acceptedAt: { $exists : true }}, {finishedAt: { $exists : false }} ] })?
