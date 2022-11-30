--[[
TODO
Unite all related variables/functions in a table
rewrite functions like "getTasksByPlayer" to "Player.getTasks"
]]

RANK_NONE = 0
RANK_JOIN = 1
RANK_HUNTSMAN = 2
RANK_RANGER = 3
RANK_BIGGAMEHUNTER = 4
RANK_TROPHYHUNTER = 5
RANK_ELITEHUNTER = 6

REWARD_MONEY = 1
REWARD_EXP = 2
REWARD_ACHIEVEMENT = 3
REWARD_STORAGE = 4
REWARD_POINT = 5
REWARD_ITEM = 6

QUESTSTORAGE_BASE = 1500
JOIN_STOR = 100157
KILLSSTORAGE_BASE = 65000
REPEATSTORAGE_BASE = 48950
POINTSSTORAGE = 2500
tasks =
{
	Extra =
	{
		[1] = {
			killsRequired = 20,
			raceName = "Mountain Trolls",
			level = {1, 9999}, storage = {12701, 1}, norepeatable = true,
			premium = false,
			creatures = {
				"mountain trolls"
			},
			rewards = {
				{type = "storage", value = {17524, 1}}
			}
		},
		[2] = {
			killsRequired = 20,
			raceName = "Muglex Clan Footman",
			level = {1, 9999}, storage = {12702, 1}, norepeatable = true,
			premium = false,
			creatures = {
				"muglex clan footman "
			},
			rewards = {
				{type = "storage", value = {17525, 1}}
			}
		},
		[3] = {
			killsRequired = 20,
			raceName = "Minotaur Bruisers",
			level = {1, 9999}, storage = {12703, 1}, norepeatable = true,
			premium = false,
			creatures = {
				"minotaur bruisers"
			},
			rewards = {
				{type = "storage", value = {17526, 1}}
			}
		}
	},
	DanielSteelsoul =
	{
		[1] = {
			killsRequired = 100,
			raceName = "Trolls",
			level = {6, 19},
			premium = true,
			creatures = {
				"troll",
				"troll champion"
			},
			rewards = {
				{type = "exp", value = {200}},
				{type = "money", value = {200}}
			}
		},
		[2] = {
			killsRequired = 150,
			raceName = "Goblins",
			level = {6, 19},
			premium = true,
			creatures = {
				"goblin",
				"goblin scavenger",
				"goblin assassin"
			},
			rewards = {
				{type = "exp", value = {300}},
				{type = "money", value = {250}}
			}
		},
		[3] = {
			killsRequired = 300,
			raceName = "Rotworms",
			level = {20, 39},
			premium = true,
			creatures = {
				"rotworm",
				"carrion worm"
			},
			rewards = {
				{type = "exp", value = {1000}},
				{type = "money", value = {400}}
			}
		},
		[4] = {
			killsRequired = 500,
			raceName = "Cyclops",
			level = {30, 59},
			premium = true,
			creatures = {
				"cyclops",
				"cyclops drone",
				"cyclops smith"
			},
			rewards = {
				{type = "exp", value = {3000}},
				{type = "money", value = {800}}
			}
		},
	},
	Gabel =
	{
		[1] = {
			killsRequired = 500,
			raceName = "Green Djinns or Efreets",
			level = {1, 9999},
			premium = true,
			creatures = {
				"green djinn",
				"efreet"
			},
			rewards = {
				{type = "exp", value = {10000}},
				{type = "money", value = {5000}}
			}
		}
	},
	Malor =
	{
		[1] = {
			killsRequired = 500,
			raceName = "Blue Djinns or Marids",
			level = {1, 9999},
			premium = true,
			creatures = {
				"blue djinn",
				"marid"
			},
			rewards = {
				{type = "exp", value = {10000}},
				{type = "money", value = {5000}}
			}
		}
	},
	RaymondStriker =
	{
		[1] = {
			killsRequired = 3000,
			raceName = "Pirates",
			level = {1, 9999},
			premium = true,
			creatures = {
				"pirate marauder",
				"pirate cutthroat",
				"pirate buccaneer",
				"pirate corsair"
			},
			rewards = {
				{type = "exp", value = {10000}},
				{type = "money", value = {5000}}
			}
		}
	},
	Budrik =
	{
		[1] = {
			killsRequired = 5000,
			raceName = "Minotaurs",
			level = {1, 40}, norepeatable = true,
			premium = false,
			creatures = {
				"minotaur",
				"minotaur guard",
				"minotaur mage",
				"minotaur archer"
			}
		}
	},
	Lugri =
	{
		[1] = {
			killsRequired = 4000,
			raceName = "Necromancers and Priestesses",
			level = {60, 9999}, norepeatable = true,
			premium = true,
			creatures = {
				"necromancer",
				"priestess",
				"blood priest",
				"blood hand",
				"shadow pupil"
			}
		}
	},
	GrizzlyAdams =
	{
		[1] = {
			killsRequired = 300,
			raceName = "Crocodiles",
			bossName = "Snapper",
			level = {6, 49},
			bossId = 1,
			premium = true,
			creatures = {
				"crocodile"
			},
			rewards = {
				{type = "exp", value = {800}},
				{type = "achievement", value = {"Blood-Red Snapper"}},
				{type = "storage", value = {34100, Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.SnapperCount, 1, 0}}, -- bossTP, bossCount, startValueTP, startValueCount
				{type = "points", value = {1}}
			}
		},
		[2] = {
			killsRequired = 300,
			raceName = "Badgers",
			level = {6, 49},
			premium = true,
			creatures = {
				"badger"
			},
			rewards = {
				{type = "exp", value = {500}},
				{type = "points", value = {1}}
			}
		},
		[3] = {
			killsRequired = 300,
			raceName = "Tarantulas",
			bossName = "Hide",
			level = {6, 49},
			bossId = 2,
			premium = true,
			creatures = {
				"tarantula"
			},
			rewards = {
				{type = "exp", value = {1500}},
				{type = "achievement", value = {"No More Hiding"}},
				{type = "storage", value = {34101, Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.HideCount, 1, 0}},
				{type = "points", value = {2}}
			}
		},
		[4] = {
			killsRequired = 150,
			raceName = "Carniphilas",
			bossName = "Deathbine",
			level = {6, 49},
			bossId = 3,
			premium = true,
			creatures = {
				"carniphila"
			},
			rewards = {
				{type = "exp", value = {2500}},
				{type = "achievement", value = {"Rootless Behaviour"}},
				{type = "storage", value = {34102, Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.DeathbineCount, 1, 0}},
				{type = "points", value = {3}}
			}
		},
		[5] = {
			killsRequired = 200,
			raceName = "Stone Golems",
			level = {6, 49},
			premium = true,
			creatures = {
				"stone golem"
			},
			rewards = {
				{type = "exp", value = {2000}},
				{type = "points", value = {3}}
			}
		},
		[6] = {
			killsRequired = 300,
			raceName = "Mammoths",
			bossName = "Bloodtusk",
			level = {6, 49},
			bossId = 4,
			premium = true,
			creatures = {
				"mammoth"
			},
			rewards = {
				{type = "exp", value = {4000}},
				{type = "achievement", value = {"Meat Skewer"}},
				{type = "storage", value = {34103, Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.BloodtuskCount, 1, 0}},
				{type = "points", value = {3}}
			}
		},
		[7] = {
			killsRequired = 300,
			raceName = "Gnarlhounds",
			level = {6, 49},
			premium = true,
			creatures = {
				"gnarlhound"
			},
			rewards = {
				{type = "exp", value = {1000}},
				{type = "points", value = {2}}
			}
		},
		[8] = {
			killsRequired = 300,
			raceName = "Terramites",
			level = {6, 49},
			premium = true,
			creatures = {
				"terramite"
			},
			rewards = {
				{type = "exp", value = {1000}},
				{type = "points", value = {2}}
			}
		},
		[9] = {
			killsRequired = 300,
			raceName = "Apes",
			level = {6, 49},
			premium = true,
			creatures = {
				"kongra",
				"merlkin",
				"sibang"
			},
			rewards = {
				{type = "exp", value = {1000}},
				{type = "points", value = {2}}
			}
		},
		[10] = {
			killsRequired = 300,
			raceName = "Thornback Tortoises",
			level = {6, 49},
			premium = true,
			creatures = {
				"thornback tortoise"
			},
			rewards = {
				{type = "exp", value = {1500}},
				{type = "points", value = {2}}
			}
		},
		[11] = {
			killsRequired = 300,
			raceName = "Gargoyles",
			level = {6, 49},
			premium = true,
			creatures = {
				"gargoyle"
			},
			rewards = {
				{type = "exp", value = {1500}}
			}
		},
		[12] = {
			killsRequired = 300,
			raceName = "Ice Golems",
			bossName = "Shardhead",
			level = {50, 79},
			bossId = 5,
			premium = true,
			creatures = {
				"ice golem"
			},
			rewards = {
				{type = "exp", value = {12000}},
				{type = "achievement", value = {"Breaking The Ice"}},
				{type = "storage", value = {34104, Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.ShardheadCount, 1, 0}},
				{type = "points", value = {2}}
			}
		},
		[13] = {
			killsRequired = 400,
			raceName = "Quara Scouts",
			level = {50, 79},
			premium = true,
			creatures = {
				"quara constrictor scout",
				"quara hydromancer scout",
				"quara mantassin scout",
				"quara pincher scout",
				"quara predator scout"
			},
			rewards = {
				{type = "exp", value = {10000}},
				{type = "points", value = {2}}
			}
		},
		[14] = {
			killsRequired = 400,
			raceName = "Mutated Rats",
			bossName = "Esmeralda",
			level = {50, 79},
			bossId = 6,
			premium = true,
			creatures = {
				"mutated rat"
			},
			rewards = {
				{type = "exp", value = {10000}},
				{type = "achievement", value = {"Twisted Mutation"}},
				{type = "storage", value = {34105, Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.EsmeraldaCount, 1, 0}},
				{type = "points", value = {2}}
			}
		},
		[15] = {
			killsRequired = 250,
			raceName = "Ancient Scarabs",
			bossName = "Fleshcrawler",
			level = {50, 79},
			bossId = 7,
			premium = true,
			creatures = {
				"ancient scarab"
			},
			rewards = {
				{type = "exp", value = {15000}},
				{type = "achievement", value = {"Crawling Death"}},
				{type = "storage", value = {34106, Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.FleshcrawlerCount, 1, 0}},
				{type = "points", value = {2}}
			}
		},
		[16] = {
			killsRequired = 300,
			raceName = "Wyverns",
			level = {50, 79},
			premium = true,
			creatures = {
				"wyvern"
			},
			rewards = {
				{type = "exp", value = {12000}},
				{type = "points", value = {2}}
			}
		},
		[17] = {
			killsRequired = 300,
			raceName = "Lancer Beetles",
			level = {50, 79},
			premium = true,
			creatures = {
				"lancer beetle"
			},
			rewards = {
				{type = "exp", value = {8000}},
				{type = "points", value = {2}}
			}
		},
		[18] = {
			killsRequired = 400,
			raceName = "Wailing Widows",
			level = {50, 79},
			premium = true,
			creatures = {
				"wailing widow"
			},
			rewards = {
				{type = "exp", value = {12000}},
				{type = "points", value = {3}}
			}
		},
		[19] = {
			killsRequired = 250,
			raceName = "Killer Caimans",
			level = {50, 79},
			premium = true,
			creatures = {
				"killer caiman"
			},
			rewards = {
				{type = "exp", value = {10000}},
				{type = "points", value = {2}}
			}
		},
		[20] = {
			killsRequired = 300,
			raceName = "Bonebeasts",
			bossName = "Ribstride",
			level = {50, 79},
			bossId = 8,
			premium = true,
			creatures = {
				"bonebeast"
			},
			rewards = {
				{type = "exp", value = {12000}},
				{type = "achievement", value = {"Spareribs for Dinner"}},
				{type = "storage", value = {34107, Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.RibstrideCount, 1, 0}},
				{type = "points", value = {2}}
			}
		},
		[21] = {
			killsRequired = 300,
			raceName = "Crystal Spiders",
			bossName = "Bloodweb",
			level = {50, 79},
			bossId = 9,
			creatures = {
				"crystal spider"
			},
			premium = true,
			rewards = {
				{type = "exp", value = {15000}},
				{type = "achievement", value = {"Arachnoise"}},
				{type = "storage", value = {34108, Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.BloodwebCount, 1, 0}},
				{type = "points", value = {3}}
			}
		},
		[22] = {
			killsRequired = 300,
			raceName = "Mutated Tigers",
			level = {50, 79},
			premium = true,
			creatures = {
				"mutated tiger"
			},
			rewards = {
				{type = "exp", value = {12000}},
				{type = "points", value = {2}}
			}
		},
		[23] = {
			killsRequired = 600,
			raceName = "Underwater Quara",
			bossName = "Thul",
			level = {80, 129},
			bossId = 10,
			premium = true,
			creatures = {
				"quara constrictor",
				"quara hydromancer",
				"quara mantassin",
				"quara pincher",
				"quara predator"
			},
			rewards = {
				{type = "exp", value = {15000}},
				{type = "achievement", value = {"Back into the Abyss"}},
				{type = "storage", value = {34109, Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.ThulCount, 1, 0}},
				{type = "points", value = {3}}
			}
		},
		[24] = {
			killsRequired = 500,
			raceName = "Giant Spiders",
			bossName = "Old Widow",
			level = {80, 129},
			bossId = 11,
			premium = true,
			creatures = {
				"giant spider"
			},
			rewards = {
				{type = "exp", value = {20000}},
				{type = "achievement", value = {"Choking on Her Venom"}},
				{type = "storage", value = {34110, Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.WidowCount, 1, 0}},
				{type = "points", value = {3}}
			}
		},
		[25] = {
			killsRequired = 300,
			raceName = "Werewolves",
			bossName = "Hemming",
			level = {80, 129},
			bossId = 12,
			premium = true,
			creatures = {
				"werewolf"
			},
			rewards = {
				{type = "exp", value = {30000}},
				{type = "achievement", value = {"Howly Silence"}},
				{type = "storage", value = {34111, Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.HemmingCount, 1, 0}},
				{type = "points", value = {4}}
			}
		},
		[26] = {
			killsRequired = 400,
			raceName = "Nightmares",
			bossName = "Tormentor",
			level = {80, 129},
			bossId = 13,
			premium = true,
			creatures = {
				"nightmare",
				"nightmare scion"
			},
			rewards = {
				{type = "exp", value = {25000}},
				{type = "achievement", value = {"Dream's Over"}},
				{type = "storage", value = {34112, Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.TormentorCount, 1, 0}},
				{type = "points", value = {3}}
			}
		},
		[27] = {
			killsRequired = 600,
			raceName = "Hellspawns",
			bossName = "Flameborn",
			level = {80, 129},
			bossId = 14,
			premium = true,
			creatures = {
				"hellspawn"
			},
			rewards = {
				{type = "exp", value = {25000}},
				{type = "achievement", value = {"Scorched Flames"}},
				{type = "storage", value = {34113, Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.FlamebornCount, 1, 0}},
			}
		},
		[28] = {
			killsRequired = 800,
			raceName = "High Class Lizards",
			bossName = "Fazzrah",
			level = {80, 129},
			bossId = 15,
			premium = true,
			creatures = {
				"lizard chosen",
				"lizard dragon priest",
				"lizard high guard",
				"lizard legionnaire",
				"lizard zaogun"
			},
			rewards = {
				{type = "exp", value = {30000}},
				{type = "achievement", value = {"Zzztill Zzztanding!"}},
				{type = "storage", value = {34114, Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.FazzrahCount, 1, 0}},
				{type = "points", value = {3}}
			}
		},
		[29] = {
			killsRequired = 600,
			raceName = "Stampors",
			bossName = "Tromphonyte",
			level = {80, 129},
			bossId = 16,
			premium = true,
			creatures = {
				"stampor"
			},
			rewards = {
				{type = "exp", value = {20000}},
				{type = "achievement", value = {"Stepped on a Big Toe"}},
				{type = "storage", value = {34115, Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.TromphonyteCount, 1, 0}},
				{type = "points", value = {3}}
			}
		},
		[30] = {
			killsRequired = 500,
			raceName = "Brimstone Bugs",
			bossName = "Sulphur Scuttler",
			level = {80, 129},
			bossId = 17,
			premium = true,
			creatures = {
				"brimstone bug"
			},
			rewards = {
				{type = "exp", value = {15000}},
				{type = "achievement", value = {"Something Smells"}},
				{type = "storage", value = {34116, Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.ScuttlerCount, 1, 0}},
				{type = "points", value = {3}}
			}
		},
		[31] = {
			killsRequired = 400,
			raceName = "Mutated Bats",
			bossName = "Bruise Payne",
			level = {80, 129},
			bossId = 18,
			premium = true,
			creatures = {
				"mutated bat"
			},
			rewards = {
				{type = "exp", value = {20000}},
				{type = "achievement", value = {"Kapow!"}},
				{type = "storage", value = {34117, Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.PayneCount, 1, 0}},
				{type = "points", value = {2}}
			}
		},
		[32] = {
			killsRequired = 650,
			raceName = "Hydras",
			bossName = "Many",
			level = {130, 9999},
			bossId = 19,
			repeatable = true,
			premium = true,
			creatures = {
				"hydra"
			},
			rewards = {
				{type = "exp", value = {30000}},
				{type = "achievement", value = {"One Less"}},
				{type = "storage", value = {34118, Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.ManyCount, 1, 0}},
				{type = "points", value = {3}}
			}
		},
		[33] = {
			killsRequired = 800,
			raceName = "Serpent Spawns",
			bossName = "Noxious Spawn",
			level = {130, 9999},
			bossId = 20,
			repeatable = true,
			premium = true,
			creatures = {
				"serpent spawn"
			},
			rewards = {
				{type = "exp", value = {30000}},
				{type = "achievement", value = {"Hissing Downfall"}},
				{type = "storage", value = {34119, Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.NoxiousCount, 1, 0}},
				{type = "points", value = {4}}
			}
		},
		[34] = {
			killsRequired = 500,
			raceName = "Medusae",
			bossName = "Gorgo",
			level = {130, 9999},
			bossId = 21,
			repeatable = true,
			premium = true,
			creatures = {
				"medusa"
			},
			rewards = {
				{type = "exp", value = {40000}},
				{type = "achievement", value = {"The Serpent's Bride"}},
				{type = "storage", value = {34120, Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.GorgoCount, 1, 0}},
				{type = "points", value = {5}}
			}
		},
		[35] = {
			killsRequired = 700,
			raceName = "Behemoths",
			bossName = "Stonecracker",
			level = {130, 9999},
			bossId = 22,
			repeatable = true,
			premium = true,
			creatures = {
				"behemoth"
			},
			rewards = {
				{type = "exp", value = {30000}},
				{type = "achievement", value = {"Just Cracked Me Up!"}},
				{type = "storage", value = {34121, Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.StonecrackerCount, 1, 0}},
				{type = "points", value = {4}}
			}
		},
		[36] = {
			killsRequired = 900,
			raceName = "Sea Serpents",
			bossName = "Leviathan",
			level = {130, 9999},
			bossId = 23,
			repeatable = true,
			premium = true,
			creatures = {
				"sea serpent",
				"young sea serpent"
			},
			rewards = {
				{type = "exp", value = {30000}},
				{type = "achievement", value = {"The Drowned Sea God"}},
				{type = "storage", value = {34122, Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.LeviathanCount, 1, 0}},
				{type = "points", value = {4}}
			}
		},
		[37] = {
			killsRequired = 250,
			raceName = "Hellhounds",
			bossName = "Kerberos",
			level = {130, 9999},
			bossId = 24,
			repeatable = true,
			premium = true,
			creatures = {
				"hellhound"
			},
			rewards = {
				{type = "exp", value = {40000}},
				{type = "achievement", value = {"The Gates of Hell"}},
				{type = "storage", value = {34123, Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.KerberosCount, 1, 0}},
				{type = "points", value = {5}}
			}
		},
		[38] = {
			killsRequired = 500,
			raceName = "Ghastly Dragons",
			bossName = "Ethershreck",
			level = {130, 9999},
			bossId = 25,
			repeatable = true,
			premium = true,
			creatures = {
				"ghastly dragon"
			},
			rewards = {
				{type = "exp", value = {30000}},
				{type = "achievement", value = {"Beautiful Agony"}},
				{type = "storage", value = {34124, Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.EthershreckCount, 1, 0}},
				{type = "points", value = {5}}
			}
		},
		[39] = {
			killsRequired = 900,
			raceName = "Drakens",
			bossName = "Paiz the Pauperizer",
			level = {130, 9999},
			bossId = 26,
			repeatable = true,
			premium = true,
			creatures = {
				"draken abomination",
				"draken elite",
				"draken spellweaver",
				"draken warmaster"
			},
			rewards = {
				{type = "exp", value = {30000}},
				{type = "achievement", value = {"Enter zze Draken!"}},
				{type = "storage", value = {34125, Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.PauperizerCount, 1, 0}},
				{type = "points", value = {3}}
			}
		},
		[40] = {
			killsRequired = 650,
			raceName = "Destroyers",
			bossName = "Bretzecutioner",
			level = {130, 9999},
			bossId = 27,
			repeatable = true,
			premium = true,
			creatures = {
				"destroyer"
			},
			rewards = {
				{type = "exp", value = {30000}},
				{type = "achievement", value = {"King of the Ring"}},
				{type = "storage", value = {34126, Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.BretzecutionerCount, 1, 0}},
				{type = "points", value = {4}}
			}
		},
		[41] = {
			killsRequired = 400,
			raceName = "Undead Dragons",
			bossName = "Zanakeph",
			level = {130, 9999},
			bossId = 28,
			repeatable = true,
			premium = true,
			creatures = {
				"undead dragon"
			},
			rewards = {
				{type = "exp", value = {50000}},
				{type = "achievement", value = {"Back from the Dead"}},
				{type = "storage", value = {34127, Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.ZanakephCount, 1, 0}},
				{type = "points", value = {6}}
			}
		},
		[42] = {
			killsRequired = 6666,
			raceName = "Demons",
			level = {130, 9999}, rank = RANK_ELITEHUNTER, norepeatable = true,
			premium = true,
			creatures = {
				"demon"
			},
			rewards = {
				{type = "item", value = {9388, 1}},
				{type = "storage", value = {41300, 1}}
			}
		}
	}
}

