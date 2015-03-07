Template.login.events
  'submit #login-form' : (e, t) ->
    e.preventDefault()
    button = new ProgressButton "button"
    utils.initFormErrors t

    username = t.find('#login-username').value
    password = t.find('#login-password').value

    Meteor.loginWithPassword(username, password, (err)->
      if err?
        button.error()
        console.log(err)
        if err.reason is "Incorrect password"
          utils.showErrorForm t.find('#password-incorrect')
        else
          utils.showErrorForm t.find('#error-serveur')
      else
        button.success()
    )
    return false
