assert = require 'assert'
bd = require '../src/business_days'

wed = new Date 2013, 8, 18
thu = new Date 2013, 8, 19 # months are zero indexed
fri = new Date 2013, 8, 20
mon = new Date 2013, 8, 23

dayPlus = (numdays, day) ->
  bd numdays, day.getFullYear(), day.getMonth(), day.getDate()

sameDay = (day1, day2, msg) ->
  assert.equal day1.getFullYear(), day2.getFullYear(), msg
  assert.equal day1.getMonth(), day2.getMonth(), msg
  assert.equal day1.getDate(), day2.getDate(), msg

test1 = dayPlus 1, thu
sameDay test1, fri, 'thu + 1 = fri'

test2 = dayPlus 2, thu
sameDay test2, mon, 'thu + 2 = mon'

test3 = dayPlus -1, thu
sameDay test3, wed, 'thu - 1 = wed'

test4 = dayPlus -1, mon
sameDay test4, fri, 'mon - 1 = fri'

