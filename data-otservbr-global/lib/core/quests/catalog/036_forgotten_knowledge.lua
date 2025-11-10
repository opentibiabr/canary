local quest = {
	name = "Forgotten Knowledge",
	startStorageId = Storage.Quest.U11_02.ForgottenKnowledge.Tomes,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "Circle of the Black Sphinx",
			storageId = Storage.Quest.U11_02.ForgottenKnowledge.LadyTenebrisKilled,
			missionId = 10361,
			startValue = 0,
			endValue = 1522018605,
			states = {
				[1] = "You defeated the rogue Lady Tenebris.",
			},
		},
		[2] = {
			name = "Bane of the Cosmic Force",
			storageId = Storage.Quest.U11_02.ForgottenKnowledge.LloydKilled,
			missionId = 10362,
			startValue = 0,
			endValue = 1522018605,
			states = {
				[1] = "You calmed poor, misguided Lloyd. All he wanted was protection from the outside world. \z
				Luckily he seems to have learned his lesson... or has he?",
			},
		},
		[3] = {
			name = "The Desecrated Glade",
			storageId = Storage.Quest.U11_02.ForgottenKnowledge.ThornKnightKilled,
			missionId = 10363,
			startValue = 0,
			endValue = 1522018605,
			states = {
				[1] = "You defeated the Thorn Knight and shattered the root of evil with all your might. \z
				The honor of being a guardian of the glade indeed comes with pride as well as responsibility.",
			},
		},
		[4] = {
			name = "The Unwary Mage",
			storageId = Storage.Quest.U11_02.ForgottenKnowledge.DragonkingKilled,
			missionId = 10364,
			startValue = 0,
			endValue = 1522018605,
			states = {
				[1] = "With help of Ivalisse from the temple of the Astral Shapers in Thais and her father, \z
				you averted the Dragon King's menace deep in the Zao Muggy Plains.",
			},
		},
		[5] = {
			name = "Dragon in Distress",
			storageId = Storage.Quest.U11_02.ForgottenKnowledge.HorrorKilled,
			missionId = 10365,
			startValue = 0,
			endValue = 1522018605,
			states = {
				[1] = "You saved the Dragon Mother's egg and she melted the ice wall that blocked your way.",
			},
		},
		[6] = {
			name = "Time is a Window",
			storageId = Storage.Quest.U11_02.ForgottenKnowledge.TimeGuardianKilled,
			missionId = 10366,
			startValue = 0,
			endValue = 1522018605,
			states = {
				[1] = "You defeated the Time Guardian and are free to return to your own time. \z
				For some creatures in this world, it seems neither past nor future are an obstacle.",
			},
		},
		[7] = {
			name = "Final Fight",
			storageId = Storage.Quest.U11_02.ForgottenKnowledge.LastLoreKilled,
			missionId = 10367,
			startValue = 0,
			endValue = 1522018605,
			states = {
				[1] = "Description Fault.",
			},
		},
	},
}

return quest
