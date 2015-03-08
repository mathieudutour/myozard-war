@myo = Myo.create()

myo.on 'connected', () ->
  myo.setLockingPolicy('none')

Session.set('myoActive', false)
previous = null
gesture = new Array()
index = 0

arraysEqual = (a, b) ->
  if a == b
    return true
  if a == null or b == null
    return false
  if a.length != b.length
    return false
  # If you don't care about the order of the elements inside
  # the array, you should sort both arrays here.
  i = 0
  while i < a.length
    if a[i] != b[i]
      return false
    ++i
  true

@checkGesture = () ->
  myo.vibrate 'short'
  id = -1
  i = 0
  while i < gestures.length
    j = 0
    while j < gestures[i].length
      if arraysEqual(gestures[i][j], gesture)
        id = i
        break
      ++j
    if id isnt -1
      break
    ++i
  gesture = []
  previous = null
  console.log "movement recognize : #{id}"
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

myo.on 'fingers_spread', (edge) ->
  if edge and Session.get('myoActive') and Session.get("currentMove")?
    Session.set('myoActive', false)
    console.log 'finished movement recording'
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
      gesture.push previous
    else if vert > trigger and hor < trigger * reduce and hor > -trigger * reduce and previous != 5
      console.log 'down'
      previous = 5
      gesture.push previous
    else if hor < -trigger and vert < trigger * reduce and vert > -trigger * reduce and previous != 3
      console.log 'rigth'
      previous = 3
      gesture.push previous
    else if hor > trigger and vert < trigger * reduce and vert > -trigger * reduce and previous != 7
      console.log 'left'
      previous = 7
      gesture.push previous
    else if vert < -trigger * rounding and hor < trigger * reduce and hor < -trigger * rounding and vert < trigger * reduce and previous != 2
      console.log 'up-rigth'
      previous = 2
      gesture.push previous
    else if vert < -trigger * rounding and hor > trigger * rounding and hor > -trigger * reduce and vert < trigger * reduce and previous != 8
      console.log 'up-left'
      previous = 8
      gesture.push previous
    else if vert > trigger * rounding and hor < trigger * reduce and hor < -trigger * rounding and vert > -trigger * reduce and previous != 4
      console.log 'down-rigth'
      previous = 4
      gesture.push previous
    else if vert > trigger * rounding and hor > trigger * rounding and hor > -trigger * reduce and vert > -trigger * reduce and previous != 6
      console.log 'down-left'
      previous = 6
      gesture.push previous
  return
