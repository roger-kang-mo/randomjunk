window.BackboneHolder = {}  if typeof BackboneHolder is "undefined"

BackboneHolder.RecordsList = Backbone.Collection.extend
	model: BackboneHolder.Record
	url: '/records/query_records'
	comparator: (property) ->
        selectedStrategy.apply(BackboneHolder.Record.get(property))

	initialize: ->
		@sort_key = 'id'

	comparator: (a,b) ->
		aKey = a.get(@sort_key)
		bKey = b.get(@sort_key)

		if @sort_key == 'time'
			aParts = aKey.split(':')
			bParts = bKey.split(':')

			aKey = (parseInt(aParts[0]) * 3600) + (parseInt(aParts[1]) * 60) + parseInt(aParts[2]) + (parseFloat(aParts[3]/1000))
			bKey = (parseInt(bParts[0]) * 3600) + (parseInt(bParts[1]) * 60) + parseInt(bParts[2]) + (parseFloat(bParts[3]/1000))
		else if @sort_key == 'dimensions'
			aKey = a.get('width') * a.get('height')
			bKey = b.get('width') * b.get('height')
			 
		(if aKey > bKey then 1 else (if aKey < bKey then -1 else 0))
