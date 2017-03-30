# Multiple Notes Prototype
$ ->
  noteHasValue = ->
    $('.notes-dropdown').val().length > 0

  $('.container').addClass 'no-pad'

  showAddEntry = () ->
    $('.field-note').addClass('hidden')
    $('.field-add-entry').removeClass('hidden').removeClass('fade-out').addClass('slide-in-up')

    now = moment().format("MMM Do YY, h:mm:ssa")
    $('.duration').text($('.cell').val())
    $('.timestamp').text(now)
    $('.note-content').text($('.notes-dropdown').val())
    h = Math.round( parseInt($('.field-add-entry').outerHeight()) ) * -1
    $('.field-add-entry').css('top', h)

  $('.cell').on 'click', (e) ->
    if noteHasValue()
      showAddEntry()
    else
      $('.notes-dropdown').removeClass('hidden').removeClass('fade-out').addClass('slide-in-up')

  $('.cell').on 'keydown', (e) ->
    switch e.which
      when 13
        if noteHasValue()
          $('.field-add-entry').removeClass('slide-in-up').addClass('fade-out')
        else
          $('.notes-dropdown').removeClass('slide-in-up').addClass('fade-out')

        console.log("**** TODO *****")
        console.log("Add logic when editing cell e.g. add misc note or update val")
        # $('.duration').text($('.cell').val())

      when 9
        unless noteHasValue()
          $('.notes-dropdown').focus()
          e.preventDefault()
      when 38 # UP
        if noteHasValue()
          showAddEntry()
        else
          $('.notes-dropdown').focus()
      else

  $('.notes-dropdown').on 'keydown', (e) ->
    switch e.which
      when 13
        $('.notes-dropdown').removeClass('slide-in-up').addClass('fade-out')
      when 40 # DOWN
        $('.cell').focus()
      else

  # Add/remove arrow indicator if notes field has any content
  $('.cell, .notes-dropdown').keyup (e) ->
    if noteHasValue()
      $('.notes-indicator').removeClass('hidden')
    else
      $('.notes-indicator').addClass('hidden')

