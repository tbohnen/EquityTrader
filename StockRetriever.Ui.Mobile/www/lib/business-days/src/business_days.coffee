# http://javascript.about.com/library/blbusdayadd.htm
module.exports = (dd, y, m, d) ->
  tis = if y? and m? and d? then new Date y, m, d else new Date()
  wks = Math.floor dd / 5
  dys = ((dd % 5) + 5) % 5
  dy = tis.getDay()
  if dy is 6 and dys > -1
    if dys is 0
      dys -= 2
      dy += 2
    ++dys
    dy -= 6
  if dy is 0 and dys < 1
    if dys is 0
      dys += 2
      dy -= 2
    --dys
    dy += 6
  if dy + dys > 5
    dys += 2
  if dy + dys < 1
    dys -= 2
  tis.setDate tis.getDate() + wks * 7 + dys
  tis
