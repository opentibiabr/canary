--[[
Reserved player action storage key ranges (const.h)
	It is possible to place the storage in a quest door, so the player who has that storage will go through the door

	Reserved player action storage key ranges (const.h at the source)
	[10000000 - 20000000]
	[1000 - 1500]
	[2001 - 2011]

	Others reserved player action/storages
	[100] = unmoveable/untrade/unusable items
	[101] = use pick floor
	[102] = well down action
	[103-120] = others keys action
	[103] = key 0010
	[303] = key 0303
	[1000] = level door. Here 1 must be used followed by the level.
	Example: 1010 = level 10,
	1100 = level 100]

	[3001-3008] = key 3001/3008
	[3012] = key 3012
	[3033] = key 3033
	[3100] = key 3100
	[3142] = key 3142
	[3200] = key 3200
	[3301] = key 3301
	[3302] = key 3302
	[3303] = key 3303
	[3304] = key 3304
	[3350] = key 3350
	[3520] = key 3520
	[3600] = key 3600
	[3610] = key 3610
	[3620] = key 3620
	[3650] = key 3650
	[3666] = key 3666
	[3667] = key 3667
	[3700] = key 3700
	[3701/3703] = key 3701/3703
	[3800/3802] = key 3800/3802
	[3899] = key 3899
	[3900] = key 3900
	[3909/3917] = key 3909/3917
	[3923] = key 3923
	[3925] = key 3925
	[3930] = key 3930
	[3932] = key 3932
	[3934] = key 3934
	[3935] = key 3935
	[3936] = key 3936
	[3938] = key 3938
	[3940] = key 3940
	[3950] = key 3950
	[3960] = key 3960
	[3980] = key 3980
	[3988] = key 3988
	[4001] = key 4001
	[4009] = key 4009
	[4022] = key 4022
	[4023] = key 4023
	[4033] = key 4033
	[4037] = key 4037
	[4055] = key 4055
	[4210] = key 4210
	[4501] = key 4501
	[4502] = key 4502
	[4503] = key 4503
	[4600] = key 4600
	[4601] = key 4601
	[4603] = key 4603
	[5000] = key 5000
	[5002] = key 5002
	[5010] = key 5010
	[5050] = key 5050
	[6010] = key 6010

	Questline = Storage through the Quest
]]

