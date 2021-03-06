randoms.cardsAgainstSingle = ->

	blackCardText = $('#black-card .card-text')
	whiteCardText = $('#white-card .card-text')
	numWhiteCards = randoms.WHITE_CARDS.length
	numBlackCards = randoms.BLACK_CARDS.length
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

	getNewCards = ->
		whiteCard = randoms.WHITE_CARDS[Math.floor(Math.random() * (numWhiteCards - 1 + 1))] unless whiteLocked
		if blackLocked
			blackCard = blackCardText.text()
		else
			blackCard = randoms.BLACK_CARDS[Math.floor(Math.random() * (numBlackCards - 1 + 1))]

		# Each blank consists of 10 underscores.
		if blackCard.match(/_/g)
			
			for i in [1..((blackCard.match(/_/g).length - 10)/10)] by 1
				whiteCard += '<br/><br/>' + randoms.WHITE_CARDS[Math.floor(Math.random() * (numWhiteCards - 1 + 1))] 

		if whiteLocked 
			if whiteCardText.html().match(/<br><br>/g)
				numBlanksToGet = whiteCardText.html().match(/<br><br>/g).length + 1	
			else
				numBlanksToGet = 1

			blackCard = ''
			
			while blackCard == ''
				blackCard = randoms.BLACK_CARDS[Math.floor(Math.random() * (numBlackCards - 1 + 1))]
				if blackCard.match(/_/g)
					blackCard = "" unless (blackCard.match(/_/g).length / 10) == numBlanksToGet
				else
					blackCard = "" unless numBlanksToGet == 1


		cards = { 'white': whiteCard, 'black': blackCard}
		loadNewCards(cards)



	# getNewCardsViaAJAX = ->
		# unless retries == 3
			# retries = 0
			# sendData = { 'black' : !blackLocked, 'white' : !whiteLocked }

			# $.ajax
			# 	url: '/cards_against/single/get_cards'
			# 	dataType: 'json'
			# 	type: 'GET'
			# 	data: sendData
			# 	success: (data) ->
			# 		loadNewCards(data.cards)
			# 	error: (data) ->
			# 		retries++
			# 		getNewCards()


	loadNewCards = (cards) ->
		if cards.black and not blackLocked
			blackCardText.fadeOut()
			setTimeout (-> blackCardText.html(cards.black).fadeIn()), 500
		if cards.white and not whiteLocked
			whiteCardText.fadeOut()
			setTimeout (-> whiteCardText.html(cards.white).fadeIn()), 500

		setTimeout getNewCards, 5000

