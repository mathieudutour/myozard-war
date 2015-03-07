Template.main.helpers
  menu_house: () ->
    Session.get('page') is 'house'
  menu_road: () ->
    Session.get('page') is 'road'
  menu_challenge: () ->
    Session.get('page') is 'challenge'

