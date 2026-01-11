local quest = {
	name = "In Service of Yalahar",
	startStorageId = Storage.Quest.U8_4.InServiceOfYalahar.Questline,
	startStorageValue = 5,
	missions = {
		[1] = {
			name = "Mission 01: Something Rotten",
			storageId = Storage.Quest.U8_4.InServiceOfYalahar.Mission01,
			missionId = 1071,
			startValue = 1,
			endValue = 6,
			states = {
				[1] = "Palimuth asked you to help with some sewer malfunctions. \z
					You will need a Crowbar, there are 4 places where you need to go marked with an X on your map.",
				[2] = "You cleaned 1 pipe of 4 from the garbage.",
				[3] = "You cleaned 2 pipes of 4 from the garbage.",
				[4] = "You cleaned 3 pipes of 4 from the garbage.",
				[5] = "You cleaned 4 pipes of 4 from the garbage. Go back to Palimuth and report your mission",
				[6] = "You cleaned all pipes from the garbage! Go back to Palimuth and ask for mission.",
			},
		},
		[2] = {
			name = "Mission 02: Watching the Watchmen",
			storageId = Storage.Quest.U8_4.InServiceOfYalahar.Mission02,
			missionId = 1072,
			startValue = 1,
			endValue = 8,
			states = {
				[1] = "You have to find all 7 guards and give a report to them. \z
					You should start by Foreign Quarter or by Trade Quarter and follow the order of the path..",
				[2] = "You reported to 1 of 7 guards",
				[3] = "You reported to 2 of 7 guards",
				[4] = "You reported to 3 of 7 guards",
				[5] = "You reported to 4 of 7 guards",
				[6] = "You reported to 5 of 7 guards",
				[7] = "You reported to 6 of 7 guards",
				[8] = "You reported to 7 of 7 guards! Go back to Palimuth and ask for mission.",
			},
		},
		[3] = {
			name = "Mission 03: Death to the Deathbringer",
			storageId = Storage.Quest.U8_4.InServiceOfYalahar.Mission03,
			missionId = 1073,
			startValue = 1,
			endValue = 6,
			states = {
				[1] = "Get the notes in Palimuths room and read them. Talk to Palimuth again when you've read the notes.",
				[2] = "Talk to Azerus the Yalahari in the city centre to get your next mission.",
				[3] = "Get the notes behind the Yalahari and read them. \z
					Talk to Azerus again and ask him for mission when you've read the notes.",
				[4] = "Ask Palimuth for mission.",
				[5] = "First you will need to kill the three plague bearers and then get The Alchemists' Formulas. \z
						When this have been done head back to either Palimuth (good side) or Yalahari (Azerus) (bad side).",
				[6] = "Ask Azerus the Yalahari for a mission.",
			},
		},
		[4] = {
			name = "Mission 04: Good to be Kingpin",
			storageId = Storage.Quest.U8_4.InServiceOfYalahar.Mission04,
			missionId = 1074,
			startValue = 1,
			endValue = 6,
			states = {
				[1] = "Ask Palimuth for mission.",
				[2] = "For this mission you are asked to go to the Trade Quarter and negotiate or threaten Mr. West. \z
					Once again you will gain access to the mechanism although if you \z
					choose to help Palimuth you should go through the sewers.",
				[3] = "You decided to help Palimuth, report him your mission.",
				[4] = "You decided to help Azerus, report him your mission. ",
				[5] = "Get back to Azerus and report him your mission.",
				[6] = "Ask Azerus for a mission.",
			},
		},
		[5] = {
			name = "Mission 05: Food or Fight",
			storageId = Storage.Quest.U8_4.InServiceOfYalahar.Mission05,
			missionId = 1075,
			startValue = 1,
			endValue = 8,
			states = {
				[1] = "Ask Palimuth for mission.",
				[2] = "On this mission you are asked to find a druid by the name of Tamerin, on the Arena Quarter. \z
					You now have permission to use the gates mechanism.",
				[3] = "The first is to bring Tamerin a flask of Animal Cure, \z
					you can buy this from Siflind on Nibelor (northeast of Svargrond).",
				[4] = "now you have to kill Morik the Gladiator and bring his helmet to Tamerin as proof.",
				[5] = "Report back to Tamerin as he will listen to your request and you can now make your choice: \z
					Cattle for Palimuth (good side), Warbeasts for Yalahari (Azerus) (bad side). \z
					Then report the one you decided your mission.",
				[6] = "You decided to help Palimuth, report him your mission.",
				[7] = "You decided to help Azerus, report him your mission.",
				[8] = "Ask Azerus for a mission.",
			},
		},
		[6] = {
			name = "Mission 06: Frightening Fuel",
			storageId = Storage.Quest.U8_4.InServiceOfYalahar.Mission06,
			missionId = 1076,
			startValue = 1,
			endValue = 5,
			states = {
				[1] = "Ask Palimuth for mission.",
				[2] = "Yalahari (Azerus) orders you to travel to the Cemetery Quarter and find the Strange Carving. \z
					He gives you a Ghost Charm and tells you to charge it with the tormented souls of the ghosts there \z
					to be used as an energy source. Palimuth wants the Charged Ghost Charm in order to free those souls. \z
					You can new use the Cemetery Quarter mechanism now. Go to the big building in the Cemetery Quarter and \z
					use the Ghost Charm on the Strange Carving at the back of the room.",
				[3] = "Good side: Go to Palimuth, ask him about your mission, and hand in the charm. Bad side: \z
					Ask about your mission to Yalahari (Azerus) and give it back.",
				[4] = "Get back to Azerus and report him your mission.",
				[5] = "Ask Azerus for a mission.",
			},
		},
		[7] = {
			name = "Mission 07: A Fishy Mission",
			storageId = Storage.Quest.U8_4.InServiceOfYalahar.Mission07,
			missionId = 1077,
			startValue = 1,
			endValue = 5,
			states = {
				[1] = "Ask Palimuth for mission.",
				[2] = "Bad side: Yalahari (Azerus) will send you for a new mission to go to the Sunken Quarter and kill the \z
					Quara Leaders, Inky, Splasher and Sharptooth. Good side: Rather than fighting any Quara leaders Palimuth \z
					will instead send you to find the cause for the Quaras aggressive behavior. Find Maritima and talk to her \z
					about the Quara and she will explain what their problem is.",
				[3] = "Get back to Palimuth and report him your mission.",
				[4] = "You killed the Quarabosses. Ask Azerus for a mission.",
				[5] = "Ask Azerus for a mission.",
			},
		},
		[8] = {
			name = "Mission 08: Dangerous Machinations",
			storageId = Storage.Quest.U8_4.InServiceOfYalahar.Mission08,
			missionId = 1078,
			startValue = 1,
			endValue = 4,
			states = {
				[1] = "Ask Palimuth for mission.",
				[2] = "Bad side: For this mission the Yalahari requests you go to the Factory Quarter and \z
					find a pattern crystal, which will be used to supply weapons to help take control of the city. Good side: \z
					Palimuth will send you there to use the crystal to supply food for the city.",
				[3] = "Get back to Azerus and report him your mission.",
				[4] = "Ask Azerus for a mission.",
			},
		},
		[9] = {
			name = "Mission 09: Decision",
			storageId = Storage.Quest.U8_4.InServiceOfYalahar.Mission09,
			missionId = 1079,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "You now need to decide between supporting Palimuth or the Yalahari's goal. \z
					To choose Palimuth's good side go to him, and simply ask him for a mission mission. \z
					Likewise, to join the Yalahari (Azerus) (bad side) go to him and say the same.",
				[2] = "you already decided!",
			},
		},
		[10] = {
			name = "Mission 10: The Final Battle",
			storageId = Storage.Quest.U8_4.InServiceOfYalahar.Mission10,
			missionId = 1080,
			startValue = 1,
			endValue = 5,
			states = {
				[1] = "Palimuth told you that a circle of Yalahari is planning some kind of ritual. They plan to create \z
					a portal for some powerful demons and to unleash them in the city to 'purge' it once and for all.",
				[2] = "The entrance to their inner sanctum has been opened for you. \z
					Be prepared for a HARD battle! Better gather some friends to assist you.",
				[3] = "Report back to whichever principal you have chosen to help and you will receive Yalaharian Outfits.",
				[4] = "You got the access to the reward room. \z
					Choose carefully which reward you pick as you can only take one item.",
				[5] = "You have completed the Quest!",
			},
		},
	},
}

return quest
