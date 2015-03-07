Meteor.subscribe("challenges")
Meteor.subscribe("users")

Tracker.autorun () ->
  Meteor.subscribe("moves", Session.get("challenge"))
