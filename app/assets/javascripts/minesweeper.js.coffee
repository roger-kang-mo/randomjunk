randoms.minesweeper = (args) ->
	closeModalButtons = $('.md-button')
	modalOverlay = $('#modal-overlay')
	modalWindow = $('.md-modal')
	blurContainer = $('.md-container')
	recordStats = $('#record-stats')
	recordName = $('#record-name')
	closeModalNoAction = $('#no-action')
	showRecordsButton = $('#show-records')
	saveRecordButton = $('#save-record')
	timerNode = $('#timer')


	widthBox = $('#board-width')
	heightBox = $('#board-height')
	minesBox = $('#num-mines')
	statusBar = $('.status-header')
	width = 0
	height = 0
	board = undefined
	numRevealed = 0
	numMines = 0
	nonMineSpots = 0
	gameOver = true
	revealFuncs = [[], []]
	timeElapsed = 0

	cachedBoardVals = {}

	recordsList = new BackboneHolder.RecordsList()
	recordsListView = null

	$(document).ready ->
		records = args.records

		for record in records
			recordsList.add(new BackboneHolder.Record(record))

		recordsListView = new BackboneHolder.RecordsListView({ collection: recordsList })


	window.oncontextmenu = (e) ->
		clickedElem = $(e.target)
		if $('#mineboard').find(clickedElem).length
			e.stopPropagation()
			clickedElem = clickedElem.parents('.boardspot') if clickedElem.hasClass('spotval') or clickedElem.hasClass('flagspot')
			unless clickedElem.hasClass('revealed') or gameOver
				if clickedElem.hasClass('flagged')
					clickedElem.removeClass('flagged')
				else
					clickedElem.addClass('flagged')
			return false

	$(document).on 'keyup', 'body', (e)->
		if e.which == 82 and (modalWindow.css('visibility') == 'hidden' and not (e.ctrlKey or e.metaKey))
			if Object.keys(cachedBoardVals).length > 0
				if gameOver
					timerNode.addClass('reset')
					generateBoard(cachedBoardVals)
				else
					showModal('quit')
		else if e.which == 27 and modalWindow.css('visibility') == 'visible'
			closeModal(closeModalNoAction)

	showRecordsButton.click -> 
		$.when(recordsList.fetch()).then -> showModal('scores')
		

	$(document).ready ->
		recordName.keyup = (e) ->  closeModal(saveRecordButton) if e.which == 13

	closeModalButtons.click (e) -> closeModal(e)

	showModal = (type)->
		$('.md-content .content-show').removeClass('content-show')

		switch type
			when 'quit'
				timerNode.removeClass('started')
				$('#content-quit').addClass('content-show')
			when 'scores'
				recordsListView.render()
				$('#content-records').addClass('content-show')
			else
				$('#content-win').addClass('content-show')
				recordStats.text("You safely uncovered #{numMines} mines on a #{height}x#{width} board with a time of #{getTimeFromTimer()}.")
			
		modalOverlay.addClass('show')
		blurContainer.addClass('blurred')
		modalWindow.addClass('md-show')


	closeModal = (elem) ->
		clickedElem = $(elem.target)
		clickedElem = clickedElem.parents('.md-button') unless clickedElem.hasClass('md-button')
		
		modalWindow.removeClass('md-show')
		modalOverlay.removeClass('show')
		blurContainer.removeClass('blurred')

		switch clickedElem.attr('id')
			
			when 'restart' then generateBoard(cachedBoardVals) 
			when 'beast-mode' then initiateBeastMode()
			when 'save-record' then saveRecord()

		timerNode.addClass('started') unless gameOver
		recordName.val('')

	modalOverlay.click ->
		closeModal(closeModalNoAction)

	initiateBeastMode = ->

		width = parseInt(cachedBoardVals.width)
		height = parseInt(cachedBoardVals.height)
		mines = parseInt(cachedBoardVals.mines)

		remainingSpots = (width * height) - mines

		mines += Math.floor(Math.random() * ((remainingSpots - 5)/2))

		minesBox.val(mines)
		boardParams = { width: width, height: height, mines: mines}
		cachedBoardVals = boardParams

		generateBoard(boardParams)

	saveRecord = ->
		newRecordData = { time: timeElapsed, name: recordName.val(), width: width, height: height, mines: numMines, time: getTimeFromTimer() }
		newRecord = new BackboneHolder.Record(newRecordData)
		newRecord.save()
		# recordsList.add(newRecord)
		# console.log recordsList

	$(document).on 'click', '.boardspot', (e) ->
		clickedElem = $(e.target)
		clickedElem = clickedElem.parents('.boardspot') if clickedElem.hasClass('spotval') or clickedElem.hasClass('flagspot')
		unless gameOver or clickedElem.hasClass('revealed') or clickedElem.hasClass('flagged')
			clickedElem.addClass('revealed').css
			  "-webkit-transition": "all 0.6s ease"
			  backgroundColor: "#999"
			  "-moz-transition": "all 0.6s ease"
			  "-o-transition": "all 0.6s ease"
			  "-ms-transition": "all 0.6s ease"
			numRevealed++

			if clickedElem.data('value') == 'W'
				loseCase()
			else if	numRevealed >= nonMineSpots
				winCase()
			else
				revealFuncs = [[], []]
				revealConnectedZeros(clickedElem.data('coords').split(','))
				seqParams = {}

				seqParams.functions = revealFuncs[0]
				seqParams.params = revealFuncs[1]
				revealFuncs = [[], []]
				$.sequentialize(seqParams)

	revealConnectedZeros = (coords) ->
		updateSpotNumbers(coords, ['W',1,2,3,4,5,6,7,8,9,10], (foundIn, x, y) ->
			thisSpot = $('[data-coords="' + x + ',' + y + '"]')
			unless thisSpot.hasClass('flagged')
				if foundIn
					if board[x][y] != 'W' and thisSpot
						unless thisSpot.hasClass('revealed')
							thisSpot.addClass('revealed').removeClass('flagged').css
							  "-webkit-transition": "all 0.6s ease"
							  backgroundColor: "#999"
							  "-moz-transition": "all 0.6s ease"
							  "-o-transition": "all 0.6s ease"
							  "-ms-transition": "all 0.6s ease"
							numRevealed++

				else if thisSpot # is a 0
					unless thisSpot.hasClass('revealed')
							thisSpot.addClass('revealed').removeClass('flagged').css
							  "-webkit-transition": "all 0.6s ease"
							  backgroundColor: "#999"
							  "-moz-transition": "all 0.6s ease"
							  "-o-transition": "all 0.6s ease"
							  "-ms-transition": "all 0.6s ease"
							numRevealed++

					revealFuncs[0].push revealConnectedZeros
					revealFuncs[1].push [x, y]

				if numRevealed >= nonMineSpots
					winCase()
		)	

	loseCase = ->
		updateStatus('You lose')
		gameOver = true
		$('.boardspot').addClass('revealed').removeClass('flagged').css
			  "-webkit-transition": "all 0.6s ease"
			  backgroundColor: "#999"
			  "-moz-transition": "all 0.6s ease"
			  "-o-transition": "all 0.6s ease"
			  "-ms-transition": "all 0.6s ease"
		timerNode.removeClass('started')

	winCase = ->
		updateStatus('You Win! B)')
		gameOver = true
		showModal('win')
		timerNode.removeClass('started')

	getTimeFromTimer = ->
		timeParts = timerNode.find('.numbers')
		timeString = ''

		for part in timeParts
			if $(part).hasClass('divide')
				timeString += ':'
			else
				timeString += Math.abs(parseInt($(part).css('top'))/40)

		# console.log timeString
		timeString

	$('#num-mines').keyup (e) ->
		if e.which == 13
			timerNode.addClass('reset')
			$('#generate-board').click()

	$('#generate-board').click ->

		timerNode.addClass('reset')
		if cachedBoardVals and not gameOver
			modalWindow.addClass('md-show')
			modalOverlay.addClass('show')
			blurContainer.addClass('blurred')
		else
			width = widthBox.val()
			height = heightBox.val()
			numMines = minesBox.val()

			if width > 1 and width < 21 and height < 21 and height > 1 and numMines > 0 and numMines < (width * height)

				boardParams = { width: width, height: height, mines: numMines}
				cachedBoardVals = boardParams
				generateBoard(boardParams)
			else
				updateStatus('TOO MANY MINES') if numMines >= (width * height)
				updateStatus('TOO FEW MINES') if numMines < 1
				updateStatus('Height must be between 2 and 20') if width < 2 or width > 21
				updateStatus('Width must be between 2 and 20') if height < 2 or height > 21

	generateBoard = (args) ->
		width = args.width
		height = args.height
		numMines = args.mines
		board = new Array(width)
		numRevealed = 0
		gameOver = false

		nonMineSpots = (width * height) - numMines

		for i in [0...width]
			board[i] = new Array(width)
			for j in [0...height]
				board[i][j] = '0'

		# place mines
		for mineCount in [0...numMines]
			spotFound = false
			while not spotFound
				coords = gimmeRandomCoords()
				unless board[coords[0]][coords[1]] == 'W'
					board[coords[0]][coords[1]] = 'W'
					spotFound = true
					updateSpotNumbers(coords, ['W'], (foundIn, x, y) ->
						unless foundIn
							board[x][y]++
					)

		# printBoardToConsole()
		renderBoard()
		updateStatus('Good luck!')
		timerNode.removeClass('reset').addClass('started')

	printBoardToConsole = ->
		printString = ""
		for i in [0...width]
			for j in [0...height]
				printString += board[i][j] 
				printString += " "
			console.log printString
			printString = ""

	gimmeRandomCoords = ->
		width = width
		height = height
		return [Math.floor(Math.random() * width), Math.floor(Math.random() * height)]

	updateSpotNumbers = (coords, values, aFunction) ->
		width = widthBox.val()
		height = heightBox.val()
		theX = parseInt coords[0]
		theY = parseInt coords[1]

		if theX > 0
			if board[theX-1][theY] in values then aFunction(true, theX-1, theY) else aFunction(false, theX-1, theY)

			if theY > 0
				if board[theX-1][theY-1] in values then aFunction(true, theX-1, theY-1) else aFunction(false, theX-1, theY-1)
					
			if theY < height - 1
				if board[theX-1][theY+1] in values then aFunction(true, theX-1, theY+1) else aFunction(false, theX-1, theY+1)
					
		if theX < width - 1
			if board[theX+1][theY] in values then aFunction(true, theX+1, theY) else aFunction(false, theX+1, theY)
				
			if theY > 0
				if board[theX+1][theY-1] in values then aFunction(true, theX+1, theY-1) else aFunction(false, theX+1, theY-1)
					
			if theY < height - 1
				if board[theX+1][theY+1] in values then aFunction(true, theX+1, theY+1) else aFunction(false, theX+1, theY+1)
					

		if theY > 0
			if board[theX][theY-1] in values then aFunction(true, theX, theY-1) else aFunction(false, theX, theY-1)
				
		if theY < height - 1#+ 1
			if board[theX][theY+1] in values then aFunction(true, theX, theY+1) else aFunction(false, theX, theY+1)
			

	renderBoard = ->
		table = "<table>"
		rowsToAppend = "<table id='mineboard'>"
		boardSpace = $('#board_space').html('')

		for i in [0...width]
			rowsToAppend += '<tr>'
			for j in [0...height]
				valHTML = if board[i][j] == 'W' then "<strong class='spotval minespot icon-font'>" else "<strong class='spotval'>"
				valHTML += board[i][j] + "</strong>"
				rowsToAppend += "<td class='boardspot' data-coords=" + i + "," + j + " data-value='" + board[i][j] + "'><span class='flagspot icon-font'>j</span>" + valHTML + "</td>"

			rowsToAppend += '</tr>'

		boardSpace.append(rowsToAppend + "</table>")

	updateStatus = (message) ->
		statusBar.text(message)


