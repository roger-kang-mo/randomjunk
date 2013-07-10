randoms.notes = (args) ->
	submitLoader = $('#submit-loader')
	authorBox = $('#note-author')
	contentBox = $('#note-content')
	submitButt = $('#submit-note')
	notesArea = $('#notes-area')
	savePosition = $('#save-position')
	positionLoader = $('#position-loader')
	highestZ = 0
	zOffset = 0

	$(document).ready ->
		notes = $('#notes-area .note')
		notes.draggable({ 
			containment: '#notes-area'
			start: -> updateZIndex(this)
			stop: -> saveNotePositions(this)
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

	$(document).on 'click', '.note', (e) -> 
		updateZIndex(e.target)
		saveNotePositions(e.target)

	submitButt.click -> submitNewNote()
	# contentBox.keyup (e) ->
	# 	submitNewNote() if e.which == 13

	submitNewNote = ->
		thisAuthor = removeTags(authorBox.val())
		thisContent = randoms.linkifierize(removeTags(contentBox.val()))

		if thisAuthor.length == 0

		else if thisContent.length == 0

		else
			sendData = { note: { author: thisAuthor, content: thisContent } } 
			submitLoader.show()
			$.ajax
				url: '/notes'
				data: sendData
				type: 'POST'
				dataType: 'json'
				success: (data) ->
					# console.log data
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
		thisAuthor = data.note.author
		thisContent = data.note.content
		noteId = data.note.id

		noteHTML = '<div class="note" data-x="247" data-y="540" data-id="'+noteId+'">
						<div class="delete-bar"><span class="icon-font note-delete">ç</span></div>
						<div class="author">' + thisAuthor + '</div>
						<div class="content">' + thisContent + '</div>
					</div>'

		notesArea.append(noteHTML)
		newNote = $('[data-id='+noteId+']')
		newNote.draggable({ 
			containment: '#notes-area'
			start: -> updateZIndex(this)
			stop: -> saveNotePositions(this)
		})
		updateZIndex(newNote)

		$('.tips').qtip
		    content:
		      attr: 'title'
		    position:
		      my: 'bottom center'
		      at: 'top center'
		    adjust:
		    	y: -5


	showError = (data) ->
		console.log 'there was an error'

	updateZIndex = (args) ->
		elem = args
		elem = $(args).parents('.note') unless $(elem).hasClass 'note'
		$(elem).css({'z-index': highestZ})
		highestZ++
		if highestZ == 600
			zOffset = 100

	# savePosition.click -> saveNotePositions()

	#  TODO: Save only last one
	saveNotePositions = (args, saveAll = null)->
		# positionLoader.show()

		sendData = { notes: collectPositions(args, saveAll) }

		$.ajax
			url: '/notes/update_positions'
			data: sendData
			type: 'POST'
			dataType: 'json'
			success: (data) ->
				# console.log data
			error: (data) ->
				# console.log data
			# complete: ->
			# 	positionLoader.hide()

	collectPositions = (args, saveAll = null) ->
		elem = args
		elem = $(args).parents('.note') unless $(elem).hasClass 'note'
		
		if saveAll
			notes = $('.note')
		else 
			notes = [elem]


		retData = []

		for i in [0..notes.length - 1]
			thisNote = notes[i]
			thisID =  $(notes[i]).data('id')
			thisX = $(notes[i]).position().left
			thisY = $(notes[i]).position().top
			thisZ = $(notes[i]).css('z-index') - zOffset

			retData.push { id: thisID, coords: { x: thisX, y: thisY, z: thisZ }}

		zOffset = 0 if zOffset == 100

		retData


# TODO: auto refresh

	$(document).on 'click', '.note-delete', (e) ->
		$(e.target).parents('.note').addClass('to-delete')

		$.confirm
	      title: "Are You Sure?"
	      message: "You can delete any of the notes, but that takes the joy away from others who won't get to see that note!"
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
	            		setTimeout (-> child.remove()), 1000
	            	error: (e) -> console.log e
	        No:
	          class: "inactive"
	          action: ->
	            







