UI.registerHelper('prettifyDate', (date) ->
  if !date?
    ''
  else
    timestamp = new Date(date)
    now = new Date().getTime()
    diffEnJour = ((now - timestamp.getTime()) / 86400000).toFixed(0)
    if diffEnJour < 1
      "Today"
    else if diffEnJour < 2
      "Yesterday"
    else if diffEnJour < 8
      "" + diffEnJour + " days ago"
    else
      "The " + timestamp.toLocaleDateString('en')
)
