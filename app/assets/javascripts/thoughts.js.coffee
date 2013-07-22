randoms.thoughts = (args) ->

	guidGen = ->
	  Math.floor((1 + Math.random()) * 0x10000).toString(16).substring 1
	guid = ->
	  guidGen() + '-' + guidGen

	Comment = Backbone.Model.extend
		urlRoot: '/comments'
		defaults: { author: 'anonymous', content: 'clickity clack' }

	CommentsView = Backbone.View.extend
		model: Comment
		template: _.template('<li data-id="<%= id %>"><div class="author"><%= author %></div>
			<div><p><%= content %></p></div></li>')

	CommentsListView = Backbone.View.extend
		el: $('#comments-area')
		render: ->
			self = this
			$el.html('')
			_(@collection.models).each ((comment) ->
			  self.appendItem comment
			), this

			# randoms.initTips()
		initialize: ->
			self = this
			@$container = $el


		events: {
			'click #save-comment' : 'saveNewComment'
		}

		saveNewComment: ->
			newComment = new Comment({author: $('#new-comment-author').val(), content: $('#new-comment-input').val()})


	Thought = Backbone.Model.extend
		urlRoot: '/thoughts'
		defaults: 
			content: ''
			thumbs: 0
			themeNum: 'theme1'

		initialize: (args) ->
			themeNum = 'theme' + Math.floor(Math.random() * (13) + 1)
			this.set('themeNum', themeNum)

	ThoughtsView = Backbone.View.extend
		model: Thought
		
		template: _.template('<div data-id="<%= id %>" class="thought-card <%= themeNum %>" style="height: <%= height %>; width: <%= width %>;">
					<div class="thought-header">
						<span class="expand expand-unspand icon-font">^</span>
						<span class="unspand expand-unspand icon-font hidden">_</span>
					</div>
					<div class="thought-content">
						<span class="preview <%= previewClass %>">
							<%= content.slice(0, 100) + (content.length > 100 ? "... <strong>(more)</strong>" : "") %>
						</span>
						<span class="actual-thought hidden <%= thoughtClass %>"><%= content %></span>
					</div><br>
					<div class="thought-bottom-bar">
						<span class="thumbs icon-font"><%= thumbs > 0 ? "e" : "f" %></span>
						<span class="comments tips" title="Leave a comment">  <span class="icon-font">a</span></span>
					</div>
				</div>')
		initialize: ->
			_.bindAll(this, 'render')

		render: -> 
			width = height = '173px'

			if Math.floor(Math.random() * (10) + 1) == 5
				width = height = '355px'

			thoughtLength = this.model.get('content').length
			previewClass = ''
			actualThoughtClass = ''

			if thoughtLength <= 25
				previewClass = 'mediumly-big-font'
				actualThoughtClass = 'really-big-font'

			else if thoughtLength <= 60
				actualThoughtClass = 'even-bigger-font'
				previewClass = 'slightly-bigger-font'

			else if thoughtLength <= 75
				actualThoughtClass = 'big-font'
				previewClass = 'slightly-bigger-font'

			else if thoughtLength <= 115
				actualThoughtClass = 'mediumly-big-font'

			else if thoughtLength <= 230
				actualThoughtClass = 'even-slightly-bigger-font'


			$(this.el).html(this.template({ id: this.model.get('id'), content: this.model.get('content'), thumbs: this.model.get('thumbs'), themeNum: this.model.get('themeNum'), height: height, width: width, previewClass: previewClass, thoughtClass: actualThoughtClass}))
			return this

	ThoughtsList = Backbone.Collection.extend
		model: Thought
		url: '/thoughts/get_all'

	ThoughtsListView = Backbone.View.extend
		el: $('#thoughts-area')
		render: ->
			self = this
			$(self.el).html('')
			_(@collection.models).each ((thought) -> # in case collection is not empty
			  self.appendItem thought
			), this

			this.initIsotope(self)
			randoms.initTips()

		initialize: ->
			self = this
			$container = $(self.el)
			
			# Save new thought modal
			@$newThoughtInput = $('#new-thought')
			@$newThoughtModal = $('#add-thought-modal')
			@$modalOverlay = $('#modal-overlay')
			@$saveNewThoughtButton = $('#save-thought')
			@$closeThoughtModalButton = $('#close-thought-modal')


			@$expandThought = @$el.find('.expand')
			@$thumbs = @$el.find('.thumbs')
			@$comments = @$el.find('.comments')

			console.log this.collection
			this.render()

			# $('#save-thought').click ->
			@$saveNewThoughtButton.click ->
				newThought = new Thought({'content': $('#new-thought').val()})
				newThought.save()
				self.collection.add(newThought)
				self.closeThoughtSaveModal(self)
				self.render()

			# $('#close-thought-modal').click ->
			@$closeThoughtModalButton.click ->
				self.closeThoughtSaveModal(self)

			$('#sort-by-id').click ->
				$container.isotope
					sortBy: 'id'
				$container.isotope 'reLayout'

			$('#sort-by-length').click ->
				$container.isotope
					sortBy: 'length'
				$container.isotope 'reLayout'

			$('#add-thought-button').click ->
				$('#modal-overlay').fadeIn()
				$('#add-thought-modal').fadeIn()
				
		events: {
			'click .expand-unspand' : 'toggleThoughtSize'
			'click .thought-content strong' : 'toggleThoughtSize'
		}

		toggleThoughtSize: (elem) ->
			cardElem = $(elem.target).parents('.thought-card')
			# cardElem.toggleClass('maximize')
			cardElem.find('.thought-header').children().toggleClass('hidden')
			cardElem.find('.thought-content').children().toggleClass('hidden')

			if cardElem.hasClass('maximize')
				cardElem.removeClass('maximize').css({ 'width': '173px', 'height': '173px'})
				# cardElem.find('.thought-bottom-bar').css({ 'margin-top':'0px' })
			else
				# width = '346px'
				# height = '346px'
				width = height = '355px'

				cardElem.addClass('maximize').css({ 'width': width, 'height': height})
				thoughtLength = cardElem.find('actual-thought').text().length 

			$(this.el).isotope 'reLayout'

		closeThoughtSaveModal: (self) ->
			self.$newThoughtModal.fadeOut()
			self.$newThoughtInput.val('')
			self.$modalOverlay.fadeOut()

		initIsotope: (self) ->
			$(self.el).isotope
				itemSelector : '.thought-card',
	      		layoutMode : 'masonry'
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