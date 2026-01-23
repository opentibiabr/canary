local quest = {
	name = "The White Raven Monastery",
	startStorageId = Storage.Quest.U7_24.TheWhiteRavenMonastery.QuestLog,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "Access to the Isle of Kings",
			storageId = Storage.Quest.U7_24.TheWhiteRavenMonastery.Passage,
			missionId = 10315,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "You are a friend of Dalbrect. \z
				Since you returned his family brooch he will sail you to the Isle of Kings unless you do something stupid.",
			},
		},
		[2] = {
			name = "The Investigation",
			storageId = Storage.Quest.U7_24.TheWhiteRavenMonastery.Diary,
			missionId = 10316,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Investigate the catacombs. Abbot Costello should be interested in information about brother Fugio.",
				[2] = "You returned Fugio's Diary. \z
				Costello was very thankful about your help and gave you a blessed ankh as reward.",
			},
		},
	},
}

return quest
