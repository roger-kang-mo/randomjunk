window.ThoughtsHolder = {}  if typeof ThoughtsHolder is "undefined"

ThoughtsHolder.ThoughtsList = Backbone.Collection.extend
		model: ThoughtsHolder.Thought
		url: '/thoughts/get_all'