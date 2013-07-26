randoms.minesweeper = (args) ->
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
	gameOver = false
	revealFuncs = [[], []]

	window.oncontextmenu = (e) ->
		clickedElem = $(e.target)
		if $('#mineboard').find(clickedElem).length
			clickedElem = clickedElem.parents('.boardspot') if clickedElem.hasClass('spotval') or clickedElem.hasClass('flagspot')
			unless clickedElem.hasClass('revealed') or gameOver
				if clickedElem.hasClass('flagged')
					clickedElem.removeClass('flagged')
				else
					clickedElem.addClass('flagged')
			return false


	$(document).on 'click', '.boardspot', (e) ->
		clickedElem = $(e.target)
		clickedElem = clickedElem.parents('.boardspot') if clickedElem.hasClass('spotval') or clickedElem.hasClass('flagspot')
		unless gameOver or clickedElem.hasClass('revealed') or clickedElem.hasClass('flagged')
			clickedElem.addClass('revealed').css("-webkit-transition","all 0.6s ease")
		    .css("backgroundColor","#999")
		    .css("-moz-transition","all 0.6s ease")
		    .css("-o-transition","all 0.6s ease")
		    .css("-ms-transition","all 0.6s ease")
			numRevealed++
			console.log(clickedElem.data('coords') + ' revealed')

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
			console.log 'numRevealed: ' + numRevealed

	revealConnectedZeros = (coords) ->
		updateSpotNumbers(coords, ['W',1,2,3,4,5,6,7,8,9,10], (foundIn, x, y) ->
			thisSpot = $('[data-coords="' + x + ',' + y + '"]')
			unless thisSpot.hasClass('flagged')
				if foundIn
					if board[x][y] != 'W' and thisSpot
						unless thisSpot.hasClass('revealed')
							thisSpot.addClass('revealed').removeClass('flagged').css("-webkit-transition","all 0.6s ease")
						    .css("backgroundColor","#999")
						    .css("-moz-transition","all 0.6s ease")
						    .css("-o-transition","all 0.6s ease")
						    .css("-ms-transition","all 0.6s ease")
							numRevealed++

				else if thisSpot # is a 0
					unless thisSpot.hasClass('revealed')
							thisSpot.addClass('revealed').removeClass('flagged').css("-webkit-transition","all 0.6s ease")
						    .css("backgroundColor","#999")
						    .css("-moz-transition","all 0.6s ease")
						    .css("-o-transition","all 0.6s ease")
						    .css("-ms-transition","all 0.6s ease")
							numRevealed++

					revealFuncs[0].push revealConnectedZeros
					revealFuncs[1].push [x, y]

				if numRevealed >= nonMineSpots
					winCase()
		)	

	loseCase = ->
		updateStatus('You lose')
		$('.boardspot').addClass('revealed').removeClass('flagged').css("-webkit-transition","all 0.6s ease")
	    .css("backgroundColor","#999")
	    .css("-moz-transition","all 0.6s ease")
	    .css("-o-transition","all 0.6s ease")
	    .css("-ms-transition","all 0.6s ease")

	winCase = ->
		updateStatus('You Win! B)')
		gameOver = true

	$('#num-mines').keyup (e) ->
		$('#generate-board').click() if e.which == 13

	$('#generate-board').click ->
		width = widthBox.val()
		height = heightBox.val()
		numMines = minesBox.val()

		if width > 1 and width < 16 and height < 16 and height > 1 and numMines > 0 and numMines < (width * height)

			boardParams = { width: width, height: height, mines: numMines}

			generateBoard(boardParams)
		else
			updateStatus('TOO MANY MINES') if numMines >= (width * height)
			updateStatus('TOO FEW MINES') if numMines < 1
			updateStatus('Height must be between 2 and 15') if width < 2 or width > 15 
			updateStatus('Width must be between 2 and 15') if height < 2 or height > 15

	generateBoard = (args) ->
		width = args.width
		height = args.height
		numMines = args.mines
		board = new Array(width)
		numRevealed = 0
		gameOver = false

		nonMineSpots = (width * height) - numMines

		for i in [0..width - 1]
			board[i] = new Array(width)
			for j in [0..height - 1]
				board[i][j] = '0'

		# place mines
		for mineCount in [0..numMines - 1]
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

	printBoardToConsole = ->
		printString = ""
		for i in [0..width - 1]
			for j in [0..height - 1]
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

		for i in [0..width - 1]
			rowsToAppend += '<tr>'
			for j in [0..height - 1]
				valHTML = if board[i][j] == 'W' then "<strong class='spotval minespot icon-font'>" else "<strong class='spotval'>"
				valHTML += board[i][j] + "</strong>"
				rowsToAppend += "<td class='boardspot' data-coords=" + i + "," + j + " data-value='" + board[i][j] + "'><span class='flagspot icon-font'>j</span>" + valHTML + "</td>"

			rowsToAppend += '</tr>'

		boardSpace.append(rowsToAppend + "</table>")

	updateStatus = (message) ->
		statusBar.text(message)

