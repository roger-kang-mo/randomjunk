randoms.thoughts = (args) ->


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
		
		template: _.template('<div data-id="<%= id %>" class="thought-card <%= themeNum %>">
					<div class="thought-header">
						<span class="expand expand-unspand icon-font">^</span>
						<span class="unspand expand-unspand icon-font hidden">_</span>
					</div>
					<div class="thought-content">
						<span class="preview">
							<%= content.slice(0, 100) + (content.length > 100 ? "... <strong>(more)</strong>" : "") %>
						</span>
						<span class="actual-thought hidden"><%= content %></span>
					</div>
					<div class="thought-bottom-bar">
						<span class="thumbs icon-font"><%= thumbs > 0 ? "e" : "f" %></span>
						<span class="comments tips" title="Leave a comment">  <span class="icon-font">a</span></span>
					</div>
				</div>')
		initialize: ->
			_.bindAll(this, 'render')

		render: -> 
			$(this.el).html(this.template({ id: this.model.get('id'), content: this.model.get('content'), thumbs: this.model.get('thumbs'), themeNum: this.model.get('themeNum')}))
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

			$('#save-thought').click ->
				newThought = new Thought({'content': $('#new-thought').val()})
				newThought.save()
				self.collection.add(newThought)
				self.closeThoughtSaveModal(self)
				self.render()

			$('#close-thought-modal').click ->
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
		}

		toggleThoughtSize: (elem) ->
			cardElem = $(elem.target).parents('.thought-card')
			cardElem.toggleClass('maximize')
			cardElem.find('.thought-header').children().toggleClass('hidden')
			cardElem.find('.thought-content').children().toggleClass('hidden')

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