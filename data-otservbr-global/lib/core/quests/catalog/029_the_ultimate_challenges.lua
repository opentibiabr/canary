local quest = {
	name = "The Ultimate Challenges",
	startStorageId = Storage.Quest.U8_0.BarbarianArena.QuestLogGreenhorn,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "Barbarian Arena - Greenhorn Mode",
			storageId = Storage.Quest.U8_0.BarbarianArena.QuestLogGreenhorn,
			missionId = 10312,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "You have to defeat all enemies in this mode.",
				[2] = "You have defeated all enemies in this mode.",
			},
		},
		[2] = {
			name = "Barbarian Arena - Scrapper Mode",
			storageId = Storage.Quest.U8_0.BarbarianArena.QuestLogScrapper,
			missionId = 10313,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "You have to defeat all enemies in this mode.",
				[2] = "You have defeated all enemies in this mode.",
			},
		},
		[3] = {
			name = "Barbarian Arena - Warlord Mode",
			storageId = Storage.Quest.U8_0.BarbarianArena.QuestLogWarlord,
			missionId = 10314,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "You have to defeat all enemies in this mode.",
				[2] = "You have defeated all enemies in this mode.",
			},
		},
	},
}

return quest
