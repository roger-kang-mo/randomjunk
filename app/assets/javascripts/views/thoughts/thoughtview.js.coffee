window.BackboneHolder = {}  if typeof BackboneHolder is "undefined"

BackboneHolder.ThoughtsView = Backbone.View.extend
		model: BackboneHolder.Thought
		
		template: _.template('<div data-id="<%= id %>" class="thought-card <%= themeNum %>">
					<div class="thought-header">
						<span class="expand expand-unspand icon-font tips" title="expand!">^</span>
						<span class="unspand expand-unspand icon-font hidden tips" title="unspand!">_</span>
					</div>
					<div class="thought-content">
						<span class="preview <%= previewClass %>">
							<%= _.escape(content.slice(0, 100)) + (content.length > 100 ? "... <strong>(more)</strong>" : "") %>
						</span>
						<span class="actual-thought hidden <%= thoughtClass %>"><%= _.escape(content) %></span>
					</div><br>
					<div class="thought-bottom-bar">
						<span class="thumbs icon-font tips"  title="<%= thumbs %> like this!"><%= thumbs > 0 ? "e" : "f" %></span>
						<span class="comments-icon tips" title="Leave a comment">  <span class="icon-font">a</span></span>
					</div>
				</div>')
		initialize: ->
			_.bindAll(this, 'render')
			this.model.bind('updateThumbs', this.updateThumbs, this);
			# this.model.bind('updateComments', this.updateComments, this);

			# updateComments: ->
			# 	console.log 'hi'

		updateThumbs: ->
			thumbsCount = this.model.get('thumbs')
			newHTML = _.template('<span class="thumbs icon-font tips"  title="<%= thumbs %> like this!"><%= thumbs > 0 ? "e" : "f" %></span>', {thumbs: thumbsCount})
			$(this.el).find('.thumbs').replaceWith(newHTML)
			randoms.initTips()

		render: -> 
			thoughtLength = this.model.get('content').length
			previewClass = ''
			actualThoughtClass = ''

			if thoughtLength <= 25
				previewClass = 'mediumly-big-font'
				actualThoughtClass = 'really-big-font'

			else if thoughtLength <= 60
				actualThoughtClass = 'even-bigger-font'
				previewClass = 'slightly-bigger-font'

			else if thoughtLength <= 85
				actualThoughtClass = 'big-font'
				previewClass = 'slightly-bigger-font'

			else if thoughtLength <= 115
				actualThoughtClass = 'mediumly-big-font'

			else if thoughtLength <= 230
				actualThoughtClass = 'even-slightly-bigger-font'


			# $(this.el).html(this.template({ id: this.model.get('id'), content: this.model.get('content'), thumbs: this.model.get('thumbs'), themeNum: this.model.get('themeNum'), height: height, width: width, previewClass: previewClass, thoughtClass: actualThoughtClass}))
			$(this.el).html(this.template({ id: this.model.get('id'), content: this.model.get('content'), thumbs: this.model.get('thumbs'), themeNum: this.model.get('themeNum'), previewClass: previewClass, thoughtClass: actualThoughtClass}))
			
			if Math.floor(Math.random() * (10) + 1) == 5
				$(this.el).find('.thought-card').addClass('maximize')
				$(this.el).find('.thought-content').children().toggleClass('hidden')
				$(this.el).find('.thought-header').children().toggleClass('hidden')
			return this