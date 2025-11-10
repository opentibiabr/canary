local quest = {
	name = "The Ice Islands Quest",
	startStorageId = Storage.Quest.U8_0.TheIceIslands.Questline,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "Befriending the Musher",
			storageId = Storage.Quest.U8_0.TheIceIslands.Mission01,
			missionId = 10233,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Find Sniffler the husky of Iskan. He should be somewhere north west of the town. \z
					He is probably marking his territory so you should be able to find his trace. \z
					Call him sniffler and feed him with meat.",
				[2] = "Tell Iskan that you found and feed Sniffler",
				[3] = "You are now a friend of Iskan and can ask him for a passage to Nibelor. \z
					You should ask Hjaern in Nibelor if you can help him.",
			},
		},
		[2] = {
			name = "Nibelor 1: Breaking the Ice",
			storageId = Storage.Quest.U8_0.TheIceIslands.Mission02,
			missionId = 10234,
			startValue = 1,
			endValue = 5,
			states = {
				[1] = "Chakoyas may use the ice for a passage to the west and attack Svargrond. Use the rocks at east \z
					of nibelor on at least three of these places and the chakoyas probably won't be able to pass the ice.",
				[2] = "You have broke 1 of 3 icepassages",
				[3] = "You have broke 2 of 3 icepassages",
				[4] = "You have broke 3 of 3 icepassages! Tell Hjaern your mission!",
				[5] = "You should ask Silfind if you can help her in some matters.",
			},
		},
		[3] = {
			name = "Nibelor 2: Ecological Terrorism",
			storageId = Storage.Quest.U8_0.TheIceIslands.Mission03,
			missionId = 10235,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Siflind send you to travel to a distant land to get ants from an Ant-Hill to \z
					perform ecological terrorism on some pirates on Tyrsung. Just use the jug on an anthill.",
				[2] = "Now head back to Svargrond and go to Buddel, the drunk sailor in southern Svargrond, \z
					and ask him to take you to Tyrsung. Now go all the way to the southern shores \z
					where you find a outpost. Go to the bottom deck and use the jug with the western mast",
				[3] = "Go tell Siflind that you released the ants and aks her for mission!",
			},
		},
		[4] = {
			name = "Nibelor 3: Artful Sabotage",
			storageId = Storage.Quest.U8_0.TheIceIslands.Mission04,
			missionId = 10236,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Siflind gave you a Vial of Paint to use on some Baby Seals. \z
					Go back to Tyrsung and follow the shore from Buddel south. Use the Vial of Paint on three of these seals.",
				[2] = "Go tell Siflind that you painted the seals and aks her for mission!",
			},
		},
		[5] = {
			name = "Nibelor 4: Berserk Brewery",
			storageId = Storage.Quest.U8_0.TheIceIslands.Mission05,
			missionId = 10237,
			startValue = 1,
			endValue = 6,
			states = {
				[1] = "The first things needed are 5 bat wings to brew a berserker elixir. Bring her them!",
				[2] = "The next items Siflind need are 4 bear paws. Bring her them!",
				[3] = "The next items Siflind need are 3 bonelord eyes. Bring her them!",
				[4] = "The next items Siflind need are 2 fish fins. Bring her them!",
				[5] = "The next item Siflind need is a green dragon scale. Bring her that!",
				[6] = "You helped Siflind to defend Svargrond. Now Nilsor need help, go ask him for mission.",
			},
		},
		[6] = {
			name = "Nibelor 5: Cure the Dogs",
			storageId = Storage.Quest.U8_0.TheIceIslands.Mission06,
			missionId = 10238,
			startValue = 1,
			endValue = 8,
			states = {
				[1] = "To cure Nilsor dogs, bring him the 1st of 7 ingredients: a Part of the Sun Adorer Cactus. \z
					Only an ordinary kitchen knife will be precise enough to produce the ingredient weneed.",
				[2] = "To cure Nilsor dogs, bring him the 2nd of 7 ingredients: Geyser Water in a Waterskin. \z
					Use it on a geyser that is NOT active. The water of active geysers is far too hot.",
				[3] = "To cure Nilsor dogs, bring him the 3rd of 7 ingredients: Fine Sulphur. \z
					Use an ordinary kitchen spoon on an inactive lava hole.",
				[4] = "To cure Nilsor dogs, bring him the 4th of 7 ingredients: the Frostbite Herb. \z
					You can find it on mountain peaks. You will need to cut it with a fine kitchen knife.",
				[5] = "To cure Nilsor dogs, bring him the 5th of 7 ingredients: Purple Kiss Blossom. \z
					The purple kiss is a plant that grows in a place called jungle. \z
					You will have to use a kitchen knife to harvest its blossom.",
				[6] = "To cure Nilsor dogs, bring him the 6th of 7 ingredients: the Hydra Tongue. \z
					The hydra tongue is a common pest plant in warmer regions. You might find one in a shop.",
				[7] = "To cure Nilsor dogs, bring him the 7th of 7 ingredients: Spores of a Giant Glimmercap Mushroom. \z
					The giant glimmercap mushroom exists in caves and other preferably warm and humid places. \z
					Use an ordinary kitchen spoon on a mushroom to collectits spores.",
				[8] = "You found all ingredients to cure Nilsor dogs, ask him for mission. \z
				You can now travel by Dog Sleds to Inukaya.",
			},
		},
		[7] = {
			name = "The Secret of Helheim",
			storageId = Storage.Quest.U8_0.TheIceIslands.Mission07,
			missionId = 10239,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Hjaern might have a mission for you. So maybe you go and talk to him.",
				[2] = "Hjaern send you to find someone in Svargrond who can give you a passage to Helheim and seek the reason for the unrest there.",
				[3] = "You discovered the necromantic altar and should report Hjaern about it.",
			},
		},
		[8] = {
			name = "The Contact",
			storageId = Storage.Quest.U8_0.TheIceIslands.Mission08,
			missionId = 10240,
			startValue = 1,
			endValue = 4,
			states = {
				[1] = "Get out of Nibelor and go to the Svargrond Explorer's Society. Ask Lurik for the mission.",
				[2] = "Get to the raider camp, then follow to the extreme south where you find lots of barbarians. \z
				Near the southern most coastline, try looking for the NPC Nor. Ask him about Memory Crystal.",
				[3] = "Go back to Lurik and deliver him the memory crystal.",
				[4] = "Give Lurik some time to evaluate the information (ca. 5min). \z
				Then talk to him again about your mission.",
			},
		},
		[9] = {
			name = "Formorgar Mines 1: The Mission",
			storageId = Storage.Quest.U8_0.TheIceIslands.Mission09,
			missionId = 10241,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Find the entrance of the Formorgar Mines. \z
				Find some hint or someone who is willing to talk about what is going on there.",
				[2] = "You found a old and tattered written paper in a skeleton next to a Restless Soul, \z
				you can only make out a signature: Tylaf, apprentice of Hjaern. Ask Hjaern about Tylaf.",
			},
		},
		[10] = {
			name = "Formorgar Mines 2: Ghostwhisperer",
			storageId = Storage.Quest.U8_0.TheIceIslands.Mission10,
			missionId = 10242,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Go back to the mine and ask the restless soul about his story.",
				[2] = "You already have listen to his story!",
			},
		},
		[11] = {
			name = "Formorgar Mines 3: The Secret",
			storageId = Storage.Quest.U8_0.TheIceIslands.Mission11,
			missionId = 10243,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "The Cultists plan is to create a new demon army for their master to conquer the world. \z
				Hjaern and the other shamans must learn about it! Hurry before its too late.",
				[2] = "The Cultists plan is to create a new demon army for their master to conquer the world. \z
				Hjaern and the other shamans are already informed!",
			},
		},
		[12] = {
			name = "Formorgar Mines 4: Retaliation",
			storageId = Storage.Quest.U8_0.TheIceIslands.Mission12,
			missionId = 10244,
			startValue = 1,
			endValue = 6,
			states = {
				[1] = "Hjaern gave you a spirit charm of cold. Travel to the mines and find four \z
				special obelisks to mark them with the charm.",
				[2] = "1 of 4 obelisks are marked.",
				[3] = "2 of 4 obelisks are marked.",
				[4] = "3 of 4 obelisks are marked.",
				[5] = "Once all 4 obelisks are marked report back to Hjaern.",
				[6] = "You got the Norseman outfit and you have access to the Yakchal room deep in the Formorgar Mines.",
			},
		},
		[13] = {
			name = "Barbarian Test 1: Barbarian Booze",
			storageId = Storage.Quest.U8_0.BarbarianTest.Mission01,
			missionId = 1055,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "You participate in the drinking challenge. Now you can get the permission for a few sips of barbarian mead in exchange for some honey.",
				[2] = "Now drink from the bucket until you drink 10 sips in a row without passing out",
				[3] = "You have mastered the first task of the barbarian test. If you haven't done so yet, talk to Sven about it.",
			},
		},
		[14] = {
			name = "Barbarian Test 2: The Bear Hugging",
			storageId = Storage.Quest.U8_0.BarbarianTest.Mission02,
			missionId = 1056,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Somewhere north of Svargrond you will find a lonely bear which you have to hug. You wonder what you were thinking when accepting this quest...",
				[2] = "You passed the bear hugging test (and should take a bath). If you haven't done so yet, talk to Sven about it.",
			},
		},
		[15] = {
			name = "Barbarian Test 3: The Mammoth Pushing",
			storageId = Storage.Quest.U8_0.BarbarianTest.Mission03,
			missionId = 1057,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Find a mammoth north-west of Svargrond and knock it over. You wonder whether your mission is becoming a barbarian or rather commiting suicide.",
				[2] = "You have knocked over a mammoth - though you wonder what this crushing noise at your spine was. If you haven't done so yet, talk to Sven about the mammoth pushing.",
			},
		},
		[16] = {
			name = "The Honorary Barbarian",
			storageId = Storage.Quest.U8_0.BarbarianTest.Questline,
			missionId = 10099,
			startValue = 8,
			endValue = 8,
			states = {
				[8] = "You are now a honorary barbarian and can become a citizen of Svargrond. If you haven't done so yet, you should look for a barbarian in need of help in the north of the town.",
			},
		},
	},
}

return quest
