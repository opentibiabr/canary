local quest = {
	name = "The Ancient Tombs",
	startStorageId = Storage.Quest.U7_4.TheAncientTombs.DefaultStart,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "Omruc's Treasure",
			storageId = Storage.Quest.U7_4.TheAncientTombs.OmrucsTreasure,
			missionId = 10210,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Now you can start the steps until you reach Omruc's room.",
				[2] = "You defeated Omruc and received a helmet adornment.",
			},
		},
		[2] = {
			name = "Thalas' Treasure",
			storageId = Storage.Quest.U7_4.TheAncientTombs.ThalasTreasure,
			missionId = 10211,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Congratulations, you have pulled all 8 levers and can now continue to the next step.",
				[2] = "You defeated Thalas and received a Gem Holder",
			},
		},
		[3] = {
			name = "Diphtrah's Treasure",
			storageId = Storage.Quest.U7_4.TheAncientTombs.DiphtrahsTreasure,
			missionId = 10212,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Now you need to pull all 11 levers to be able to continue.",
				[2] = "Now you need to use all the plaques before accessing Diphtrah's room.",
				[3] = "Congratulations, this step has been completed.",
			},
		},
		[4] = {
			name = "Mahrdis' Treasure",
			storageId = Storage.Quest.U7_4.TheAncientTombs.MahrdisTreasure,
			missionId = 10213,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "You need to defeat Mahrdis and receive a Helmet Ornament.",
				[2] = "You defeated Mahrdis and received a Helmet Ornament.",
			},
		},
		[5] = {
			name = "Vashresamun's Treasure",
			storageId = Storage.Quest.U7_4.TheAncientTombs.VashresamunsTreasure,
			missionId = 10214,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Once you've started this quest, you'll need to play the musicals before teleporting.",
				[2] = "Congratulations, you played the musical correctly, now you can continue.",
				[3] = "You solved the musical riddles of Vashresamun's Tomb and received a left horn.",
			},
		},
		[6] = {
			name = "Morguthis' Treasure",
			storageId = Storage.Quest.U7_4.TheAncientTombs.MorguthisTreasure,
			missionId = 10215,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Now you need to go over the blue fireworks on the path.",
				[2] = "You defeated Morguthis and received a Right Horn.",
			},
		},
		[7] = {
			name = "Rahemos' Treasure",
			storageId = Storage.Quest.U7_4.TheAncientTombs.RahemosTreasure,
			missionId = 10216,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "You have started the steps to access Rahemos' room, and you will need to pull some levers to get to Rahemos' room.",
				[2] = "You defeated Rahemos and received a Helmet Piece.",
			},
		},
	},
}

return quest
