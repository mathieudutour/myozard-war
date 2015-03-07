Meteor.subscribe("challenges")
Meteor.subscribe("users0")
Meteor.subscribe("users1")
Meteor.subscribe("users2")

Tracker.autorun () ->
  Meteor.subscribe("moves", Session.get("challenge"))
