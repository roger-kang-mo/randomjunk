window.BackboneHolder = {}  if typeof BackboneHolder is "undefined"

BackboneHolder.RecordsListView = Backbone.View.extend
	el: $('#records-list')
	tagName: 'tr'
	render: (className) ->
		@setElement $('#records-list')

		# self.$el.html('<tr><th class="place">#</th><th class="player">Name</th><th class="time">Time</th><th class="dimensions">HeightxWidth</th><th class="mines"># of Mines</th></tr>')
		@$el.html('<tr><th class="player" data-sort="name">Name <span class="sort-icon"></span></th><th class="time" data-sort="time">Time <span class="sort-icon"></span></th><th class="dimensions" data-sort="dimensions">Height x Width <span class="sort-icon"></span></th><th class="mines" data-sort="mines"># of Mines <span class="sort-icon"></span></th></tr>')
		$(".#{className}").addClass('sorted') if className
		if @collection.models.length > 0
			_(@collection.models).each ((record) ->
				@appendItem record
			), @
		else
			$(@el).append('<tr><p>Currently no records to show.</p></tr>')

	events: -> 
		{ 'click th': 'sort_by'}

	initialize: (opts) ->
		@$container = @$el

		@collection.on('sync sort', @render());

	appendItem: (record) ->
		  recordView = new BackboneHolder.RecordView(model: record)
		  $(@el).append recordView.render().el

	sort_by: (e) ->
		$('.sorted').removeClass('sorted')
		@collection.sort_key = $(e.target).data('sort')
		@collection.sort()
		@render($(e.target).attr('class'))
			
