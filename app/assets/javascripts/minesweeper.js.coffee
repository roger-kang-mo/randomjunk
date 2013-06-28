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


	$(document).on 'click', '.boardspot', (e) ->
		unless gameOver
			clickedElem = $(e.target)
			clickedElem.addClass('revealed')
			numRevealed++		

			if clickedElem.data('value') == 'x'
				loseCase()
			else if	numRevealed >= nonMineSpots
				winCase()
			else
				revealConnectedZeros(clickedElem.data('coords').split(','))
				seqParams = {}
				seqParams.functions = revealFuncs[0]
				seqParams.params = revealFuncs[1]
				$.sequentialize(seqParams)

	revealConnectedZeros = (coords) ->
		updateSpotNumbers(coords, ['x',1,2,3,4,5,6,7,8,9,10], (foundIn, x, y) ->
			thisSpot = $('[data-coords="' + x + ',' + y + '"]')
			if foundIn
				if board[coords[0]][coords[1]] == 0 and board[x][y] != 'x'
					unless thisSpot.hasClass('revealed')
						thisSpot.addClass('revealed')
						numRevealed++
			else
				# $('[data-coords="' + x + ',' + y + '"]').addClass('revealed')
				unless thisSpot.hasClass('revealed')
						thisSpot.addClass('revealed')
						numRevealed++
				revealFuncs[0].push revealConnectedZeros
				revealFuncs[1].push [x, y]
		)	

	loseCase = ->
		updateStatus('You lose')
		$('.boardspot').addClass('revealed')

	winCase = ->
		updateStatus('You Win! B)')
		gameOver = true

	$('#generate-board').click ->
		width = widthBox.val()
		height = heightBox.val()
		numMines = minesBox.val()

		if width > 1 and width < 16 and height < 16 and height > 1 and numMines > 0 and numMines < (width * height)

			boardParams = { width: width, height: height, mines: numMines}

			generateBoard(boardParams)
		else
			updateStatus('TOO MANY MINES') if numMines > (width * height)
			updateStatus('TOO FEW MINES') if numMines < 1
			updateStatus('Height has to be between 2 and 15') if height < 2 or height > 15
			updateStatus('Width has to be between 2 and 15') if width < 2 or width > 15

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
				unless board[coords[0]][coords[1]] == 'x'
					board[coords[0]][coords[1]] = 'x'
					spotFound = true
					updateSpotNumbers(coords, ['x'], (foundIn, x, y) ->
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
				
		if theY < height + 1
			if board[theX][theY+1] in values then aFunction(true, theX, theY+1) else aFunction(false, theX, theY+1)
			

	renderBoard = ->
		table = "<table>"
		rowsToAppend = "<table id='mineboard'>"
		boardSpace = $('#board_space').html('')

		for i in [0..width - 1]
			rowsToAppend += '<tr>'
			for j in [0..height - 1]
				rowsToAppend += "<td class='boardspot' data-coords=" + i + "," + j + " data-value='" + board[i][j] + "'><strong class='spotval'>" + board[i][j] + "</strong></td>"

			rowsToAppend += '</tr>'

		boardSpace.append(rowsToAppend + "</table>")

	updateStatus = (message) ->
		statusBar.text(message)

