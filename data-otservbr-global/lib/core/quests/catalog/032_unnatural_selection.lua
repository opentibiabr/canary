local quest = {
	name = "Unnatural Selection",
	startStorageId = Storage.Quest.U8_54.UnnaturalSelection.Questline,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "Mission 1: Skulled",
			storageId = Storage.Quest.U8_54.UnnaturalSelection.Mission01,
			missionId = 10330,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Your mission is to find the Holy Skull. It is in a cave in the northern orc settlement, \z
				which is located north-west on the Zao Steppe.",
				[2] = "You found the Holy Skull. Retrieve it to Lazaran in the Zao Mountains.",
				[3] = "You brought Lazaran the Holy Skull. Ask him for new mission!",
			},
		},
		[2] = {
			name = "Mission 2: All Around the World",
			storageId = Storage.Quest.U8_54.UnnaturalSelection.Mission02,
			missionId = 10331,
			startValue = 1,
			endValue = 13,
			states = {
				[1] = "You received the Skull of a Caveman and need to explore the world, letting the skull see everything. \z
				You need to stand at the highest place of Edron.",
				[2] = "You received the Skull of a Caveman and need to explore the world, letting the skull see everything. \z
				You need to stand at the highest place of Ab'dendriel.",
				[3] = "You received the Skull of a Caveman and need to explore the world, letting the skull see everything. \z
				You need to stand at the highest place of Femor Hills.",
				[4] = "You received the Skull of a Caveman and need to explore the world, letting the skull see everything. \z
				You need to stand at the highest place of Darashia",
				[5] = "You received the Skull of a Caveman and need to explore the world, letting the skull see everything. \z
				You need to stand at the highest place of Ankrahmun",
				[6] = "You received the Skull of a Caveman and need to explore the world, letting the skull see everything. \z
				You need to stand at the highest place of Port Hope",
				[7] = "You received the Skull of a Caveman and need to explore the world, letting the skull see everything. \z
				You need to stand at the highest place of Liberty Bay",
				[8] = "You received the Skull of a Caveman and need to explore the world, letting the skull see everything. \z
				You need to stand at the highest place of Yalahar",
				[9] = "You received the Skull of a Caveman and need to explore the world, letting the skull see everything. \z
				You need to stand at the highest place of Svargrond",
				[10] = "You received the Skull of a Caveman and need to explore the world, letting the skull see everything. \z
				You need to stand at the highest place of Thais",
				[11] = "You received the Skull of a Caveman and need to explore the world, letting the skull see everything. \z
				You need to stand at the highest place of Carlin",
				[12] = "You visited all the highest places with the skull. \z
				Turn the skull back to Lazaran and report him your mission!",
				[13] = "You turned the skull already back to Lazaran. Ask him for new mission!",
			},
		},
		[3] = {
			name = "Mission 3: Dance Dance Evolution",
			storageId = Storage.Quest.U8_54.UnnaturalSelection.Mission03,
			missionId = 10332,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Lazaran told you to go to Ulala, who is located above Lazaran.",
				[2] = "Ulala told you to dance to please their god Krunus. \z
				On the south mountain in the camp you will find the Krunus altar, there are lots of leaves on the ground.",
				[3] = "You solved the dance. Head back to Ulala and report your mission!",
			},
		},
		[4] = {
			name = "Mission 4: Bits and Pieces",
			storageId = Storage.Quest.U8_54.UnnaturalSelection.Mission04,
			missionId = 10333,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Now the god Krunus is pleased, another god called Pandor needs to be pleased. \z
				Ulala wants you to collect 5 Orc Teeth, 5 Minotaur leathers and 5 Lizard Leathers. Bring them to her.",
				[2] = "You brought Ulala 5 Orc Teeth, 5 Minotaur leathers and 5 Lizard Leathers. Ask her for new mission!",
			},
		},
		[5] = {
			name = "Mission 5: Ray of Light",
			storageId = Storage.Quest.U8_54.UnnaturalSelection.Mission05,
			missionId = 10334,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "The third god which needs to be pleased is called Fasuon. \z
				Find the great crystal on top of mountain of Fasuon and pray there for his support!",
				[2] = "You already prayed at the great crystal. Report it to Ulala",
				[3] = "You have reported back to Ulala that you have completed the mission.",
			},
		},
		[6] = {
			name = "Mission 6: Firewater Burn",
			storageId = Storage.Quest.U8_54.UnnaturalSelection.Mission06,
			missionId = 10335,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Speak with Lazaran and tell the gods are pleased now.",
				[2] = "Bring Lazaran a Pot of brown water for a party after the great hunt.",
				[3] = "You brought Lazaran the beer and got a Serpent Crest as reward!",
			},
		},
	},
}

return quest
