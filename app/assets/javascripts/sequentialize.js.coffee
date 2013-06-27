# sequential.js
# Pass in a hash containing arrays of functions and their 
# respective params. Empty array for no params

$ ->

	$.sequentialize = (params) ->
		seqFunctions = params.functions
		seqParams = params.params
		numFuns = seqFunctions.length
		numParams = seqParams.length
		funCount = 0 # F is friends who do stuff together
		funLimit = numFuns # :( I'm so sorry.

		doFunc = ->
			if funCount == funLimit
				return "All Done!"
			else
				$.when(seqFunctions[funCount].apply(undefined, seqParams[funCount])).then (funStatus = true) ->
					if funStatus 
						funCount++
						doFunc()
					else
						console.log "Function number #{funCount} returned an error."

		if numFuns != numParams
			return "Requires equal number of parameters and functions! Ex: params = { functions: [fun1, fun2, fun3], params: [[1, p1-2: 2], [], [1, 2] ] }"
		else if numFuns == 0
			return "We require more functions!"
		else if numParams == 0
			return "WE REQUIRE MORE MINERA.... PARAMETERS"
		else
			doFunc()