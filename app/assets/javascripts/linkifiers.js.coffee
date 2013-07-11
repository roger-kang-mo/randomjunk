randoms.linkifierize = (content)->
	zoidbergLinks = ["http://youtu.be/3nRwnYwks7c"
					"http://youtu.be/Ndfe5J8qmVk"
					"http://youtu.be/BSKVEkMiTMI"
					"http://youtu.be/P_WI0VI7aIw"]

	victoriaLinks = ["https://fbcdn-sphotos-h-a.akamaihd.net/hphotos-ak-prn2/9627_1146647988947_6700310_n.jpg"
					"https://sphotos-a.xx.fbcdn.net/hphotos-ash3/217499_1689865449044_3131388_n.jpg"
					"https://fbcdn-sphotos-d-a.akamaihd.net/hphotos-ak-ash4/485001_4656401930602_207243476_n.jpg"
					"https://fbcdn-sphotos-c-a.akamaihd.net/hphotos-ak-ash4/221761_1706734390757_7292716_n.jpg"]

	carltonLinks = ["http://www.youtube.com/watch?v=zS1cLOIxsQ8"
					"http://www.youtube.com/watch?v=T3ANUkOyDNQ"
					"http://i.imgur.com/8K4UWE4.gif"
					"http://carltontomjonesdance.ytmnd.com"
	]

	randomLinks = ["http://www.youtube.com/watch?v=eh7lp9umG2I"
			"http://drecosby.ytmnd.com"
			"http://treadmillzaza.ytmnd.com"
			"http://youtu.be/Dd7FixvoKBw"
			"http://youtu.be/EhXsJjVdj1E"
			"http://youtu.be/T3BALr6luW8"
			"http://youtu.be/g5WB-p-QBJc"
			"http://youtu.be/G7Od4H9uIJ8"
			"http://youtu.be/dJQG6V1MOVY"
			"http://youtu.be/5I_QzPLEjM4"
			"http://youtu.be/NtILxBszyf8"
			"http://youtu.be/FArZxLj6DLk"
			"http://youtu.be/ji5_MqicxSo"
			"http://youtu.be/iIiAAhUeR6Y"
			"http://youtu.be/qBjLW5_dGAM"
			"http://youtu.be/dNJdJIwCF_Y"
			"http://youtu.be/WVm84MD4vU4"
			"http://youtu.be/UNfyBqrAaPk"
			"http://youtu.be/U3myrBMACWQ"

	]

	gimmeRandomZoidIndex = Math.floor(Math.random() * zoidbergLinks.length)
	gimmeRandomVictoriaIndex = Math.floor(Math.random() * victoriaLinks.length)
	gimmeRandomCarltonIndex = Math.floor(Math.random() * carltonLinks.length)
	gimmeRandomRandomIndex = Math.floor(Math.random() * randomLinks.length)

	zoidIndex = content.toLowerCase().indexOf 'zoidberg'
	content = content.replace /zoidberg/i, '<a href="' + zoidbergLinks[gimmeRandomZoidIndex] + '" target="_blank">'+content.substring(zoidIndex, zoidIndex+8)+'</a>'

	vicIndex = content.toLowerCase().indexOf 'victoria'	
	content = content.replace /victoria/i, '<a href="' + victoriaLinks[gimmeRandomVictoriaIndex] + '" target="_blank">'+content.substring(vicIndex, vicIndex+8)+'</a>'

	carIndex = content.toLowerCase().indexOf 'carlton'
	content = content.replace /carlton/i, '<a href="' + carltonLinks[gimmeRandomCarltonIndex] + '" target="_blank">'+content.substring(carIndex, carIndex+7)+'</a>'
	
	ranIndex = content.toLowerCase().indexOf 'random'
	content = content.replace /random/i, '<a href="' + randomLinks[gimmeRandomRandomIndex] + '" target="_blank">'+content.substring(ranIndex, ranIndex+6)+'</a>'

	content
