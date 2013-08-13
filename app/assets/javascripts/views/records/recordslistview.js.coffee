window.BackboneHolder = {}  if typeof BackboneHolder is "undefined"

BackboneHolder.RecordsListView = Backbone.View.extend
	el: $('#records-list')
	tagName: 'tr'
	render: ->
		self = this

		@setElement $('#records-list')

		# self.$el.html('<tr><th class="place">#</th><th class="player">Name</th><th class="time">Time</th><th class="dimensions">HeightxWidth</th><th class="mines"># of Mines</th></tr>')
		self.$el.html('<tr><th class="player">Name</th><th class="time">Time</th><th class="dimensions">HeightxWidth</th><th class="mines"># of Mines</th></tr>')

		if @collection.models.length > 0
			_(@collection.models).each ((record) ->
				self.appendItem record
			), this
		else
			$(@el).append('<tr><p>Currently no records to show.</p></tr>')


	initialize: (opts) ->
		self = this
		@$container = $(self.el)

		@collection.on('sync', @render());

	appendItem: (record) ->
		  recordView = new BackboneHolder.RecordView(model: record)
		  $(@el).append recordView.render().el