window.BackboneHolder = {}  if typeof BackboneHolder is "undefined"

BackboneHolder.CommentsListView = Backbone.View.extend
		el: $('#comments-list')
		tagName: 'ul'
		render: ->
			self = this

			@setElement $('#comments-list')
			self.$el.html('')
			if @collection.models.length > 0
				_(@collection.models).each ((comment) ->
				  self.appendItem comment
				), this
			else
				$(@el).append "<li><p>No Comments to show. Add one!</p></li>"

			randoms.initTips()
			self.$newCommentAuthorInput.val(self.names[Math.floor(Math.random() * (self.names.length - 1 + 1))])

		initialize: (opts) ->
			self = this
			@$container = $(self.el)
			self.id = opts.id
			self.collection.on("sync", this.render, this);
			self.collection.on("reset", this.render, this);

			@$commentModal = $('#comment-modal')
			@$saveNewCommentButton = $('#submit-comment')
			@$newCommentInput = $('#new-comment-input')
			@$newCommentAuthorInput = $('#new-comment-author')
			@$newCommentPasscodeInput = $('#new-comment-passcode')

			@$commentErrorText = $('#comment-error')

			@names = ["Rambo McQueen", 'Powers Boothe', 'Commander Flex Plexico', 'Duncan Steel', 'Lightning McPhaser', 'Blazer McTaser', 'Jennifer', 'Michelle', 'Sunshine', 'The California Kid', 'Jeeves', 'Kabeer Gbaja-Biamila', 'Coco Crisp', 'World B. Free', "D'Brickashaw Ferguson", 'Chief Kickingstallionsims', 'Sein McFeld', 'H.E. PennyPacker', 
				'Dr. Martin van Nostrand', 'Kel Varnsen', 'Art Vandelay', 'Cantstandya', 'Buck Naked', 'Max Power', 'Curtis E. Bear', 'Churchy La Femme', 'Plow King', 'John McBananaFeather', 'Eduardo Coroccio', 'Alex P Keaton', 'Mr. Tea', 'Mr. Brown',
				'Stirling Mortlock', 'Magnus Ver Magnusson', 'Dick Pound', 'Staff Sgt. Max Fightmaster', 'Dick Trickle', 'Tricky Dick', 'A Real American Hero', 'Gaylord Focker', 'Moxie Crimefighter', 'ShaDynasty', 'Pepe Silvia', 'Nightman - Sneaky & Mean', 'Dayman, Fighter of the Nightman', 'Oscar Gamble', '']

			@$saveNewCommentButton.click -> self.saveNewComment(self)

			@$passcodeModal = $('#passcode-modal')
			@$passcodeInput = $('#passcode-input')
			@$passcodeSubmit = $('#submit-passcode')
			@$passcodeClose = $('#close-passcode-modal')
			@$modalOverlay = $('#modal-overlay')

			@$passcodeSubmit.click -> self.deleteComment(self)
			@$passcodeInput.keyup (e) -> self.deleteComment(self) if e.which == 13
			@$passcodeClose.click -> self.closePassCodeModal(self)

			$(document).on 'click', '.delete-comment', (e) -> self.showPasscodeModal(e, self)

		saveNewComment: (self) ->
			@$commentErrorText.text('').fadeOut()
			authorVal = @$newCommentAuthorInput.val()
			contentVal = @$newCommentInput.val() 
			if contentVal.length > 0
				newComment = new BackboneHolder.Comment({author: authorVal, content: contentVal, thought_id: self.id, passcode: randoms.getGUID()})
				newComment.save()
				# data = newComment.save(null, { 
				# 	success: (data) ->
				# 		# console.log data
				# })

				@$newCommentPasscodeInput.val(newComment.get('passcode'))
				
				self.collection.add(newComment)

				@$newCommentAuthorInput.val(self.names[Math.floor(Math.random() * (self.names.length - 1 + 1))])
				@$newCommentInput.val('')
			# else
			# 	@$commentErrorText.text('Both fields are required.').fadeIn()

		showPasscodeModal: (e, self) ->
			clickedElem = $(e.target)
			commentToDelete = clickedElem.parents('.comment').addClass('awaiting-delete')
			self.$passcodeModal.fadeIn()
			self.$commentModal.addClass('passcode-modal-shown')
			self.$passcodeInput.focus()

		closePassCodeModal: (self)->
			$('.awaiting-delete').removeClass('awaiting-delete')
			self.$passcodeModal.fadeOut()
			self.$passcodeInput.val('').removeClass('incorrect')
			self.$commentModal.removeClass('passcode-modal-shown')

		deleteComment: (self) ->
			commentToDelete = $('.awaiting-delete')
			commentID = commentToDelete.data('id')

			#check passcode
			if commentID and this.collection.get(commentID)
				if self.$passcodeInput.val() in [this.collection.get(commentID).get('passcode'), 'supersecretadminpassword']
					this.collection.get(commentID).destroy()

					self.closePassCodeModal(self)

					this.render()
				else
					self.$passcodeInput.addClass('incorrect')


		appendItem: (comment) ->
		  commentView = new BackboneHolder.CommentView(model: comment)
		  $(@el).append commentView.render().el
