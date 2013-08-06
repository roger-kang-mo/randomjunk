window.ThoughtsHolder = {}  if typeof ThoughtsHolder is "undefined"

ThoughtsHolder.Comment = Backbone.Model.extend
		urlRoot: '/comments'
		# defaults: { author: 'anonymous', content: 'clickity clack' }