window.randoms = {
	
}

window.onload = ->
	$('#main-page-loader').fadeOut('slow')
	$('#page-load-overlay').fadeOut('slow')

$.fn.preload = ->
  @each ->
    $("<img/>")[0].src = this	

$(document).ready ->
	$('.tips').qtip
	    content:
	      attr: 'title'
	    position:
	      my: 'bottom center'
	      at: 'top center'
	    adjust:
	    	y: -5

	$('.outbound').click (e) ->
		unless e.ctrlKey or e.metaKey
			$('#page-load-overlay').fadeIn(100)
			$('.page-loader').show()

