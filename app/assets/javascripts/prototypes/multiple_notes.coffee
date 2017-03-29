# Multiple Notes Prototype
$ ->
  $('.container').addClass 'no-pad'

  $('.cell').on 'click', (e) ->
    $('.notes-dropdown').removeClass('hidden').removeClass('fade-out').addClass('slide-in-up')

  $('.cell').on 'keydown', (e) ->
    switch e.which
      when 13
        $('.notes-dropdown').removeClass('slide-in-up').addClass('fade-out')
      when 38
        $('.notes-dropdown').focus()
      else

  $('.notes-dropdown').on 'keydown', (e) ->
    switch e.which
      when 13
        $('.notes-dropdown').removeClass('slide-in-up').addClass('fade-out')
      when 40
        $('.cell').focus()
      else

  # Add/remove arrow indicator if notes field has any content
  $('.cell, .notes-dropdown').keyup (e) ->
    if ($('.notes-dropdown').val().length > 0)
      $('.notes-indicator').removeClass('hidden')
    else
      $('.notes-indicator').addClass('hidden')

