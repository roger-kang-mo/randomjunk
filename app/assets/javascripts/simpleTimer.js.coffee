randoms.simpleTimer = (args) ->
	timerParent = $('div#timer')
	timeDisplay = timerParent.find('strong')
	timeLimit = 60 * args.timeLimit 
	timeLeft = timeLimit
	timerDiv = $('div#timer')
	
	elemsToHide = $('.hide-when-timer')
	elemsToShow = $('.show-when-timer')

	$('.timer-begin').click -> 
		timeLeft = timeLimit if timeLeft == 0
		elemsToHide.css({ visibility: 'hidden' })
		timerParent.removeClass('times-up')
		elemsToShow.fadeIn()
		timeDisplay.text(getTimeString())
		setTimeout(tick, 1000);

	tick = ->
		if timeLeft == 0
			timerParent.addClass('times-up')
			timeDisplay.text("TIME'S UP")
			setTimeout(hideTimerStuff, 5000)
		else
			timeLeft--

			timeDisplay.text(getTimeString())

			setTimeout(tick, 1000);

	getTimeString = ->
		timeString = ''

		mins = parseInt(timeLeft / 60)
		secs = timeLeft % 60

		timeString += mins + ':'
		timeString += if secs < 10 then ('0' + secs) else secs

		return timeString


	hideTimerStuff = ->
		elemsToShow.fadeOut()
		elemsToHide.css({ visibility: 'visible'})