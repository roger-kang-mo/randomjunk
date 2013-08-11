window.BackboneHolder = {}  if typeof BackboneHolder is "undefined"

BackboneHolder.ThoughtsList = Backbone.Collection.extend
		model: BackboneHolder.Thought
		url: '/thoughts/get_all'