local quest = {
	name = "Spirithunters Quest",
	startStorageId = Storage.Quest.U8_7.SpiritHunters.Mission01,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "Method",
			storageId = Storage.Quest.U8_7.SpiritHunters.Mission01,
			missionId = 10426,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Use the item on the tombstones.",
				[2] = "You have used these item in the tombstones.",
			},
		},
		[2] = {
			name = "First Mission",
			storageId = Storage.Quest.U8_7.SpiritHunters.Mission01,
			missionId = 10427,
			startValue = 2,
			endValue = 4,
			states = {
				[3] = "Talk to Sinclair and take the ghost residue.",
				[4] = "You got the ghost waste.",
			},
		},
		[3] = {
			name = "Second Mission",
			storageId = Storage.Quest.U8_7.SpiritHunters.Mission01,
			missionId = 10428,
			startValue = 4,
			endValue = 6,
			states = {
				[5] = "You need to get more samples of ghosts.",
				[6] = "You got all the ghost scraps.",
			},
		},
	},
}

return quest
