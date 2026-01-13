local quest = {
	name = "Children of the Revolution",
	startStorageId = Storage.Quest.U8_54.ChildrenOfTheRevolution.Questline,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "Prove Your Worzz!",
			storageId = Storage.Quest.U8_54.ChildrenOfTheRevolution.Mission00,
			missionId = 1058,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Your Mission is to go to a little camp of lizards at north-east of the Dragonblaze Peaks. \z
					You have to find and deliver the Tactical map complete the mission.",
				[2] = "You delivered the Tactical map to Zalamon.",
			},
		},
		[2] = {
			name = "Mission 1: Corruption",
			storageId = Storage.Quest.U8_54.ChildrenOfTheRevolution.Mission01,
			missionId = 1059,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Go to the Temple of Equilibrium (it's marked on your map) and find out what happened there.",
				[2] = "The temple has been corrupted and is lost. Zalamon should be informed about this as soon as possible.",
				[3] = "You already reported Zalamon about the Temple! Ask him for new mission!",
			},
		},
		[3] = {
			name = "Mission 2: Imperial Zzecret Weaponzz",
			storageId = Storage.Quest.U8_54.ChildrenOfTheRevolution.Mission02,
			missionId = 1060,
			startValue = 1,
			endValue = 5,
			states = {
				[1] = "Go into the small camp Chaochai to the north of the Dragonblaze Peaks \z
					(Zalamon marks the entrance on your map). There are 3 buildings which you have to spy",
				[2] = "You spied 1 of 3 buildings of the camp.",
				[3] = "You spied 2 of 3 buildings of the camp.",
				[4] = "You spied 3 of 3 buildings of the camp. Zalamon should be informed about this as soon as possible.",
				[5] = "You already reported Zalamon about the camp! Ask him for new mission!",
			},
		},
		[4] = {
			name = "Mission 3: Zee Killing Fieldzz",
			storageId = Storage.Quest.U8_54.ChildrenOfTheRevolution.Mission03,
			missionId = 1061,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Get the poison from Zalamon's storage room. Then go to the teleporter to the Muggy Plains and head \z
					east from there to the rice fields. Go to the very top rice field and use the poison anywhere on the water.",
				[2] = "The rice has been poisoned. This will weaken the Emperor's army significantly. \z
					Return and tell Zalamon about your success.",
				[3] = "You already reported Zalamon about your success! Ask him for new mission!",
			},
		},
		[5] = {
			name = "Mission 4: Zze Way of Zztonezz",
			storageId = Storage.Quest.U8_54.ChildrenOfTheRevolution.Mission04,
			missionId = 1062,
			startValue = 1,
			endValue = 6,
			states = {
				[1] = "Your mission is to find a way to enter the north of the valley and find a \z
				passage to the great gate itself. Search any temples or settlements you come across for hidden passages.",
				[2] = "Report Zalamon about the strange symbols that you found.",
				[3] = "Get the greasy oil from Zalamon's storage room and put them on the levers that you found.",
				[4] = "Due to being extra greasy, the leavers can now be moved.",
				[5] = "You found the right combination for the puzzle in the mountains and triggered some kind of mechanism. \z
					You should head back to Zalamon to report your success.",
				[6] = "You already reported Zalamon about your success! You got a Tome of Knowledge as reward! \z
					Ask him for new mission!",
			},
		},
		[6] = {
			name = "Mission 5: Phantom Army",
			storageId = Storage.Quest.U8_54.ChildrenOfTheRevolution.Mission05,
			missionId = 1063,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Zalamon has sent you on a quest to find out what lies beneath the secret portal in the temple. Find it and explore the other side.",
				[2] = "Eternal guardians and lizard chosen has been awaken. Survive them and report it to Zalamon!",
				[3] = "You Survived the Waves and reported Zalamon about your success! You got a Serpent Crest as reward!",
			},
		},
	},
}

return quest
