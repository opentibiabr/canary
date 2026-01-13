local quest = {
	name = "The Djinn War - Marid Faction",
	startStorageId = Storage.Quest.U7_4.DjinnWar.MaridFaction.Start,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "Marid Mission 1: The Dwarven Kitchen",
			storageId = Storage.Quest.U7_4.DjinnWar.MaridFaction.Mission01,
			missionId = 10224,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Bring a cookbook of the dwarven kitchen to Bo'ques.",
				[2] = "You have delivered the cookbook. \z
					Bo'ques seemed very satisfied and told you that Fa'hradin might have another mission for you.",
			},
		},
		[2] = {
			name = "Marid Mission 2: The Spyreport",
			storageId = Storage.Quest.U7_4.DjinnWar.MaridFaction.Mission02,
			missionId = 10225,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Fa'hradin asked you to sneak into the Efreet fortress Mal'ouqhah and find their undercover spy. \z
					The codeword is PIEDPIPER.",
				[2] = "You have delivered the spyreport. \z
					Fa'hradin seemed impressed and told you that Gabel himself might have another mission for you.",
			},
		},
		[3] = {
			name = "Rata'Mari and the Cheese",
			storageId = Storage.Quest.U7_4.DjinnWar.MaridFaction.RataMari,
			missionId = 10226,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "You have promised Rata'Mari cheese. Once you deliver some to him, he will hand over his spyreport.",
				[2] = "You got Rata'Mari's spyreport. He seems to be quite happy with the cheese you brought him.",
			},
		},
		[4] = {
			name = "Marid Mission 3: The Sleeping Lamp",
			storageId = Storage.Quest.U7_4.DjinnWar.MaridFaction.Mission03,
			missionId = 10227,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Gabel asked you to find Fa'hradin's sleeping lamp in the orc fortress at Ulderek's Rock. \z
					Then, sneak into Mal'ouqhah and exchange Malor's sleeping lamp with Fa'hradin's lamp.",
				[2] = "You successfully exchanged the lamps. Gabel will be happy to hear about this.",
				[3] = "The Marid deeply appreciate your help. King Gabel allowed you to trade with Haroun and Nah'bob.",
			},
		},
	},
}

return quest
