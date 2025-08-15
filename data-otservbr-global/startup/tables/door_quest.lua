--[[

Look README.md for look the reserved action/unique

]]
QuestDoorAction = {
	-- The queens of the banshee door
	[Storage.Quest.U7_2.TheQueenOfTheBanshees.BansheeDoor] = {
		itemId = 5113,
		itemPos = {
			{ x = 32246, y = 31861, z = 14 },
			{ x = 32246, y = 31862, z = 14 },
		},
	},
	[Storage.Quest.U7_2.TheQueenOfTheBanshees.FirstSealDoor] = {
		itemId = 5104,
		itemPos = { { x = 32223, y = 31872, z = 14 } },
	},
	[Storage.Quest.U7_2.TheQueenOfTheBanshees.SecondSealDoor] = {
		itemId = 5104,
		itemPos = { { x = 32223, y = 31875, z = 14 } },
	},
	[Storage.Quest.U7_2.TheQueenOfTheBanshees.ThirdSealDoor] = {
		itemId = 5104,
		itemPos = { { x = 32223, y = 31878, z = 14 } },
	},
	[Storage.Quest.U7_2.TheQueenOfTheBanshees.FourthSealDoor] = {
		itemId = 5104,
		itemPos = { { x = 32223, y = 31881, z = 14 } },
	},
	[Storage.Quest.U7_2.TheQueenOfTheBanshees.FifthSealDoor] = {
		itemId = 5104,
		itemPos = { { x = 32223, y = 31884, z = 14 } },
	},
	[Storage.Quest.U7_2.TheQueenOfTheBanshees.SixthSealDoor] = {
		itemId = 5104,
		itemPos = { { x = 32223, y = 31887, z = 14 } },
	},
	[Storage.Quest.U7_2.TheQueenOfTheBanshees.LastSealDoor] = {
		itemId = 5104,
		itemPos = { { x = 32223, y = 31890, z = 14 } },
	},
	-- Sams old backpack door
	[Storage.Quest.U7_5.SamsOldBackpack.SamsOldBackpackDoor] = {
		itemId = false,
		itemPos = { { x = 32455, y = 31967, z = 14 } },
	},
	-- To Outfox a Fox Quest, mining helmet door
	[Storage.Quest.U8_1.ToOutfoxAFoxQuest.Questline] = {
		itemId = false,
		itemPos = { { x = 32467, y = 31969, z = 5 } },
	},
	-- Rathleton quest door
	[Storage.HeroRathleton.AccessDoor] = {
		itemId = false,
		itemPos = {
			{ x = 33567, y = 31951, z = 14 },
			{ x = 33569, y = 31951, z = 14 },
		},
	},
	-- Koshei the deathless quest door
	[Storage.Quest.U8_1.KosheiTheDeathless.RewardDoor] = {
		itemId = false,
		itemPos = { { x = 33269, y = 32446, z = 12 } },
	},
	-- Beggar outfit quest door
	[Storage.Quest.U7_8.BeggarOutfits.BeggarFirstAddonDoor] = {
		itemId = false,
		itemPos = { { x = 33165, y = 31600, z = 15 } },
	},
	-- The explorer society quest doors
	-- Mission in Dwacatra
	[Storage.Quest.U7_6.ExplorerSociety.DwacatraDoor] = {
		itemId = false,
		itemPos = { { x = 32598, y = 31933, z = 15 } },
	},
	-- Mission in Chor
	[Storage.Quest.U7_6.ExplorerSociety.ChorurnDoor] = {
		itemId = false,
		itemPos = { { x = 32957, y = 32835, z = 8 } },
	},
	-- Mission in Dark Pyramid
	[Storage.Quest.U7_6.ExplorerSociety.BonelordsDoor] = {
		itemId = false,
		itemPos = { { x = 33308, y = 32280, z = 12 } },
	},
	-- Mission in Orc Fortress
	[Storage.Quest.U7_6.ExplorerSociety.OrcDoor] = {
		itemId = false,
		itemPos = { { x = 32967, y = 31720, z = 2 } },
	},
	-- Mission in Hell Gate
	[Storage.Quest.U7_6.ExplorerSociety.ElvenDoor] = {
		itemId = false,
		itemPos = { { x = 32703, y = 31605, z = 14 } },
	},
	-- Mission in Endron
	[Storage.Quest.U7_6.ExplorerSociety.MemoryStoneDoor] = {
		itemId = false,
		itemPos = { { x = 33151, y = 31640, z = 11 } },
	},
	-- Mission in Isle of Kings
	[Storage.Quest.U7_6.ExplorerSociety.BansheeDoor] = {
		itemId = false,
		itemPos = { { x = 32259, y = 31948, z = 14 } },
	},
	-- Astral Bridge from Port Hope to Northport
	[Storage.Quest.U7_6.ExplorerSociety.SpectralStoneDoor] = {
		itemId = false,
		itemPos = {
			{ x = 32665, y = 32734, z = 6 },
			{ x = 32500, y = 31622, z = 6 },
		},
	},
	-- Astral Bridge from Svargrond to Liberty Bay
	[Storage.Quest.U7_6.ExplorerSociety.IceMusicDoor] = {
		itemId = false,
		itemPos = {
			{ x = 32318, y = 31137, z = 6 },
			{ x = 32360, y = 32808, z = 6 },
		},
	},
	-- Mission in Calassa
	[Storage.Quest.U7_6.ExplorerSociety.CalassaDoor] = {
		itemId = false,
		itemPos = { { x = 31939, y = 32771, z = 13 } },
	},
	-- The war djin quest
	-- Marid faction
	[Storage.Quest.U7_4.DjinnWar.Faction.MaridDoor] = {
		itemId = false,
		itemPos = { { x = 33106, y = 32532, z = 6 } },
	},
	[Storage.Quest.U7_4.DjinnWar.Faction.EfreetDoor] = {
		itemId = false,
		itemPos = { { x = 33047, y = 32626, z = 6 } },
	},
	[Storage.Quest.U7_4.DjinnWar.MaridFaction.DoorToLamp] = {
		itemId = false,
		itemPos = { { x = 33038, y = 32632, z = 1 } },
	},
	[Storage.Quest.U7_4.DjinnWar.MaridFaction.DoorToEfreetTerritory] = {
		itemId = false,
		itemPos = {
			{ x = 33034, y = 32620, z = 6 },
			{ x = 32869, y = 31105, z = 7 },
			{ x = 32869, y = 31106, z = 7 },
		},
	},
	-- Efreet faction
	[Storage.Quest.U7_4.DjinnWar.EfreetFaction.DoorToLamp] = {
		itemId = false,
		itemPos = { { x = 33097, y = 32531, z = 1 } },
	},
	[Storage.Quest.U7_4.DjinnWar.EfreetFaction.DoorToMaridTerritory] = {
		itemId = false,
		itemPos = {
			{ x = 33100, y = 32518, z = 7 },
			{ x = 32821, y = 31112, z = 7 },
			{ x = 32822, y = 31112, z = 7 },
		},
	},
	-- Bigfoot burden quest
	[Storage.Quest.U9_60.BigfootsBurden.DoorGoldenFruits] = {
		itemId = false,
		itemPos = { { x = 32822, y = 31745, z = 10 } },
	},
	-- Dawnport door key 0010 (npcs dormitory)
	[103] = {
		itemId = false,
		itemPos = { { x = 32067, y = 31896, z = 3 } },
	},
	-- Cults of tibia door
	[Storage.Quest.U11_40.CultsOfTibia.Minotaurs.BossAccessDoor] = {
		itemId = false,
		itemPos = { { x = 31957, y = 32468, z = 9 } },
	},
	[Storage.Quest.U11_40.CultsOfTibia.Minotaurs.AccessDoor] = {
		itemId = false,
		itemPos = { { x = 31950, y = 32501, z = 8 } },
	},
	[Storage.Quest.U11_40.CultsOfTibia.MotA.AccessDoorInvestigation] = {
		itemId = false,
		itemPos = { { x = 33273, y = 32172, z = 8 } },
	},
	[Storage.Quest.U11_40.CultsOfTibia.MotA.AccessDoorGareth] = {
		itemId = false,
		itemPos = { { x = 33220, y = 32147, z = 9 } },
	},
	[Storage.Quest.U11_40.CultsOfTibia.MotA.AccessDoorDenominator] = {
		itemId = false,
		itemPos = { { x = 33220, y = 32149, z = 9 } },
	},
	[Storage.Quest.U11_40.CultsOfTibia.Barkless.TrialAccessDoor] = {
		itemId = false,
		itemPos = { { x = 32688, y = 31543, z = 9 } },
	},
	[Storage.Quest.U11_40.CultsOfTibia.Barkless.TarAccessDoor] = {
		itemId = false,
		itemPos = { { x = 32747, y = 31462, z = 8 } },
	},
	[Storage.Quest.U11_40.CultsOfTibia.Barkless.SulphurAccessDoor] = {
		itemId = false,
		itemPos = { { x = 32678, y = 31506, z = 8 } },
	},
	[Storage.Quest.U11_40.CultsOfTibia.Barkless.AccessDoor] = {
		itemId = false,
		itemPos = {
			{ x = 32686, y = 31430, z = 8 },
			{ x = 32746, y = 31423, z = 8 },
			{ x = 32754, y = 31442, z = 8 },
		},
	},
	[Storage.Quest.U11_40.CultsOfTibia.Barkless.BossAccessDoor] = {
		itemId = false,
		itemPos = { { x = 32672, y = 31543, z = 9 } },
	},
	[Storage.Quest.U11_40.CultsOfTibia.Life.AccessDoor] = {
		itemId = false,
		itemPos = { { x = 33295, y = 32271, z = 12 } },
	},
	[Storage.Quest.U11_40.CultsOfTibia.Misguided.AccessDoor] = {
		itemId = false,
		itemPos = { { x = 32508, y = 32370, z = 9 } },
	},
	[Storage.Quest.U11_40.CultsOfTibia.FinalBoss.AccessDoor] = {
		itemId = false,
		itemPos = { { x = 33452, y = 32241, z = 7 } },
	},
	-- Ferumbras ascension door
	[Storage.Quest.U10_90.FerumbrasAscension.FirstDoor] = {
		itemId = false,
		itemPos = { { x = 33479, y = 32782, z = 11 } },
	},
	[Storage.Quest.U10_90.FerumbrasAscension.MonsterDoor] = {
		itemId = false,
		itemPos = { { x = 33482, y = 32786, z = 11 } },
	},
	[Storage.Quest.U10_90.FerumbrasAscension.TarbazDoor] = {
		itemId = false,
		itemPos = { { x = 33470, y = 32786, z = 11 } },
	},
	-- Wrath of the emperor door
	[Storage.Quest.U8_6.WrathOfTheEmperor.Mission02] = {
		itemId = false,
		itemPos = { { x = 33242, y = 31051, z = 10 } },
	},
	[Storage.Quest.U8_6.WrathOfTheEmperor.Mission08] = {
		itemId = false,
		itemPos = { { x = 33080, y = 31164, z = 8 } },
	},
	[Storage.Quest.U8_6.WrathOfTheEmperor.Mission12] = {
		itemId = false,
		itemPos = { { x = 33076, y = 31176, z = 8 } },
	},
	-- Unnatural selection door
	[Storage.Quest.U8_54.UnnaturalSelection.Mission01] = {
		itemId = false,
		itemPos = { { x = 33046, y = 31302, z = 7 } },
	},
	-- Dark trails/oramond door
	[Storage.Quest.U10_50.OramondQuest.ToTakeRoots.Door] = {
		itemId = false,
		itemPos = { { x = 33573, y = 31982, z = 7 } },
	},
	[Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Door] = {
		itemId = false,
		itemPos = { { x = 33549, y = 31974, z = 10 } },
	},
	[Storage.Quest.U10_50.DarkTrails.DoorQuandon] = {
		itemId = false,
		itemPos = { { x = 33573, y = 31953, z = 7 } },
	},
	[Storage.Quest.U10_50.DarkTrails.DoorHideout] = {
		itemId = false,
		itemPos = { { x = 33666, y = 31924, z = 7 } },
	},
	-- Outfit quest door
	[Storage.Quest.U7_8.HunterOutfits.HunterHatAddon] = {
		itemId = false,
		itemPos = { { x = 32369, y = 32796, z = 10 } },
	},
	-- The Ancient Tombs Quest - door Vashresamuns
	[Storage.Quest.U7_4.TheAncientTombs.VashresamunsDoor] = {
		itemId = false,
		itemPos = { { x = 33184, y = 32665, z = 15 } },
	},
	-- The ape city door
	[Storage.Quest.U7_6.TheApeCity.ChorDoor] = {
		itemId = false,
		itemPos = { { x = 32934, y = 32886, z = 7 } },
	},
	[Storage.Quest.U7_6.TheApeCity.FibulaDoor] = {
		itemId = false,
		itemPos = { { x = 32182, y = 32468, z = 10 } },
	},
	[Storage.Quest.U7_6.TheApeCity.CasksDoor] = {
		itemId = false,
		itemPos = {
			{ x = 32861, y = 32495, z = 9 },
			{ x = 32861, y = 32497, z = 9 },
			{ x = 32861, y = 32499, z = 9 },
			{ x = 32861, y = 32501, z = 9 },
			{ x = 32861, y = 32503, z = 9 },
			{ x = 32861, y = 32505, z = 9 },
			{ x = 32861, y = 32507, z = 9 },
		},
	},
	[Storage.Quest.U7_6.TheApeCity.DworcDoor] = {
		itemId = false,
		itemPos = { { x = 32781, y = 32910, z = 8 } },
	},
	-- The New Frontier Doors
	[Storage.Quest.U8_54.TheNewFrontier.Mission01] = {
		itemId = false,
		itemPos = {
			{ x = 33060, y = 31529, z = 10 },
			{ x = 33061, y = 31529, z = 10 },
			{ x = 33062, y = 31529, z = 10 },
			{ x = 33060, y = 31529, z = 12 },
			{ x = 33061, y = 31529, z = 12 },
			{ x = 33062, y = 31529, z = 12 },
			{ x = 33060, y = 31529, z = 14 },
			{ x = 33061, y = 31529, z = 14 },
			{ x = 33062, y = 31529, z = 14 },
		},
	},
	[Storage.Quest.U8_54.TheNewFrontier.Mission04] = {
		itemId = false,
		itemPos = {
			{ x = 33055, y = 31529, z = 10 },
			{ x = 33056, y = 31529, z = 10 },
			{ x = 33057, y = 31529, z = 10 },
			{ x = 33055, y = 31529, z = 12 },
			{ x = 33056, y = 31529, z = 12 },
			{ x = 33057, y = 31529, z = 12 },
			{ x = 33055, y = 31529, z = 14 },
			{ x = 33056, y = 31529, z = 14 },
			{ x = 33057, y = 31529, z = 14 },
		},
	},
	[Storage.Quest.U8_54.TheNewFrontier.Mission07[1]] = {
		itemId = false,
		itemPos = {
			{ x = 33170, y = 31260, z = 10 },
			{ x = 33171, y = 31260, z = 10 },
		},
	},
	[Storage.Quest.U8_54.TheNewFrontier.Mission09.ArenaDoor] = {
		itemId = false,
		itemPos = {
			{ x = 33080, y = 31019, z = 2 },
		},
	},
	[Storage.Quest.U8_54.TheNewFrontier.Mission09.RewardDoor] = {
		itemId = false,
		itemPos = {
			{ x = 33061, y = 31025, z = 7 },
		},
	},
	[Storage.Quest.U8_54.TheNewFrontier.Mission10.MagicCarpetDoor] = {
		itemId = false,
		itemPos = {
			{ x = 32990, y = 31547, z = 4 },
		},
	},
	-- The inquisition door
	[Storage.Quest.U8_2.TheInquisitionQuest.Mission01] = {
		itemId = false,
		itemPos = { { x = 32316, y = 32264, z = 8 } },
	},
	[Storage.Quest.U8_2.TheInquisitionQuest.RewardDoor] = {
		itemId = false,
		itemPos = { { x = 32320, y = 32258, z = 9 } },
	},
	-- In service of yalahar door
	[Storage.Quest.U8_4.InServiceOfYalahar.Mission03] = {
		itemId = false,
		itemPos = {
			{ x = 32801, y = 31220, z = 7 },
			{ x = 32803, y = 31220, z = 7 },
		},
	},
	[Storage.Quest.U8_4.InServiceOfYalahar.AlchemistFormula] = {
		itemId = false,
		itemPos = { { x = 32693, y = 31085, z = 7 } },
	},
	[Storage.Quest.U8_4.InServiceOfYalahar.TamerinStatus] = {
		itemId = false,
		itemPos = { { x = 32660, y = 31222, z = 8 } },
	},
	[Storage.Quest.U8_4.InServiceOfYalahar.MorikSummon] = {
		itemId = false,
		itemPos = { { x = 32690, y = 31241, z = 6 } },
	},
	[Storage.Quest.U8_4.InServiceOfYalahar.MatrixReward] = {
		itemId = false,
		itemPos = { { x = 32879, y = 31260, z = 8 } },
	},
	[Storage.Quest.U8_4.InServiceOfYalahar.NotesPalimuth] = {
		itemId = false,
		itemPos = { { x = 32797, y = 31226, z = 7 } },
	},
	[Storage.Quest.U8_4.InServiceOfYalahar.DoorToAzerus] = {
		itemId = false,
		itemPos = { { x = 32796, y = 31185, z = 7 } },
	},
	[Storage.Quest.U8_4.InServiceOfYalahar.DoorToBog] = {
		itemId = false,
		itemPos = {
			{ x = 32673, y = 31121, z = 7 },
			{ x = 32700, y = 31123, z = 7 },
			{ x = 32705, y = 31186, z = 8 },
			{ x = 32709, y = 31186, z = 8 },
		},
	},
	[Storage.Quest.U8_4.InServiceOfYalahar.DoorToLastFight] = {
		itemId = false,
		itemPos = { { x = 32783, y = 31193, z = 8 } },
	},
	[Storage.Quest.U8_4.InServiceOfYalahar.DoorToMatrix] = {
		itemId = false,
		itemPos = {
			{ x = 32867, y = 31265, z = 10 },
			{ x = 32940, y = 31248, z = 9 },
		},
	},
	[Storage.Quest.U8_4.InServiceOfYalahar.DoorToQuara] = {
		itemId = false,
		itemPos = {
			{ x = 32906, y = 31209, z = 14 },
			{ x = 32965, y = 31205, z = 14 },
			{ x = 32975, y = 31148, z = 14 },
		},
	},
	[Storage.Quest.U8_4.InServiceOfYalahar.DoorToReward] = {
		itemId = false,
		itemPos = {
			{ x = 32780, y = 31205, z = 7 },
			{ x = 32780, y = 31208, z = 7 },
		},
	},
	-- Children of the revolution door
	[Storage.Quest.U8_54.ChildrenOfTheRevolution.Mission03] = {
		itemId = false,
		itemPos = { { x = 33330, y = 31411, z = 8 } },
	},
	-- Unnatural selection door
	[Storage.Quest.U8_54.UnnaturalSelection.Mission05] = {
		itemId = false,
		itemPos = { { x = 32982, y = 31439, z = 3 } },
	},
	-- Postman door
	[Storage.Quest.U7_24.ThePostmanMissions.Mission05] = {
		itemId = false,
		itemPos = { { x = 32567, y = 32023, z = 6 } },
	},
	[Storage.Quest.U7_24.ThePostmanMissions.Mission08] = {
		itemId = false,
		itemPos = { { x = 32515, y = 32248, z = 8 } },
	},
	[Storage.Quest.U7_24.ThePostmanMissions.Mission09] = {
		itemId = false,
		itemPos = { { x = 32569, y = 32023, z = 6 } },
	},
	[Storage.Quest.U7_24.ThePostmanMissions.Door] = {
		itemId = false,
		itemPos = {
			{ x = 31921, y = 32652, z = 8 },
			{ x = 32008, y = 32863, z = 5 },
			{ x = 32059, y = 32733, z = 13 },
			{ x = 32101, y = 31264, z = 7 },
			{ x = 32148, y = 31122, z = 11 },
			{ x = 32386, y = 32951, z = 7 },
			{ x = 32423, y = 32096, z = 15 },
			{ x = 32448, y = 31965, z = 10 },
			{ x = 32453, y = 31975, z = 10 },
			{ x = 32455, y = 31975, z = 10 },
			{ x = 32459, y = 31965, z = 10 },
			{ x = 32524, y = 32026, z = 13 },
			{ x = 32535, y = 31970, z = 7 },
			{ x = 32615, y = 31435, z = 7 },
			{ x = 32962, y = 31487, z = 6 },
			{ x = 32971, y = 31778, z = 7 },
			{ x = 32995, y = 32447, z = 7 },
			{ x = 33076, y = 31212, z = 7 },
			{ x = 33083, y = 32185, z = 8 },
			{ x = 33201, y = 31064, z = 9 },
			{ x = 33271, y = 31657, z = 8 },
			{ x = 33284, y = 31791, z = 13 },
			{ x = 33307, y = 32291, z = 7 },
		},
	},
	-- The thieves guild door
	[Storage.Quest.U8_2.TheThievesGuildQuest.Mission04] = {
		itemId = false,
		itemPos = { { x = 32359, y = 32787, z = 6 } },
	},
	[Storage.Quest.U8_2.TheThievesGuildQuest.Mission05] = {
		itemId = false,
		itemPos = { { x = 32550, y = 32652, z = 10 } },
	},
	[Storage.Quest.U8_2.TheThievesGuildQuest.Door] = {
		itemId = false,
		itemPos = { { x = 32314, y = 32210, z = 8 } },
	},
	[Storage.Quest.U8_2.TheThievesGuildQuest.TheatreScript] = {
		itemId = false,
		itemPos = { { x = 32367, y = 31782, z = 8 } },
	},
	-- Secret service door
	[Storage.Quest.U8_1.SecretService.CGBMission01] = {
		itemId = false,
		itemPos = { { x = 33270, y = 31839, z = 3 } },
	},
	[Storage.Quest.U8_1.SecretService.TBIMission02] = {
		itemId = false,
		itemPos = { { x = 32872, y = 31957, z = 11 } },
	},
	[Storage.Quest.U8_1.SecretService.AVINMission02] = {
		itemId = false,
		itemPos = { { x = 32310, y = 32178, z = 5 } },
	},
	[Storage.Quest.U8_1.SecretService.CGBMission02] = {
		itemId = false,
		itemPos = { { x = 32876, y = 31957, z = 11 } },
	},
	[Storage.Quest.U8_1.SecretService.TBIMission03] = {
		itemId = false,
		itemPos = { { x = 32639, y = 32735, z = 7 } },
	},
	[Storage.Quest.U8_1.SecretService.TBIMission04] = {
		itemId = false,
		itemPos = { { x = 32772, y = 31582, z = 11 } },
	},
	[Storage.Quest.U8_1.SecretService.CGBMission04] = {
		itemId = false,
		itemPos = { { x = 32906, y = 32013, z = 6 } },
	},
	[Storage.Quest.U8_1.SecretService.AVINMission05] = {
		itemId = false,
		itemPos = { { x = 32156, y = 31951, z = 13 } },
	},
	[Storage.Quest.U8_1.SecretService.CGBMission05] = {
		itemId = false,
		itemPos = { { x = 32599, y = 32380, z = 10 } },
	},
	[Storage.Quest.U8_1.SecretService.Mission07] = {
		itemId = false,
		itemPos = { { x = 32537, y = 31897, z = 13 } },
	},
	-- Hidden city of beregar door
	[Storage.Quest.U8_4.TheHiddenCityOfBeregar.DoorNorthMine] = {
		itemId = false,
		itemPos = { { x = 32606, y = 31489, z = 14 } },
	},
	[Storage.Quest.U8_4.TheHiddenCityOfBeregar.DoorWestMine] = {
		itemId = false,
		itemPos = { { x = 32584, y = 31499, z = 14 } },
	},
	[Storage.Quest.U8_4.TheHiddenCityOfBeregar.DoorSouthMine] = {
		itemId = false,
		itemPos = { { x = 32608, y = 31516, z = 14 } },
	},
	[Storage.Quest.U8_6.AnInterestInBotany.ChestDoor] = {
		itemId = false,
		itemPos = { { x = 33007, y = 31536, z = 10 } },
	},
	[Storage.Quest.U8_1.TibiaTales.AritosTaskDoor] = {
		itemId = false,
		itemPos = { { x = 33247, y = 32534, z = 8 } },
	},
	-- THe shattered isles door
	[Storage.Quest.U7_8.TheShatteredIsles.TortoiseEggNargorDoor] = {
		itemId = false,
		itemPos = { { x = 31934, y = 32838, z = 7 } },
	},
	[Storage.Quest.U7_8.TheShatteredIsles.YavernDoor] = {
		itemId = false,
		itemPos = { { x = 31978, y = 32856, z = 3 } },
	},
	-- Hot cuisine door
	[Storage.Quest.U8_5.HotCuisineQuest.CookbookDoor] = {
		itemId = false,
		itemPos = {
			{ x = 33065, y = 32529, z = 5 },
			{ x = 33065, y = 32531, z = 5 },
		},
	},
	-- The annihilator door
	[Storage.Quest.U7_24.TheAnnihilator.Reward] = {
		itemId = 5113,
		itemPos = { { x = 33216, y = 31671, z = 13 } },
	},
	-- Svargrond arena door
	[Storage.Quest.U8_0.BarbarianArena.PitDoor] = {
		itemId = false,
		itemPos = {
			{ x = 32233, y = 31098, z = 7 },
			{ x = 32233, y = 31099, z = 7 },
			{ x = 32233, y = 31100, z = 7 },
		},
	},
	[Storage.Quest.U8_0.BarbarianArena.GreenhornDoor] = {
		itemId = false,
		itemPos = { { x = 32227, y = 31066, z = 7 } },
	},
	[Storage.Quest.U8_0.BarbarianArena.ScrapperDoor] = {
		itemId = false,
		itemPos = { { x = 32227, y = 31059, z = 7 } },
	},
	[Storage.Quest.U8_0.BarbarianArena.WarlordDoor] = {
		itemId = false,
		itemPos = { { x = 32227, y = 31052, z = 7 } },
	},
	-- The pits of inferno door
	[Storage.Quest.U7_9.ThePitsOfInferno.ShortcutHubDoor] = {
		itemId = false,
		itemPos = { { x = 32786, y = 32328, z = 6 } },
	},
	[Storage.Quest.U7_9.ThePitsOfInferno.ShortcutLeverDoor] = {
		itemId = false,
		itemPos = {
			{ x = 32825, y = 32331, z = 11 },
			{ x = 32825, y = 32332, z = 11 },
		},
	},
	-- Fathers burden door
	[Storage.Quest.U8_6.AFathersBurden.QuestLog] = {
		itemId = false,
		itemPos = {
			{ x = 31989, y = 31225, z = 7 },
			{ x = 32124, y = 31914, z = 14 },
			{ x = 32638, y = 31985, z = 14 },
			{ x = 32815, y = 32505, z = 8 },
			{ x = 33216, y = 31422, z = 10 },
			{ x = 33231, y = 31756, z = 5 },
			{ x = 33235, y = 32808, z = 12 },
		},
	},
	-- What a foolish door
	[Storage.Quest.U8_1.WhatAFoolishQuest.TriangleTowerDoor] = {
		itemId = false,
		itemPos = { { x = 32563, y = 32116, z = 4 } },
	},
	[Storage.Quest.U8_1.WhatAFoolishQuest.QueenEloiseCatDoor] = {
		itemId = false,
		itemPos = { { x = 32316, y = 31757, z = 9 } },
	},
	-- White raven monastery door
	[Storage.Quest.U7_24.TheWhiteRavenMonastery.Door] = {
		itemId = false,
		itemPos = {
			{ x = 32171, y = 31936, z = 7 },
			{ x = 32169, y = 31933, z = 7 },
		},
	},
	-- The Rookie Guard Quest - Mission 07: Attack!
	-- The library vault door
	[Storage.Quest.U9_1.TheRookieGuard.LibraryDoor] = {
		itemId = false,
		itemPos = { { x = 32090, y = 32156, z = 9 } },
	},
	-- The Rookie Guard Quest - Mission 10: Tomb Raiding
	-- The unholy crypt door
	[Storage.Quest.U9_1.TheRookieGuard.UnholyCryptDoor] = {
		itemId = false,
		itemPos = { { x = 32147, y = 32186, z = 9 } },
	},
	-- The Rookie Guard Quest - Mission 12: Into The Fortress
	-- Lower academy floor door
	[Storage.Quest.U9_1.TheRookieGuard.AcademyDoor] = {
		itemId = false,
		itemPos = { { x = 32109, y = 32189, z = 8 } },
	},
	-- Hidden Threats Quest
	[Storage.Quest.U11_50.HiddenThreats.RatterDoor] = {
		itemId = 1644,
		itemPos = { { x = 33046, y = 32066, z = 12 } },
	},
	[Storage.Quest.U11_50.HiddenThreats.ServantDoor] = {
		itemId = 1642,
		itemPos = { { x = 33036, y = 32008, z = 12 } },
	},
	[Storage.Quest.U11_50.HiddenThreats.CorymWorksDoor01] = {
		itemId = 1642,
		itemPos = { { x = 33025, y = 32008, z = 12 } },
	},
	[Storage.Quest.U11_50.HiddenThreats.CorymWorksDoor02] = {
		itemId = 1642,
		itemPos = { { x = 33045, y = 32007, z = 12 } },
	},
	[Storage.Quest.U11_50.HiddenThreats.CorymWorksDoor03] = {
		itemId = 1644,
		itemPos = { { x = 33001, y = 32047, z = 12 } },
	},
	[Storage.Quest.U8_1.SecretService.CGBMission06] = {
		itemId = 6260,
		itemPos = { { x = 32180, y = 31933, z = 11 } },
	},
	[Storage.Quest.U7_8.KnightOutfits.RamsaysHelmetDoor] = {
		itemId = 5122,
		itemPos = { { x = 32860, y = 32517, z = 11 } },
	},
	[Storage.Quest.U8_54.TheNewFrontier.ZaoPalaceDoors] = {
		itemId = 9874,
		itemPos = {
			{ x = 33161, y = 31265, z = 10 },
			{ x = 33161, y = 31266, z = 10 },
		},
	},
	[Storage.Quest.U8_54.AnUneasyAlliance.QuestDoor] = {
		itemId = false,
		itemPos = { { x = 33047, y = 31295, z = 7 } },
	},
	[Storage.Quest.U8_6.WrathOfTheEmperor.Mission06] = {
		itemId = false,
		itemPos = {
			{ x = 33080, y = 31215, z = 7 },
			{ x = 33086, y = 31199, z = 7 },
			{ x = 33090, y = 31190, z = 7 },
		},
	},
	[Storage.Quest.U8_6.WrathOfTheEmperor.Mission07] = {
		itemId = false,
		itemPos = {
			{ x = 33073, y = 31170, z = 7 },
			{ x = 33074, y = 31170, z = 7 },
		},
	},
	[Storage.Quest.U8_6.WrathOfTheEmperor.Mission09] = {
		itemId = false,
		itemPos = { { x = 33083, y = 31216, z = 8 } },
	},

	[Storage.Quest.U12_20.GraveDanger.Questline] = {
		itemId = false,
		itemPos = {
			{ x = 33264, y = 31993, z = 7 },
			{ x = 33197, y = 31684, z = 7 },
			{ x = 32644, y = 32388, z = 8 },
			{ x = 32191, y = 31823, z = 8 },
			{ x = 32543, y = 31856, z = 6 },
			{ x = 33376, y = 32798, z = 8 },
			{ x = 33812, y = 31639, z = 10 },
			{ x = 32959, y = 31541, z = 7 },
			{ x = 33288, y = 32479, z = 9 },
			{ x = 32355, y = 32163, z = 11 },
			{ x = 32773, y = 31823, z = 8 },
			{ x = 32012, y = 31565, z = 7 },
		},
	},
	[Storage.Quest.U12_20.GraveDanger.Bosses.KingZelos.Room] = {
		itemId = false,
		itemPos = { { x = 32173, y = 31922, z = 8 } },
	},

	[Storage.Quest.U12_70.AdventuresOfGalthen.AccessDoor] = {
		itemId = false,
		itemPos = { { x = 32466, y = 32494, z = 8 } },
	},
	[Storage.Quest.U10_80.GrimvaleQuest.AncientFeudDoors] = {
		itemId = false,
		itemPos = {
			{ x = 33124, y = 32261, z = 10 },
			{ x = 33123, y = 32230, z = 12 },
			{ x = 33159, y = 32322, z = 12 },
		},
	},
	[Storage.Quest.U10_90.FerumbrasAscension.TarbazDoor] = {
		itemId = 22508,
		itemPos = {
			{ x = 33476, y = 32791, z = 11 },
			{ x = 33470, y = 32786, z = 11 },
		},
	},
	-- Kilmaresh Quest
	[Storage.Quest.U12_20.KilmareshQuest.AccessDoor] = {
		itemId = false,
		itemPos = { { x = 33886, y = 31476, z = 7 } },
	},
	[Storage.Quest.U12_20.KilmareshQuest.Second.Investigating] = {
		itemId = 31568,
		itemPos = { { x = 33959, y = 31501, z = 4 } },
	},
	[Storage.Quest.U12_20.KilmareshQuest.Sixth.GryphonMask] = {
		itemId = 9558,
		itemPos = { { x = 33884, y = 31536, z = 9 } },
	},
	[Storage.Quest.U12_20.KilmareshQuest.Sixth.MirrorMask] = {
		itemId = 9558,
		itemPos = { { x = 33884, y = 31510, z = 9 } },
	},
	[Storage.Quest.U12_20.KilmareshQuest.Sixth.IvoryMask] = {
		itemId = 9558,
		itemPos = {
			{ x = 33911, y = 31496, z = 9 },
			{ x = 33855, y = 31496, z = 9 },
		},
	},
	[Storage.Quest.U12_20.KilmareshQuest.Sixth.SilverMask] = {
		itemId = 9558,
		itemPos = {
			{ x = 33855, y = 31450, z = 9 },
			{ x = 33912, y = 31466, z = 9 },
		},
	},
	[Storage.Quest.U12_60.APiratesTail.TentuglyDoor] = {
		itemId = false,
		itemPos = { { x = 33793, y = 31388, z = 6 } },
	},
	[Storage.Quest.U12_40.TheOrderOfTheLion.AccessEastSide] = {
		itemId = false,
		itemPos = {
			{ x = 32429, y = 32461, z = 7 },
			{ x = 32430, y = 32461, z = 8 },
		},
	},
	[Storage.Quest.U12_40.TheOrderOfTheLion.AccessSouthernSide] = {
		itemId = false,
		itemPos = {
			{ x = 32422, y = 32499, z = 8 },
		},
	},
	[Storage.Quest.U13_10.CradleOfMonsters.Access.LowerIngol] = {
		itemId = false,
		itemPos = {
			{ x = 33796, y = 32561, z = 8 },
			{ x = 33796, y = 32561, z = 9 },
			{ x = 33796, y = 32573, z = 9 },
			{ x = 33796, y = 32573, z = 10 },
			{ x = 33796, y = 32561, z = 10 },
			{ x = 33796, y = 32561, z = 11 },
			{ x = 33796, y = 32573, z = 11 },
			{ x = 33796, y = 32573, z = 12 },
		},
	},
	[Storage.Quest.U13_10.CradleOfMonsters.Access.Monster] = {
		itemId = false,
		itemPos = {
			{ x = 33791, y = 32576, z = 12 },
		},
	},
	[Storage.Quest.U13_10.CradleOfMonsters.Access.MutatedAbomination] = {
		itemId = false,
		itemPos = {
			{ x = 33782, y = 32576, z = 12 },
		},
	},
	[Storage.Quest.U7_8.DruidOutfits.DruidAmuletDoor] = {
		itemId = false,
		itemPos = {
			{ x = 32939, y = 31775, z = 9 },
		},
	},
	[Storage.Quest.U7_8.OrientalOutfits.OrientalDoor] = {
		itemId = false,
		itemPos = {
			{ x = 32084, y = 32776, z = 11 },
		},
	},
	[Storage.Quest.U7_9.NightmareOutfits.KnightwatchTowerDoor] = {
		itemId = false,
		itemPos = {
			{ x = 32815, y = 32328, z = 8 },
			{ x = 32817, y = 32328, z = 8 },
		},
	},
	[Storage.Quest.U8_0.TheIceIslands.FormorgarMinesDoor] = {
		itemId = false,
		itemPos = {
			{ x = 32134, y = 31095, z = 6 },
		},
	},
	[Storage.Quest.U8_0.TheIceIslands.yakchalDoor] = {
		itemId = false,
		itemPos = {
			{ x = 32203, y = 31022, z = 14 },
			{ x = 32204, y = 31022, z = 14 },
		},
	},
	[Storage.Quest.U8_1.TowerDefenceQuest.Door] = {
		itemId = 6258,
		itemPos = {
			{ x = 32600, y = 31758, z = 9 },
		},
	},
	[Storage.Quest.U8_2.VampireHunterQuest.Door] = {
		itemId = 8259,
		itemPos = {
			{ x = 32953, y = 31460, z = 9 },
		},
	},
}

QuestDoorUnique = {
	--Dawnport
	-- Vocation doors
	-- Sorcerer
	[22001] = {
		itemId = 11239,
		itemPos = { x = 32055, y = 31885, z = 6 },
	},
	-- Druid
	[22002] = {
		itemId = 7040,
		itemPos = { x = 32073, y = 31885, z = 6 },
	},
	-- Paladin
	[22003] = {
		itemId = 6898,
		itemPos = { x = 32059, y = 31885, z = 6 },
	},
	-- Knight
	[22004] = {
		itemId = 8363,
		itemPos = { x = 32069, y = 31885, z = 6 },
	},
	-- Secret Service
	[22005] = {
		itemId = 17709,
		itemPos = { x = 32908, y = 32112, z = 7 },
	},
	-- Katana Quest
	[22006] = {
		itemId = 5107,
		itemPos = { x = 32177, y = 32148, z = 11 },
	},
}
