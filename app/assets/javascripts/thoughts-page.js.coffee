randoms.getGUID = ->
	genGUID = ->
		# This is too... secure. I'm going with a... different... approach.
		# Math.floor((1 + Math.random()) * 0x10000).toString(16).substring 1

		randoms.randomWords[Math.floor(Math.random() * (randoms.randomWords.length - 1 + 1))]


	genGUID() + '_' + genGUID()

randoms.randomWords = ['banana-hammock', 'longfellow', 'crapbag', 'holiday-armadillo', 'MYFAJITAS', 'arcane', 'whispering', 'hollows', 'savannah', 'pandemic',
		'orangina', 'creole', 'testy', 'test-sicles', 'roberto', 'bender', 'flexo', 'extortion', 'putnam', 'wiser', 'ocean', 'opening', 'clearing', 'flustering', 
		'criminally', 'spineless'
	]

randoms.thoughts = (args) ->
	args = args


	createModelsFromArgs = (thoughts, thoughtsList) ->
		for i in [0..thoughts.length - 1] by 1
			thoughtsList.add(new ThoughtsHolder.Thought(thoughts[i]))

	$(document).ready ->
		thoughtsList = new ThoughtsHolder.ThoughtsList()

		createModelsFromArgs(args.thoughts, thoughtsList)

		thoughtsListView = new ThoughtsHolder.ThoughtsListView({ collection: thoughtsList })