tasksByPlayer = 3
repeatTimes = 3

function Player.getPawAndFurRank(self)
	return (self:getStorageValue(POINTSSTORAGE) >= 100
	and RANK_ELITEHUNTER or self:getStorageValue(POINTSSTORAGE) >= 70
	and RANK_TROPHYHUNTER or self:getStorageValue(POINTSSTORAGE) >= 40
	and RANK_BIGGAMEHUNTER or self:getStorageValue(POINTSSTORAGE) >= 20
	and RANK_RANGER or self:getStorageValue(POINTSSTORAGE) >= 10
	and RANK_HUNTSMAN or self:getStorageValue(JOIN_STOR) == 1
	and RANK_JOIN or RANK_NONE)
end

function Player.getPawAndFurPoints(self)
	return math.max(self:getStorageValue(POINTSSTORAGE), 0)
end

function getTaskByName(name, table)
	local t = (table and table or tasks.GrizzlyAdams)
	for k, v in pairs(t) do
		if v.name then
			if v.name:lower() == name:lower() then
				return k
			end
		else
			if v.raceName:lower() == name:lower() or v.raceName:lower():sub(1, -2) == name:lower() then
				return k
			end
		end
	end
	return false
end

function Player.getTasks(self)
	local canmake = {}
	local able = {}
	for k, v in pairs(tasks.GrizzlyAdams) do
		if self:getStorageValue(QUESTSTORAGE_BASE + k) < 1 and self:getStorageValue(REPEATSTORAGE_BASE + k) < repeatTimes then
			able[k] = true
			if self:getLevel() < v.level[1] or self:getLevel() > v.level[2] then
				able[k] = false
			end
			if v.storage and self:getStorageValue(v.storage[1]) < v.storage[2] then
				able[k] = false
			end

			if v.rank then
				if self:getPawAndFurRank() < v.rank then
					able[k] = false
				end
			end

			if v.premium then
				if not self:isPremium() then
					able[k] = false
				end
			end

			if able[k] then
				canmake[#canmake + 1] = k
			end
		end
	end
	return canmake
end

function Player.canStartTask(self, name, table)
	local v = ""
	local id = 0
	local t = (table and table or tasks.GrizzlyAdams)
	for k, i in pairs(t) do
		if i.name then
			if i.name:lower() == name:lower() then
				v = i
				id = k
				break
			end
		else
			if i.raceName:lower() == name:lower() or i.raceName:lower():sub(1, -2) == name:lower() then
				v = i
				id = k
				break
			end
		end
	end
	if v == "" then
		return false
	end
	if self:getStorageValue(QUESTSTORAGE_BASE + id) > 0 then
		return false
	end
	if self:getStorageValue(REPEATSTORAGE_BASE +  id) >= repeatTimes or v.norepeatable and self:getStorageValue(REPEATSTORAGE_BASE +  id) > 0 then
		return false
	end
	if v.level and self:getLevel() >= v.level[1] and self:getLevel() <= v.level[2] then
		if v.premium then
			if self:isPremium() then
				if v.rank then
					if self:getPawAndFurRank() >= v.rank then
						if v.storage then
							if self:getStorageValue(v.storage[1]) >= v.storage then
								return true
							end
						else
							return true
						end
					end
				else
					return true
				end
			else
				return true
			end
		else
			return true
		end
	end
	return false
end

function Player.getStartedTasks(self)
	local tmp = {}
	for k, v in ipairs(tasks.GrizzlyAdams) do
		if self:getStorageValue(QUESTSTORAGE_BASE + k) > 0 and self:getStorageValue(QUESTSTORAGE_BASE + k) < 2 then
			tmp[#tmp + 1] = k
		end
	end
	return tmp
end

function getPlayerRank(cid) local p = Player(cid) return p and p:getPawAndFurRank() end
function getPlayerTasksPoints(cid) local p = Player(cid) return p and p:getPawAndFurPoints() end
function getTasksByPlayer(cid) local p = Player(cid) return p and p:getTasks() end
function canStartTask(cid, name, table) local p = Player(cid) return p and p:canStartTask(name, table) end
function getPlayerStartedTasks(cid) local p = Player(cid) return p and p:getStartedTasks() end
