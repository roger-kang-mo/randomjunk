window.ThoughtsHolder = {}  if typeof ThoughtsHolder is "undefined"

ThoughtsHolder.CommentView = Backbone.View.extend
		model: ThoughtsHolder.Comment
		template: _.template('<li class="comment" data-id="<%= id %>"><div class="delete-comment" title="Delete comment"><img src="/assets/loader.gif" alt="loader" class="loader hidden"><span class="icon-font tips">ç</span></div><div class="author"><h4><%= _.escape(author) %></h4></div>
			<div class="content"><p><%= _.escape(content) %></p></div></li>')

		render: ->
			$(this.el).html(this.template({id: this.model.get('id'), author: this.model.get('author'), content: this.model.get('content')}))
			return this