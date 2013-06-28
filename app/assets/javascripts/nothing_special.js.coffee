window.randoms = {
	
}

$(document).ready ->
	$('.tips').qtip
	    content:
	      attr: 'title'
	    position:
	      my: 'bottom center'
	      at: 'top center'
	    adjust:
	    	y: -5

	$('.outbound').click ->
		$('#page-load-overlay').fadeIn(100)
		$('.page-loader').show()
		console.log 'hi'

