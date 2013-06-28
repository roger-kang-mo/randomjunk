randoms.whatis = ->
	carouselLeft = $(".carousel-button.left")
	carouselRight = $(".carousel-button.right")
	zoidbergHolder =  $('.roundabout-holder')

	$(document).ready ->
		$('.roundabout-holder').roundabout()

	carouselLeft.click ->
		zoidbergHolder.roundabout("animateToPreviousChild")
		animateColor $(".carousel-button.left")

	carouselRight.click ->
		zoidbergHolder.roundabout("animateToNextChild")
		animateColor $(".carousel-button.right")

		
	animateColor = (obj) ->
		obj.animate color: '#ffffff', 200
		obj.animate color: "#000000", 200

	$(document).keyup (e) ->
		whichKey = e.which

		if whichKey == 37 #left
			zoidbergHolder.roundabout("animateToPreviousChild")
			animateColor $(".carousel-button.left")

		else if whichKey == 39 #right
			zoidbergHolder.roundabout("animateToNextChild")
			animateColor $(".carousel-button.right")