randoms.thoughts = (args) ->

	guidGen = ->
	  Math.floor((1 + Math.random()) * 0x10000).toString(16).substring 1
	guid = ->
	  guidGen() + '-' + guidGen

	Comment = Backbone.Model.extend
		urlRoot: '/comments'
		# defaults: { author: 'anonymous', content: 'clickity clack' }

	CommentView = Backbone.View.extend
		model: Comment
		template: _.template('<li class="comment" data-id="<%= id %>"><div class="delete-comment" title="Delete comment"><img src="/assets/loader.gif" alt="loader" class="loader hidden"><span class="icon-font tips">ç</span></div><div class="author"><h4><%= _.escape(author) %></h4></div>
			<div class="content"><p><%= _.escape(content) %></p></div></li>')

		render: ->
			$(this.el).html(this.template({id: this.model.get('id'), author: this.model.get('author'), content: this.model.get('content')}))
			return this

	CommentsList = Backbone.Collection.extend
		model: Comment
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

	CommentsListView = Backbone.View.extend
		el: $('#comments-list')
		tagName: 'ul'
		render: ->
			self = this
			self.$el.html('')
			if @collection.models.length > 0
				_(@collection.models).each ((comment) ->
				  self.appendItem comment
				), this
			else
				$(@el).append "<li><p>No Comments to show. Add one!</p></li>"

			randoms.initTips()

		initialize: (opts) ->
			self = this
			@$container = $(self.el)
			self.id = opts.id
			self.collection.on("sync", this.render, this);
			self.collection.on("reset", this.render, this);

			@$saveNewCommentButton = $('#submit-comment')
			@$newCommentInput = $('#new-comment-author')
			@$newCommentAuthorInput = $('#new-comment-input')

			@$commentErrorText = $('#comment-error')

			@$saveNewCommentButton.click -> self.saveNewComment(self)

			$(document).on 'click', '.delete-comment', (e) -> self.deleteComment(e, self)


		saveNewComment: (self) ->
			@$commentErrorText.text('').fadeOut()
			authorVal = @$newCommentInput.val()
			contentVal = @$newCommentAuthorInput.val()
			if authorVal.length > 0 and contentVal.length > 0
				newComment = new Comment({author: authorVal, content: contentVal, thought_id: self.id})
				newComment.save()
				
				self.collection.add(newComment)

				@$newCommentAuthorInput.val('')
				@$newCommentInput.val('')
			# else
			# 	@$commentErrorText.text('Both fields are required.').fadeIn()


		deleteComment: (e) ->
			clickedElem = $(e.target)
			commentToDelete = clickedElem.parents('.comment').addClass('awaiting-delete')
			clickedElem.parent().children().toggleClass('hidden')
			commentID = commentToDelete.data('id')

			if commentID and this.collection.get(commentID)
				this.collection.get(commentID).destroy()

				this.render()



		appendItem: (comment) ->
		  commentView = new CommentView(model: comment)
		  $(@el).append commentView.render().el


	Thought = Backbone.Model.extend
		urlRoot: '/thoughts'
		defaults: 
			content: ''
			thumbs: 0
			themeNum: 'theme1'
			approved: false

		initialize: (args) ->
			themeNum = 'theme' + Math.floor(Math.random() * (13) + 1)
			this.set('themeNum', themeNum)

	ThoughtsView = Backbone.View.extend
		model: Thought
		
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

	ThoughtsList = Backbone.Collection.extend
		model: Thought
		url: '/thoughts/get_all'

	ThoughtsListView = Backbone.View.extend
		el: $('#thoughts-area')
		render: ->
			self = this
			$(self.el).html('')
			_(@collection.models).each ((thought) ->
			  self.appendItem thought
			), this

			this.initIsotope(self)
			$(self.el).isotope 'shuffle'
			randoms.initTips()

		initialize: ->
			self = this
			$container = $(self.el)
			
			this.render()

			# Save new thought modal
			@$newThoughtInput = $('#new-thought')
			@$newThoughtModal = $('#add-thought-modal')
			@$modalOverlay = $('#modal-overlay')
			@$saveNewThoughtButton = $('#save-thought')
			@$closeThoughtModalButton = $('#close-thought-modal')
			@$shuffleButton = $('#shuffle')

			@$expandThought = @$el.find('.expand')
			@$thumbs = @$el.find('.thumbs')
			@$commentsIcons = @$el.find('.comments-icon')
			@$thoughtBottomBars = @$el.find('.thought-bottom-bar')
			@$commentModal = $('#comment-modal')
			@$commentAuthorInput = $('#new-comment-author')
			@$commentInput = $('#new-comment-input')
			@$closeCommentModalButton = $('#close-comment-modal')
			@$commentErrorText = $('#comment-error')

			# @$commentListViews = []
			self.$commentsListView = null

			@$saveNewThoughtButton.click ->
				newThought = new Thought({'content': $('#new-thought').val()})
				newThought.save()
				# self.collection.add(newThought)
				self.closeThoughtSaveModal(self)
				$.confirm
			      title: "Submitted"
			      message: "Your thought has been submitted for approval"
			      buttons:
			        Okay: 
			        	action: ->
			        		# console.log 'hi'

			@$closeThoughtModalButton.click ->
				self.closeThoughtSaveModal(self)

			@$closeCommentModalButton.click ->
				self.closeCommentModal(self)

			@$shuffleButton.click -> self.shuffleElements(self)


			@$commentsIcons.click (e) ->
				clickedElem = $(e.target)
				thoughtID = clickedElem.parents('.thought-card').data('id')
				
				self.$commentsListView.unbind() if self.$commentsListView
 
				# _(self.$commentsListViews).each ((cListView) ->
				# 	if cListView.id == thoughtID
				# 		commentsListView = cListView
				# ), this

				# unless commentsListView
				commentsList = new CommentsList(null, {thoughtID: thoughtID})
				self.$commentsListView = new CommentsListView({ id: thoughtID, collection: commentsList})
				# self.$commentListViews.push commentsListView


				self.$commentsListView.collection.fetch(-> 
					$('#comment-modal').show()
					$('#modal-overlay').fadeIn()
				)

				# commentsListView.render()

			@$thoughtBottomBars.on 'click', '.thumbs', (e) ->
				clickedElem = $(e.target)
				thoughtCard = clickedElem.parents('.thought-card')
				thoughtID = thoughtCard.data('id')
				incVal = 1
				if thoughtCard.hasClass('liked') #unliking
					thoughtCard.removeClass('liked')
					incVal = -1
				else
					thoughtCard.addClass('liked')

				model = self.collection.get(thoughtID)

				model.set({thumbs: (model.get('thumbs') + incVal)})
				model.save()
				model.trigger('updateThumbs')

			$('#sort-by-id').click ->
				$container.isotope
					sortBy: 'id'
				$container.isotope 'reLayout'

			# $('#sort-by-length').click ->
			# 	$container.isotope
			# 		sortBy: 'length'
			# 	$container.isotope 'reLayout'

			$('#add-thought-button').click ->
				$('#modal-overlay').fadeIn()
				$('#add-thought-modal').fadeIn()
				
		events: {
			'click .expand-unspand' : 'toggleThoughtSize'
			'click .thought-content strong' : 'toggleThoughtSize'
		}

		toggleThoughtSize: (elem) ->
			cardElem = $(elem.target).parents('.thought-card')

			cardElem.find('.thought-header').children().toggleClass('hidden')
			cardElem.find('.thought-content').children().toggleClass('hidden')

			cardElem.toggleClass('maximize')

			$(this.el).isotope 'reLayout'

		closeThoughtSaveModal: (self) ->
			self.$newThoughtModal.fadeOut()
			self.$newThoughtInput.val('')
			self.$modalOverlay.fadeOut()

		closeCommentModal: (self) ->
			self.$commentErrorText.text('').fadeOut()
			self.$commentModal.fadeOut()
			self.$commentAuthorInput.val('')
			self.$commentInput.val('')
			self.$modalOverlay.fadeOut()

		shuffleElements: (self) ->
			$(self.el).isotope 'shuffle'

		initIsotope: (self) ->
			$(self.el).isotope
				itemSelector : '.thought-card',
	      		layoutMode : 'masonry',
				resizable: true,
	      		getSortData: 
	      			id: ($elem) ->
	      				parseInt $elem.data('id')
	      			length: ($elem) ->
	      				parseInt $elem.find('.actual-thought').text().length

		appendItem: (thought) ->
		  thoughtView = new ThoughtsView(model: thought)
		  $(@el).append thoughtView.render().el


	createModelsFromArgs = (thoughts) ->
		for i in [0..thoughts.length - 1] by 1
			thoughtsList.add(new Thought(thoughts[i]))


	thoughtsList = new ThoughtsList()

	createModelsFromArgs(args.thoughts)

	thoughtsListView = new ThoughtsListView({ collection: thoughtsList })