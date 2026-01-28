local quest = {
	name = "The Djinn War - Efreet Faction",
	startStorageId = Storage.Quest.U7_4.DjinnWar.EfreetFaction.Start,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "Efreet Mission 1: The Supply Thief",
			storageId = Storage.Quest.U7_4.DjinnWar.EfreetFaction.Mission01,
			missionId = 10221,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Travel to Thais and keep your eyes open for something that might give you a clue on the supply thief.",
				[2] = "You have found the potential supply thief - Partos in Thais seemed very suspicious. \z
					Baa'leal might be interested in this matter.",
				[3] = "You have reported the case to Baa'leal. \z
					He seemed very satisfied and told you that Alesar might have another mission for you.",
			},
		},
		[2] = {
			name = "Efreet Mission 2: The Tear of Daraman",
			storageId = Storage.Quest.U7_4.DjinnWar.EfreetFaction.Mission02,
			missionId = 10222,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Sneak into Ashta'daramai and steal a &quot;Tear of Daraman&quot;. \z
					For more information about these gems visit the Efreet library.",
				[2] = "You have successfully managed to steal a Tear of Daraman from Ashta'daramai. Bring it to Alesar.",
				[3] = "You have delivered Daraman's Tear. \z
					Alesar seemed very satisfied and told you that Malor himself might have another mission for you.",
			},
		},
		[3] = {
			name = "Efreet Mission 3: The Sleeping Lamp",
			storageId = Storage.Quest.U7_4.DjinnWar.EfreetFaction.Mission03,
			missionId = 10223,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Malor asked you to find Fa'hradin's sleeping lamp in the orc fortress at Ulderek's Rock. \z
					Then, sneak into Ashta'daramai and exchange Gabel's sleeping lamp with Fa'hradin's lamp.",
				[2] = "You successfully exchanged the lamps. Malor will be happy to hear about this.",
				[3] = "The Efreet are very satisfied with your help. King Malor allowed you to trade with Yaman and Alesar.",
			},
		},
	},
}

return quest
