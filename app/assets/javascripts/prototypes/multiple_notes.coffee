# Multiple Notes Prototype
$ ->
  $('.container').addClass 'no-pad'

  $('.cell').on 'click', (e) ->
    $('.notes-dropdown').removeClass('hidden').removeClass('fade-out').addClass('slide-in-up')

  $('.cell, .notes-dropdown').keypress (e) ->
    if e.which == 13
      $('.notes-dropdown').removeClass('slide-in-up').addClass('fade-out')

  # Add/remove arrow indicator if notes field has any content
  $('.cell, .notes-dropdown').keyup (e) ->
    if ($('.notes-dropdown').val().length > 0)
      $('.notes-indicator').removeClass('hidden')
    else
      $('.notes-indicator').addClass('hidden')

