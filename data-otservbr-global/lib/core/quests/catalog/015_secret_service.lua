local quest = {
	name = "Secret Service",
	startStorageId = Storage.Quest.U8_1.SecretService.Quest,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "Mission 1: From Thais with Love",
			storageId = Storage.Quest.U8_1.SecretService.TBIMission01,
			missionId = 10191,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Your first mission is to deliver a warning to the Venoreans. \z
					Get a fire bug from Liberty Bay and set their shipyard on fire.",
				[2] = "You have set the Venoreans shipyard on fire, report back to Chester!",
				[3] = "You have reported back that you have completed your mission, ask Chester for a new mission!",
			},
		},
		[2] = {
			name = "Mission 1: For Your Eyes Only",
			storageId = Storage.Quest.U8_1.SecretService.AVINMission01,
			missionId = 10192,
			startValue = 1,
			endValue = 4,
			states = {
				[1] = "Your first task is to deliver a letter to Gamel in thais, If he is a bit reluctant, be persuasive.",
				[2] = "Gamel sent his thugs on you, defeat them and deliver the letter to Gamel!",
				[3] = "After defeating Gamel's thugs, he found you to be persuasive enough to accept the letter. \z
					Report back to Uncle!",
				[4] = "You have reported back that you have completed your task. Ask Uncle for a new mission!",
			},
		},
		[3] = {
			name = "Mission 1: Borrowed Knowledge",
			storageId = Storage.Quest.U8_1.SecretService.CGBMission01,
			missionId = 10193,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Emma has requested that you steal a Nature Magic Spellbook in the Edron academy.",
				[2] = "You have delivered the Nature Magic Spellbook to Emma, ask her for a new mission!",
			},
		},
		[4] = {
			name = "Mission 2: Operation Green Claw",
			storageId = Storage.Quest.U8_1.SecretService.TBIMission02,
			missionId = 10194,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Your next mission is to find some information about one of \z
					their missing agents in The Green Claw Swamp.",
				[2] = "You have delivered the Black Knight's notes to Chester, ask him for a new mission!",
			},
		},
		[5] = {
			name = "Mission 2: A File Between Friends",
			storageId = Storage.Quest.U8_1.SecretService.AVINMission02,
			missionId = 10195,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Your next task is to retrieve a file named AH-X17L89.",
				[2] = "You have delivered the file named AH-X17L89 to Uncle, ask him for a new mission!",
			},
		},
		[6] = {
			name = "Mission 2: Codename:Lumberjack",
			storageId = Storage.Quest.U8_1.SecretService.CGBMission02,
			missionId = 10196,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Emma has requested that you retrieve a Rotten Heart of a Tree from \z
					the Black Knight Villa in Greenclaw swamp north-west of Venore.",
				[2] = "You have delivered the Rotten Heart of a Tree to Emma, ask her for a new mission!",
			},
		},
		[7] = {
			name = "Mission 3: Treachery in Port Hope",
			storageId = Storage.Quest.U8_1.SecretService.TBIMission03,
			missionId = 10197,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Your next mission is to retrieve some evidence that the traders in Port Hope are up to no good!",
				[2] = "You have found the evidence, report back to Chester!",
				[3] = "You have reported back that you have completed your mission, ask Chester for a new mission!",
			},
		},
		[8] = {
			name = "Mission 3: What Men are Made of",
			storageId = Storage.Quest.U8_1.SecretService.AVINMission03,
			missionId = 10198,
			startValue = 1,
			endValue = 4,
			states = {
				[1] = "Your next task is to bring a barrel of beer to the Secret Tavern in the sewers of Carlin.",
				[2] = "On your way to the Secret Tavern in the sewers you were attacked by amazons trying to stop you! \z
					Deliver the barrel of beer to Karl.",
				[3] = "You have delivered the barrel of beer to Karl, report back to Uncle!",
				[4] = "You have reported back that you have completed your task, ask Uncle for a new mission!",
			},
		},
		[9] = {
			name = "Mission 3: Rust in Peace",
			storageId = Storage.Quest.U8_1.SecretService.CGBMission03,
			missionId = 10199,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Emma has requested that you damage the Ironhouse of Venore, use the \z
					Case of Rust Bugs on the keyhole in the cellar of the ironhouse.",
				[2] = "The bugs are at work! Report back to Emma.",
				[3] = "You have reported back that you have completed your mission, ask her for a new mission!",
			},
		},
		[10] = {
			name = "Mission 4: Objective Hellgate",
			storageId = Storage.Quest.U8_1.SecretService.TBIMission04,
			missionId = 10200,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Your next mission is to investigate for some documents in Hellgate.",
				[2] = "You have delivered the documents to Chester, ask him for a new mission!",
			},
		},
		[11] = {
			name = "Mission 4: Pawn Captures Knight",
			storageId = Storage.Quest.U8_1.SecretService.AVINMission04,
			missionId = 10201,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Your next task is to travel to the Black Knight's Villa and kill the Black Knight!",
				[2] = "You have killed the Black Knight, report back to Uncle!",
				[3] = "You have reported back that you have completed your task, ask Uncle for a new mission!",
			},
		},
		[12] = {
			name = "Mission 4: Plot for A Plan",
			storageId = Storage.Quest.U8_1.SecretService.CGBMission04,
			missionId = 10202,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Emma has requested that you retrieve the Building Plans for a ship from the Venore shipyard.",
				[2] = "You have delivered the Building Plans to Emma, ask her for a new mission!",
			},
		},
		[13] = {
			name = "Mission 5: Coldfinger",
			storageId = Storage.Quest.U8_1.SecretService.TBIMission05,
			missionId = 10203,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Your next mission is to travel to the southern barbarians camp and place false evidence!",
				[2] = "You have placed the false evidence! Report back to Chester.",
				[3] = "You have reported back that you have completed your mission, ask Chester for a new mission!",
			},
		},
		[14] = {
			name = "Mission 5: A Cryptic Mission",
			storageId = Storage.Quest.U8_1.SecretService.AVINMission05,
			missionId = 10204,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Your next task is to travel to the Isle of the Kings and find a ring.",
				[2] = "You have delivered the ring to Uncle, ask him for a new mission!",
			},
		},
		[15] = {
			name = "Mission 5: No Admittance",
			storageId = Storage.Quest.U8_1.SecretService.CGBMission05,
			missionId = 10205,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Emma has requested that you find some hints in the ruins of Dark Cathedral.",
				[2] = "You have delivered the Suspicious Documents to Emma, ask her for a new mission!",
			},
		},
		[16] = {
			name = "Mission 6: The Weakest Spot",
			storageId = Storage.Quest.U8_1.SecretService.TBIMission06,
			missionId = 10206,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Your next mission is to disguise yourself as an amazon and destroy a \z
					beer casket in the north-east corner in the cellar of Svargrond's Tavern.",
				[2] = "You have succesfully destroyed the beer casket disguised as an amazon, report back to Chester!",
				[3] = "You have reported back that you have completed your mission, ask Chester for a new mission!",
			},
		},
		[17] = {
			name = "Mission 6: A Little Bribe Won't Hurt",
			storageId = Storage.Quest.U8_1.SecretService.AVINMission06,
			missionId = 10207,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Your next task is to bribe a barbarian in the large barbarian camp with a weapons crate.",
				[2] = "You have bribed Freezhild with the weapons create! Report back to Uncle.",
				[3] = "You have reported back that you have completed your task, ask Uncle for a new mission!",
			},
		},
		[18] = {
			name = "Mission 6: News From the Past",
			storageId = Storage.Quest.U8_1.SecretService.CGBMission06,
			missionId = 10208,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Emma has requested that you go to the Isle of the Kings and retrieve a book.",
				[2] = "You have delivered the book to Emma, ask her for a new mission!",
			},
		},
		[19] = {
			name = "Mission 7: Licence to Kill",
			storageId = Storage.Quest.U8_1.SecretService.Mission07,
			missionId = 10209,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "A Mad Technomancer in Kazordoon is trying to blackmail the city! \z
					Kill him and bring back his beard as proof.",
				[2] = "You have reported back that you have completed your mission, you are now a Special Agent!",
			},
		},
	},
}

return quest
