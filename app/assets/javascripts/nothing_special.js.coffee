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