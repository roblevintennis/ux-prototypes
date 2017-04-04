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
    $('.notes').removeClass('hidden').removeClass('fade-out').addClass('slide-in-down')
    $('.field-notes').bind('keydown', onFieldNotesKeydown)
    $('.add-entry-link').bind('click', onAddEntryClicked)
    $('.edit-link').bind('click', onEditClicked)

  onEditClicked = (e) ->
    console.log("onEditClicked called")
    e.preventDefault()
    $('.timeentry-popover').show()

    $(document).keyup (e) ->
      if e.keyCode == 27
        $('.timeentry-popover').hide()

  onFieldNotesKeydown = (e) ->
    switch e.which
      when 13
        addNote({
          content: $(this).val(),
          duration: $(this).siblings('.field-duration').val()
        })
        renderNotes()

  onAddEntryClicked = (e) ->
    console.log("onAddEntryClicked called")
    e.preventDefault()
    parent = $(this).parent()
    parent.children('.add-entry-form, .add-entry-link').toggle()
    parent.children('.field-duration').focus()
    currentNotesLength = $(this).data('notesLength')
    diff = getDurationDifference($('.cell').val(), durationTotal)

    unless diff == "0h 0" || currentNotesLength > 1
      addDurationDifferencePrompt(parent, diff)

  addDurationDifferencePrompt = (parent, diff) ->
    console.log("addDurationDifferencePrompt function...")
    applyDurationDifferencePrompt = "<span class='difference-prompt'>You just added #{diff}. </span><a href='#'>Apply here?</a>"
    prompt = parent.children('.add-entry-form').find('.duration-difference-prompt').append(applyDurationDifferencePrompt).show()

    $(prompt).on 'click', (e) ->
      e.preventDefault()
      parent.children('.add-entry-form').find('.field-duration').val(diff)
      prompt.hide()

  template = _.template($('script.notes-template').html())

  render() #initial render

  addNote = (note) ->
    notes.push(note)
    durationTotal = addDurations(durationTotal, note.duration)
    $('.cell').val(durationTotal)

  getDurationDifference = (d1, d2) ->
    _getDuration(d1, d2, false)

  addDurations = (d1, d2) ->
    _getDuration(d1, d2, true)

  _getDuration = (d1, d2, doAddition) ->
    d1minutes = d1hours = d2minutes = d2hours = ''
    match1 = d1.split(' ')
    d1hours = match1[0] if match1.length
    d1minutes = match1[1] if match1.length > 1
    match2 = d2.split(' ')
    d2hours = match2[0] if match2.length
    d2minutes = match2[1] if match2.length > 1

    if (doAddition)
      totalHours = (parseInt(d1hours) || 0) + (parseInt(d2hours) || 0)
      totalMinutes = (parseInt(d1minutes) || 0) + (parseInt(d2minutes) || 0)
    else
      totalHours = (parseInt(d1hours) || 0) - (parseInt(d2hours) || 0)
      totalMinutes = (parseInt(d1minutes) || 0) - (parseInt(d2minutes) || 0)

    realmin = totalMinutes % 60
    additionalHours = Math.floor(totalMinutes / 60)
    totalHours += additionalHours || 0
    totalMinutes = realmin
    total = totalHours + 'h ' + totalMinutes
    total

  closeNotes = ->
    $('.notes, .notes-dropdown').removeClass('slide-in-down').addClass('fade-out')

  noteHasValue = ->
    return false if $('.notes').hasClass('slide-in-down')
    $('.notes-dropdown').val().length > 0 || notes.length

  $('html').on 'click', (e) ->
    console.log("HTML click...")

    #Don't close if clicking on notes popover
    if ($(e.target).closest('.notes, .notes-dropdown').length)
      console.log("Clicked on notes popover .. ignoring click")
      return false

    #Don't close if event handed
    if (e.isDefaultPrevented())
      console.log("isDefaultPrevented true...returning false...")
      return false

    closeNotes()

  $('.cell').on 'click', (e) ->
    console.log("cell onclick")
    e.preventDefault()
    if noteHasValue()
      renderNotes()
    else
      $('.notes-dropdown').removeClass('hidden').removeClass('fade-out').addClass('slide-in-down')

  $('.cell').on 'keydown', (e) ->
    switch e.which
      when 13
        # Is it the first note? Then just add
        if notes.length < 1 && noteHasValue()
          addNote({
            content: $('.notes-dropdown').val(),
            duration: $('.cell').val()
          })
        else if notes.length > 1
          currentNotesLength = $(this).data('notesLength')
          diff = getDurationDifference($('.cell').val(), durationTotal)

          unless diff == "0h 0"
            addNote({
              content: '<em>Automatically added note</em>'
              duration: diff
            })

        closeNotes()

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
    console.log("notes-dropdown keydown")
    switch e.which
      when 13
        closeNotes()
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
