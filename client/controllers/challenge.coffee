TIME_PER_TURN = 5000
soundEmbed = null

@soundPlay = (which) ->
  if soundEmbed
    document.body.removeChild(soundEmbed)
  if which?
    soundEmbed = document.createElement("audio")
    soundEmbed.setAttribute("src", "/sounds/"+which+".wav")
    soundEmbed.setAttribute("style", "display:none")
    soundEmbed.setAttribute("autostart", true)
    soundEmbed.setAttribute("loop", false)
    document.body.appendChild(soundEmbed)

Template.challenge.helpers
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
  begin: () ->
    currentChallenge = Challenges.findOne(Session.get('challenge'))
    !Moves.findOne({challengeId: currentChallenge._id})
  player1Spell: () ->
    currentChallenge = Challenges.findOne(Session.get('challenge'))
    currentMoves = Moves.findOne({challengeId: currentChallenge._id, finishedAt: {$exists: false}})
    if currentMoves?
      soundPlay currentMoves.player1
      currentMoves.player1
  player2Spell: () ->
    currentChallenge = Challenges.findOne(Session.get('challenge'))
    currentMoves = Moves.findOne({challengeId: currentChallenge._id, finishedAt: {$exists: false}})
    if currentMoves?
      soundPlay currentMoves.player2
      currentMoves.player2
  playing: () ->
    Session.get("currentMove")?
  lastMovement: () ->
    Session.get("lastMovement")

Template.challenge.rendered = () ->
  @autorun () ->
    deamon()
    query = Challenges.find(Session.get('challenge'))
    handle = query.observeChanges
      changed: (id, fields) ->
        if fields.player1Life?
          $('.player1').addClass('damage')
          setTimeout( () ->
            $('.player1').removeClass('damage')
          , 1200)
        else if fields.player2Life?
          $('.player2').addClass('damage')
          setTimeout( () ->
            $('.player2').removeClass('damage')
          , 1200)

###
#
#
# Everytime we have a change in the move, check if it's our turn to play
#
###
deamon = () ->
  currentChallenge = Challenges.findOne(Session.get('challenge'))
  if currentChallenge
    currentMove = Moves.findOne({challengeId: currentChallenge._id, finishedAt: {$exists: false}})
    if currentMove? and ((!currentMove.player1 and currentMove.playerToPlay is 1 and currentChallenge.user1Id is Meteor.userId()) or (!currentMove.player2 and currentMove.playerToPlay is 2 and currentChallenge.user2Id is Meteor.userId()))
      if myo?
        myo.vibrate 'short'
      console.log "my turn now #{currentMove.playerToPlay}"
      Session.set("currentMove", currentMove._id)
      Meteor.setTimeout(
        () ->
          failTurn(currentMove._id)
      , TIME_PER_TURN)
    else
      Session.set("currentMove", null)


###
#
#
# When the user don't draw anything after 5s
#
###
failTurn = (moveId) ->
  if Session.get("currentMove") is moveId # check if we are still in the same turn
    if !checkGesture() #check if we have a gesture complete
      currentMove = Moves.findOne(moveId)

      if currentMove.playerToPlay is 1 and currentMove.player2 or currentMove.playerToPlay is 2 and currentMove.player1 # means that we miss the counter spell
        console.log "fail counterspell"
        if currentMove.playerToPlay is 1 and damage(currentMove.player2, 0)
          Challenges.update(currentMove.challengeId, {$inc: {player1Life : -1}})
        else if currentMove.playerToPlay is 2 and damage(currentMove.player1, 0)
          Challenges.update(currentMove.challengeId, {$inc: {player2Life : -1}})

        Moves.update(moveId, {$set: {finishedAt: new Date()}})
        if Challenges.findOne(currentMove.challengeId).player1Life isnt 0 and Challenges.findOne(currentMove.challengeId).player2Life isnt 0 # if we haven't finish, then new move
          Meteor.setTimeout( () ->
            Moves.insert
              playerToPlay: currentMove.playerToPlay
              createdAt: new Date()
              challengeId: currentMove.challengeId
          , 2000)
      else # means that we miss the spell
        nextPlayer = ((currentMove.playerToPlay % 2) + 1)
        console.log "fail spell. Current Player : #{currentMove.playerToPlay}. Next player : #{nextPlayer}"
        Moves.update(moveId, {$set: {finishedAt: new Date()}})
        Moves.insert
          playerToPlay: nextPlayer
          createdAt: new Date()
          challengeId: currentMove.challengeId
      #Session.set('myoActive', false)
      Session.set("currentMove", null)

###
#
#
# When the user don't draw anything after 5s
#
###
@launchSpell = (spellId) ->
  if spellId is 0
    spellId = 11
  currentMove = Moves.findOne(Session.get('currentMove'))

  if currentMove.playerToPlay is 1 and currentMove.player2 or currentMove.playerToPlay is 2 and currentMove.player1 # means that we launch a counter spell
    console.log "launch counterspell"

    if currentMove.playerToPlay is 1
      Moves.update(currentMove._id, {$set: {player1: spellId}})
    else
      Moves.update(currentMove._id, {$set: {player2: spellId}})

    Meteor.setTimeout( () ->
      # if it was a wrong counterspell
      if currentMove.playerToPlay is 1 and damage(currentMove.player2, spellId)
        Challenges.update(currentMove.challengeId, {$inc: {player1Life : -1}})
      else if currentMove.playerToPlay is 2 and damage(currentMove.player1, spellId)
        Challenges.update(currentMove.challengeId, {$inc: {player2Life : -1}})

      Moves.update(currentMove._id, {$set: {finishedAt: new Date()}})
      if Challenges.findOne(currentMove.challengeId).player1Life isnt 0 and Challenges.findOne(currentMove.challengeId).player2Life isnt 0 # if we haven't finish, then new move
        Moves.insert
          playerToPlay: currentMove.playerToPlay
          createdAt: new Date()
          challengeId: currentMove.challengeId
    , 3000)

  else # means that we launch the spell
    console.log "launch spell"
    if currentMove.playerToPlay is 1
      Moves.update(currentMove._id, {$set: {player1: spellId, playerToPlay: 2, playedAt: new Date()}})
    else
      Moves.update(currentMove._id, {$set: {player2: spellId, playerToPlay: 1, playedAt: new Date()}})
  #Session.set('myoActive', false)
  Session.set("currentMove", null)

damage = (attackSpell, counterSpell) ->
  attackSpell is 11 or attackSpell < 6 and (counterSpell < 6 or counterSpell > 10 or counterSpell - attackSpell isnt 5)
