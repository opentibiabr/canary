local quest = {
	name = "Oramond",
	startStorageId = Storage.Quest.U10_50.OramondQuest.QuestLine,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "To Take Roots",
			storageId = Storage.Quest.U10_50.OramondQuest.ToTakeRoots.Mission,
			missionId = 10360,
			startValue = 1,
			endValue = 3000,
			description = "Five Juicy roots from the outskirts of Rathleton may already help feed the poor. \z
			Try to find a city official to deliver them to or go to the Rathleton poor house.",
		},
	},
}

return quest
