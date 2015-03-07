Template.house.events
  'click #return-button' : (e, t) ->
    e.preventDefault()
    Session.set('page', 'road')
    return false
