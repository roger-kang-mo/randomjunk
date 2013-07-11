randoms.cardsAgainstSingle = ->

	blackCardText = $('#black-card .card-text')
	whiteCardText = $('#white-card .card-text')
	blackLocked = false
	whiteLocked = false
	retries = 0

	$(document).ready ->
		setTimeout (-> getNewCards()), 5000

	# ê - unlocked
	# è - locked
	$('span.lock-icon').click (e) ->
		clickedElem = $(e.target)

		if clickedElem.text() == 'ê'
			clickedElem.text('è')
		else
			clickedElem.text('ê')

		clickedId = clickedElem.attr('id')
		eval(clickedId + " = !" + clickedId)
		console.log 'black: ' + blackLocked
		console.log 'white: ' + whiteLocked

	getNewCards = ->
		unless retries == 3
			retries = 0
			sendData = { 'black' : !blackLocked, 'white' : !whiteLocked }
			console.log sendData

			$.ajax
				url: '/cards_against/single/get_cards'
				dataType: 'json'
				type: 'GET'
				data: sendData
				success: (data) ->
					loadNewCards(data)
				error: (data) ->
					retries++
					getNewCards()


	loadNewCards = (data) ->
		if data.cards.black and not blackLocked
			blackCardText.fadeOut()
			setTimeout (-> blackCardText.text(data.cards.black).fadeIn()), 500
		if data.cards.white and not whiteLocked
			whiteCardText.fadeOut()
			setTimeout (-> whiteCardText.text(data.cards.white).fadeIn()), 500

		setTimeout getNewCards, 5000

