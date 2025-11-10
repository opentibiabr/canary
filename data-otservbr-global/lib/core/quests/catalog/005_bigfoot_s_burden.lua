local quest = {
	name = "Bigfoot's Burden",
	startStorageId = Storage.Quest.U9_60.BigfootsBurden.QuestLine,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "Looking for Gnomerik",
			storageId = Storage.Quest.U9_60.BigfootsBurden.QuestLine,
			missionId = 1033,
			startValue = 1,
			endValue = 2,
			description = "The dwarf Xelvar has sent you to meet the gnome Gnomerik. \z
				He can recruit you to the Bigfoot Company. \z
				Use the teleporter near Xelvar to enter the gnomish base and start looking for Gnomerik.",
		},
		[2] = {
			name = "A New Recruit",
			storageId = Storage.Quest.U9_60.BigfootsBurden.QuestLine,
			missionId = 1034,
			startValue = 3,
			endValue = 4,
			description = "You have found the gnomish recruiter and are ready to become a Bigfoot.",
		},
		[3] = {
			name = "Recruitment: A Test in Gnomology",
			storageId = Storage.Quest.U9_60.BigfootsBurden.QuestLine,
			missionId = 1035,
			startValue = 5,
			endValue = 7,
			states = {
				[5] = "Pass Gnomerik's test by answering his questions. \z
					If you fail to get a high enough score drink a mushroom beer and start again.",
				[6] = "You have passed the gnomish psychology test and can proceed to the medical exam. \z
					Talk to Gnomespector about your next examination.",
			},
		},
		[4] = {
			name = "Recruitment: Medical Examination",
			storageId = Storage.Quest.U9_60.BigfootsBurden.QuestLine,
			missionId = 1036,
			startValue = 8,
			endValue = 9,
			description = "Walk through the g-ray apparatus for your g-raying.",
		},
		[5] = {
			name = "Recruitment: Ear Examination",
			storageId = Storage.Quest.U9_60.BigfootsBurden.QuestLine,
			missionId = 1037,
			startValue = 10,
			endValue = 12,
			states = {
				[10] = "You have been g-rayed. It has been an ... unexpected experience. Now you are ready for your \z
					ear examination. Walk up to doctor Gnomedix and wait for him to finish your ear examination.",
				[11] = "You passed the ear examination. Well, at least most of you did. \z
					Now talk to Gnomaticus about your next test. ",
			},
		},
		[6] = {
			name = "Recruitment: Gnomish Warfare",
			storageId = Storage.Quest.U9_60.BigfootsBurden.Shooting,
			missionId = 1038,
			startValue = 0,
			endValue = 5,
			description = function(player)
				return string.format(
					"Hit five targets in a row. \z
				Don't hit an innocent target as it will reset your hit counter. %d / 5",
					(math.max(player:getStorageValue(Storage.Quest.U9_60.BigfootsBurden.Shooting), 0))
				)
			end,
		},
		[7] = {
			name = "Recruitment: Gnomish Warfare",
			storageId = Storage.Quest.U9_60.BigfootsBurden.QuestLine,
			missionId = 1039,
			startValue = 15,
			endValue = 16,
			description = "You are now ready for your endurance test. Talk to Gnomewart about it.",
		},
		[8] = {
			name = "Recruitment: Endurance Test",
			storageId = Storage.Quest.U9_60.BigfootsBurden.QuestLine,
			missionId = 1040,
			startValue = 17,
			endValue = 20,
			states = {
				[17] = "Enter the lower chamber for your endurance test. Reach the teleporter north of the hall.",
				[18] = "You have passed the endurance test. Report back to Gnomewart.",
				[19] = "You passed the endurance test and are ready to talk to Gnomelvis about your soul melody.",
			},
		},
		[9] = {
			name = "Recruitment: Soul Melody",
			storageId = Storage.Quest.U9_60.BigfootsBurden.QuestLine,
			missionId = 1041,
			startValue = 21,
			endValue = 23,
			states = {
				[21] = "Find your personal soul melody by trial and error. \z
					Create the complete soul melody of seven notes and then report to Gnomelvis. Red notes indicate a failure.",
				[22] = "You found your very own soul melody. You should talk to Gnomelvis about it!",
			},
		},
		[10] = {
			name = "Recruitment",
			storageId = Storage.Quest.U9_60.BigfootsBurden.QuestLineComplete,
			missionId = 1042,
			startValue = 1,
			endValue = 2,
			description = "You are now a true member of the Bigfoot company.",
		},
		[11] = {
			name = "Gnome Reputation",
			storageId = Storage.Quest.U9_60.BigfootsBurden.Rank,
			missionId = 1043,
			startValue = 0,
			endValue = 999999,
			description = function(player)
				return string.format(
					"Your reputation in the eyes of gnomekind is %d.\nYour standing rises at: \z
				\nReputation   30 - I \nReputation  120 - II \nReputation  480 - III \nReputation 1440 - IV \n",
					(math.max(player:getStorageValue(Storage.Quest.U9_60.BigfootsBurden.Rank), 0))
				)
			end,
		},
		[12] = {
			name = "Daily Minor: Crystal Keeper",
			storageId = Storage.Quest.U9_60.BigfootsBurden.RepairedCrystalCount,
			missionId = 1044,
			startValue = 0,
			endValue = 5,
			description = function(player)
				return string.format(
					"Use the repair crystal to repair five damaged blue crystals in the crystal caves. \z
				Damaged crystals will not glow.\n%d / 5",
					(math.max(player:getStorageValue(Storage.Quest.U9_60.BigfootsBurden.RepairedCrystalCount), 0))
				)
			end,
		},
		[13] = {
			name = "Daily Minor: Raiders of the Lost Spark",
			storageId = Storage.Quest.U9_60.BigfootsBurden.ExtractedCount,
			missionId = 1045,
			startValue = 0,
			endValue = 7,
			description = function(player)
				return string.format(
					"Kill crystal crushers and use the discharger item on the corpse to collect their charges. \z
				Gather 7 charges and report back. %d / 7",
					(math.max(player:getStorageValue(Storage.Quest.U9_60.BigfootsBurden.ExtractedCount), 0))
				)
			end,
		},
		[14] = {
			name = "Daily Minor Plus: Exterminators",
			storageId = Storage.Quest.U9_60.BigfootsBurden.ExterminatedCount,
			missionId = 1046,
			startValue = 0,
			endValue = 10,
			description = function(player)
				return string.format("Kill 10 of the wigglers for the gnomes. Then report back. %d / 10", (math.max(player:getStorageValue(Storage.Quest.U9_60.BigfootsBurden.ExterminatedCount), 0)))
			end,
		},
		[15] = {
			name = "Daily Minor Plus: Mushroom Digger",
			storageId = Storage.Quest.U9_60.BigfootsBurden.MushroomCount,
			missionId = 1047,
			startValue = 0,
			endValue = 3,
			description = function(player)
				return string.format(
					"Find a truffle sniffing pig and lure it around. \z
				Occasionally it will unearth some truffles. Use the baby pig on the truffles to feed it 3 times. \z
				Then report back to the gnomes. %d / 3",
					(math.max(player:getStorageValue(Storage.Quest.U9_60.BigfootsBurden.MushroomCount), 0))
				)
			end,
		},
		[16] = {
			name = "Daily Major: Matchmaker",
			storageId = Storage.Quest.U9_60.BigfootsBurden.MatchmakerStatus,
			missionId = 1048,
			startValue = 0,
			endValue = 1,
			states = {
				[0] = "You have to enter the crystal caves and find a crystal that is fitting the crystal you got \z
					from the gnomes. Use the crystal on one of the bigger red crystals in the caves to bond them.",
				[1] = "You have finished this quest for now.",
			},
		},
		[17] = {
			name = "Daily Major: The Tinker's Bell",
			storageId = Storage.Quest.U9_60.BigfootsBurden.GolemCount,
			missionId = 1049,
			startValue = 0,
			endValue = 4,
			description = function(player)
				return string.format(
					"Use the harmonic bell on the mad golems in the golem workshop so that they will \z
				automatically be teleported to the gnomish workshops. Then report back to the gnomes. %d / 4",
					(math.max(player:getStorageValue(Storage.Quest.U9_60.BigfootsBurden.GolemCount), 0))
				)
			end,
		},
		[18] = {
			name = "Daily Major Advanced: Spores",
			storageId = Storage.Quest.U9_60.BigfootsBurden.SporeCount,
			missionId = 1050,
			startValue = 0,
			endValue = 4,
			description = "Gather spores in the correct order. \z
				Your spore gathering list will display the next color you have to look for.",
		},
		[19] = {
			name = "Daily Major Advanced: Yet Another Grinding",
			storageId = Storage.Quest.U9_60.BigfootsBurden.GrindstoneStatus,
			missionId = 1051,
			startValue = 0,
			endValue = 2,
			description = "Gather a grindstone from the lava area en report back.",
		},
		[20] = {
			name = "Gnomish War Hero (Warzone 1)",
			storageId = Storage.Quest.U9_60.BigfootsBurden.Warzone1Access,
			missionId = 1052,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Deliver the Deathstrike's snippet to gnomission to enter the first warzone for free.",
				[2] = "You may enter the first warzone without using a mission crystal.",
			},
		},
		[21] = {
			name = "Gnomish War Hero (Warzone 2)",
			storageId = Storage.Quest.U9_60.BigfootsBurden.Warzone2Access,
			missionId = 1053,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Deliver the Gnomevil's hat to gnomission to enter the second warzone for free.",
				[2] = "You may enter the second warzone without using a mission crystal.",
			},
		},
		[22] = {
			name = "Gnomish War Hero (Warzone 3)",
			storageId = Storage.Quest.U9_60.BigfootsBurden.Warzone3Access,
			missionId = 1054,
			startValue = 1,
			endValue = 2,
			states = {
				[1] = "Deliver the Abyssador's lash to gnomission to enter the third warzone for free.",
				[2] = "You may enter the third warzone without using a mission crystal.",
			},
		},
	},
}

return quest
