# Multiple Notes Prototype
$ ->
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
      $(this).parent().children('.add-entry-form, .add-entry-link').toggle()
      $(this).parent().children('.field-duration').focus()
      resizeNotes()

    $('.field-notes').on 'keydown', (e) ->
      switch e.which
        when 13
          notes.push({
            content: $(this).val(),
            duration: $(this).siblings('.field-duration').val()
          })
          renderNotes()

  resizeNotes = ->
    h = Math.round( parseInt($('.notes').outerHeight()) ) * -1
    $('.notes').css('top', h)

  template = _.template($('script.notes-template').html())
  notes = []
  render() #initial render

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
          notes.push({
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
          notes.push({
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
