local quest = {
	name = "Tibia Tales",
	startStorageId = Storage.Quest.U8_1.TibiaTales.DefaultStart,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "To Appease the Mighty",
			storageId = Storage.Quest.U8_1.TibiaTales.ToAppeaseTheMightyQuest,
			missionId = 10317,
			startValue = 0,
			endValue = 4,
			states = {
				[1] = "Kazzan sent you to talk with Ubaid and Umar to offer an appeasement treaty to the Djinn races. \z
				Talk to Umar first.",
				[2] = "Umar said he won't be part of Kazzan's plans. Now you need to try with Ubaid.",
				[3] = "Umar and Ubaid said they won't be part of those plans. Return to Kazzan and collect your reward.",
				[4] = "You have completed the quest!",
			},
		},
		[2] = {
			name = "Arito's Task",
			storageId = Storage.Quest.U8_1.TibiaTales.AritosTask,
			missionId = 10318,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Arito asked you to make a peace agreement between him and the Nomads.",
				[2] = "Return to Arito and tell him the good news.",
				[3] = "Now Arito are safe and you have access to Nomads Cave.",
			},
		},
		[3] = {
			name = "Lion's Rock",
			storageId = Storage.Quest.U10_70.LionsRock.Questline,
			missionId = 10319,
			startValue = 1,
			endValue = 11,
			states = {
				[1] = function(player)
					return string.format(
						"You have discovered the Lion's Rock. If you pass the following tests you may enter the inner sanctum.\n\nThe Lion's Strength %d/1\nThe Lion's Beauty %d/1\nThe Lion's Tears %d/1",
						(math.max(player:getStorageValue(Storage.Quest.U10_70.LionsRock.OuterSanctum.LionsStrength), 0)),
						(math.max(player:getStorageValue(Storage.Quest.U10_70.LionsRock.OuterSanctum.LionsBeauty), 0)),
						(math.max(player:getStorageValue(Storage.Quest.U10_70.LionsRock.OuterSanctum.LionsTears), 0))
					)
				end,
				[2] = function(player)
					return string.format(
						"You have discovered the Lion's Rock. If you pass the following tests you may enter the inner sanctum.\n\nThe Lion's Strength %d/1\nThe Lion's Beauty %d/1\nThe Lion's Tears %d/1",
						(math.max(player:getStorageValue(Storage.Quest.U10_70.LionsRock.OuterSanctum.LionsStrength), 0)),
						(math.max(player:getStorageValue(Storage.Quest.U10_70.LionsRock.OuterSanctum.LionsBeauty), 0)),
						(math.max(player:getStorageValue(Storage.Quest.U10_70.LionsRock.OuterSanctum.LionsTears), 0))
					)
				end,
				[3] = function(player)
					return string.format(
						"You have discovered the Lion's Rock. If you pass the following tests you may enter the inner sanctum.\n\nThe Lion's Strength %d/1\nThe Lion's Beauty %d/1\nThe Lion's Tears %d/1",
						(math.max(player:getStorageValue(Storage.Quest.U10_70.LionsRock.OuterSanctum.LionsStrength), 0)),
						(math.max(player:getStorageValue(Storage.Quest.U10_70.LionsRock.OuterSanctum.LionsBeauty), 0)),
						(math.max(player:getStorageValue(Storage.Quest.U10_70.LionsRock.OuterSanctum.LionsTears), 0))
					)
				end,
				[4] = "You have passed the three tests of Lion's Rock and thus lit the three mystical pyramids. You may enter the inner sanctum now. - What other secrets could be hidden down there?",
				[5] = "You found a mysterious scroll in the debris of an old amphora. It seems it could help to translate the old temple inscriptions.",
				[6] = function(player)
					return string.format(
						"lions' enemies in this area of the temple. What could be the resolution?\n\nblood %d/1\negg %d/1\neye %d/1\npoison %d/1",
						(math.max(player:getStorageValue(Storage.Quest.U10_70.LionsRock.InnerSanctum.SnakeSign), 0)),
						(math.max(player:getStorageValue(Storage.Quest.U10_70.LionsRock.InnerSanctum.LizardSign), 0)),
						(math.max(player:getStorageValue(Storage.Quest.U10_70.LionsRock.InnerSanctum.ScorpionSign), 0)),
						(math.max(player:getStorageValue(Storage.Quest.U10_70.LionsRock.InnerSanctum.HyenaSign), 0))
					)
				end,
				[7] = function(player)
					return string.format(
						"lions' enemies in this area of the temple. What could be the resolution?\n\nblood %d/1\negg %d/1\neye %d/1\npoison %d/1",
						(math.max(player:getStorageValue(Storage.Quest.U10_70.LionsRock.InnerSanctum.SnakeSign), 0)),
						(math.max(player:getStorageValue(Storage.Quest.U10_70.LionsRock.InnerSanctum.LizardSign), 0)),
						(math.max(player:getStorageValue(Storage.Quest.U10_70.LionsRock.InnerSanctum.ScorpionSign), 0)),
						(math.max(player:getStorageValue(Storage.Quest.U10_70.LionsRock.InnerSanctum.HyenaSign), 0))
					)
				end,
				[8] = function(player)
					return string.format(
						"lions' enemies in this area of the temple. What could be the resolution?\n\nblood %d/1\negg %d/1\neye %d/1\npoison %d/1",
						(math.max(player:getStorageValue(Storage.Quest.U10_70.LionsRock.InnerSanctum.SnakeSign), 0)),
						(math.max(player:getStorageValue(Storage.Quest.U10_70.LionsRock.InnerSanctum.LizardSign), 0)),
						(math.max(player:getStorageValue(Storage.Quest.U10_70.LionsRock.InnerSanctum.ScorpionSign), 0)),
						(math.max(player:getStorageValue(Storage.Quest.U10_70.LionsRock.InnerSanctum.HyenaSign), 0))
					)
				end,
				[9] = 'In the north-west area of the Inner Sanctum, find the southern rectangular room to the south-west. In this room you will find 4 "sun" floor inscriptions as well as a rock in the center. The sun inscriptions represent gem slots.',
				[11] = "By solving the gem puzzle you unveiled the last secret of the Lion's Rock. You drew a treasure out of the ornamented fountain in the lower temple areas.",
			},
		},
		[4] = {
			name = "Against the Spider Cult",
			storageId = Storage.Quest.U8_1.TibiaTales.AgainstTheSpiderCult,
			missionId = 10320,
			startValue = 1,
			endValue = 6,
			states = {
				[1] = "Daniel Steelsoul in Edron wants you to infiltrate the Edron Orc Cave and destroy 4 Spider Eggs.",
				[2] = "You destroyed 1 of 4 Spider Eggs in the Edron Orc Cave",
				[3] = "You destroyed 2 of 4 Spider Eggs in the Edron Orc Cave",
				[4] = "You destroyed 3 of 4 Spider Eggs in the Edron Orc Cave",
				[5] = "You destroyed all Spider Eggs in the Edron Orc Cave, report back to Daniel Steelsoul!",
				[6] = "You have completed the Quest!",
			},
		},
		[5] = {
			name = "An Interest In Botany",
			storageId = Storage.Quest.U8_6.AnInterestInBotany.Questline,
			missionId = 10321,
			startValue = 1,
			endValue = 4,
			states = {
				[1] = "Rabaz in Farmine asked you to collect samples from rare plant specimen in Zao. \z
				Go to the storage room to the west and receive the Botany Almanach. \z
				Find then the Giant Dreadcoil and use your Obsidian Knife on it to obtain a sample.",
				[2] = "Now you must find the second plant, a Giant Verminous and use your \z
				Obsidian Knife on it to obtain a sample.",
				[3] = "You found the two samples, report back to Rabaz in Farmine!",
				[4] = "You have completed the Quest!",
			},
		},
		[6] = {
			name = "Graves Sanctified - In Progress",
			storageId = Storage.Quest.U8_1.RestInHallowedGround.HolyWater,
			missionId = 10322,
			startValue = 1,
			endValue = 15,
			description = function(player)
				return string.format("You sanctified %d of 15 graves.", (math.max(player:getStorageValue(Storage.Quest.U8_1.RestInHallowedGround.HolyWater), 0)))
			end,
		},
		[7] = {
			name = "Into the Bone Pit",
			storageId = Storage.Quest.U8_1.TibiaTales.IntoTheBonePit,
			missionId = 10323,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Search the Cursed Bone Pit in the dungeon north of Thais and dig for a \z
				well-preserved human bone for Muriel.",
				[2] = "You have found a desecrated bone for Muriel.",
				[3] = "You helped Muriel to obtain a desecrated bone.",
			},
		},
		[8] = {
			name = "Rest in Hallowed Ground",
			storageId = Storage.Quest.U8_1.RestInHallowedGround.Questline,
			missionId = 10324,
			startValue = 1,
			endValue = 5,
			states = {
				[1] = "Go to the white raven monastery and ask for some holy water for Amanda.",
				[2] = "You got the holy water from the white raven monastery. \z
				Go back to Amanda and report about your mission.",
				[3] = "Sanctify every single grave at the unholy graveyard north of Edron with the holy water.",
				[4] = "You have sanctified all graves at the unholy graveyard of Edron. Report about your mission at Amanda.",
				[5] = "You helped Amanda by sanctifying the cursed graveyard of Edron.",
			},
		},
		[9] = {
			name = "The Exterminator",
			storageId = Storage.Quest.U8_1.TibiaTales.TheExterminator,
			missionId = 10325,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Padreia in Carlin asked you to exterminate the slimes in the sewers of \z
				Carlin by poisoning their spawn pool.",
				[2] = "You poisoned the spawn pool of the slimes in the sewers of Carlin. \z
				Report to Padreia about your mission.",
				[3] = "You successfully helped Padreia in saving Carlin from a slimy disease.",
			},
		},
		[10] = {
			name = "The Ultimate Booze",
			storageId = Storage.Quest.U8_1.TibiaTales.UltimateBoozeQuest,
			missionId = 10326,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Boozer in Vernore asked you to bring him some special dwarven brown ale. \z
				You may find some in the brewery in Kazordoon.",
				[2] = "You found the special dwarven brown ale. Bring it to Boozer in Vernore.",
				[3] = "You have completed The Ultimate Booze Quest!",
			},
		},
		[11] = {
			name = "Jack to the Future",
			storageId = Storage.Quest.U8_7.JackFutureQuest.QuestLine,
			missionId = 10327,
			startValue = 1,
			endValue = 11,
			states = {
				[1] = "Spectulus told you about a failed experiment he once did, involving an intern \z
				named Jack, and asked you to help him rescue Jack. Go to Jack's house and talk to him \z
				about Spectulus.",
				[2] = "You have talked to Jack and found out that he is not remembering the time \z
				accident or Spectulus. Return to Spectulus in the Edron Academy to tell him about \z
				your findings.",
				[3] = "Spectulus wants you to trigger Jack's memory. Jack used to like his red cushioned \z
				chair, an old globe, a telescope, a large amphora and a rocking horse. Place those in his \z
				room and ask him about it.",
				[4] = "You have talked to Jack about the furniture you placed in his house. Report it back \z
				to Spectulus in the Edron Academy.",
				[5] = "Spectulus sent you once again to his former intern Jack. Explain the incident to the \z
				people close to him. Talk to Jack's mother and sister and return to Spectulus to report their reaction.",
				[6] = "You have talked with Jack's mother and sister. Report it back to Spectulus.",
				[7] = "Spectulus suggested asking Jack abouthis hobbies. Make Jack leave his hobby be by whateber \z
				means it takes. Only by doing this he will be separated from what distracts him from his former self.",
				[8] = "You found out and destroyed Jack's hobby. Jack is now finally ready and beginning to change. \z
				He event seems to start remembering Spectulus and the Academy.",
				[9] = "Jack is finally remembering Spectulus and the Academy. Report back your mission.",
				[10] = "Spectulus found out that you were convincing the wrong Jack. His real intern was transported \z
				way back to the past. He left a note years ago which, to your misery, reached Spectulus a little too late.",
				[11] = function(player)
					return string.format("%s", getJackLastMissionState(player))
				end,
			},
		},
		[12] = {
			name = "The Cursed Crystal",
			storageId = Storage.Quest.U10_70.TheCursedCrystal.Questline,
			missionId = 10328,
			startValue = 0,
			endValue = 4,
			states = {
				[0] = "A pirate told you about an evil artifact down in the crystal caves under Nargor.\z
				 It is a big crystal that affects the caves in a negative manner. Perhaps a jarring,\z
				very loud sound could destroy it.",
				[1] = "You found an old inscription to a mysterious recipe: 'vial of emb... fl... and \z
				mix ... a medusa's bl... Then ... the dust of ... crystal ... get Medusa's Ointm... able \z
				to unpetrify ...'",
				[2] = "You mixed the proper ingredients to create a special salve. The Medusa's Ointment. \z
				With this balm you may unpetrify a petrified object.",
				[3] = "With the Medusa's Ointment you unpetrified a banshee's scream near the evil crystal. \z
				Thus the baleful artefact was destroyed. You should return to One-Eyed Joe.",
				[4] = "You have completed the Quest!",
			},
		},
		[13] = {
			name = "Hidden Threats",
			storageId = Storage.Quest.U11_50.HiddenThreats.QuestLine,
			missionId = 10329,
			startValue = 1,
			endValue = 5,
			states = {
				[1] = "You have talked to Corym Ratter. He asked you to find the reason why the amount of  \z
				delivered ores is decreasing. You got access to the mine.",
				[2] = "You have met Corym Servant. He told you the true story of enslaved corym working under  \z
				terrible conditions. You have agreed to help him planing a riot. First you have to liberate his comrades.",
				[3] = "You have found two key fragments. They are quite rusted. It is necessary to remove the  \z
				rust before forging them together. You have to find a way to rebuild the key. This might open the doors.",
				[4] = "With the forged key you have unlocked the three areas. The Corym Servant was very relieved  \z
				and asked you to bring 20 units of rare earth.",
				[5] = "You have brought 20 units of rare earth to Corym Servant. He was very thankful and gave you  \z
				a reward. The revolution should now take place as intended.",
			},
		},
		[14] = {
			name = "To Outfox a Fox",
			storageId = Storage.Quest.U8_1.ToOutfoxAFoxQuest,
			missionId = 10432,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Budrik asked you to look for the hideout of the Horned Fox and bring his stolen mining helmet back. The Fox's lair is presumed to be west of Kazordoon near the coast.",
				[2] = "You succesfully helped Budrik in stealing back his old mining helemt.",
			},
		},
		[15] = {
			name = "Fish for a Serpent",
			storageId = Storage.Quest.U8_2.TheHuntForTheSeaSerpent.FishForASerpent,
			missionId = 10097,
			startValue = 1,
			endValue = 5,
			states = {
				[1] = "Your first task is to bring 5 fish.",
				[2] = "Your second task is to bring 5 northern pike.",
				[3] = "Your third task is to bring 5 green perch.",
				[4] = "Your forth task is to bring 5 rainbow trout.",
				[5] = "You bring enough fish to make the bait. Now you're ready for the hunt.",
			},
		},
		[16] = {
			name = "The hunt for the Sea Serpent",
			storageId = Storage.Quest.U8_2.TheHuntForTheSeaSerpent.QuestLine,
			missionId = 10098,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "",
				[2] = "You navigated the ship to the right location. You are now able to dive down and explore the caves.",
			},
		},
		-- [17] = {
		-- name = "Nomads Land",
		-- storageId = PLACEHOLDER,
		-- missionId = PLACEHOLDER,
		-- startValue = 1,
		-- endValue = 2,
		-- states = {
		-- [1] = "",
		-- [2] = ""
		-- }
		-- }
	},
}

return quest
