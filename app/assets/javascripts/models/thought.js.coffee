window.BackboneHolder = {}  if typeof BackboneHolder is "undefined"

BackboneHolder.Thought = Backbone.Model.extend
		urlRoot: '/thoughts'
		defaults: 
			content: ''
			thumbs: 0
			themeNum: 'theme1'
			approved: false

		initialize: (args) ->
			themeNum = 'theme' + Math.floor(Math.random() * (13) + 1)
			this.set('themeNum', themeNum)

