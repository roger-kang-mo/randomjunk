randoms.notes = (args) ->
	submitLoader = $('#submit-loader')
	authorBox = $('#note-author')
	contentBox = $('#note-content')
	submitButt = $('#submit-note')
	notesArea = $('#notes-area')
	savePosition = $('#save-position')
	positionLoader = $('#position-loader')
	highestZ = 0

	$(document).ready ->
		notes = $('#notes-area .note')
		notes.draggable({ 
			containment: '#notes-area'
			start: -> updateZIndex(this)
			stop: -> saveNotePositions()
			})

		allNotes = args.notes
		for i in [0..allNotes.length - 1]
			currentZ = allNotes[i].z
			highestZ = currentZ if currentZ > highestZ 
			highestZ++

		# for i in [0..notes.length - 1]
		# 	thisNote = notes[i]
		# 	noteX = thisNote.attributes['data-x'].nodeValue
		# 	noteY = thisNote.attributes['data-y'].nodeValue
		# 	$(thisNote).offset({ top: noteY, left: noteX})

	$(document).on 'click', '.note', (e) -> updateZIndex(e.target)

	submitButt.click ->
		thisAuthor = authorBox.val()
		thisContent = contentBox.val()

		if thisAuthor.length == 0
			console.log 'here'
		else if thisContent.length == 0
			console.log 'here2'
		else
			sendData = { note: { author: thisAuthor, content: thisContent } } 
			submitLoader.show()
			$.ajax
				url: '/notes'
				data: sendData
				type: 'POST'
				dataType: 'json'
				success: (data) ->
					console.log data
					createNote(data)
					clearFields()
				error: (data) ->
					console.log data
					showError(data)
				complete: -> submitLoader.hide()

	clearFields = ->
		authorBox.val('')
		contentBox.val('')

	createNote = (data) ->
		thisAuthor = authorBox.val()
		thisContent = contentBox.val()
		noteId = data.note.id

		noteHTML = '<div class="note" data-x="247" data-y="540" data-note-id="'+noteId+'">
						<div class="delete-bar"><span class="icon-font">ã</span></div>
						<div class="author">' + thisAuthor + '</div>
						<div class="content">' + thisContent + '</div>
					</div>'

		notesArea.append(noteHTML)
		newNote = $('[data-note-id='+noteId+']')
		newNote.draggable({ 
			containment: '#notes-area'
			start: -> updateZIndex(this)
			stop: -> saveNotePositions()
		})
		newNote.position({ 'top': '42%', 'left': '42%' })


	showError = (data) ->
		console.log 'there was an error'

	updateZIndex = (args) ->
		$(args).css({'z-index': highestZ})
		highestZ++

	# savePosition.click -> saveNotePositions()

	saveNotePositions = ->
		# positionLoader.show()

		sendData = { notes: collectPositions() }

		$.ajax
			url: '/notes/update_positions'
			data: sendData
			type: 'POST'
			dataType: 'json'
			success: (data) ->
				console.log data
			error: (data) ->
				console.log data
			# complete: ->
			# 	positionLoader.hide()

	collectPositions = ->
		notes = $('.note')
		retData = []

		for i in [0..notes.length - 1]
			thisNote = notes[i]
			thisID =  $(notes[i]).data('id')
			thisX = $(notes[i]).position().left
			thisY = $(notes[i]).position().top

			retData.push { id: thisID, coords: { x: thisX, y: thisY }}

		retData

	$(document).on 'click', '.note-delete', (e) ->
		$(e.target).parents('.note').addClass('to-delete')

		$.confirm
	      title: "Are You Sure?"
	      message: "You can delete any of the notes, but that takes the joy away from others who<br/>won't get to see that note!"
	      buttons:
	        Yes:
	          class: "blue"
	          action: ->
	            deleteID = $('.to-delete').data('id')
	            $.ajax
	            	url: '/notes/' + deleteID
	            	type: 'DELETE'
	            	dataType: 'json'
	            	success: ->
	            		child = $('.to-delete').fadeOut()
	            		child.parent().removeChild(child)
	            	error: (e) -> console.log e
	        No:
	          class: "inactive"
	          action: ->
	            






