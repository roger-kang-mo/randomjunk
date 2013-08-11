window.BackboneHolder = {}  if typeof BackboneHolder is "undefined"

BackboneHolder.ThoughtsListView = Backbone.View.extend
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
			@setElement $('#thoughts-area')
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
			@$newCommentPasscodeInput = $('#new-comment-passcode')

			# @$commentListViews = []
			self.$commentsListView = null

			@$saveNewThoughtButton.click ->
				newThought = new BackboneHolder.Thought({'content': $('#new-thought').val()})
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
				commentsList = undefined
				commentsList = new BackboneHolder.CommentsList(null, {thoughtID: thoughtID})
				self.$commentsListView = new BackboneHolder.CommentsListView({ id: thoughtID, collection: commentsList})
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
			self.$newCommentPasscodeInput.val('')
			self.$commentErrorText.text('').fadeOut()
			self.$commentModal.fadeOut()
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
		  thoughtView = new BackboneHolder.ThoughtsView(model: thought)
		  $(@el).append thoughtView.render().el
