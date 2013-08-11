window.BackboneHolder = {}  if typeof BackboneHolder is "undefined"

BackboneHolder.RecordsList = Backbone.Collection.extend
	model: BackboneHolder.Record
	url: '/records/query_records'