Storage = {
	-- General storages
	isTraining = 30000,
	NpcExhaust = 30001,
	NpcExhaustOnBuy = 30002,
	Dragonfetish = 30003,
	EdronRopeQuest = 30004,
	GhostShipQuest = 30005,
	OrcKingGreeting = 30006,
	MarkwinGreeting = 30007,
	-- empty = 30008
	WagonTicket = 30009,
	BloodHerbQuest = 30010,
	firstMageWeapon = 30011,
	toOutfoxAFoxQuest = 30012,
	KawillBlessing = 30014,
	RentedHorseTimer = 30015,
	FountainOfLife = 30016,
	KnightwatchTowerDoor = 30017,
	-- Promotion Storage cannot be changed, it is set in source code
	Promotion = 30018,
	RookgaardHints = 30019,
	RookgaardDestiny = 30020,
	EruaranGreeting = 30021,
	MaryzaCookbook = 30022,
	combatProtectionStorage = 30023,
	Factions = 30024,
	blockMovementStorage = 30025,
	PetSummon = 30026,
	TrainerRoom = 30027,
	NpcSpawn = 30028,
	ExerciseDummyExhaust = 30029,
	SamsOldBackpack = 30030,
	SamsOldBackpackDoor = 30031,
	StrawberryCupcake = 30032,
	ChayenneReward = 30033,
	SwampDiggingTimeout = 30034,
	HydraEggQuest = 30035,
	Atrad = 30036,
	ElementalistQuest1 = 30037,
	ElementalistQuest2 = 30038,
	ElementalistQuest3 = 30039,
	ElementalistOutfitStart = 30040,
	WayfarerOutfit = 30041,
	DreamOutfit = 30042,
	Percht1 = 30043,
	Percht2 = 30044,
	Percht3 = 30045,
	Irmana1 = 30046,
	Irmana2 = 30047,
	Navigator = 30048,
	DwarvenLegs = 30049,
	PrinceDrazzakTime = 30050,
	StoreExaust = 30051,
	LemonCupcake = 30052,
	BlueberryCupcake = 30053,
	PetSummonEvent10 = 30054,
	PetSummonEvent60 = 30055,
	FreeQuests = 990000,
	PremiumAccount = 998899,

	--[[
	Old storages
	Over time, this will be dropped and replaced by the table above
	]]
	DeeplingsWorldChange = {
		-- Reserved storage from 50000 - 50009
		Questline = 50000,
		FirstStage = 50001,
		SecondStage = 50002,
		ThirdStage = 50003,
		Crystal = 50004
	},
	LiquidBlackQuest = {
		-- Reserved storage from 50010 - 50014
		Questline = 50010,
		Visitor = 50011
	},
	Kilmaresh = {
		-- Reserved storage from 50015 - 50049
		Questline = 50015,
		First = {
			Title = 50016
		},
		Second = {
			Investigating = 50017
		},
		Third = {
			Recovering = 50018
		},
		Fourth = {
			Moe = 50019,
			MoeTimer = 50020
		},
		Fifth = {
			Memories = 50021,
			MemoriesShards = 50022
		},
		Sixth = {
			Favor = 50023,
			FourMasks = 50024,
			BlessedStatues = 50025
		},
		Set = {
			Ritual = 50026
		},
		Eighth = {
			Yonan = 50027,
			Narsai = 50028,
			Shimun = 50029,
			Tefrit = 50030
		},
		Nine = {
			Owl = 50031
		},
		Tem = {
			Bleeds = 50032
		},
		Eleven = {
			Basin = 50033
		},
		Twelve = {
			Boss = 50034,
			Bragrumol = 50035,
			Mozradek = 50036,
			Xogixath = 50037
		},
		Thirteen = {
			Fafnar = 50038,
			Lyre = 50039,
			Presente = 50040
		},
		Fourteen = {
			Remains = 50041
		},
		UrmahlulluTimer = 50042
	},
	TheSecretLibrary = {
		-- Reserved storage from 50050 - 50069
		TheOrderOfTheFalcon = {
			OberonTimer = 50050
		},
		LiquidDeath = 50051,
		Mota = 50052,
		MotaDoor = 50053,
		BasinDoor = 50054,
		SkullDoor = 50055,
		TheLament = 50056,
		GreenTel = 50057,
		BlueTel = 50058,
		BlackTel = 50059,
		PinkTel = 50060,
		Peacock = 50061,
		HighDry = 50062
	},
	DeeplingBosses = {
		-- Reserved storage from 50070 - 50079
		Jaul = 50070,
		Tanjis = 50071,
		Obujos = 50072,
		DeeplingStatus = 50073
	},
	DangerousDepths = {
		-- Reserved storage from 50080 - 50199
		Questline = 50080,
		Dwarves = {
			Status = 50081,
			Home = 50082, -- Mission
			Subterranean = 50083, -- Mission
			LostExiles = 50084,
			Prisoners = 50085,
			Organisms = 50086,
			TimeTaskHome = 50087,
			TimeTaskSubterranean = 50088
		},
		Scouts = {
			Status = 50090,
			Diremaw = 50091, -- Mission
			Growth = 50092, -- Mission
			DiremawsCount = 50093,
			GnomishChest = 50094,
			BarrelCount = 50095,
			FirstBarrel = 50096,
			SecondBarrel = 50097,
			ThirdBarrel = 50098,
			FourthBarrel = 50099,
			FifthBarrel = 50100,
			TimeTaskDiremaws = 50101,
			TimeTaskGrowth = 50102,
			Barrel = 50103,
			BarrelTimer = 50104
		},
		Gnomes = {
			Status = 50115,
			Ordnance = 50116, -- Mission
			Measurements = 50117, -- Mission
			Charting = 50118, -- Mission
			GnomeChartChest = 50119, -- Measurements
			GnomeChartPaper = 50120, -- Charting
			GnomesCount = 50121, -- Ordnance
			CrawlersCount = 50122, -- Ordnance
			LocationA = 50123, -- Measurements
			LocationB = 50124, -- Measurements
			LocationC = 50125, -- Measurements
			LocationD = 50126, -- Measurements
			LocationE = 50127, -- Measurements
			LocationCount = 50128, -- Measurements
			OldGate = 50129, -- Charting
			TheGaze = 50130, -- Charting
			LostRuin = 50131, -- Charting
			Outpost = 50132, -- Charting
			Bastion = 50133,
			-- Charting
			BrokenTower = 50134, -- Charting
			ChartingCount = 50135, -- Contador
			TimeTaskOrdnance = 50136,
			TimeTaskMeasurements = 50137,
			TimeTaskCharting = 50138
		},
		Access = {
			LavaPumpWarzoneVI = 50139,
			TimerWarzoneVI = 50140,
			LavaPumpWarzoneV = 50141,
			TimerWarzoneV = 50142,
			LavaPumpWarzoneIV = 50143,
			TimerWarzoneIV = 50144
		},
		Crystals = {
			WarzoneVI = {
				BigCrystal1 = 50155,
				BigCrystal2 = 50156,
				MediumCrystal1 = 50157,
				MediumCrystal2 = 50158,
				SmallCrystal1 = 50159,
				SmallCrystal2 = 50160
			},
			WarzoneV = {
				BigCrystal1 = 50165,
				BigCrystal2 = 50166,
				MediumCrystal1 = 50167,
				MediumCrystal2 = 50168,
				SmallCrystal1 = 50169,
				SmallCrystal2 = 50170
			},
			WarzoneIV = {
				BigCrystal1 = 50175,
				BigCrystal2 = 50176,
				MediumCrystal1 = 50177,
				MediumCrystal2 = 50178,
				SmallCrystal1 = 50179,
				SmallCrystal2 = 50180
			}
		},
		Bosses = {
			TheCountOfTheCore = 50185,
			TheDukeOfTheDepths = 50186,
			TheBaronFromBelow = 50187,
			TheCountOfTheCoreAchiev = 50188,
			TheDukeOfTheDepthsAchiev = 50189,
			TheBaronFromBelowAchiev = 50190,
			LastAchievement = 50191
		}
	},
	CultsOfTibia = {
		-- Reserved storage from 50200 - 50269
		Questline = 50200,
		Minotaurs = {
			EntranceAccessDoor = 50201,
			JamesfrancisTask = 50202,
			Mission = 50203,
			BossTimer = 50204,
			AccessDoor = 50205
		},
		MotA = {
			Mission = 50210,
			Stone1 = 50211,
			Stone2 = 50212,
			Stone3 = 50213,
			Answer = 50214,
			QuestionId = 50215,
			AccessDoorInvestigation = 50216,
			AccessDoorGareth = 50217,
			AccessDoorDenominator = 50218
		},
		Barkless = {
			Mission = 50225,
			sulphur = 50226,
			Tar = 50227,
			Ice = 50228,
			Death = 50229,
			Objects = 50230,
			Temp = 50231,
			BossTimer = 50232,
			TrialAccessDoor = 50233,
			TarAccessDoor = 50234,
			AccessDoor = 50235,
			BossAccessDoor = 50236
		},
		Orcs = {
			Mission = 50240,
			LookType = 50241,
			BossTimer = 50242
		},
		Life = {
			Mission = 50245,
			BossTimer = 50246,
			AccessDoor = 50247
		},
		Humans = {
			Mission = 50250,
			Vaporized = 50251,
			Decaying = 50252,
			BossTimer = 50253
		},
		Misguided = {
			Mission = 50255,
			Monsters = 50256,
			Exorcisms = 50257,
			Time = 50258,
			BossTimer = 50259,
			AccessDoor = 50260
		},
		FinalBoss = {
			Mission = 50261,
			BossTimer = 50262,
			AccessDoor = 50263
		}
	},
	ThreatenedDreams = {
		-- Reserved storage from 50270 - 50349
		Start = 50270,
		TroubledMission01 = 50271,
		TroubledMission02 = 50272,
		TroubledMission03 = 50273,
		FairyMission01 = 50274,
		FairyMission02 = 50275,
		FairyMission03 = 50276,
		FairyMission04 = 50277,
		DreamMission01 = 50278,
		DreamCounter = 50279,
		KroazurTimer = 50280,
		CoupleMission01 = 50281,
		CoupleMission02 = 50282,
		FacelessBaneTime = 50283,
		Reward01 = 50284,
		Reward02 = 50285,
		Reward03 = 50286,
		TatteredSwanFeathers = 50300,
		TatteredSwanFeathers01 = 50301,
		TatteredSwanFeathers02 = 50302,
		TatteredSwanFeathers03 = 50303,
		TatteredSwanFeathers04 = 50304,
		TatteredSwanFeathers05 = 50305
	},
	FirstDragon = {
		-- Reserved storage from 50350 - 50379
		Questline = 50350,
		DragonCounter = 50351,
		ChestCounter = 50352,
		TazhadurTimer = 50353,
		KalyassaTimer = 50354,
		SecretsCounter = 50355,
		GelidrazahAccess = 50356,
		GelidrazahTimer = 50357,
		DesertTile = 50358,
		StoneSculptureTile = 50359,
		SuntowerTile = 50360,
		ZorvoraxTimer = 50361,
		Horn = 50362,
		Scale = 50363,
		Bones = 50364,
		Tooth = 50365,
		AccessCave = 50366,
		SomewhatBeatable = 50367,
		FirstDragonTimer = 50368,
		RewardFeather = 50369,
		RewardMask = 50370,
		RewardBackpack = 50371
	},
	Grimvale = {
		-- Reserved storage from 50380 - 50399
		SilverVein = 50380,
		WereHelmetEnchant = 50381
	},
	HeroRathleton = {
		-- Reserved storage from 50400 - 50419
		QuestLine = 50400,
		VotesCasted = 50401,
		Rank = 50402,
		AccessDoor = 50403,
		AccessTeleport1 = 50404,
		AccessTeleport2 = 50405,
		AccessTeleport3 = 50406
	},
	FerumbrasAscension = {
		-- Reserved storage from 50420 - 50469
		RiftRunner = 50420, -- Scroll
		TheShattererTimer = 50421,
		TheLordOfTheLiceTimer = 50422,
		TarbazTimer = 50423,
		RazzagornTimer = 50424,
		RagiazTimer = 50425,
		ZamuloshTimer = 50426,
		ShulgraxTimer = 50427,
		MazoranTimer = 50428,
		PlagirathTimer = 50429,
		FerumbrasTimer = 50430,
		Tarbaz = 50431,
		Razzagorn = 50432,
		Ragiaz = 50433,
		Zamulosh = 50434,
		Shulgrax = 50435,
		Mazoran = 50436,
		Plagirath = 50437,
		Access = 50438,
		TheShatterer = 50439,
		ZamuloshTeleports = 50440,
		BasinCounter = 50441,
		TheLordOfTheLiceAccess = 50442,
		FirstDoor = 50443,
		MonsterDoor = 50444,
		TarbazDoor = 50445,
		HabitatsAccess = 50446,
		HabitatsTimer = 50447,
		TarbazNotes = 50448,
		ColorLever = 50449,
		BoneFluteWall = 50450,
		BoneFlute = 50451,
		Ring = 50452,
		Statue = 50453,
		Fount = 50454,
		Vampire = 50455,
		Flower = 50456,
		Ring2 = 50457,
		Bone = 50458,
		Reward = 50459
	},
	ForgottenKnowledge = {
		-- Reserved storage from 50470 - 50519
		AccessDeath = 50470,
		AccessViolet = 50471,
		AccessEarth = 50472,
		AccessFire = 50473,
		AccessIce = 50474,
		AccessGolden = 50475,
		AccessLast = 50476,
		OldDesk = 50477,
		GirlPicture = 50478,
		SilverKey = 50479,
		Phial = 50480,
		BirdCounter = 50481,
		PlantCounter = 50482,
		GoldenServantCounter = 50483,
		DiamondServantCounter = 50484,
		AccessPortals = 50485,
		AccessMachine = 50486,
		LadyTenebrisTimer = 50487,
		LadyTenebrisKilled = 50488,
		LloydTimer = 50489,
		LloydKilled = 50490,
		ThornKnightTimer = 50491,
		ThornKnightKilled = 50492,
		DragonkingTimer = 50493,
		DragonkingKilled = 50494,
		HorrorTimer = 50495,
		HorrorKilled = 50496,
		TimeGuardianTimer = 50497,
		TimeGuardianKilled = 50498,
		LastLoreTimer = 50499,
		LastLoreKilled = 50501,
		BirdCage = 50502,
		AccessLavaTeleport = 50503,
		Ivalisse = 50504,
		Chalice = 50505,
		Tomes = 50506,
		BabyDragon = 50507,
		SpiderWeb = 50508
	},
	SweetyCyclops = {
		-- Reserved storage from 50520 - 50529
		AmuletTimer = 50520,
		AmuletStatus = 50521
	},
	ExplorerSociety = {
		-- Reserved storage from 50530 - 50599
		QuestLine = 50530,
		SpectralStone = 50531,
		SkullOfRatha = 50532,
		GiantSmithHammer = 50533,
		JoiningTheExplorers = 505344,
		TheIceDelivery = 50535,
		TheButterflyHunt = 50536,
		ThePlantCollection = 50537,
		TheLizardUrn = 50538,
		TheBonelordSecret = 50539,
		TheOrcPowder = 50540,
		CalassaQuest = 50541,
		TheMemoryStone = 50542,
		TheRuneWritings = 50543,
		TheEctoplasm = 50544,
		TheSpectralDress = 50545,
		TheSpectralStone = 50546,
		TheAstralPortals = 50547,
		TheIslandofDragons = 50548,
		TheIceMusic = 50549,
		BansheeDoor = 50550,
		BonelordsDoor = 50551,
		CalassaDoor = 50552,
		MemoryStoneDoor = 50553,
		ElvenDoor = 50554,
		OrcDoor = 50555,
		ChorurnDoor = 50556,
		DwacatraDoor = 50557,
		FamilyBroochDoor = 50558,
		TheElvenPoetry = 50559,
		SpectralStoneDoor = 50560,
		IceMusicDoor = 50561
	},
	TravellingTrader = {
		-- Reserved storage from 50600 - 50619
		Mission01 = 50600,
		Mission02 = 50601,
		Mission03 = 50602,
		Mission04 = 50603,
		Mission05 = 50604,
		Mission06 = 50605,
		Mission07 = 50606,
		packageDoor = 50607
	},
	DjinnWar = {
		-- Reserved storage from 50620 - 50649
		Faction = {
			Greeting = 50620,
			MaridDoor = 50621,
			EfreetDoor = 50622
		},
		RecievedLamp = 50625,
		-- Blue djinn
		MaridFaction = {
			Start = 50630,
			Mission01 = 50631,
			Mission02 = 50632,
			RataMari = 50633,
			Mission03 = 50634,
			DoorToLamp = 50635,
			DoorToEfreetTerritory = 50636
		},
		-- Green djinn
		EfreetFaction = {
			Start = 50640,
			Mission01 = 50641,
			Mission02 = 50642,
			Mission03 = 50643,
			DoorToLamp = 50644,
			DoorToMaridTerritory = 50645
		}
	},
	VampireHunter = {
		-- Reserved storage from 50650 - 50659
		Rank = 50650
	},
	BigfootBurden = {
		-- Reserved storage from 50660 - 50719
		QuestLine = 50660,
		Test = 50661,
		Shooting = 50662,
		QuestLineComplete = 50663,
		MelodyTone1 = 50664,
		MelodyTone2 = 50665,
		MelodyTone3 = 50666,
		MelodyTone4 = 50667,
		MelodyTone5 = 50668,
		MelodyTone6 = 50669,
		MelodyTone7 = 50670,
		MelodyStatus = 50671,
		Rank = 50672,
		MissionCrystalKeeper = 50673,
		CrystalKeeperTimout = 50674,
		RepairedCrystalCount = 50675,
		MissionRaidersOfTheLostSpark = 50676,
		ExtractedCount = 50677,
		RaidersOfTheLostSparkTimeout = 50678,
		MissionExterminators = 50679,
		ExterminatedCount = 50680,
		ExterminatorsTimeout = 50681,
		MissionMushroomDigger = 50682,
		MushroomCount = 50683,
		MushroomDiggerTimeout = 50684,
		MissionMatchmaker = 50685,
		MatchmakerStatus = 50686,
		MatchmakerIdNeeded = 50687,
		MatchmakerTimeout = 50688,
		MissionTinkersBell = 50689,
		GolemCount = 50690,
		TinkerBellTimeout = 50691,
		MissionSporeGathering = 50692,
		SporeCount = 50693,
		SporeGatheringTimeout = 50694,
		MissionGrindstoneHunt = 50695,
		GrindstoneStatus = 50696,
		GrindstoneTimeout = 50697,
		WarzoneStatus = 50698,
		Warzone1Access = 50699,
		Warzone2Access = 50700,
		Warzone3Access = 50701,
		Warzone1Reward = 50702,
		Warzone2Reward = 50703,
		Warzone3Reward = 50704,
		BossKills = 50705,
		DoorGoldenFruits = 50706,
		BossWarzone1 = 50707,
		BossWarzone2 = 50708,
		BossWarzone3 = 50709
	},
	TheirMastersVoice = {
		-- Reserved storage from 50720 - 50739
		SlimeGobblerTimeout = 50720,
		SlimeGobblerReceived = 50721
	},
	KosheiTheDeathless = {
		-- Reserved storage from 50740 - 50749
		RewardDoor = 50740
	},
	ElementalSphere = {
		-- Reserved storage from 50750 - 50759
		QuestLine = 50750,
		BossStorage = 50751,
		MachineGemCount = 50752
	},
	GravediggerOfDrefia = {
		-- Reserved storage from 50760 - 50849
		QuestStart = 50760,
		Mission01 = 50761,
		Mission02 = 50762,
		Mission03 = 50763,
		Mission04 = 50764,
		Mission05 = 50765,
		Mission06 = 50766,
		Mission07 = 50767,
		Mission08 = 50768,
		Mission09 = 50769,
		Mission10 = 50770,
		Mission11 = 50771,
		Mission12 = 50772,
		Mission13 = 50773,
		Mission14 = 50774,
		Mission15 = 50775,
		Mission16 = 50776,
		Mission17 = 50777,
		Mission18 = 50778,
		Mission19 = 50779,
		Mission20 = 50780,
		Mission21 = 50781,
		Mission22 = 50782,
		Mission23 = 50783,
		Mission24 = 50784,
		Mission25 = 50785,
		Mission26 = 50786,
		Mission27 = 50787,
		Mission28 = 50788,
		Mission29 = 50789,
		Mission30 = 50790,
		Mission31 = 50791,
		Mission32 = 50792,
		Mission32a = 50793,
		Mission32b = 50794,
		Mission33 = 50795,
		Mission34 = 50796,
		Mission35 = 50797,
		Mission36 = 50798,
		Mission36a = 50799,
		Mission37 = 50800,
		Mission38 = 50801,
		Mission38a = 50802,
		Mission38b = 50803,
		Mission38c = 50804,
		Mission39 = 50805,
		Mission40 = 50806,
		Mission41 = 50807,
		Mission42 = 50808,
		Mission43 = 50809,
		Mission44 = 50810,
		Mission45 = 50811,
		Mission46 = 50812,
		Mission47 = 50813,
		Mission48 = 50814,
		Mission49 = 50815,
		Mission50 = 50816,
		Mission51 = 50817,
		Mission50 = 50818,
		Mission53 = 50819,
		Mission54 = 50820,
		Mission55 = 50821,
		Mission56 = 50822,
		Mission57 = 50823,
		Mission58 = 50824,
		Mission59 = 50825,
		Mission60 = 50826,
		Mission61 = 50827,
		Mission62 = 50828,
		Mission63 = 50829,
		Mission64 = 50830,
		Mission65 = 50831,
		Mission66 = 50832,
		Mission67 = 50833,
		Mission68 = 50834,
		Mission69 = 50835,
		Mission70 = 50836,
		Mission71 = 50837,
		Mission72 = 50838,
		Mission73 = 50839,
		Mission74 = 50840,
		Bookcase = 50841
	},
	Oramond = {
		-- Reserved storage from 50850 - 50879
		QuestLine = 50850,
		VotingPoints = 50851,
		MissionToTakeRoots = 50852,
		HarvestedRootCount = 50853,
		TaskProbing = 50854,
		DoorBeggarKing = 50855,
		MissionAbandonedSewer = 50856,
		DoorAbandonedSewer = 50857
	},
	DarkTrails = {
		-- Reserved storage from 50880 - 50909
		Mission01 = 50881,
		Mission02 = 50882,
		Mission03 = 50883,
		Mission04 = 50884,
		Mission05 = 50885,
		Mission06 = 50886,
		Mission07 = 50887,
		Mission08 = 50888,
		Mission09 = 50889,
		Mission10 = 50890,
		Mission11 = 50891,
		Mission12 = 50892,
		Mission13 = 50893,
		Mission14 = 50894,
		Mission15 = 50895,
		Mission16 = 50896,
		Mission17 = 50897,
		Mission18 = 50898,
		Outfit = 50899, -- final storage
		DoorQuandon = 50901,
		DoorHideout = 50902
	},
	SpikeTaskQuest = {
		-- Reserved storage from 50910 - 50959
		QuestLine = 50910,
		Gnomilly = 50911,
		Gnombold = {
			Points = 50912,
			Nests = 50913,
			Fertilise = 50914,
			Kill = 50915,
			Charges = 50916
		},
		Gnomargery = {
			Points = 50920,
			Deliver = 50921,
			Undercover = 50922,
			Temperature = 50923,
			Kill = 50924
		}
	},
	OutfitQuest = {
		-- Reserved storage from 50960 - 51039
		-- Until all outfit quests are completed
		DefaultStart = 50960,
		Ref = 50961,
		Afflicted = {
			Outfit = 50962,
			AddonPlagueMask = 50963,
			AddonPlagueBell = 50964
		},
		Citizen = {
			-- Mission storages for temporary questlog entries
			MissionHat = 50966,
			AddonHat = 50967,
			MissionBackpack = 50968,
			AddonBackpack = 50969,
			AddonBackpackTimer = 50970
		},
		-- Begger Outfit Quest
		BeggarFirstAddonDoor = 50975, -- Staff quest
		BeggarSecondAddon = 50976,
		-- Druid-outfit Quest
		DruidHatAddon = 50977,
		DruidBodyAddon = 50978,
		DruidAmuletDoor = 50979,
		-- Barbarian-outfit Quest
		BarbarianAddon = 50980,
		BarbarianAddonWaitTimer = 50981,
		-- Beggar
		BeggarOutfit = 50982,
		BeggarOutfitTimer = 50983,
		-- Hunter-outfit Quest
		HunterMusicSheet01 = 50984,
		HunterMusicSheet02 = 50985,
		HunterMusicSheet03 = 50986,
		HunterMusicSheet04 = 50987,
		HunterBodyAddon = 50988,
		HunterHatAddon = 50989,
		Hunter = {
			AddonGlove = 50990,
			AddonHat = 50991
		},
		Knight = {
			AddonSword = 50992,
			MissionHelmet = 50993,
			AddonHelmet = 50994,
			AddonHelmetTimer = 50995,
			RamsaysHelmetDoor = 50996
		},
		MageSummoner = {
			AddonWand = 50997,
			AddonBelt = 50998,
			MissionHatCloak = 50999,
			AddonHatCloak = 51000,
			AddonWandTimer = 51001
		},
		-- Nobleman Outfit
		NoblemanFirstAddon = 51002,
		NoblemanSecondAddon = 51003,
		-- Norseman-outfit Quest
		NorsemanAddon = 51004,
		-- Warrior-outfit Quest
		WarriorShoulderAddon = 51005,
		WarriorSwordAddon = 51006,
		WarriorShoulderTimer = 51007,
		-- Wizard-outfit Quest
		WizardAddon = 51008,
		-- Pirate-outfit Quest
		PirateBaseOutfit = 51009,
		PirateSabreAddon = 51010,
		PirateHatAddon = 51011,
		-- Assassin Outfit
		AssassinBaseOutfit = 51012,
		AssassinFirstAddon = 51013,
		AssassinSecondAddon = 51014,
		-- Golden Outfit
		GoldenOutfit = 51015,
		NightmareOutfit = 51016,
		NightmareDoor = 51017,
		BrotherhoodOutfit = 51018,
		BrotherhoodDoor = 51019,
		Shaman = {
			AddonStaffMask = 51020,
			MissionStaff = 51021,
			MissionMask = 51022
		},
		DeeplingAnchor = 51023,
		FirstOrientalAddon = 51024,
		SecondOrientalAddon = 51025
	},
	TheAncientTombs = {
		-- Reserved storage from 50940 - 51059
		DefaultStart = 50940,
		VashresamunInstruments = 50941,
		VashresamunsDoor = 50942,
		MorguthisBlueFlameStorage1 = 50943,
		MorguthisBlueFlameStorage2 = 50944,
		MorguthisBlueFlameStorage3 = 50945,
		MorguthisBlueFlameStorage4 = 50946,
		MorguthisBlueFlameStorage5 = 50947,
		MorguthisBlueFlameStorage6 = 50948,
		MorguthisBlueFlameStorage7 = 50949,

		OmrucsTreasure = 50950,
		ThalasTreasure = 50951,
		DiphtrahsTreasure = 50952,
		MahrdisTreasure = 50953,
		VashresamunsTreasure = 50954,
		MorguthisTreasure = 50955,
		RahemosTreasure = 50956
	},
	TheApeCity = {
		-- Reserved storage from 51060 - 51079
		Started = 51060,
		Questline = 51061,
		DworcDoor = 51062,
		ChorDoor = 51063,
		ParchmentDecyphering = 51064,
		FibulaDoor = 51065,
		WitchesCapSpot = 51066,
		CasksDoor = 51067,
		Casks = 51068,
		HolyApeHair = 51069,
		SnakeDestroyer = 51070,
		ShamanOufit = 51071
	},
	TheNewFrontier = {
		-- Reserved storage from 51080 - 51109
		Questline = 51080,
		Mission01 = 51081,
		Mission02 = 51082,
		Mission03 = 51083,
		Mission04 = 51084,
		Mission05 = 51085,
		Mission06 = 51086,
		Mission07 = 51087,
		Mission08 = 51088,
		Mission09 = 51089,
		Mission10 = 51090,
		TomeofKnowledge = 51091,
		Beaver1 = 51092,
		Beaver2 = 51093,
		Beaver3 = 51094,
		BribeKing = 51095,
		BribeLeeland = 51096,
		BribeExplorerSociety = 51097,
		BribeWydrin = 51098,
		BribeTelas = 51099,
		BribeHumgolf = 51100
	},
	TheInquisition = {
		-- Reserved storage from 51110 - 51139
		Questline = 51110,
		Mission01 = 51111,
		Mission02 = 51112,
		Mission03 = 51113,
		Mission04 = 51114,
		Mission05 = 51115,
		Mission06 = 51116,
		Mission07 = 51117,
		RewardDoor = 51118,
		GrofGuard = 51120,
		KulagGuard = 51121,
		MilesGuard = 51122,
		TimGuard = 51123,
		WalterGuard = 51124,
		StorkusVampiredust = 51125,
		EnterTeleport = 51126,
		Reward = 51127,
		RewardRoomText = 51128
	},
	BarbarianTest = {
		-- Reserved storage from 51140 - 51159
		Questline = 51140,
		Mission01 = 51141,
		Mission02 = 51142,
		Mission03 = 51143,
		MeadTotalSips = 51144,
		MeadSuccessSips = 51145
	},
	TheIceIslands = {
		-- Reserved storage from 51160 - 51199
		Questline = 51160,
		Mission01 = 51161, -- Befriending the Musher
		Mission02 = 51162, -- Nibelor 1: Breaking the Ice
		Mission03 = 51163, -- Nibelor 2: Ecological Terrorism
		Mission04 = 51164, -- Nibelor 3: Artful Sabotage
		Mission05 = 51165, -- Nibelor 4: Berserk Brewery
		Mission06 = 51166, -- Nibelor 5: Cure the Dogs
		Mission07 = 51167, -- The Secret of Helheim
		Mission08 = 51168, -- The Contact
		Mission09 = 51169, -- Formorgar Mines 1: The Mission
		Mission10 = 51170, -- Formorgar Mines 2: Ghostwhisperer
		Mission11 = 51171, -- Formorgar Mines 3: The Secret
		Mission12 = 51172, -- Formorgar Mines 4: Retaliation
		PickAmount = 51173,
		PaintSeal = 51174,
		SulphurLava = 51175,
		SporesMushroom = 51176,
		FrostbiteHerb = 51177,
		FlowerCactus = 51178,
		FlowerBush = 51179,
		MemoryCrystal = 51180,
		Obelisk01 = 51181,
		Obelisk02 = 51182,
		Obelisk03 = 51183,
		Obelisk04 = 51184,
		yakchalDoor = 51185
	},
	TheWayToYalahar = {
		-- Reserved storage from 51200 - 51209
		QuestLine = 51200
	},
	InServiceofYalahar = {
		-- Reserved storage from 51210 - 51259
		Questline = 51210,
		Mission01 = 51211,
		Mission02 = 51212,
		Mission03 = 51213,
		Mission04 = 51214,
		Mission05 = 51215,
		Mission06 = 51216,
		Mission07 = 51217,
		Mission08 = 51218,
		Mission09 = 51219,
		Mission10 = 51220,
		SewerPipe01 = 51221,
		SewerPipe02 = 51222,
		SewerPipe03 = 51223,
		SewerPipe04 = 51224,
		DiseasedDan = 51225,
		DiseasedBill = 55226,
		DiseasedFred = 55227,
		AlchemistFormula = 51228,
		BadSide = 51229,
		GoodSide = 55230,
		MrWestDoor = 51231,
		MrWestStatus = 51232,
		TamerinStatus = 55233,
		MorikSummon = 51234,
		QuaraState = 51235,
		QuaraSplasher = 51236,
		QuaraSharptooth = 51237,
		QuaraInky = 51238,
		MatrixState = 51239,
		SideDecision = 51240,
		MatrixReward = 51241,
		NotesPalimuth = 51242,
		NotesAzerus = 51243,
		DoorToAzerus = 51244,
		DoorToBog = 55136,
		DoorToLastFight = 55137,
		DoorToMatrix = 51247,
		DoorToQuara = 51248,
		DoorToReward = 51249
	},
	ChildrenoftheRevolution = {
		-- Reserved storage from 55145 - 51279
		Questline = 55145,
		Mission00 = 55146, -- Prove Your Worzz!
		Mission01 = 51262,
		Mission02 = 51263,
		Mission03 = 51264,
		Mission04 = 55148,
		Mission05 = 51266,
		SpyBuilding01 = 51267,
		SpyBuilding02 = 51268,
		SpyBuilding03 = 51269,
		StrangeSymbols = 55154
	},
	UnnaturalSelection = {
		-- Reserved storage from 55159 - 51299
		Questline = 55159,
		Mission01 = 51281,
		Mission02 = 51282,
		Mission03 = 51283,
		Mission04 = 51284,
		Mission05 = 51285,
		Mission06 = 51286,
		DanceStatus = 51287
	},
	WrathoftheEmperor = {
		-- Reserved storage from 51300 - 51339
		Questline = 51300,
		Mission01 = 51301,
		Mission02 = 51302,
		Mission03 = 51303,
		Mission04 = 51304,
		Mission05 = 51305,
		Mission06 = 51306,
		Mission07 = 51307,
		Mission08 = 51308,
		Mission09 = 51309,
		Mission10 = 51310,
		Mission11 = 51311,
		Mission12 = 51312,
		CrateStatus = 51313, --1068
		GuardcaughtYou = 51314, --1062
		ZumtahStatus = 51315, --1066
		PrisonReleaseStatus = 51316, --1067
		GhostOfAPriest01 = 51317, --1070
		GhostOfAPriest02 = 51318, --1071
		GhostOfAPriest03 = 51319, --1072
		InterdimensionalPotion = 51320, --1084
		BossStatus = 51321, --1090
		platinumReward = 51322,
		backpackReward = 51323,
		mainReward = 51324,
		-- never set just added here
		TeleportAccess = 51325
	},
	FriendsandTraders = {
		-- Reserved storage from 51340 - 51359
		DefaultStart = 51340,
		TheSweatyCyclops = 51341,
		TheMermaidMarina = 51342,
		TheBlessedStake = 51343,
		TheBlessedStakeWaitTime = 51344
	},
	Postman = {
		-- Reserved storage from 51360 - 51389
		Mission01 = 51360,
		Mission02 = 51361,
		Mission03 = 51362,
		Mission04 = 51363,
		Mission05 = 51364,
		Mission06 = 51365,
		Mission07 = 51366,
		Mission08 = 51367,
		Mission09 = 51368,
		Mission10 = 51369,
		Rank = 51370,
		Door = 51371,
		TravelCarlin = 51372,
		TravelEdron = 51373,
		TravelVenore = 51374,
		TravelCormaya = 51375,
		MeasurementsBenjamin = 51376,
		MeasurementsKroox = 51377,
		MeasurementsDove = 51378,
		MeasurementsLiane = 51379,
		MeasurementsChrystal = 51380,
		MeasurementsOlrik = 51381
	},
	ThievesGuild = {
		-- Reserved storage from 515206 - 51409
		Quest = 515206,
		Mission01 = 515207,
		Mission02 = 515208,
		Mission03 = 515209,
		Mission04 = 51394,
		Mission05 = 56395,
		Mission06 = 51396,
		Mission07 = 51397,
		Mission08 = 51398,
		Door = 51399,
		Reward = 51400,
		TheatreScript = 51401
	},
	TheHuntForTheSeaSerpent = {
		-- Reserved storage from 51410 - 51419
		CaptainHaba = 51410
	},
	SecretService = {
		-- Reserved storage from 51420 - 51449
		Quest = 51420,
		TBIMission01 = 51421,
		AVINMission01 = 51422,
		CGBMission01 = 51423,
		TBIMission02 = 51424,
		AVINMission02 = 51425,
		CGBMission02 = 51426,
		TBIMission03 = 51427,
		AVINMission03 = 51428,
		CGBMission03 = 51429,
		TBIMission04 = 51430,
		AVINMission04 = 51431,
		CGBMission04 = 51432,
		TBIMission05 = 51433,
		AVINMission05 = 51434,
		CGBMission05 = 51435,
		TBIMission06 = 51436,
		AVINMission06 = 51437,
		CGBMission06 = 51438,
		Mission07 = 51439,
		RottenTree = 51440
	},
	HiddenCityOfBeregar = {
		-- Reserved storage from 51450 - 51479
		DefaultStart = 51450,
		WayToBeregar = 51451,
		OreWagon = 51452,
		GoingDown = 51453,
		JusticeForAll = 51454,
		GearWheel = 51455,
		SweetAsChocolateCake = 51456,
		RoyalRescue = 51457,
		TheGoodGuard = 51458,
		PythiusTheRotten = 51459,
		DoorNorthMine = 51460,
		DoorWestMine = 51461,
		DoorSouthMine = 51462,
		BrownMushrooms = 51463
	},
	TibiaTales = {
		-- Reserved storage from 51480 - 51539
		DefaultStart = 51480,
		ultimateBoozeQuest = 51481,
		AgainstTheSpiderCult = 51482,
		AnInterestInBotany = 51483,
		AnInterestInBotanyChestDoor = 51484,
		AritosTask = 51485,
		ToAppeaseTheMightyQuest = 51486,
		IntoTheBonePit = 51487,
		TheExterminator = 51488,
		RestInHallowedGround = {
			Questline = 51495,
			HolyWater = 51496,
			Graves = {
				Grave1 = 51501,
				Grave2 = 51502,
				Grave3 = 51503,
				Grave4 = 51504,
				Grave5 = 51505,
				Grave6 = 51506,
				Grave7 = 51507,
				Grave8 = 51508,
				Grave9 = 51509,
				Grave10 = 51510,
				Grave11 = 51511,
				Grave12 = 51512,
				Grave13 = 51513,
				Grave14 = 51514,
				Grave15 = 51515,
				Grave16 = 51516
			}
		},
		JackFutureQuest = {
			QuestLine = 51520,
			Furniture01 = 51521,
			Furniture02 = 51522,
			Furniture03 = 51523,
			Furniture04 = 51524,
			Furniture05 = 51525,
			Mother = 51526,
			Sister = 51527,
			Statue = 51528,
			LastMissionState = 51529
		},
	TheCursedCrystal = {
		Oneeyedjoe = 51530,
		MedusaOil = 51531,
		Questline = 51532
		}
	},
	TheShatteredIsles = {
		-- Reserved storage from 51540 - 51589
		DefaultStart = 51540,
		TheGovernorDaughter = 51541,
		TheErrand = 51542,
		AccessToMeriana = 51543,
		APoemForTheMermaid = 51544,
		ADjinnInLove = 51545,
		AccessToLagunaIsland = 51546,
		AccessToGoroma = 51547,
		Shipwrecked = 51548,
		DragahsSpellbook = 51549,
		TheCounterspell = 51550,
		ReputationInSabrehaven = 51551,
		RaysMission1 = 51552,
		RaysMission2 = 51553,
		RaysMission3 = 51554,
		RaysMission4 = 51555,
		AccessToNargor = 51556,
		TortoiseEggNargorDoor = 51557,
		TortoiseEggNargorTime = 51558,
		YavernDoor = 51559,
		TavernMap1 = 51560,
		TavernMap2 = 51561,
		TavernMap3 = 51562
	},
	SearoutesAroundYalahar = {
		-- Reserved storage from 51590 - 51609
		TownsCounter = 51590,
		AbDendriel = 51591,
		Darashia = 51592,
		Venore = 51593,
		Ankrahmun = 51594,
		PortHope = 51595,
		Thais = 51596,
		LibertyBay = 51597,
		Carlin = 51598
	},
	KillingInTheNameOf = {
		-- Reserved storage from 51610 - 51629
		LugriNecromancers = 51610,
		LugriNecromancerCount = 51611,
		BudrikMinos = 51612,
		BudrikMinosCount = 51613,
		MissionTiquandasRevenge = 51614,
		TiquandasRevengeTeleport = 51615,
		MissionDemodras = 51616,
		DemodrasTeleport = 51617
	},
	HotCuisineQuest = {
		-- Reserved storage from 51650 - 51659
		QuestStart = 51650,
		CurrentDish = 51651,
		QuestLog = 51652,
		CookbookDoor = 51653
	},
	RookgaardTutorialIsland = {
		-- Reserved storage from 51660 - 51679
		tutorialHintsStorage = 51665,
		SantiagoNpcGreetStorage = 51666,
		SantiagoQuestLog = 51667,
		cockroachKillStorage = 51668,
		cockroachLegsMsgStorage = 51669,
		cockroachBodyMsgStorage = 51670,
		ZirellaNpcGreetStorage = 51671,
		ZirellaQuestLog = 51672,
		CarlosNpcGreetStorage = 51677,
		CarlosQuestLog = 51678
	},
	TheRookieGuard = {
		--Reserved storage 52360 - 52395
		Questline = 52360,
		Mission01 = 52361,
		Mission02 = 52362,
		Mission03 = 52363,
		Mission04 = 52364,
		Mission05 = 52365,
		Mission06 = 52366,
		Mission07 = 52367,
		Mission08 = 52368,
		Mission09 = 52369,
		Mission10 = 52370,
		Mission11 = 52371,
		Mission12 = 52372,
		StonePileTimer = 52373,
		Catapults = 52374,
		RatKills = 52375,
		PoacherCorpse = 52376,
		LibraryChest = 52377,
		TrollChests = 52378,
		TunnelPillars = 52379,
		Sarcophagus = 52380,
		AcademyChest = 52381,
		KraknaknorkChests = 52382,
		TutorialDelay = 52383,
		LibraryDoor = 52384,
		UnholyCryptDoor = 52385,
		AcademyDoor = 52386,
		AcademyChestTimer = 52387,
		WarWolfDenChest = 52388,
		UnholyCryptChests = 52389,
		OrcFortressChests = 52390,
		Level8Warning = 52391
	},
	BanutaSecretTunnel = {
		-- Reserved storage from 51680 - 51689
		DeeperBanutaShortcut = 51680,
	},
	DemonOak = {
		-- Reserved storage from 51700 - 51709
		Done = 51700,
		Progress = 51701,
		Squares = 51702,
		AxeBlowsBird = 51703,
		AxeBlowsLeft = 51704,
		AxeBlowsRight = 51705,
		AxeBlowsFace = 51706
	},
	SvargrondArena = {
		-- Reserved storage from 51710 - 51729
		Arena = 51710,
		PitDoor = 51711,
		QuestLogGreenhorn = 51712,
		QuestLogScrapper = 51713,
		QuestLogWarlord = 51714,
		RewardGreenhorn = 51715,
		RewardScrapper = 51716,
		RewardWarlord = 51717,
		TrophyGreenhorn = 51718,
		TrophyScrapper = 51719,
		TrophyWarlord = 51720,
		GreenhornDoor = 51721,
		ScrapperDoor = 51722,
		WarlordDoor= 51723
	},
	QuestChests = {
		-- Reserved storage from 51730 - 51999
		KosheiTheDeathlessLegs = 51730,
		KosheiTheDeathlessGold = 51731,
		TutorialShovel = 51732,
		TutorialRope = 51733,
		DemonHelmetQuestDemonShield = 51734,
		DemonHelmetQuestDemonHelmet = 51735,
		DemonHelmetQuestSteelBoots = 51736,
		FormorgarMinesHoistSkeleton = 51737,
		FormorgarMinesHoistChest = 51738,
		-- Custom Quests, currently not using system.lua (aid 2000)
		BlackKnightTreeCrownShield = 51739,
		BlackKnightTreeCrownArmor = 51740,
		BlackKnightTreeKey = 51741,
		KosheiAmulet1 = 51742,
		KosheiAmulet2 = 51743,
		SilverBrooch = 51744,
		FamilyBrooch = 51745,
		DCQGhoul = 51746,
		FirewalkerBoots = 51747,
		DeeperFibulaKey = 51748,
		SixRubiesQuest = 51749,
		ParchmentRoomQuest = 51750,
		WarzoneReward1 = 51751,
		WarzoneReward2 = 51752,
		WarzoneReward3 = 51753,
		FathersBurdenWood = 51754,
		FathersBurdenIron = 51755,
		FathersBurdenRoot = 5176,
		FathersBurdenCrystal = 51757,
		FathersBurdenSilk = 51758,
		FathersBurdenCloth = 51759,
		OutlawCampKey1 = 51760,
		OutlawCampKey2 = 51761,
		OutlawCampKey3 = 51762,
		DoubletQuest = 51763,
		HoneyFlower = 51764,
		BananaPalm = 51765,
		WhisperMoss = 51766,
		OldParchment = 51767,
		DragahsSpellbook = 51768,
		StealFromThieves = 51769
	},
	PitsOfInferno = {
		-- Reserved storage from 52000 - 52019
		ShortcutHubDoor = 52000,
		ShortcutLeverDoor = 52001,
		Pumin = 52002,
		WeaponReward = 52003,
		ThroneInfernatil = 52004,
		ThroneTafariel = 52005,
		ThroneVerminor = 52006,
		ThroneApocalypse = 52007,
		ThroneBazir = 52008,
		ThroneAshfalor = 52009,
		ThronePumin = 52010
	},
	HorestisTomb = {
		-- Reserved storage from 52020 - 52029
		JarFloor1 = 52020,
		JarFloor2 = 52021,
		JarFloor3 = 52022,
		JarFloor4 = 52023,
		JarFloor5 = 52024
	},
	WhiteRavenMonastery = {
		-- Reserved storage from 52030 - 52039
		QuestLog = 52030,
		Passage = 52031,
		Diary = 52032,
		Door = 52033
	},
	FathersBurden = {
		-- Reserved storage from 52040 - 52059
		QuestLog = 52040,
		Progress = 52041,
		Status = 52042,
		Sinew = 52043,
		Wood = 52044,
		Cloth = 52045,
		Silk = 52046,
		Crystal = 52047,
		Root = 52048,
		Iron = 52049,
		Scale = 52050,
		Corpse = {
			Scale = 52051,
			Sinew = 52052
		}
	},
	WhatAFoolish = {
		-- Reserved storage from 52060 - 52099
		Questline = 52060,
		Mission1 = 52061,
		Mission2 = 52062,
		Mission3 = 52063,
		Mission4 = 52064,
		Mission5 = 52065,
		Mission6 = 52066,
		Mission7 = 52067,
		Mission8 = 52068,
		Mission9 = 52069,
		Mission10 = 52070,
		Mission11 = 52071,
		PieBuying = 52072,
		PieBoxTimer = 52073,
		TriangleTowerDoor = 52074,
		EmperorBeardShave = 52075,
		JesterOutfit = 52076,
		WhoopeeCushion = 52077,
		QueenEloiseCatDoor = 52078,
		CatBasket = 52079,
		ScaredCarina = 52080,
		InflammableSulphur = 52081,
		SpecialLeaves = 52082,
		Cigar = 52083,
		Contract = 52084,
		CookieDelivery = {
			SimonTheBeggar = 52085,
			Markwin = 52086,
			Ariella = 52087,
			Hairycles = 52088,
			Djinn = 52089,
			AvarTar = 52090,
			OrcKing = 52091,
			Lorbas = 52092,
			Wyda = 52093,
			Hjaern = 52094
		},
		OldWornCloth = 52095,
		LostDisguise = 52096,
		ScaredKazzan = 52097
	},
	SpiritHunters = {
		-- Reserved storage from 52100 - 52109
		Mission01 = 52100,
		TombUse = 52101,
		CharmUse = 52102,
		NightstalkerUse = 52103,
		SouleaterUse = 52104,
		GhostUse = 52105
	},
	SeaOfLight = {
		-- Reserved storage from 52110 - 52119
		Questline = 52110,
		Mission1 = 52111,
		Mission2 = 52112,
		Mission3 = 52113,
		StudyTimer = 52114,
		LostMinesCrystal = 52115
	},
	Diapason = {
		-- Reserved storage from 52120 - 52129
		Lyre = 52120,
		LyreTimer = 52121,
		Edala = 52122,
		EdalaTimer = 52123
	},
	AdventurersGuild = {
		-- Reserved storage from 52130 - 52159
		Stone = 52130,
		MagicDoor = 52131,
		CharosTrav = 52132,
		FreeStone = {
			Alia = 52133,
			Amanda = 52134,
			Brewster = 52135,
			Isimov = 52136,
			Kasmir = 52137,
			Kjesse = 52138,
			Lorietta = 52139,
			Maealil = 52140,
			Quentin = 52141,
			RockWithASoftSpot = 52142,
			Tyrias = 52143,
			Yberius = 52144,
			Rahkem = 52145
		},
		GreatDragonHunt = {
			WarriorSkeleton = 52146,
			DragonCounter = 52147
		}
	},
	DreamersChallenge = {
		-- Reserved storage from 52160 - 52199
		LeverNightmare1 = 52160,
		LeverNightmare2 = 52161,
		LeverNightmare3 = 52162,
		LeverBrotherhood1 = 52163,
		LeverBrotherhood2 = 52164,
		LeverBrotherhood3 = 52165,
		TicTac = 52166,
		Reward = 52167
	},
	HallsOfHope = {
		-- Reserved storage from 52200 - 52219
		Questline = 52200,
		Reward1 = 52201,
		Reward2 = 52202,
		Reward3 = 52203,
		Reward4 = 52204,
		Reward5 = 52205
	},
	InsectoidCell = {
		-- Reserved storage from 52220 - 52249
		Questline = 52220,
		Reward1 = 52221,
		Reward2 = 52222,
		Reward3 = 52223,
		Reward4 = 52224,
		Reward5 = 52225,
		Reward6 = 52226,
		Reward7 = 52227,
		Reward8 = 52228,
		Reward9 = 52229,
		Reward10 = 52230,
		Reward11 = 52231,
		Reward12 = 52232,
		Reward13 = 52233,
		Reward14 = 52234,
		Reward15 = 52235,
		Reward16 = 52236
	},
	Dawnport = {
		-- Reserved storage from 52250 - 52289
		-- Reward items storages
		SorcererHealthPotion = 52251,
		SorcererManaPotion = 52252,
		SorcererLightestMissile = 52253,
		SorcererLightStoneShower = 52254,
		SorcererMeat = 52255,
		DruidHealthPotion = 52256,
		DruidManaPotion = 52257,
		DruidLightestMissile = 52258,
		DruidLightStoneShower = 52259,
		DruidMeat = 52260,
		PaladinHealthPotion = 52261,
		PaladinManaPotion = 52262,
		PaladinLightestMissile = 52263,
		PaladinLightStoneShower = 52264,
		PaladinMeat = 52265,
		KnightHealthPotion = 52266,
		KnightManaPotion = 52267,
		KnightMeat = 52268,

		Sorcerer = 52269,
		Druid = 52270,
		Paladin = 52271,
		Knight = 52272,
		DoorVocation = 52273,
		DoorVocationFinish = 52274,
		ChestRoomFinish = 52275,
		Tutorial = 52276,
		MessageStair = 52277,
		Lever = 52278,
		Mainland = 52279
	},
	LionsRock = {
		-- Reserved storage from 52290 - 52309
		Questline = 52290,
		LionsStrength = 52291,
		LionsBeauty = 52292,
		LionsTears = 52293,
		GetLionsMane = 52294,
		GetHolyWater = 52295,
		SnakeSign = 52296,
		LizardSign = 52297,
		ScorpionSign = 52298,
		HyenaSign = 52299,
		Time = 52300
	},
	GraveDanger = {
		-- Reserved storage from 52310 - 52339
		Questline = 52310,
		CobraBastion = {
			Questline = 52311,
			ScarlettTimer = 52312
		}
	},
	RottinWoodAndMaried = {
		-- Reserved storage from 52340 - 52349
		Questline = 52340,
		RottinStart = 52341,
		Trap = 52342,
		Corpse = 52343,
		Time = 52344,
		Mission03 = 52345,
	},
	TheMummysCurse = {
		-- Reserved storage from 52350 - 52359
		Time1 = 52351,
		Time2 = 52352,
		Time3 = 52353,
		Time4 = 52354,
	},
	-- News quest development
	-- New storages
	Quest = {
		Key = {
			ID0010 = 103,
			ID3001 = 3001,
			ID3002 = 3002,
			ID3003 = 3003,
			ID3004 = 3004,
			ID3005 = 3005,
			ID3006 = 3006,
			ID3007 = 3007,
			ID3008 = 3008,
			ID3012 = 3012,
			ID3620 = 3620,
			ID3666 = 3666,
			ID3702 = 3702,
			ID3800 = 3800,
			ID3801 = 3801,
			ID3802 = 3802,
			ID3899 = 3899,
			ID3940 = 3940,
			ID3980 = 3980,
			ID4055 = 4055,
			ID4502 = 4502,
			ID5010 = 5010,
			ID6010 = 6010
		},
		SimpleChest = {
			FamilyBrooch = 9000
		},
		-- update pre-6.0
		DeeperFibula = {
			-- 10000 EMPTY
			RewardTowerShield = 10001,
			RewardWarriorHelmet = 10002,
			RewardDwarvenRing = 10003,
			RewardElvenAmulet = 10004,
			RewardKnightAxe = 10005
		},
		OrnamentedShield = {
			Bag = 10006,
			RedBag = 10007
		},
		ShortSword = {
			Book = 10008
		},
		ThaisLighthouse = {
			BattleHammer = 10009,
			DarkShield = 10010
		},
		-- update 6.0
		StuddedShield = {
			BananaFree = 10011,
			BananaPremium = 10012
		},
		-- update 6.1
		EmperorsCookies = {
			-- 10013/10015 EMPTY
			RopeReward = 10016,
		},
		ExplorerBrooch = {
			Reward = 10017
		},
		OrcFortress = {
			KnightAxe = 10018,
			KnightArmor = 10019,
			FireSword = 10020
		},
		Panpipe = {
			-- 10021 EMPTY
			Reward = 10022
		},
		-- update 6.2
		Draconia = {
			Reward1 = 10023,
			Reward2 = 10024
		},
		-- update 6.4
		AdornedUHRune = {
			Reward = 10025
		},
		BarbarianAxe = {
			BarbarianAxe = 10026,
			Scimitar = 10027
		},
		BerserkerTreasure = {
			Reward = 10028
		},
		DarkArmor = {
			Reward = 10029
		},
		DemonHelmet = {
			SteelBoots = 10030,
			DemonHelmet = 10031,
			DemonShield = 10032
		},
		DoubleHero = {
			RedGem = 10033,
			ClubRing = 10034
		},
		EdronGoblin = {
			SilverAmulet = 10035,
			SteelShield = 10036
		},
		FireAxe = {
			Bag = 10037,
			FireAxe = 10038
		},
		PoisonDaggers = {
			BackpackReward = 10039
		},
		Ring = {
			TimeRing = 10040,
			SwordRing = 10041
		},
		ShamanTreasure = {
			Bag = 10042
		},
		StrongPotions = {
			Reward = 10043
		},
		TrollCave = {
			GarlicNecklace = 10044,
			BrassLegs = 10045
		},
		VampireShield = {
			Bag = 10046,
			DragonLance = 10047,
			VampireShield = 10048
		},
		WeddingRing = {
			DragonNecklace = 10049,
			WeedingRing = 10050
		},
		-- update 6.5
		AlawarsVault = {
			WhitePearl = 10051,
			Broadsword = 10052
		},
		-- update 7.1
		BlackKnight = {
			-- 10053 EMPTY
			CrownArmor = 10054,
			CrownShield = 10055
		},
		DragonTower = {
			Backpack1 = 10056,
			Backpack2 = 10057
		},
		TimeRing = {
			CrystallBall = 10058,
			TimeRing = 10059,
			ElvenAmulet = 10060
		},
		-- update 7.2
		Behemoth = {
			Bag = 10061,
			GuardianHalberd = 10062,
			DemonShield = 10063,
			GoldenArmor = 10064
		},
		ParchmentRoom = {
			Bag = 10065
		},
		TheQueenOfTheBanshees = {
			Reward = {
				StoneSkinAmulet = 10066,
				StealthRing = 10067,
				TowerShield = 10068,
				GiantSword = 10069,
				BootsOfHaste = 10070,
				PlatinumCoin = 10071
			},
			QuestLine = 10072,
			FirstSeal = 10073,
			FirstSealDoor = 10074,
			SecondSeal = 10075,
			SecondSealDoor = 10076,
			ThirdSeal = 10077,
			ThirdSealDoor = 10078,
			ThirdSealWarlocks = 10079,
			FourthSeal = 10080,
			FourthSealDoor = 10081,
			FifthSeal = 10082,
			FifthSealDoor = 10083,
			FifthSealTile = 10084,
			SixthSeal = 10085,
			SixthSealDoor = 10086,
			LastSeal = 10087,
			LastSealDoor = 10088,
			BansheeDoor = 10089,
			FinalBattle = 10090
		},
		-- update 7.24
		GiantSmithhammer = {
			QuestLine = 10091,
			Talon = 10092,
			Hammer = 10093,
			GoldCoin = 10094
		},
		MadMageRoom = {
			QuestLine = 10095,
			APrisoner = 10096,
			StarAmulet = 10097,
			Hat = 10098,
			StoneSkinAmulet = 10099
		},
		SkullOfRatha = {
			Bag1 = 10100,
			Bag2 = 10101
		},
		TheAnnihilator = {
			Reward = 10102
		},
		TheParadoxTower = {
			QuestLine = 10103,
			TheFearedHugo = 10104,
			FirstParadoxAcess = 10105,
			FavoriteColour = 10106,
			Mathemagics = 10107,
			Reward = {
				Egg = 10108,
				Gold = 10109,
				Talon = 10110,
				Wand = 10111
			}
		},
		ThePostmanMissions = {},
		TheWhiteRavenMonastery = {},
		VoodooDoll = {},
		-- update 7.3
		MedusaShield = {},
		SerpentineTower = {},
		WhitePearl = {},
		-- update 7.4
		TheAncientTombs = {},
		TheDjinnWarEfreetFaction = {},
		TheDjinnWarMaridFaction = {},
		-- update 7.5
		ElephantTusk = {},
		Waterfall = {},
		-- update 7.6
		HydraEgg = {},
		TheApeCity = {},
		TheExplorerSociety = {},
		-- update 7.8
		AssassinOutfits = {},
		BarbarianOutfits = {},
		BeggarOutfits = {},
		CitizenOutfits = {},
		CitizenOutfitsRook = {},
		DruidOutfits = {},
		DruidOutfitsRook = {},
		HunterOutfits = {},
		KnightOutfits = {},
		MageOutfits = {},
		MarlinTrophy = {},
		Meriana = {},
		NoblemanOutfits = {},
		ObsidianKnife = {},
		OrientalOutfits = {},
		PirateOutfits = {},
		ShamanOutfits = {},
		SummonerOutfits = {},
		TheBlessedStake = {},
		TheMermaidMarina = {},
		TheShatteredIsles = {},
		TheSweatyCyclops = {},
		TreasureIsland = {},
		WarriorOutfits = {},
		WizardOutfits = {},
		-- update 7.9
		DreamersChallenge = {},
		ThePitsOfInferno = {},
		-- update 8.0
		BarbarianArena = {},
		BarbarianTest = {},
		BerserkPotion = {},
		FishingBox = {},
		FormorgarMinesHoist = {},
		FormorgarMines = {},
		FrostDragon = {},
		Inukaya = {},
		LionTrophy = {},
		MastermindPotion = {},
		NorsemanOutfits = {},
		Sinatuki = {},
		SkeletonDecoration = {},
		TheIceIslands = {},
		WaterskinOfMead = {},
		-- update 8.1
		AgainstTheSpiderCult = {},
		AritosTask = {},
		BrotherhoodOutfits = {},
		OutfitBrotherhoodMaleAddon = {},
		IntoTheBonePit = {},
		KissingAPig = {},
		KosheiTheDeathless = {},
		NightmareOutfits = {},
		OutfitNightmareMaleAddon = {},
		NomadsLand = {},
		RestInHallowedGround = {},
		SecretService = {},
		StealFromThieves = {},
		TheExterminator = {},
		TheTravellingTrader = {},
		TheUltimateBooze = {},
		ToAppeaseTheMighty = {},
		ToBlindTheEnemy = {},
		ToOutfoxAFox = {},
		TowerDefence = {},
		WhatAFoolish = {},
		-- update 8.2
		ElementalSpheres = {},
		MachineryOfWar = {},
		TheBeginning = {},
		TheDemonOak = {},
		TheHuntForTheSeaSerpent = {},
		TheInquisition = {},
		TheThievesGuild = {},
		TrollSabotage = {},
		VampireHunter = {},
		-- update 8.4
		BloodBrothers = {},
		InServiceOfYalahar = {},
		TheHiddenCityOfBeregar = {},
		TopOfTheCity = {},
		YalaharianOutfits = {},
		-- update 8.5
		Braindeath = {},
		DarashiaDragon = {},
		HotCuisine = {},
		KillingInTheNameOf = {},
		LoneMedusa = {},
		PilgrimageOfAshes = {},
		ShadowsOfYalahar = {},
		TheIsleOfEvil = {},
		TheLightbearer = {},
		TheScatterbrainedSorcerer = {},
		TreasureHunt = {},
		-- update 8.54
		AnUneasyAlliance = {},
		ChildrenOfTheRevolution = {},
		SeaOfLight = {},
		TheNewFrontier = {},
		TomesOfKnowledge = {},
		UnnaturalSelection = {},
		WarmasterOutfits = {},
		-- update 8.6
		AFathersBurden = {},
		AnInterestInBotany = {},
		TheSpiritWillGetYou = {},
		WayfarerOutfits = {},
		WrathOfTheEmperor = {},
		-- update 8.61
		RiseOfDevovorga = {},
		-- update 8.7
		APieceOfCake = {},
		APiratesDeathToMe = {},
		AnnualAutumnVintage = {},
		Bewitched = {},
		DemonsLullaby = {},
		JackToTheFuture = {},
		LastCreepStanding = {},
		ResearchAndDevelopment = {},
		RottinWoodAndTheMarriedMen = {},
		Spirithunters = {},
		TheColoursOfMagic = {},
		--update 9.1
		AfflictedOutfits = {},
		AwashWorldChange = {},
		DemonWarsWorldChange = {},
		ElementalistOutfits = {},
		HorseStationWorldChange = {},
		InsectoidInvasionWorldChange = {},
		LooseEnds = {},
		OverhuntingWorldChange = {},
		SteamshipWorldChange = {},
		SwampFeverWorldChange = {},
		TheMagesTowerWorldChange = {},
		TheMummysCurseWorldChange = {},
		TheRookieGuard = {},
		TheirMastersVoiceWorldChange = {},
		ThornfireWorldChange = {},
		TwistedWatersWorldChange = {},
		-- update 9.4
		BankRobberyMiniWorldChange = {},
		BoredMiniWorldChange = {},
		DeeplingsWorldChange = {},
		DownTheDrainMiniWorldChange = {},
		FireFromTheEarthMiniWorldChange = {},
		HiveBornWorldChange = {},
		InsectoidOutfits = {},
		KingsdayMiniWorldChange = {},
		LiquidBlack = {},
		LumberjackMiniWorldChange = {},
		NomadsMiniWorldChange = {},
		NoodlesIsGoneMiniWorldChange = {},
		OrientalTraderMiniWorldChange = {},
		RiverRunsDeepMiniWorldChange = {},
		StampedeMiniWorldChange = {},
		ThawingMiniWorldChange = {},
		WarAgainstTheHive = {},
		-- update 9.5
		SpringIntoLife = {},
		-- update 9.80
		BigfootsBurden = {},
		CrystalWarlordOutfits = {},
		DevovorgasEssenceMiniWorldChange = {},
		SoilGuardianOutfits = {},
		SpiderNestMiniWorldChange = {},
		WarpathMiniWorldChange = {},
		-- update 9.80
		ChildOfDestiny = {},
		DemonOutfits = {},
		GoblinMerchant = {},
		VenoreDailyTasks = {},
		-- update 10.10
		FuryGatesMiniWorldChange = {},
		HuntingForTokens = {},
		OpticordingSphere = {},
		SmallSapphire = {},
		TheGravediggerOfDrefia = {},
		TheRepenters = {},
		-- update 10.20
		CaveExplorerOutfits = {},
		SpikeTasks = {},
		SpiritGroundsMiniWorldChange = {},
		-- update 10.30
		DreamWardenOutfits = {},
		Roshamuul = {},
		-- update 10.37
		TinderBox = {},
		ChyllfroestMiniWorldChange = {},
		-- update 10.50
		DarkTrails = {},
		GloothEngineerOutfits = {},
		Oramond = {},
		Rathleton = {},
		-- update 10.55
		Dawnport = {
			VocationReward = 20000,
			Questline = 20001,
			GoMain = 20002,
			TheLostAmulet = 20003,
			TheStolenLogBook = 20004,
			TheRareHerb = 20005,
			TheDormKey = 20006,
			StrangeAmulet = 20007,
			TornLogBook = 20008,
			HerbFlower = 20009,
			MorriskTroll = 20010,
			MorrisTrollCount = 20011,
			MorrisGoblin = 20012,
			MorrisGoblinCount = 20013,
			MorrisMinos = 20014,
			MorrisMinosCount = 20015
		},
		SanctuaryOfTheLizardGod = {
			LizardGodTeleport = 20020,
			LegionHelmet = 20021
		},
		-- update 10.70
		HeroOfRathleton = {},
		LionsRock = {},
		TheCursedCrystal = {},
		TheFireFeatheredSerpentWorldChange = {},
		TwentyMilesBeneathTheSea = {},
		-- update 10.80
		AsuraPalace = {},
		Cartography101 = {},
		Grimvale = {},
		NightmareTeddy = {},
		TheGreatDragonHunt = {},
		TheLostBrother = {},
		TheTaintedSouls = {},
		-- update 10.90
		FerumbrasAscension = {},
		Krailos = {},
		RiftWarriorOutfits = {},
		-- update 10.94
		HeartOfDestruction = {},
		-- update 11.02
		FestiveOutfits = {},
		FirstDragon = {},
		ForgottenKnowledge = {},
		-- update 11.40
		CultsOfTibia = {},
		ThreatenedDreams = {},
		-- update 11.50
		DangerousDepths = {},
		HiddenThreats = {},
		MakeshiftWarriorOutfits = {},
		-- update 11.80
		BattleMageOutfits = {},
		DiscovererOutfits = {},
		MeasuringTibia = {},
		TheSecretLibrary = {},
		-- update 12.00
		DreamWarriorOutfits = {},
		TheDreamCourts = {
			AndrewDoor = 14900
		},
		-- update 12.02
		TibiaAnniversary = {},
		WinterlightSolstice = {},
		-- update 12.15.8659
		GoldenOutfits = {},
		-- update 12.20
		GraveDanger = {},
		HandOfTheInquisitionOutfits = {},
		-- Kilmaresh = {}, done earlier in the file
		GraveDanger = {},
		-- update 12.30
		FeasterOfSouls = {},
		PoltergeistOutfits = {}
	}
}

