local quest = {
	name = "What a foolish Quest",
	startStorageId = Storage.Quest.U8_1.WhatAFoolishQuest.Questline,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "What a foolish Quest - Tasks of a Fool",
			storageId = Storage.Quest.U8_1.WhatAFoolishQuest.Mission1,
			missionId = 10336,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Cut a flower at the Whiteflower Temple south of Thais. Then report to Bozo about your mission.",
				[2] = "You have finished your first mission and should ask Bozo for the next mission.",
			},
		},
		[2] = {
			name = "What a foolish Quest - That stinks!",
			storageId = Storage.Quest.U8_1.WhatAFoolishQuest.Mission2,
			missionId = 10337,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "It sometimes stinks to be a fool. \z
				Collect some noxious fumes from a recently slain slime with the special vial. \z
				Then report to Bozo about your mission.",
				[2] = "You have finished your second mission and should ask Bozo for the next mission.",
			},
		},
		[3] = {
			name = "What a foolish Quest - A Piece of Cake",
			storageId = Storage.Quest.U8_1.WhatAFoolishQuest.Mission3,
			missionId = 10338,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Get 12 pies from Mirabell in Edron. Then report to Bozo about your mission.",
				[2] = "You have finished your third mission and should ask Bozo for the next mission.",
			},
		},
		[4] = {
			name = "What a foolish Quest - Fool Spirits",
			storageId = Storage.Quest.U8_1.WhatAFoolishQuest.Mission4,
			missionId = 10339,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Get 18 vials of wine for Bozo. Then report to Bozo about your mission.",
				[2] = "Exchange the crates in front of Xodet's house and return to Bozo with the swapped crate.",
				[3] = "You have finished your fourth mission and should ask Bozo for the next mission.",
			},
		},
		[5] = {
			name = "What a foolish Quest - Watch out for the foolish",
			storageId = Storage.Quest.U8_1.WhatAFoolishQuest.Mission5,
			missionId = 10340,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Steal the magic watch from the Triangle Tower west of Jakundaf Desert. \z
				Then report to Bozo about your mission.",
				[2] = "Use the magic watch to steal the beard of the sleeping dwarven emperor.",
				[3] = "You have already finished five missions for that fool. \z
				You should definitely talk to Bozo about your jester outfit now!",
			},
		},
		[6] = {
			name = "What a foolish Quest - The queen of farts",
			storageId = Storage.Quest.U8_1.WhatAFoolishQuest.Mission6,
			missionId = 10341,
			startValue = 1,
			endValue = 5,
			states = {
				[1] = "Get Bozo 4 pieces of minotaur leather.",
				[2] = "Get Bozo a piece of giant spider silk.",
				[3] = "Ask Bozo about your mission, he might be finished with the whoopee cushion by now.",
				[4] = "Place the whoopee cushion on the queen's throne in Carlin by using the cushion with the throne.",
				[5] = "You have finished your sixth mission and should ask Bozo for the next mission.",
			},
		},
		[7] = {
			name = "What a foolish Quest - For your mice only",
			storageId = Storage.Quest.U8_1.WhatAFoolishQuest.Mission7,
			missionId = 10342,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Get the toy mouse of Queen Eloise's cat and show it to Carina, the jeweler in Venore, to scare her.",
				[2] = "You have finished your seventh mission and should ask Bozo for the next mission.",
			},
		},
		[8] = {
			name = "What a foolish Quest - Smoking is a foolish thing",
			storageId = Storage.Quest.U8_1.WhatAFoolishQuest.Mission8,
			missionId = 10343,
			startValue = 1,
			endValue = 5,
			states = {
				[1] = "Gather some easily inflammable sulphur using a spoon on an inactive lava hole.",
				[2] = "You brought Bozo the sulphur. Now cut him some leaves of the jungle dweller bush with a kitchen knife.",
				[3] = "You have gathered the ordered ingredients and should ask Bozo for the next mission.",
				[4] = "Deliver the exploding cigar to Theodore Loveless in Liberty Bay.",
				[5] = "You have finished your eighth mission and should ask Bozo for the next mission.",
			},
		},
		[9] = {
			name = "What a foolish Quest - A fool's bargain",
			storageId = Storage.Quest.U8_1.WhatAFoolishQuest.Mission9,
			missionId = 10344,
			startValue = 1,
			endValue = 5,
			states = {
				[1] = "Bozo wants you to fill a vial with the blood of a stalker. \z
				Use the vial on a slain stalker immediately after his death. Then report to Bozo about your mission.",
				[2] = "Bozo wants you to fill a vial with the ink of a quara constrictor. \z
				Use the vial on a slain constrictor immediately after its death. Then report to Bozo about your mission.",
				[3] = "You have gathered the ordered ingredients and should ask Bozo for the next mission.",
				[4] = "Order 2000 steel shields from Sam. Sign his contract with the magic ink.",
				[5] = "You have finished your ninth mission and should ask Bozo for the next mission.",
			},
		},
		[10] = {
			name = "What a foolish Quest - A sweet surprise",
			storageId = Storage.Quest.U8_1.WhatAFoolishQuest.Mission10,
			missionId = 10345,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Deliver a cookie to Avar Tar, Simon, Ariella, Lorbas, King Markwin, \z
				Hjaern, Wyda, Hairycles, the orc king and EITHER Yaman OR Nah'Bob. Then report to Bozo about the mission.",
				[2] = "You have finished your tenth mission and should ask Bozo for the next mission.",
			},
		},
		[11] = {
			name = "What a foolish Quest - The final foolishness",
			storageId = Storage.Quest.U8_1.WhatAFoolishQuest.Mission11,
			missionId = 10346,
			startValue = 1,
			endValue = 4,
			states = {
				[1] = "Gather 5 pieces of white cloth for Bozo. Then report about your mission.",
				[2] = "Travel to Darama and climb the highest point of the Plague Spike to give these pieces of white \z
				cloth an old and worn look. Some ancient altar should suit your needs best - use the white cloth on it.",
				[3] = "Use your mummy disguise to scare the caliph Kazzan in Darashia. \z
				DON'T use the disguise too early or you will fail the quest.",
				[4] = "You have finished all of Bozo's missions and you are a complete fool now. Yay!",
			},
		},
		[12] = {
			name = "What a foolish Quest - To become a complete fool",
			storageId = Storage.Quest.U8_1.WhatAFoolishQuest.JesterOutfit,
			missionId = 10347,
			startValue = 4,
			endValue = 4,
			states = {
				[4] = "Now that you have a basic outfit, you should talk to Bozo about your missions to gain further rewards.",
			},
		},
	},
}

return quest
