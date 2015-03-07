Meteor.startup ->
  if Meteor.users.find().count() is 0
    Accounts.createUser
      username : 'Merlin'
      password: '1234'

