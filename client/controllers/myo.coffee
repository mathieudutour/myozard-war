myo = Myo.create()

myo.on 'connected', () ->
  myo.setLockingPolicy('none')

active = false
previous = null
gesture = new Array()
index = 0

myo.on 'fist', (edge)->
  if(edge and !active)
    active = true
    myo.vibrate('short')
    console.log("movement recording")

myo.on 'fingers_spread', (edge) ->
  if edge and active == true
    active = false
    myo.vibrate 'short'
    console.log 'finished movement recording'
    index = 0

    sp = gesture.toString()
    gesture = []
    id = -1
    if sp == '3,6,2,4,8' or sp == '6,2,4,8,3' or sp == '2,4,8,3,6' or sp == '4,8,3,6,2' or sp == '8,3,6,2,4'
      id = 0
    else if sp == '2,4,7' or sp == '4,7,2' or sp == '7,2,4'
      id = 1
    else if sp == '1,3,5,7' or sp == '3,5,7,1' or sp == '5,7,1,3' or sp == '7,1,3,5'
      id = 2
    else if sp == '3,6,3,8' or sp == '6,3,8,3' or sp == '3,8,3,6' or sp == '8,3,6,3'
      id = 3
    else if sp == '3,5,3,5,8' or sp == '5,3,5,8,3' or sp == '3,5,8,3,5' or sp == '5,8,3,5,3' or sp == '8,3,5,3,5'
      id = 4
    else if sp == '1,4,1,4,7' or sp == '4,1,4,7,1' or sp == '1,4,7,1,4' or sp == '4,7,1,4,1' or sp == '7,1,4,1,4'
      id = 5
    else if sp == '6,8,2,4' or sp == '8,2,4,6' or sp == '2,4,6,8' or sp == '4,6,8,2'
      id = 6
    else if sp == '2,3,6,7' or sp == '3,6,7,2' or sp == '6,7,2,3' or sp == '7,2,3,6'
      id = 7
    else if sp == '1,4,1,6' or sp == '4,1,6,1' or sp == '1,6,1,4' or sp == '6,1,4,1'
      id = 8
    else if sp == '7,5,7,5,2' or sp == '5,7,5,2,7' or sp == '7,5,2,7,5' or sp == '5,2,7,5,7' or sp == '2,7,5,7,5'
      id = 9
    else if sp == '5,8,5,8,3' or sp == '8,5,8,3,5' or sp == '5,8,3,5,8' or sp == '8,3,5,8,5' or sp == '3,5,8,5,8'
      id = 10
    # counter - dress

    console.log id + '\n'

myo.on 'gyroscope', (data) ->
  if active == true
    vert = data.y
    hor = data.z
    reduce = 0.3
    rounding = 1
    trigger = 80

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
