window.BackboneHolder = {}  if typeof BackboneHolder is "undefined"

BackboneHolder.Record = Backbone.Model.extend
	urlRoot: '/minesweeper_records'
	# defaults:
	# 	time: 0
	# 	name: 'Hooligan'
	# 	width: 12
	# 	height: 12
	# 	mines: 20
	# intialize: (args) ->
