local quest = {
	name = "The Travelling Trader Quest",
	startStorageId = Storage.Quest.U8_1.TheTravellingTrader.Mission01,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "Mission 1: Trophy",
			storageId = Storage.Quest.U8_1.TheTravellingTrader.Mission01,
			missionId = 10288,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Your first mission for becoming a recognized trader is to bring the \z
				traveling salesman Rashid a Deer Trophy.",
				[2] = "You have completed this mission. Talk with Rashid to continue.",
			},
		},
		[2] = {
			name = "Mission 2: Delivery",
			storageId = Storage.Quest.U8_1.TheTravellingTrader.Mission02,
			missionId = 10289,
			startValue = 1,
			endValue = 5,
			states = {
				[1] = "Your mission is to get the package from Willard the weapon dealer at Edron.",
				[2] = "Willard forgot to pick it up from Snake Eye at Outlaw Camp. \z
				So he wants you to go and pick it up from Snake Eye.",
				[3] = "Take the package just next door.",
				[4] = "Now bring back the package to Rashid.",
				[5] = "You have completed this mission. Talk with Rashid to continue.",
			},
		},
		[3] = {
			name = "Mission 3: Cheese",
			storageId = Storage.Quest.U8_1.TheTravellingTrader.Mission03,
			missionId = 10290,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Rashid wants you to pick his special order from Miraia in Darashia. \z
				But you have to be quick, Scarab cheese can rot really fast in high temperature.",
				[2] = "Now quickly bring back the Scarab cheese to Rashid.",
				[3] = "You have completed this mission. Talk with Rashid to continue.",
			},
		},
		[4] = {
			name = "Mission 4: Vase",
			storageId = Storage.Quest.U8_1.TheTravellingTrader.Mission04,
			missionId = 10291,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Rashid have ordered a special elven vase from Briasol in Ab'Dendriel. \z
				    He asks you to buy it from Briasol and bring it back. \z
                            But you should be carefully, since the vase is very fragile.",
				[2] = "Now carefully bring the vase back to Rashid.",
				[3] = "You have completed this mission. Talk with Rashid to continue.",
			},
		},
		[5] = {
			name = "Mission 5: Make a deal",
			storageId = Storage.Quest.U8_1.TheTravellingTrader.Mission05,
			missionId = 10292,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "This time, Rashid is testing your trading skills to buy a Crimson Sword from Uzgod. \z
				But it have to be less than 400 gold coins and the quality has to be perfect.",
				[2] = "Now bring the sword back to Rashid.",
				[3] = "You have completed this mission. Talk with Rashid to continue.",
			},
		},
		[6] = {
			name = "Mission 6: Goldfish",
			storageId = Storage.Quest.U8_1.TheTravellingTrader.Mission06,
			missionId = 10293,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Rashid wants you to bring him a Goldfish Bowl.",
				[2] = "You have completed this mission. Talk with Rashid to continue.",
			},
		},
		[7] = {
			name = "Mission 7: Declare",
			storageId = Storage.Quest.U8_1.TheTravellingTrader.Mission07,
			missionId = 10294,
			startValue = 1,
			endValue = 1,
			states = {
				[1] = "Rashid has declare you as one of his recognized traders, \z
				and now you are able to trade with him anytime..",
			},
		},
	},
}

return quest
