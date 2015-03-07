Template.login.events
  'click #facebook-button' : (e, t) ->
    e.preventDefault()

    Meteor.loginWithFacebook({}, (err)->
      if err?
        console.log(err)
    )
    return false
  'click #twitter-button' : (e, t) ->
    e.preventDefault()

    Meteor.loginWithTwitter({}, (err)->
      if err?
        console.log(err)
    )
    return false
