window.BackboneHolder = {}  if typeof BackboneHolder is "undefined"

BackboneHolder.RecordView = Backbone.View.extend
	model: BackboneHolder.Record
	element: 'tr'
	# template: _.template('<tr class="record"><td class="place"></td><td class="name"><%= name %></td><td class="time"><%=time%></td> <td class="dimensions"><%=width%>x<%=height%></td> <td class="mines"><%=mines%></td></tr>')
	template: _.template('<tr class="record"><td class="name"><%= name %></td><td class="time"><%=time%></td> <td class="dimensions"><%=width%>x<%=height%></td> <td class="mines"><%=mines%></td></tr>')

	render: ->
		this.el = this.template(this.model.toJSON())
		return this