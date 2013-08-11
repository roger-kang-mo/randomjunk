randoms.scattergories = (args) ->

	# non-interactive elems
	currentLetter = $('#current-letter strong')
	categoryList = $('#cat-list')
	playerList = $('.player-list')

	# clickables
	incScore = $('.incScoreButton')
	decScore = $('.decScoreButton')
	addPlayer = $('#add-player')
	genList = $('#generate-list')
	genLetter = $('#generate-letter')
	clearScores = $('#clear-scores')

	# etc
	numPlayers = 1
	alphabet = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']


	$(document).ready ->
		genList.click()

	addPlayer.click ->
		numPlayers++
		newPlayerHtml = '<li><input type="text" class="player" placeholder="player name" id="player' + numPlayers + '">'

		newPlayerHtml +='<span class="inc-score-button score-butt tips" title="Increase Score"></span>
					<span class="dec-score-button score-butt tips" title="Decrease Score"></span>
					<input type="number" id="player' + numPlayers + 'score" value=0 min="0" class="score-input">
				</li>'
				
		playerList.append(newPlayerHtml)


	genList.click ->
		rand = Math.floor(Math.random() * (randoms.scattergoriesCategoryLists.length - 1 + 1))
		newList = randoms.scattergoriesCategoryLists[rand]
		newListHtml = '<ol class="category-list">'

		categoryList.html('')

		for category in newList
			newListHtml += '<li class="cat">' + category + '</li>'

		newListHtml += '</ol>'

		categoryList.append(newListHtml)

	genLetter.click ->
		letter = alphabet[Math.floor(Math.random() * (alphabet.length - 0 + 1)) + 0]
		currentLetter.text(letter)

	$(document).on 'click', '.inc-score-button', (e) ->
		scoreInput = $(e.target).parent().find('.score-input')
		scoreInput.val(parseInt(scoreInput.val()) + 1)

	$(document).on 'click', '.dec-score-button', (e) ->
		scoreInput = $(e.target).parent().find('.score-input')
		scoreInput.val(parseInt(scoreInput.val()) - 1)

	clearScores.click ->
		$('.score-input').val(0)



