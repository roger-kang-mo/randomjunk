window.BackboneHolder = {}  if typeof BackboneHolder is "undefined"

BackboneHolder.Record = Backbone.Model.extend
	urlRoot: '/minesweeper_records'
