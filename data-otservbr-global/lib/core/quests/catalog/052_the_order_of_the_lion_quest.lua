local quest = {
	name = "The Order of the Lion",
	startStorageId = Storage.Quest.U12_40.TheOrderOfTheLion.Evrard,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "Mission 01: Infiltrating the Camp",
			storageId = Storage.Quest.U12_40.TheOrderOfTheLion.Evrard,
			missionId = 10473,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Evrard the Miller asked you to sneak into the usurper camp to the east and retrieve a ledger from the harbour warehouse and a map from somewhere in the camp. Be quiet and avoid being seen.",
				[2] = "You have retrieved both the ledger and the map. Report back to Evrard the Miller.",
				[3] = "Evrard rewarded you with access to an underground route into the city and a passphrase: YSELDA. Use it with the citizens of Bounac to earn their trust.",
			},
		},
		[2] = {
			name = "Gaining the Trust of Bounac Residents",
			storageId = Storage.Quest.U12_40.TheOrderOfTheLion.BounacTrust,
			missionId = 10474,
			startValue = 1,
			endValue = 5,
			states = {
				[1] = "You have earned the trust of 1 citizen of Bounac. Use the passphrase YSELDA with the other residents to earn their trust as well.",
				[2] = "You have earned the trust of 2 citizens of Bounac. Use the passphrase YSELDA with the other residents to earn their trust as well.",
				[3] = "You have earned the trust of 3 citizens of Bounac. Use the passphrase YSELDA with the other residents to earn their trust as well.",
				[4] = "You have earned the trust of 4 citizens of Bounac. Use the passphrase YSELDA with the other residents to earn their trust as well.",
				[5] = "You have earned the trust of all the citizens of Bounac. The Bounac Guard may now allow you to enter the Castle. Just ask him to 'pass'.",
			},
		},
		[3] = {
			name = "Mission: Tasks of Trust",
			storageId = Storage.Quest.U12_40.TheOrderOfTheLion.WesTask,
			missionId = 10475,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Wes the Blacksmith needs materials to forge better equipment. Bring him 20 broken longbows from fallen usurpers.",
				[2] = "You have earned Wes the Blacksmith's trust by delivering the broken longbows.",
			},
		},
		[4] = {
			name = "Mission: The Baker's Request",
			storageId = Storage.Quest.U12_40.TheOrderOfTheLion.JehanTask,
			missionId = 10476,
			startValue = 1,
			endValue = 1,
			states = {
				[1] = "You delivered 10 loaves of bread to Jehan the Baker and earned his trust.",
			},
		},
		[5] = {
			name = "Mission: Purify the Crypt",
			storageId = Storage.Quest.U12_40.TheOrderOfTheLion.OnfroiKills,
			missionId = 10477,
			startValue = 0,
			endValue = 20,
			states = {
				[1] = function(player)
					return string.format("You already destroyed %d/20 crypt warriors.", math.max(player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.OnfroiKills) or 0, 0))
				end,
			},
		},
		[6] = {
			name = "Mission: The Hunt for Dal",
			storageId = Storage.Quest.U12_40.TheOrderOfTheLion.DalKills,
			missionId = 10478,
			startValue = 0,
			endValue = 20,
			states = {
				[1] = function(player)
					return string.format("You already hunted %d/20 deer.", math.max(player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.DalKills) or 0, 0))
				end,
			},
		},
		[7] = {
			name = "Mission: Provisions for the Butcher",
			storageId = Storage.Quest.U12_40.TheOrderOfTheLion.FralTask,
			missionId = 10479,
			startValue = 1,
			endValue = 1,
			states = {
				[1] = "You delivered 20 chunks of raw ham to Fral the Butcher and earned his trust.",
			},
		},
		[8] = {
			name = "Mission 02: The Siege of Bounac",
			storageId = Storage.Quest.U12_40.TheOrderOfTheLion.KesarMission,
			missionId = 10480,
			startValue = 1,
			endValue = 5,
			states = {
				[1] = "Kesar the Younger has asked you to wait while he attends to other matters. Return to him after some time and ask him about the siege again.",
				[2] = "You have agreed to Kesar's plan. Wait for one Tibian day and then return to his chambers during the night. Stay alert — enemies may appear.",
				[3] = "You have defeated Fugue. Speak with Kesar the Younger during the day. He may ask you to investigate other knightly orders before proceeding.",
				[4] = "Join up to 4 other adventurers at the battlefield on the eastern coast of Bounac. Defeat the Usurper Commanders, then face Drume himself.",
				[5] = "You have defeated Drume and his forces. Report back to Kesar the Younger to receive your reward.",
			},
		},
	},
}

return quest
