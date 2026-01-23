local quest = {
	name = "The Outlaw Camp",
	startStorageId = Storage.Quest.U6_4.OutlawCampQuest,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "Outlaw Treasure",
			storageId = Storage.Quest.U6_4.OutlawCampQuest,
			missionId = 10451,
			startValue = 1,
			endValue = 1,
			description = "You made your way through the Outlaw Camp and found the hidden treasure of the bandits.",
		},
	},
}

return quest
