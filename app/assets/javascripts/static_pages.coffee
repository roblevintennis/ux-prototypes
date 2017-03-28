$ ->
  $('.container').addClass 'no-pad'

  $('.cell').on 'click', (e) ->
    $('.notes-dropdown').show()

  $('.cell, .notes-dropdown').keypress (e) ->
    if e.which == 13
      $('.notes-dropdown').hide()
