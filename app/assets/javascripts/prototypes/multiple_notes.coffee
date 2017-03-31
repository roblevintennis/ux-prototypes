# Multiple Notes Prototype
$ ->
  notes = []
  durationTotal = ''

  $('.container').addClass 'no-pad'

  render = ->
    $('.notes-container').html template({notes: notes})

  renderNotes = ->
    $('.field-note').addClass('hidden')
    render()
    $('.notes').show()
    $('.notes').removeClass('hidden').removeClass('fade-out').addClass('slide-in-up')
    resizeNotes()

    # When user clicks 'Add Entry' toggle in the form
    $('.add-entry-link').on 'click', (e) ->
      e.preventDefault()
      parent = $(this).parent()
      parent.children('.add-entry-form, .add-entry-link').toggle()
      parent.children('.field-duration').focus()
      diff = getDurationDifference($('.cell').val(), durationTotal)

      unless diff == "0h 0"
        applyDurationDifferencePrompt = "<span class='difference-prompt'>You just added #{diff}. </span><a href='#'>Apply here?</a>"
        prompt = parent.children('.add-entry-form').find('.duration-difference-prompt').append(applyDurationDifferencePrompt).show()

        $(prompt).on 'click', (e) ->
          e.preventDefault()
          parent.children('.add-entry-form').find('.field-duration').val(diff)
          prompt.hide()

      resizeNotes()

    $('.field-notes').on 'keydown', (e) ->
      switch e.which
        when 13
          addNote({
            content: $(this).val(),
            duration: $(this).siblings('.field-duration').val()
          })
          renderNotes()

  resizeNotes = ->
    h = Math.round( parseInt($('.notes').outerHeight()) ) * -1
    $('.notes').css('top', h)

  template = _.template($('script.notes-template').html())

  render() #initial render

  addNote = (note) ->
    notes.push(note)
    durationTotal = addDurations(durationTotal, note.duration)
    console.log('durationTotal: ' + durationTotal)

  getDurationDifference = (d1, d2) ->
    d1minutes = d1hours = d2minutes = d2hours = ''
    match1 = d1.split(' ')
    d1hours = match1[0] if match1.length
    d1minutes = match1[1] if match1.length > 1
    match2 = d2.split(' ')
    d2hours = match2[0] if match2.length
    d2minutes = match2[1] if match2.length > 1
    totalHours = (parseInt(d1hours) || 0) - (parseInt(d2hours) || 0)
    totalMinutes = (parseInt(d1minutes) || 0) - (parseInt(d2minutes) || 0)
    total = totalHours + 'h ' + totalMinutes
    total

  addDurations = (d1, d2) ->
    d1minutes = d1hours = d2minutes = d2hours = ''
    match1 = d1.split(' ')
    d1hours = match1[0] if match1.length
    d1minutes = match1[1] if match1.length > 1
    match2 = d2.split(' ')
    d2hours = match2[0] if match2.length
    d2minutes = match2[1] if match2.length > 1
    totalHours = (parseInt(d1hours) || 0) + (parseInt(d2hours) || 0)
    totalMinutes = (parseInt(d1minutes) || 0) + (parseInt(d2minutes) || 0)
    total = totalHours + 'h ' + totalMinutes
    total

  noteHasValue = ->
    return false if $('.notes').hasClass('slide-in-up')
    $('.notes-dropdown').val().length > 0 || notes.length

  $('.cell').on 'click', (e) ->
    if noteHasValue()
      renderNotes()
    else
      $('.notes-dropdown').removeClass('hidden').removeClass('fade-out').addClass('slide-in-up')

  $('.cell').on 'keydown', (e) ->
    switch e.which
      when 13
        if noteHasValue()
          addNote({
            content: $('.notes-dropdown').val(),
            duration: $('.cell').val()
          })

        $('.notes').removeClass('slide-in-up').addClass('fade-out')
        console.log("**** TODO *****")
        console.log("Add logic when editing cell e.g. add misc note or update val")

      when 9 # TAB
        unless noteHasValue()
          $('.notes-dropdown').focus()
          e.preventDefault()
      when 38 # UP
        if noteHasValue()
          renderNotes()
        else
          $('.notes-dropdown').focus()
      else

  $('.notes-dropdown').on 'keydown', (e) ->
    switch e.which
      when 13
        $('.notes-dropdown').removeClass('slide-in-up').addClass('fade-out')
        if noteHasValue()
          addNote({
            content: $('.notes-dropdown').val(),
            duration: $('.cell').val()
          })

      when 40 # DOWN
        $('.cell').focus()
      else

  # Add/remove arrow indicator if notes field has any content
  $('.cell, .notes-dropdown').keyup (e) ->
    if noteHasValue()
      $('.notes-indicator').removeClass('hidden')
    else
      $('.notes-indicator').addClass('hidden')
