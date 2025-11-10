local quest = {
	name = "Killing in the Name of...",
	startStorageId = 100157,
	startStorageValue = 1,
	missions = {
		[1] = {
			name = "Paw and Fur - Hunting Elite",
			storageId = Storage.Quest.U8_5.KillingInTheNameOf.QuestLogEntry,
			missionId = 1081,
			startValue = 0,
			endValue = 1,
			description = function(player)
				return string.format("You joined the 'Paw and Fur - Hunting Elite'. Ask Grizzly Adams for some hunting tasks. You already gained %d points. You currently have %d boss points.", (math.max(player:getStorageValue(POINTSSTORAGE), 0)), (math.max(player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.BossPoints), 0)))
			end,
		},
		[2] = {
			name = "Paw and Fur - Rank: Huntsman",
			storageId = Storage.Quest.U8_5.KillingInTheNameOf.PawAndFurRank,
			missionId = 1082,
			startValue = 0,
			endValue = 1,
			description = "You have been promoted to the rank of a 'Huntsman' in the 'Paw and Fur - Hunting Elite'.",
		},
		[3] = {
			name = "Paw and Fur - Rank: Ranger",
			storageId = Storage.Quest.U8_5.KillingInTheNameOf.PawAndFurRank,
			missionId = 1083,
			startValue = 2,
			endValue = 3,
			description = "You have been promoted to the rank of a 'Ranger' in the 'Paw and Fur - Hunting Elite'.",
		},
		[4] = {
			name = "Paw and Fur - Rank: Big Game Hunter",
			storageId = Storage.Quest.U8_5.KillingInTheNameOf.PawAndFurRank,
			missionId = 1084,
			startValue = 4,
			endValue = 5,
			description = "You have been promoted to the rank of a 'Big Game Hunter' in the 'Paw and Fur - Hunting Elite'.",
		},
		[5] = {
			name = "Paw and Fur - Rank: Trophy Hunter",
			storageId = Storage.Quest.U8_5.KillingInTheNameOf.PawAndFurRank,
			missionId = 1085,
			startValue = 5,
			endValue = 6,
			description = "You have been promoted to the rank of a 'Trophy Hunter' in the 'Paw and Fur - Hunting Elite'.",
		},
		[6] = {
			name = "Paw and Fur - Rank: Elite Hunter",
			storageId = Storage.Quest.U8_5.KillingInTheNameOf.PawAndFurRank,
			missionId = 1086,
			startValue = 7,
			endValue = 8,
			description = "You have been promoted to the rank of a 'Elite Hunter' in the 'Paw and Fur - Hunting Elite'.",
		},
		[7] = { -- Grizzly Adams
			name = "Paw and Fur: Crocodiles",
			storageId = 65001,
			missionId = 1087,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format("You already hunted %d/300 crocodiles.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.CrocodileCount))
				end,
				[1] = "You successfully hunted 300 crocodiles. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 300 crocodiles.",
			},
		},
		[8] = {
			name = "Paw and Fur: Badgers",
			storageId = 65002,
			missionId = 1088,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format("You already hunted %d/300 badgers.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.BadgerCount))
				end,
				[1] = "You successfully hunted 300 badgers. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 300 badgers.",
			},
		},
		[9] = {
			name = "Paw and Fur: Tarantulas",
			storageId = 65003,
			missionId = 1089,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format("You already hunted %d/300 tarantulas.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.TarantulaCount))
				end,
				[1] = "You successfully hunted 300 tarantulas. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 300 tarantulas.",
			},
		},
		[10] = {
			name = "Paw and Fur: Carniphilas",
			storageId = 65004,
			missionId = 1090,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format("You already hunted %d/150 carniphilas.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.CarniphilasCount))
				end,
				[1] = "You successfully hunted 150 carniphilas. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 150 carniphilas.",
			},
		},
		[11] = {
			name = "Paw and Fur: Stone Golems",
			storageId = 65005,
			missionId = 1091,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format("You already hunted %d/200 stone golems.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.StoneGolemCount))
				end,
				[1] = "You successfully hunted 200 stone golems. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 200 stone golems.",
			},
		},
		[12] = {
			name = "Paw and Fur: Mammoths",
			storageId = 65006,
			missionId = 1092,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format("You already hunted %d/300 mammoths.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.MammothCount))
				end,
				[1] = "You successfully hunted 300 mammoths. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 300 mammoths.",
			},
		},
		[13] = {
			name = "Paw and Fur: Gnarlhounds",
			storageId = 65007,
			missionId = 1093,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format("You already hunted %d/300 gnarlhounds.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.GnarlhoundCount))
				end,
				[1] = "You successfully hunted 300 gnarlhounds. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 300 gnarlhounds.",
			},
		},
		[14] = {
			name = "Paw and Fur: Terramites",
			storageId = 65008,
			missionId = 1094,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format("You already hunted %d/300 terramites.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.TerramiteCount))
				end,
				[1] = "You successfully hunted 300 terramites. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 300 terramites.",
			},
		},
		[15] = {
			name = "Paw and Fur: Apes",
			storageId = 65009,
			missionId = 1095,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format(
						"You already hunted %d kongras, %d merlkins and %d sibangs. You are supposed to kill 300 apes in total.",
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.KongraCount),
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.MerlkinCount),
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.SibangCount)
					)
				end,
				[1] = "You successfully hunted 300 apes. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 300 apes.",
			},
		},
		[16] = {
			name = "Paw and Fur: Thornback Tortoises",
			storageId = 65010,
			missionId = 1096,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format("You already hunted %d/300 thornback tortoises.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.ThornbackTortoiseCount))
				end,
				[1] = "You successfully hunted 300 thornback tortoises. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 300 thornback tortoises.",
			},
		},
		[17] = {
			name = "Paw and Fur: Gargoyles",
			storageId = 65011,
			missionId = 1097,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format("You already hunted %d/300 gargoyles.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.GargoyleCount))
				end,
				[1] = "You successfully hunted 300 gargoyles. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 300 gargoyles.",
			},
		},
		[18] = {
			name = "Paw and Fur: Ice Golems",
			storageId = 65012,
			missionId = 1098,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format("You already hunted %d/300 ice golems.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.IceGolemCount))
				end,
				[1] = "You successfully hunted 300 ice golems. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 300 ice golems.",
			},
		},
		[19] = {
			name = "Paw and Fur: Quara Scouts",
			storageId = 65013,
			missionId = 1099,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format(
						"You already killed %d constrictor scouts, %d hydromancer scouts, %d mantassin scouts, %d pincher scouts and %d predator scouts. You are supposed to kill 400 in total.",
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.QuaraConstrictorScoutCount),
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.QuaraHydromancerScoutCount),
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.QuaramMntassinScoutCount),
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.QuaraPincherScoutCount),
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.QuaraPredatorScoutCount)
					)
				end,
				[1] = "You successfully hunted 400 quara scouts. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 400 quara scouts.",
			},
		},
		[20] = {
			name = "Paw and Fur: Mutated Rats",
			storageId = 65014,
			missionId = 10100,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format("You already hunted %d/400 mutated rats.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.MutatedRatCount))
				end,
				[1] = "You successfully hunted 400 mutated rats. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 400 mutated rats.",
			},
		},
		[21] = {
			name = "Paw and Fur: Ancient Scarabs",
			storageId = 65015,
			missionId = 10101,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format("You already hunted %d/250 ancient scarabs.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.AncientScarabCount))
				end,
				[1] = "You successfully hunted 250 ancient scarabs. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 250 ancient scarabs.",
			},
		},
		[22] = {
			name = "Paw and Fur: Wyverns",
			storageId = 65016,
			missionId = 10102,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format("You already hunted %d/300 wyverns.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.WyvernCount))
				end,
				[1] = "You successfully hunted 300 wyverns. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 300 wyverns.",
			},
		},
		[23] = {
			name = "Paw and Fur: Lancer Beetles",
			storageId = 65017,
			missionId = 10103,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format("You already hunted %d/300 lancer beetles.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.LancerBeetleCount))
				end,
				[1] = "You successfully hunted 300 lancer beetles. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 300 lancer beetles.",
			},
		},
		[24] = {
			name = "Paw and Fur: Wailing Widows",
			storageId = 65018,
			missionId = 10104,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format("You already hunted %d/400 wailing widows.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.WailingWidowCount))
				end,
				[1] = "You successfully hunted 400 wailing widows. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 400 wailing widows.",
			},
		},
		[25] = {
			name = "Paw and Fur: Killer Caimans",
			storageId = 65019,
			missionId = 10105,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format("You already hunted %d/250 killer caimans.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.KillerCaimanCount))
				end,
				[1] = "You successfully hunted 250 killer caimans. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 250 killer caimans.",
			},
		},
		[26] = {
			name = "Paw and Fur: Bonebeasts",
			storageId = 65020,
			missionId = 10106,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format("You already hunted %d/300 bonebeasts.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.BonebeastCount))
				end,
				[1] = "You successfully hunted 300 bonebeasts. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 300 bonebeasts.",
			},
		},
		[27] = {
			name = "Paw and Fur: Crystal Spiders",
			storageId = 65021,
			missionId = 10107,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format("You already hunted %d/300 crystal spiders.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.CrystalSpiderCount))
				end,
				[1] = "You successfully hunted 300 crystal spiders. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 300 crystal spiders.",
			},
		},
		[28] = {
			name = "Paw and Fur: Mutated Tigers",
			storageId = 65022,
			missionId = 10108,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format("You already hunted %d/300 mutated tigers.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.MutatedTigerCount))
				end,
				[1] = "You successfully hunted 300 mutated tigers. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 300 mutated tigers.",
			},
		},
		[29] = {
			name = "Paw and Fur: Underwater Quara",
			storageId = 65023,
			missionId = 10109,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format(
						"You already killed %d constrictors, %d hydromancers, %d mantassins, %d pinchers and %d predators. You are supposed to kill 600 in total.",
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.QuaraConstrictorCount),
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.QuaraHydromancerCount),
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.QuaraMantassinCount),
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.QuaraPincherCount),
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.QuaraPredatorCount)
					)
				end,
				[1] = "You successfully hunted 600 underwater quara. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 600 underwater quara.",
			},
		},
		[30] = {
			name = "Paw and Fur: Giant Spiders",
			storageId = 65024,
			missionId = 10110,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format("You already hunted %d/500 giant spiders.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.GiantSpiderCount))
				end,
				[1] = "You successfully hunted 500 giant spiders. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 500 giant spiders.",
			},
		},
		[31] = {
			name = "Paw and Fur: Werewolves",
			storageId = 65025,
			missionId = 10111,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format("You already hunted %d/300 werewolves.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.WerewolveCount))
				end,
				[1] = "You successfully hunted 300 werewolves. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 300 werewolves.",
			},
		},
		[32] = {
			name = "Paw and Fur: Nightmares",
			storageId = 65026,
			missionId = 10112,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format("You already hunted %d nightmares and %d nightmare scions. You are supposed to kill 400 in total.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.NightmareCount), player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.NightmareScionCount))
				end,
				[1] = "You successfully hunted 400 nightmares. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 400 nightmares.",
			},
		},
		[33] = {
			name = "Paw and Fur: Hellspawns",
			storageId = 65027,
			missionId = 10113,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format("You already hunted %d/600 hellspawns.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.HellspawnCount))
				end,
				[1] = "You successfully hunted 600 hellspawns. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 600 hellspawns.",
			},
		},
		[34] = {
			name = "Paw and Fur: Lizards",
			storageId = 65028,
			missionId = 10114,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format(
						"You already hunted %d Chosen, %d Dragon Priest, %d High Guard, %d Legionnaire and %d Zaogun. You are supposed to kill 800 high class lizards in total.",
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.LizardChosenCount),
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.LizardDragonPriestCount),
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.LizardHighGuardCount),
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.LizardLegionnaireCount),
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.LizardZaogunCount)
					)
				end,
				[1] = "You successfully hunted 800 high class lizards. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 800 high class lizards.",
			},
		},
		[35] = {
			name = "Paw and Fur: Stampors",
			storageId = 65029,
			missionId = 10115,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format("You already hunted %d/600 stampors.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.StamporCount))
				end,
				[1] = "You successfully hunted 600 stampors. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 600 stampors.",
			},
		},
		[36] = {
			name = "Paw and Fur: Brimstone Bugs",
			storageId = 65030,
			missionId = 10116,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format("You already hunted %d/500 brimstone bugs.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.BrimstoneBugCount))
				end,
				[1] = "You successfully hunted 500 brimstone bugs. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 500 brimstone bugs.",
			},
		},
		[37] = {
			name = "Paw and Fur: Mutated Bats",
			storageId = 65031,
			missionId = 10117,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format("You already hunted %d/400 mutated bats.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.MutatedBatCount))
				end,
				[1] = "You successfully hunted 400 mutated bats. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 400 mutated bats.",
			},
		},
		[38] = {
			name = "Paw and Fur: Hydras",
			storageId = 65032,
			missionId = 10118,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format("You already hunted %d/650 hydras.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.HydraCount))
				end,
				[1] = "You successfully hunted 650 hydras. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 650 hydras.",
			},
		},
		[39] = {
			name = "Paw and Fur: Serpent Spawns",
			storageId = 65033,
			missionId = 10119,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format("You already hunted %d/800 serpent spawns.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.SerpentSpawnCount))
				end,
				[1] = "You successfully hunted 800 serpent spawns. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 800 serpent spawns.",
			},
		},
		[40] = {
			name = "Paw and Fur: Medusae",
			storageId = 65034,
			missionId = 10120,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format("You already hunted %d/500 medusae.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.MedusaCount))
				end,
				[1] = "You successfully hunted 500 medusae. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 500 medusae.",
			},
		},
		[41] = {
			name = "Paw and Fur: Behemoths",
			storageId = 65035,
			missionId = 10121,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format("You already hunted %d/700 behemoths.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.BehemothCount))
				end,
				[1] = "You successfully hunted 700 behemoths. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 700 behemoths.",
			},
		},
		[42] = {
			name = "Paw and Fur: Sea Serpents",
			storageId = 65036,
			missionId = 10122,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format("You already hunted %d sea serpents and %d young sea serpents. You are supposed to kill 900 in total.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.SeaSerpentCount), player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.YoungSeaSerpentCount))
				end,
				[1] = "You successfully hunted 900 sea serpents. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 900 sea serpents.",
			},
		},
		[43] = {
			name = "Paw and Fur: Hellhounds",
			storageId = 65037,
			missionId = 10123,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format("You already hunted %d/250 hellhounds.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.HellhoundCount))
				end,
				[1] = "You successfully hunted 250 hellhounds. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 250 hellhounds.",
			},
		},
		[44] = {
			name = "Paw and Fur: Ghastly Dragons",
			storageId = 65038,
			missionId = 10124,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format("You already hunted %d/500 ghastly dragons.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.GhastlyDragonCount))
				end,
				[1] = "You successfully hunted 500 ghastly dragons. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 500 ghastly dragons.",
			},
		},
		[45] = {
			name = "Paw and Fur: Drakens",
			storageId = 65039,
			missionId = 10125,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format(
						"You already hunted %d draken abomination, %d draken elite, %d draken spellweaver and %d draken warmaster. You are supposed to kill 900 drakens in total.",
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.DrakenAbominationCount),
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.DrakenEliteCount),
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.DrakenSpellweaverCount),
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.DrakenWarmasterCount)
					)
				end,
				[1] = "You successfully hunted 900 drakens. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 900 drakens.",
			},
		},
		[46] = {
			name = "Paw and Fur: Destroyers",
			storageId = 65040,
			missionId = 10126,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format("You already hunted %d/650 destroyers.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.DestroyerCount))
				end,
				[1] = "You successfully hunted 650 destroyers. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 650 destroyers.",
			},
		},
		[47] = {
			name = "Paw and Fur: Undead Dragons",
			storageId = 65041,
			missionId = 10127,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format("You already hunted %d/400 undead dragons.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.UndeadDragonCount))
				end,
				[1] = "You successfully hunted 400 undead dragons. If you want to you may complete this task again.",
				[2] = "You succesfully hunted 400 undead dragons.",
			},
		},
		[48] = {
			name = "Paw and Fur: Demons",
			storageId = 65042,
			missionId = 10128,
			startValue = 0,
			endValue = 1,
			states = {
				[0] = function(player)
					return string.format("You already hunted %d/6666 demons.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.DemonCount))
				end,
				[1] = "You successfully hunted 6666 demons.",
			},
		},
		[49] = { -- Grizzly Adams Boss
			name = "Paw and Fur: The Snapper",
			storageId = 34100,
			missionId = 10129,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Grizzly told you about the Snapper, a crocodile that already killed many citizens of Port Hope. Try find its hideout and kill it.",
				[2] = "You have found the hideout of Snapper. Talk to Grizzly again.",
				[3] = "You've killed the Snapper and reported back to Grizzly.",
			},
		},
		[50] = {
			name = "Paw and Fur: Hide",
			storageId = 34101,
			missionId = 10130,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Grizzly told you about 'Hide', a tarantula that already killed many citizens. Try find its hideout and kill it.",
				[2] = "You have found the hideout of Hide. Talk to Grizzly again.",
				[3] = "You've killed Hide and reported back to Grizzly.",
			},
		},
		[51] = {
			name = "Paw and Fur: Deathbine",
			storageId = 34102,
			missionId = 10131,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Grizzly told you about 'Deathbine', a carniphila that already killed many citizens. Try find its hideout and kill it.",
				[2] = "You have found the hideout of Deathbine. Talk to Grizzly again.",
				[3] = "You've killed Deathbine and reported back to Grizzly.",
			},
		},
		[52] = {
			name = "Paw and Fur: The Bloodtusk",
			storageId = 34103,
			missionId = 10132,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Grizzly told you about the Bloodtusk, a mammoth that already killed many citizens. Try find its hideout and kill it.",
				[2] = "You have found the hideout of Bloodtusk. Talk to Grizzly again.",
				[3] = "You've killed the Bloodtusk and reported back to Grizzly.",
			},
		},
		[53] = {
			name = "Paw and Fur: Shardhead",
			storageId = 34104,
			missionId = 10133,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Grizzly told you about 'Shardhead', a ice golem that already killed many citizens. Try find its hideout and kill it.",
				[2] = "You have found the hideout of Shardhead. Talk to Grizzly again.",
				[3] = "You've killed Shardhead and reported back to Grizzly.",
			},
		},
		[54] = {
			name = "Paw and Fur: Esmerelda",
			storageId = 34105,
			missionId = 10134,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Grizzly told you about 'Esmerelda', a mutated rat that already killed many citizens. Try find its hideout and kill it.",
				[2] = "You have found the hideout of Esmerelda. Talk to Grizzly again.",
				[3] = "You've killed Esmerelda and reported back to Grizzly.",
			},
		},
		[55] = {
			name = "Paw and Fur: Fleshcrawler",
			storageId = 34106,
			missionId = 10135,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Grizzly told you about 'Fleshcrawler', a ancient scarab that already killed many citizens. Try find its hideout and kill it.",
				[2] = "You have found the hideout of Fleshcrawler. Talk to Grizzly again.",
				[3] = "You've killed Fleshcrawler and reported back to Grizzly.",
			},
		},
		[56] = {
			name = "Paw and Fur: Ribstride",
			storageId = 34107,
			missionId = 10136,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Grizzly told you about 'Ribstride', a bonebeast that already killed many citizens. Try find its hideout and kill it.",
				[2] = "You have found the hideout of Ribstride. Talk to Grizzly again.",
				[3] = "You've killed Ribstride and reported back to Grizzly.",
			},
		},
		[57] = {
			name = "Paw and Fur: Bloodweb",
			storageId = 34108,
			missionId = 10137,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Grizzly told you about 'Bloodweb', a crystal spider that already killed many citizens. Try find its hideout and kill it.",
				[2] = "You have found the hideout of Bloodweb. Talk to Grizzly again.",
				[3] = "You've killed Bloodweb and reported back to Grizzly.",
			},
		},
		[58] = {
			name = "Paw and Fur: Thul",
			storageId = 34109,
			missionId = 10138,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Grizzly told you about 'Thul', a quara that already killed many citizens. Try find its hideout and kill it.",
				[2] = "You have found the hideout of Thul. Talk to Grizzly again.",
				[3] = "You've killed Thul and reported back to Grizzly.",
			},
		},
		[59] = {
			name = "Paw and Fur: The Old Widow",
			storageId = 34110,
			missionId = 10139,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Grizzly told you about the Old Widow, a giant spider that already killed many citizens. Try find its hideout and kill it.",
				[2] = "You have found the hideout of Old Widow. Talk to Grizzly again.",
				[3] = "You've killed the Old Widow and reported back to Grizzly.",
			},
		},
		[60] = {
			name = "Paw and Fur: Hemming",
			storageId = 34111,
			missionId = 10140,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Grizzly told you about 'Hemming', a werewolf that already killed many citizens. Try find its hideout and kill it.",
				[2] = "You have found the hideout of Hemming. Talk to Grizzly again.",
				[3] = "You've killed Hemming and reported back to Grizzly.",
			},
		},
		[61] = {
			name = "Paw and Fur: Tormentor",
			storageId = 34112,
			missionId = 10141,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Grizzly told you about 'Tormentor', a nightmare that already killed many citizens. Try find its hideout and kill it.",
				[2] = "You have found the hideout of Tormentor. Talk to Grizzly again.",
				[3] = "You've killed Tormentor and reported back to Grizzly.",
			},
		},
		[62] = {
			name = "Paw and Fur: Flameborn",
			storageId = 34113,
			missionId = 10142,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Grizzly told you about 'Flameborn', a hellspawn that already killed many citizens. Try find its hideout and kill it.",
				[2] = "You have found the hideout of Flameborn. Talk to Grizzly again.",
				[3] = "You've killed Flameborn and reported back to Grizzly.",
			},
		},
		[63] = {
			name = "Paw and Fur: Fazzrah",
			storageId = 34114,
			missionId = 10143,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Grizzly told you about 'Fazzrah', a lizard that already killed many citizens. Try find its hideout and kill it.",
				[2] = "You have found the hideout of Fazzrah. Talk to Grizzly again.",
				[3] = "You've killed Fazzrah and reported back to Grizzly.",
			},
		},
		[64] = {
			name = "Paw and Fur: Tromphonyte",
			storageId = 34115,
			missionId = 10144,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Grizzly told you about 'Tromphonyte', a stampor that already killed many citizens. Try find its hideout and kill it.",
				[2] = "You have found the hideout of Tromphonyte. Talk to Grizzly again.",
				[3] = "You've killed Tromphonyte and reported back to Grizzly.",
			},
		},
		[65] = {
			name = "Paw and Fur: Sulphur Scuttler",
			storageId = 34116,
			missionId = 10145,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Grizzly told you about 'Sulphur Scuttler', a brimstone bug that already killed many citizens. Try find its hideout and kill it.",
				[2] = "You have found the hideout of Sulphur Scuttler. Talk to Grizzly again.",
				[3] = "You've killed Sulphur Scuttler and reported back to Grizzly.",
			},
		},
		[66] = {
			name = "Paw and Fur: Bruise Payne",
			storageId = 34117,
			missionId = 10146,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Grizzly told you about 'Bruise Payne', a mutated bat that already killed many citizens. Try find its hideout and kill it.",
				[2] = "You have found the hideout of Bruise Payne. Talk to Grizzly again.",
				[3] = "You've killed Bruise Payne and reported back to Grizzly.",
			},
		},
		[67] = {
			name = "Paw and Fur: The Many",
			storageId = 34118,
			missionId = 10147,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Grizzly told you about the Many, a hydra that already killed many citizens. Try find its hideout and kill it.",
				[2] = "You have found the hideout of Many. Talk to Grizzly again.",
				[3] = "You've killed the Many and reported back to Grizzly.",
			},
		},
		[68] = {
			name = "Paw and Fur: The Noxious Spawn",
			storageId = 34119,
			missionId = 10148,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Grizzly told you about the Noxious Spawn, a serpent spawn that already killed many citizens. Try find its hideout and kill it.",
				[2] = "You have found the hideout of Noxious Spawn. Talk to Grizzly again.",
				[3] = "You've killed the Noxious Spawn and reported back to Grizzly.",
			},
		},
		[69] = {
			name = "Paw and Fur: Gorgo",
			storageId = 34120,
			missionId = 10149,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Grizzly told you about 'Gorgo', a medusa that already killed many citizens. Try find its hideout and kill it.",
				[2] = "You have found the hideout of Gorgo. Talk to Grizzly again.",
				[3] = "You've killed Gorgo and reported back to Grizzly.",
			},
		},
		[70] = {
			name = "Paw and Fur: Stonecracker",
			storageId = 34121,
			missionId = 10150,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Grizzly told you about 'Stonecracker', a behemoth that already killed many citizens. Try find its hideout and kill it.",
				[2] = "You have found the hideout of Stonecracker. Talk to Grizzly again.",
				[3] = "You've killed Stonecracker and reported back to Grizzly.",
			},
		},
		[71] = {
			name = "Paw and Fur: Leviathan",
			storageId = 34122,
			missionId = 10151,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Grizzly told you about 'Leviathan', a sea serpent that already killed many citizens of Svargrond. Try find its hideout and kill it.",
				[2] = "You have found the hideout of Leviathan. Talk to Grizzly again.",
				[3] = "You've killed Leviathan and reported back to Grizzly.",
			},
		},
		[72] = {
			name = "Paw and Fur: Kerberos",
			storageId = 34123,
			missionId = 10152,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Grizzly told you about 'Kerberos', a hellhound that already killed many citizens. Try find its hideout and kill it.",
				[2] = "You have found the hideout of Kerberos. Talk to Grizzly again.",
				[3] = "You've killed Kerberos and reported back to Grizzly.",
			},
		},
		[73] = {
			name = "Paw and Fur: Ethershreck",
			storageId = 34124,
			missionId = 10153,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Grizzly told you about 'Ethershreck', a ghastly dragon that already killed many citizens. Try find its hideout and kill it.",
				[2] = "You have found the hideout of Ethershreck. Talk to Grizzly again.",
				[3] = "You've killed Ethershreck and reported back to Grizzly.",
			},
		},
		[74] = {
			name = "Paw and Fur: Paiz the Pauperizer",
			storageId = 34125,
			missionId = 10154,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Grizzly told you about 'Paiz the Pauperizer', a daunting draken that already killed many citizens. Try find its hideout and kill it.",
				[2] = "You have found the hideout of Paiz the Pauperizer. Talk to Grizzly again.",
				[3] = "You've killed Paiz the Pauperizer and reported back to Grizzly.",
			},
		},
		[75] = {
			name = "Paw and Fur: Bretzecutioner",
			storageId = 34126,
			missionId = 10155,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Grizzly told you about 'Bretzecutioner', a destroyer that already killed many citizens. Try find its hideout and kill it.",
				[2] = "You have found the hideout of Bretzecutioner. Talk to Grizzly again.",
				[3] = "You've killed Bretzecutioner and reported back to Grizzly.",
			},
		},
		[76] = {
			name = "Paw and Fur: Zanakeph",
			storageId = 34127,
			missionId = 10156,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "Grizzly told you about Zanakeph, an undead dragon that already killed many citizens. Try find its hideout and kill it.",
				[2] = "You have found the hideout of Zanakeph. Talk to Grizzly again.",
				[3] = "You've killed Zanakeph and reported back to Grizzly.",
			},
		},
		[77] = {
			name = "Paw and Fur: Tiquandas Revenge",
			storageId = Storage.Quest.U8_5.KillingInTheNameOf.MissionTiquandasRevenge,
			missionId = 10157,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "You have the special task to bring down Tiquanda's Revenge.",
				[2] = "You have fought 'Tiquanda's Revenge'. Report to Grizzly Adams about your special task.",
				[3] = "You found the hideout of Tiquanda's Revenge and managed to kill it.",
			},
		},
		[78] = {
			name = "Paw and Fur: Demodras",
			storageId = Storage.Quest.U8_5.KillingInTheNameOf.MissionDemodras,
			missionId = 10158,
			startValue = 1,
			endValue = 3,
			states = {
				[1] = "You have the special task to bring down Demodras.",
				[2] = "You have fought 'Demodras'. Report to Grizzly Adams about your special task.",
				[3] = "You found the hideout of Demodras and managed to kill it.",
			},
		},
		[79] = { -- Others
			name = "The Marid: Green Djinns",
			storageId = Storage.Quest.U8_5.KillingInTheNameOf.GreenDjinnTask,
			missionId = 10159,
			startValue = 0,
			endValue = 3,
			states = {
				[0] = function(player)
					return string.format("Gabel sent you to kill 500 green djinns or Efreet. You have killed %d green djinns and %d Efreet so far.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.GreenDjinnCount), player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.EfreetCount))
				end,
				[1] = "If you dare, you can try finding and fighting Merikh the Slaughterer.",
				[2] = "You faced Merikh the Slaughterer. Go back to Gabel.",
				[3] = "You've finished this task. If you want to kill green djinns or Efreet again, talk to Gabel about this task.",
			},
		},
		[80] = {
			name = "The Efreet: Blue Djinns",
			storageId = Storage.Quest.U8_5.KillingInTheNameOf.BlueDjinnTask,
			missionId = 10160,
			startValue = 0,
			endValue = 3,
			states = {
				[0] = function(player)
					return string.format("Malor sent you to kill 500 blue djinns or Marid. You have killed %d blue djinns and %d Marid so far.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.BlueDjinnCount), player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.MaridCount))
				end,
				[1] = "If you dare, you can try finding and fighting Fahim the wise.",
				[2] = "You faced Fahim the wise. Go back to Malor.",
				[3] = "You've finished this task. If you want to kill blue djinns or Marid again, talk to Malor about this task.",
			},
		},
		[81] = {
			name = "Meriana Rebels: Pirates",
			storageId = Storage.Quest.U8_5.KillingInTheNameOf.PirateTask,
			missionId = 10161,
			startValue = 0,
			endValue = 3,
			states = {
				[0] = function(player)
					return string.format(
						"Kill 3000 pirates in total to help the rebels on Meriana. So far, you have killed %d Marauders, %d Cutthroats, %d Buccaneers and %d Corsairs.",
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.PirateMarauderCount),
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.PirateCutthroadCount),
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.PirateBuccaneerCount),
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.PirateCorsairCount)
					)
				end,
				[1] = "You succesfully killed 3000 pirates. Striker sent you to find the secret hideout of the pirate leaders on Nargor and vanquish whoever you find inside.",
				[2] = "You discovered the secret hideout of a pirate leader. Talk to Ray Striker if you like.",
				[3] = "You succesfully killed 3000 pirates.",
			},
		},
		[82] = {
			name = "Turmoil of War",
			storageId = Storage.Quest.U8_5.KillingInTheNameOf.BudrikMinos,
			missionId = 10162,
			startValue = 0,
			endValue = 2,
			states = {
				[0] = function(player)
					return string.format(
						"Budrik asked you to kill 5000 minotaurs for him. You already killed %d minotaurs, %d minotaur guards, %d minotaur mages and %d minotaur archers.",
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.MinotaurCount),
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.MinotaurGuardCount),
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.MinotaurMageCount),
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.MinotaurArcherCount)
					)
				end,
				[1] = "Budrik found the hideout of The Horned Fox! You have a single chance of bringing him down. Go for it.",
				[2] = "You have slain 5000 minotaurs and fought The Horned Fox for Budrik and the whole dwarven kind.",
			},
		},
		[83] = {
			name = "Lugri: Necromancers and Priestesses",
			storageId = Storage.Quest.U8_5.KillingInTheNameOf.LugriNecromancers,
			missionId = 10163,
			startValue = 0,
			endValue = 4,
			states = {
				[0] = function(player)
					return string.format(
						"Lugri sent you to kill 4000 necromancers, though he said 'no reward'. So far you killed %d Necromancers, %d Priestesses, %d Blood Priests, %d Blood Hands and %d Shadow Pupils.",
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.NecromancerCount),
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.PriestessCount),
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.BloodPriestCount),
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.BloodHandCount),
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.ShadowPupilCount)
					)
				end,
				[1] = "If you dare, you can try finding and fighting Necropharus in his Halls of Sacrifice, deep under Drefia. Note that this will be the only time you're allowed to enter his room, so be well prepared.",
				[2] = "You faced Necropharus. Go back to Lugri if you like.",
				[3] = function(player)
					return string.format(
						"Lugri sent you to kill 1000 necromancers. So far you killed %d Necromancers, %d Priestesses, %d Blood Priests, %d Blood Hands and %d Shadow Pupils.",
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.NecromancerCount),
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.PriestessCount),
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.BloodPriestCount),
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.BloodHandCount),
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.ShadowPupilCount)
					)
				end,
				[4] = "You've finished this task - for now. If you want to kill the different necromancers and priestesses again for an experience and money bonus, talk to Lugri about this task.",
			},
		},
		[84] = {
			name = "Edron City: Trolls",
			storageId = Storage.Quest.U8_5.KillingInTheNameOf.TrollTask,
			missionId = 10164,
			startValue = 0,
			endValue = 1,
			states = {
				[0] = function(player)
					return string.format("Daniel Steelsoul sent you to kill 100 trolls, preferably west of Edron city. You have killed %d trolls and %d troll champions so far.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.TrollCount), player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.TrollChampionCount))
				end,
				[1] = "You succesfully killed 100 trolls. As long as you are level 20 or lower, you may repeat this task by talking to Daniel Steelsoul about it.",
			},
		},
		[85] = {
			name = "Edron City: Goblins",
			storageId = Storage.Quest.U8_5.KillingInTheNameOf.GoblinTask,
			missionId = 10165,
			startValue = 0,
			endValue = 1,
			states = {
				[0] = function(player)
					return string.format(
						"Daniel Steelsoul sent you to kill 150 goblins, preferably west of Edron city. You have killed %d goblins so far, %d goblin scavengers and %d goblin assassins.",
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.GoblinCount),
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.GoblinScavengerCount),
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.GoblinAssassinCount)
					)
				end,
				[1] = "You succesfully killed 150 goblins. As long as you are level 20 or lower, you may repeat this task by talking to Daniel Steelsoul about it.",
			},
		},
		[86] = {
			name = "Edron City: Rotworms",
			storageId = Storage.Quest.U8_5.KillingInTheNameOf.RotwormTask,
			missionId = 10166,
			startValue = 0,
			endValue = 1,
			states = {
				[0] = function(player)
					return string.format("Daniel Steelsoul sent you to kill 300 rotworms, preferably in their tunnels south of Edron city. You have killed %d rotworms and %d carrion worms so far.", player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.RotwormCount), player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.CarrionWormnCount))
				end,
				[1] = "You succesfully killed 300 rotworms. As long as you are level 40 or lower, you may repeat this task by talking to Daniel Steelsoul about it.",
			},
		},
		[87] = {
			name = "Edron City: Cyclops",
			storageId = Storage.Quest.U8_5.KillingInTheNameOf.CyclopsTask,
			missionId = 10167,
			startValue = 0,
			endValue = 1,
			states = {
				[0] = function(player)
					return string.format(
						"Daniel Steelsoul sent you to kill 500 cyclops, preferably in Cyclopolis north of Edron city. You have killed %d cyclops, %d drones and %d smiths so far.",
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.CyclopsCount),
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.CyclopsDroneCount),
						player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.CyclopsSmithCount)
					)
				end,
				[1] = "You succesfully killed 500 cyclops. As long as you are level 60 or lower, you may repeat this task by talking to Daniel Steelsoul about it.",
			},
		},
	},
}

return quest
