window.BackboneHolder = {}  if typeof BackboneHolder is "undefined"

BackboneHolder.CommentsList = Backbone.Collection.extend
		model: BackboneHolder.Comment
		url: '/thoughts/comments/get_comments_for/'
		initialize: (models, opts) ->
			self = this
			self.thoughtID = opts.thoughtID
			self.url += self.thoughtID

		fetch: (callback) ->
			self = this
			
			$.ajax
				type: "GET"
				url: self.url
				dataType: "json"
				success: (data) ->
					# console.log data
					self.reset data.comments
					callback()

				error: (data) ->
					# console.log data

		destroyAll: ->
			promises = []
			promises.push @models[0].destroy() while @models.length > 0
			# handle errors communicating with the server
			$.when(promises).fail (response) ->
				@trigger "syncError", response
		  	.bind(this)