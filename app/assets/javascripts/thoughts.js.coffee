randoms.thoughts = (args) ->


	Thought = Backbone.Model.extend
		urlRoot: '/thoughts'
		defaults: 
			content: ''
			thumbs: 0


		initialize: (args) ->

	ThoughtsView = Backbone.View.extend
		model: Thought
		tagName: 'div'
		template: _.template('<div class="thought-card" data-id="<%= id %>">
					<div class="thought-header">
						<span class="expand icon-font">^</span>
					</div>
					<div class="thought-content">
						<span class="preview">
							<%= content.slice(0, 100) + "... <strong>(more)</strong>" %>
						</span>
					<span class="actual-thought"><%= content %></span>
					</div>
					<div class="thought-bottom-bar">
						<span class="thumbs icon-font"><%= thumbs > 0 ? "e" : "f" %></span>
						<span class="comments tips" title="Leave a comment">  <span class="icon-font">a</span></span>
					</div>
				</div>')
		initialize: ->
			_.bindAll(this, 'render')

		render: -> 
			$(this.el).html(this.template({ id: this.model.get('id'), content: this.model.get('content'), thumbs: this.model.get('thumbs')}))
			return this

	ThoughtsList = Backbone.Collection.extend
		model: Thought
		url: '/thoughts/get_all'

	ThoughtsListView = Backbone.View.extend
		el: $('#thoughts-area')
		events: {}
		render: ->
			self = this
			$(self.el).html('')
			_(@collection.models).each ((thought) -> # in case collection is not empty
			  self.appendItem thought
			), this

			this.initIsotope()
			randoms.initTips()

		initialize: ->
			
			self = this

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

			# @$saveNewThoughtButton.click ->
			$('#save-thought').click ->
				newThought = new Thought({'content': $('#new-thought').val()})
				newThought.save()
				self.collection.add(newThought)
				self.render()
				self.closeThoughtSaveModal()

			$('#sort-by-id').click ->
				$(self.el).isotope
					sortBy: 'id'

			$('#sort-by-length').click ->
				$(self.el).isotope
					sortBy: 'length'
			
			$('#add-thought-button').click ->
				$('#modal-overlay').fadeIn()
				$('#add-thought-modal').fadeIn()
				


		events: {
			'#save-thought' : 'saveNewThought'
			'#close-thought-modal' : 'closeThoughtSaveModal'
		}

		saveNewThought: ->
			newThought = new Thought({'content': $('#new-thought')})
			newThought.save()
			self.collection.add(newThought)
			self.render()
			closeThoughtSaveModal()

		closeThoughtSaveModal: ->
			@$newThoughtModal.fadeOut()
			@$newThoughtInput.val('')
			@$modalOverlay.fadeOut()

		initIsotope: ->
			$(self.el).isotope
				itemSelector : '.thought-card',
	      		layoutMode : 'fitRows'
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