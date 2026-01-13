local quest = {
	name = "The Paradox Tower",
	startStorageId = Storage.Quest.U7_24.TheParadoxTower.QuestLine,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "The Feared Hugo",
			storageId = Storage.Quest.U7_24.TheParadoxTower.TheFearedHugo,
			missionId = 9,
			startValue = 1,
			endValue = 4,
			states = {
				[1] = "Oldrak told you that the fearsome Hugo was accidentally created by the mage Yenny the Gentle. Try to find out more about this.",
				[2] = "Zoltan told you about Crunor's Caress, a druid order originating from Carlin. Try to find out more about this.",
				[3] = "Padreia told you that Crunor's Caress founded the inn Crunor's Cottage south of Mt. Sternum. Try to find out more about this.",
				[4] = "Lubo told you about a magical experiment that went wrong and created a demonbunny. Someone might be interested in this...",
			},
		},
		[2] = {
			name = "Favorite colour: Green",
			storageId = Storage.Quest.U7_24.TheParadoxTower.FavoriteColour,
			missionId = 10,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Favorite colour is the green.",
				[2] = "Favorite colour is the green.",
			},
		},
		[3] = {
			name = "The Secret of Mathemagics",
			storageId = Storage.Quest.U7_24.TheParadoxTower.Mathemagics,
			missionId = 11,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "You learnt Mathemagics. Everything is based on the simple fact that 1+1=1.",
				[2] = "You learnt Mathemagics. Everything is based on the simple fact that 1+1=1.",
			},
		},
	},
}

return quest
