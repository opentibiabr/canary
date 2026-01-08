local quest = {
	name = "Factions",
	startStorageId = Storage.Quest.U7_4.DjinnWar.Factions,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "The Marid and the Efreet - Djinn Greeting",
			storageId = Storage.Quest.U7_4.DjinnWar.Faction.Greeting,
			missionId = 1064,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Melchior told you the word &quot;Djanni'hah&quot; which can be used to talk to Djinns. \z
					Be aware that once you become an ally of one Djinn race, you cannot switch sides anymore.",
				[2] = "",
			},
		},
		[2] = {
			name = "The Marid and the Efreet - Marid Faction",
			storageId = Storage.Quest.U7_4.DjinnWar.Faction.MaridDoor,
			missionId = 1065,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "You have joined the Marid. These friendly, blue Djinns are honest and fair allies. \z
					You have pledged eternal loyalty to King Gabel and may enter Asha'daramai freely. Djanni'hah!",
				[2] = "",
			},
		},
		[3] = {
			name = "The Efreet and the Efreet - Efreet Faction",
			storageId = Storage.Quest.U7_4.DjinnWar.Faction.EfreetDoor,
			missionId = 1066,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "You have joined the Efreet. These evil, green Djinns are always up to mischievous pranks. \z
					You have pledged eternal loyalty to King Malor and may enter Mal'ouquah freely. Djanni'hah!",
				[2] = "",
			},
		},
	},
}

return quest
