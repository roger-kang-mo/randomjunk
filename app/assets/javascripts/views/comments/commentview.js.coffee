window.BackboneHolder = {}  if typeof BackboneHolder is "undefined"

BackboneHolder.CommentView = Backbone.View.extend
		model: BackboneHolder.Comment
		template: _.template('<li class="comment" data-id="<%= id %>"><div class="delete-comment" title="Delete comment"><img src="/assets/loader.gif" alt="loader" class="loader hidden"><span class="icon-font tips">ç</span></div><div class="author"><h4><%= _.escape(author) %></h4></div>
			<div class="content"><p><%= _.escape(content) %></p></div></li>')

		render: ->
			this.el = this.template(this.model.toJSON())
			return this