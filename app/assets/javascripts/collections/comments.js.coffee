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