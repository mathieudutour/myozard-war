myo = Myo.create()

myo.on 'connected', () ->
  myo.setLockingPolicy('none')

Session.set('myoActive', false)
previous = null
gesture = new Array()
index = 0

@checkGesture = () ->
  id = -1
  i = 0
  while i < gestures.length
    console.log gestures[i].indexOf(gesture)
    if gestures[i].indexOf(gesture) isnt -1
      id = i
      break
    ++i
  gesture = []
  if id >= 0
    launchSpell(id)
  return id >= 0

# 1 -> up
# 2 -> up-right
# 3 -> right
# 4 -> down-right
# 5 -> down-right
# 6 -> down-left
# 7 -> left
# 8 -> up-left
gestures = [
  [[3,6,2,4,8], [6,2,4,8,3], [2,4,8,3,6], [4,8,3,6,2], [8,3,6,2,4]], # super spell
  [[2,4,7], [4,7,2], [7,2,4]], # cat
  [[1,3,5,7], [3,5,7,1], [5,7,1,3], [7,1,3,5]], # sheep
  [[3,6,3,8], [6,3,8,3], [3,8,3,6], [8,3,6,3]], # unicorn
  [[3,5,3,5,8], [5,3,5,8,3], [3,5,8,3,5], [5,8,3,5,3], [8,3,5,3,5]], # underwears
  [[1,4,1,4,7], [4,1,4,7,1], [1,4,7,1,4], [4,7,1,4,1], [7,1,4,1,4]], # dress
  [[6,8,2,4], [8,2,4,6], [2,4,6,8], [4,6,8,2]], # counter cat
  [[2,3,6,7], [3,6,7,2], [6,7,2,3], [7,2,3,6]], # counter sheep
  [[1,4,1,6], [4,1,6,1], [1,6,1,4], [6,1,4,1]], # counter unicorn
  [[7,5,7,5,2], [5,7,5,2,7], [7,5,2,7,5], [5,2,7,5,7], [2,7,5,7,5]], # counter underwears
  [[5,8,5,8,3], [8,5,8,3,5], [5,8,3,5,8], [8,3,5,8,5], [3,5,8,5,8]] # counter dress
]

myo.on 'fist', (edge)->
  if edge and !Session.get('myoActive') and Session.get("currentMove")?
    Session.set('myoActive', true)
    myo.vibrate('short')
    console.log("movement recording")
    index = 0

myo.on 'fingers_spread', (edge) ->
  if edge and Session.get('myoActive') and Session.get("currentMove")?
    Session.set('myoActive', false)
    myo.vibrate 'short'
    console.log 'finished movement recording'
    index = 0

    checkGesture()

myo.on 'gyroscope', (data) ->
  if Session.get('myoActive')
    vert = data.y
    hor = data.z
    reduce = 0.3
    rounding = 1
    trigger = 50

    if vert < -trigger and hor < trigger * reduce and hor > -trigger * reduce and previous != 1
      console.log 'up'
      previous = 1
      gesture[index] = previous
      index++
    else if vert > trigger and hor < trigger * reduce and hor > -trigger * reduce and previous != 5
      console.log 'down'
      previous = 5
      gesture[index] = previous
      index++
    else if hor < -trigger and vert < trigger * reduce and vert > -trigger * reduce and previous != 3
      console.log 'rigth'
      previous = 3
      gesture[index] = previous
      index++
    else if hor > trigger and vert < trigger * reduce and vert > -trigger * reduce and previous != 7
      console.log 'left'
      previous = 7
      gesture[index] = previous
      index++
    else if vert < -trigger * rounding and hor < trigger * reduce and hor < -trigger * rounding and vert < trigger * reduce and previous != 2
      console.log 'up-rigth'
      previous = 2
      gesture[index] = previous
      index++
    else if vert < -trigger * rounding and hor > trigger * rounding and hor > -trigger * reduce and vert < trigger * reduce and previous != 8
      console.log 'up-left'
      previous = 8
      gesture[index] = previous
      index++
    else if vert > trigger * rounding and hor < trigger * reduce and hor < -trigger * rounding and vert > -trigger * reduce and previous != 4
      console.log 'down-rigth'
      previous = 4
      gesture[index] = previous
      index++
    else if vert > trigger * rounding and hor > trigger * rounding and hor > -trigger * reduce and vert > -trigger * reduce and previous != 6
      console.log 'down-left'
      previous = 6
      gesture[index] = previous
      index++
  return