GlobalStorage = {
	DangerousDepths = {
		-- Reserved storage from 60001 - 60009
		Geodes = {
			WarzoneVI = 60001,
			WarzoneV = 60002,
			WarzoneIV = 60003
		}
	},
	TheirMastersVoice = {
		-- Reserved storage from 60010 - 60019
		CurrentServantWave = 60010,
		ServantsKilled = 60011
	},
	Feroxa = {
		-- Reserved storage from 60020 - 60029
		Chance = 60020,
		Active = 60021
	},
	FerumbrasAscendant = {
		-- Reserved storage from 60030 - 60069
		ZamuloshSummon = 60030,
		FerumbrasEssence = 60031,
		DesperateSoul = 60032,
		Crystals = {
			Crystal1 = 60040,
			Crystal2 = 60041,
			Crystal3 = 60042,
			Crystal4 = 60043,
			Crystal5 = 60044,
			Crystal6 = 60045,
			Crystal7 = 60046,
			Crystal8 = 60047,
			AllCrystals = 60048
		},
		Habitats = {
			Roshamuul = 60050,
			Grass = 60051,
			Mushroom = 60052,
			Desert = 60053,
			Venom = 60054,
			Ice = 60055,
			Corrupted = 60056,
			Dimension = 60057,
			AllHabitats = 60058
		},
		Elements = {
			First = 60060,
			Second = 60061,
			Third = 60062,
			Four = 60063,
			Active = 60064,
			Done = 60065
		}
	},
	HeroRathleton = {
		-- Reserved storage from 60070 - 60089
		FirstMachines = 60070,
		SecondMachines = 60071,
		ThirdMachines = 60072,
		FourthMachines = 60073,
		DeepRunning = 60074,
		HorrorRunning = 60075,
		LavaRunning = 60076,
		LavaCounter = 60077,
		MaxxenRunning = 60078,
		TentacleWave = 60079,
		DevourerWave = 60080,
		GloothWave = 60081,
		LavaChange = 60082
	},
	ForgottenKnowledge = {
		-- Reserved storage from 60090 - 60099
		ActiveTree = 60090,
		MechanismGolden = 60091,
		MechanismDiamond = 60092,
		GoldenServant = 60093,
		DiamondServant = 60094,
		AstralPowerCounter = 60095,
		AstralGlyph = 60096
	},
	InServiceOfYalahar = {
		-- Reserved storage from 60100 - 60109
		LastFight = 60100,
		WarGolemsMachine1 = 60101,
		WarGolemsMachine2 = 60102
	},
	BigfootBurden = {
		-- Reserved storage from 60110 - 60119
		Warzones = 60110,
		Weeper = 60111,
		Versperoth = {
			Battle = 60112,
			Health = 60113
		},
		Mouthpiece = 60114
	},
	WrathOfTheEmperor = {
		-- Reserved storage from 60120 - 60139
		Light01 = 60120,
		Light02 = 60121,
		Light03 = 60122,
		Light04 = 60123,
		Bosses = {
			Fury = 60130,
			Wrath = 60131,
			Scorn = 60132,
			Spite = 60133
		}
	},
	ElementalSphere = {
		-- Reserved storage from 60140 - 60159
		BossRoom = 60140,
		KnightBoss = 60141,
		SorcererBoss = 60142,
		PaladinBoss = 60143,
		DruidBoss = 60144,
		Machine1 = 60145,
		Machine2 = 60146,
		Machine3 = 60147,
		Machine4 = 60148
	},
	TheAncientTombs = {
		-- Reserved storage from 60160 - 60169
		ThalasSwitchesGlobalStorage = 60160,
		DiprathSwitchesGlobalStorage = 60161,
		AshmunrahSwitchesGlobalStorage = 60162
	},
	FuryGates = 65000,
	Yakchal = 65001,
	PitsOfInfernoLevers = 65002,
	NaginataStone = 65003,
	ExpBoost = 65004,
	SwordOfFury = 65005,
	XpDisplayMode = 65006,
	LionsRockFields = 65007,
	TheMummysCurse = 65008,
	OberonEventTime = 65009,
	PrinceDrazzakEventTime = 65010,
	ScarlettEtzelEventTime = 65011,
	CobraBastionFlask = 65012,
	Inquisition = 65013,
	Yasir = 65014,
	NightmareIsle = 65015
}


-- Values extraction function
local function extractValues(tab, ret)
	if type(tab) == "number" then
		table.insert(ret, tab)
	else
		for _, v in pairs(tab) do
			extractValues(v, ret)
		end
	end
end

local benchmark = os.clock()
local extraction = {}
extractValues(Storage, extraction) -- Call function
table.sort(extraction) -- Sort the table
-- The choice of sorting is due to the fact that sorting is very cheap O (n log2 (n))
-- And then we can simply compare one by one the elements finding duplicates in O(n)

-- Scroll through the extracted table for duplicates
if #extraction > 1 then
	for i = 1, #extraction - 1 do
		if extraction[i] == extraction[i+1] then
			Spdlog.warn(string.format("Duplicate storage value found: %d",
				extraction[i]))
			Spdlog.warn(string.format("Processed in %.4f(s)", os.clock() - benchmark))
		end
	end
end
