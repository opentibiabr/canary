local stage = configManager.getNumber(configKeys.FREE_QUEST_STAGE)

local questTable = {
	-- Bigfoot's Burden
	{storage = Storage.BigfootBurden.QuestLine,storageValue = 2},
	{storage = Storage.BigfootBurden.QuestLine,storageValue = 4},
	{storage = Storage.BigfootBurden.QuestLine,storageValue = 7},
	{storage = Storage.BigfootBurden.QuestLine,storageValue = 9},
	{storage = Storage.BigfootBurden.QuestLine,storageValue = 12},
	{storage = Storage.BigfootBurden.Shooting, storageValue =  5},
	{storage = Storage.BigfootBurden.QuestLine, storageValue = 16},
	{storage = Storage.BigfootBurden.QuestLine, storageValue = 20},
	{storage = Storage.BigfootBurden.QuestLine, storageValue = 23},
	{storage = Storage.BigfootBurden.QuestLineComplete, storageValue = 2},
	{storage = Storage.BigfootBurden.Rank, storageValue = 999999},
	{storage = Storage.BigfootBurden.Warzone1Access, storageValue = 2},
	{storage = Storage.BigfootBurden.Warzone2Access, storageValue = 2},
	{storage = Storage.BigfootBurden.Warzone3Access, storageValue = 2},

	-- WZ 4, 5 e 6
	{storage = Storage.DangerousDepths.Questline, storageValue = 10},
	{storage = Storage.DangerousDepths.Access.LavaPumpWarzoneVI, storageValue = 10},
	{storage = Storage.DangerousDepths.Access.LavaPumpWarzoneV, storageValue = 10},
	{storage = Storage.DangerousDepths.Access.LavaPumpWarzoneIV, storageValue = 30},
	{storage = Storage.DangerousDepths.Dwarves.Status, storageValue = 10},
	{storage = Storage.DangerousDepths.Scouts.Status, storageValue = 10},
	{storage = Storage.DangerousDepths.Gnomes.Status, storageValue = 10},

	--In Service of Yalahar
	{storage = Storage.InServiceofYalahar.Questline, storageValue = 51},
	{storage = Storage.InServiceofYalahar.Mission01, storageValue = 6},
	{storage = Storage.InServiceofYalahar.Mission02, storageValue = 8},
	{storage = Storage.InServiceofYalahar.Mission03, storageValue = 6},
	{storage = Storage.InServiceofYalahar.Mission04, storageValue = 6},
	{storage = Storage.InServiceofYalahar.Mission05, storageValue = 8},
	{storage = Storage.InServiceofYalahar.Mission06, storageValue = 5},
	{storage = Storage.InServiceofYalahar.Mission07, storageValue = 5},
	{storage = Storage.InServiceofYalahar.Mission08, storageValue = 4},
	{storage = Storage.InServiceofYalahar.Mission09, storageValue = 2},
	{storage = Storage.InServiceofYalahar.Mission10, storageValue = 1},
	-- part 2
	{storage = Storage.InServiceofYalahar.SewerPipe01, storageValue = 1},
	{storage = Storage.InServiceofYalahar.SewerPipe02, storageValue = 1},
	{storage = Storage.InServiceofYalahar.SewerPipe03, storageValue = 1},
	{storage = Storage.InServiceofYalahar.SewerPipe04, storageValue = 1},
	{storage = Storage.InServiceofYalahar.DiseasedDan, storageValue = 1},
	{storage = Storage.InServiceofYalahar.DiseasedBill, storageValue = 1},
	{storage = Storage.InServiceofYalahar.DiseasedFred, storageValue = 1},
	{storage = Storage.InServiceofYalahar.AlchemistFormula, storageValue = 1},
	{storage = Storage.InServiceofYalahar.BadSide, storageValue = 1},
	{storage = Storage.InServiceofYalahar.GoodSide , storageValue = 1},
	{storage = Storage.InServiceofYalahar.MrWestDoor, storageValue = 1},
	{storage = Storage.InServiceofYalahar.MrWestStatus, storageValue = 1},
	{storage = Storage.InServiceofYalahar.TamerinStatus, storageValue = 1},
	{storage = Storage.InServiceofYalahar.MorikSummon, storageValue = 1},
	{storage = Storage.InServiceofYalahar.QuaraState, storageValue = 1},
	{storage = Storage.InServiceofYalahar.QuaraSplasher, storageValue = 1},
	{storage = Storage.InServiceofYalahar.QuaraSharptooth, storageValue = 1},
	{storage = Storage.InServiceofYalahar.QuaraInky, storageValue = 1},
	{storage = Storage.InServiceofYalahar.MatrixState, storageValue = 1},
	{storage = Storage.InServiceofYalahar.NotesPalimuth, storageValue = 1},
	{storage = Storage.InServiceofYalahar.NotesAzerus, storageValue = 1},
	{storage = Storage.InServiceofYalahar.DoorToAzerus, storageValue = 1},
	{storage = Storage.InServiceofYalahar.DoorToBog, storageValue = 1},
	{storage = Storage.InServiceofYalahar.DoorToLastFight, storageValue = 1},
	{storage = Storage.InServiceofYalahar.DoorToMatrix, storageValue = 1},
	{storage = Storage.InServiceofYalahar.DoorToQuara, storageValue = 1},
	{storage = Storage.InServiceofYalahar.SewerPipe01, storageValue = 1},
	{storage = Storage.InServiceofYalahar.SewerPipe02, storageValue = 1},
	{storage = Storage.InServiceofYalahar.SewerPipe03, storageValue = 1},
	{storage = Storage.InServiceofYalahar.SewerPipe04, storageValue = 1},
	{storage = Storage.InServiceofYalahar.DiseasedDan, storageValue = 1},
	{storage = Storage.InServiceofYalahar.DiseasedBill, storageValue = 1},
	{storage = Storage.InServiceofYalahar.DiseasedFred, storageValue = 1},
	{storage = Storage.InServiceofYalahar.AlchemistFormula, storageValue = 1},
	{storage = Storage.InServiceofYalahar.BadSide, storageValue = 1},
	{storage = Storage.InServiceofYalahar.GoodSide, storageValue = 1},
	{storage = Storage.InServiceofYalahar.MrWestDoor, storageValue = 1},
	{storage = Storage.InServiceofYalahar.MrWestStatus, storageValue = 1},
	{storage = Storage.InServiceofYalahar.TamerinStatus, storageValue = 1},
	{storage = Storage.InServiceofYalahar.MorikSummon, storageValue = 1},
	{storage = Storage.InServiceofYalahar.QuaraState, storageValue = 1},
	{storage = Storage.InServiceofYalahar.QuaraSplasher, storageValue = 1},
	{storage = Storage.InServiceofYalahar.QuaraSharptooth, storageValue = 1},
	{storage = Storage.InServiceofYalahar.QuaraInky, storageValue = 1},

	--Cults of Tibia Quest.
	{storage = Storage.CultsOfTibia.Questline, storageValue = 7},
	{storage = Storage.CultsOfTibia.Minotaurs.jamesfrancisTask, storageValue = 1},
	{storage = Storage.CultsOfTibia.Minotaurs.Mission, storageValue = 1},
	{storage = Storage.CultsOfTibia.Minotaurs.bossTimer, storageValue = 1},
	{storage = Storage.CultsOfTibia.MotA.Mission, storageValue = 1},
	{storage = Storage.CultsOfTibia.MotA.Pedra1, storageValue = 1},
	{storage = Storage.CultsOfTibia.MotA.Pedra2, storageValue = 1},
	{storage = Storage.CultsOfTibia.MotA.Pedra3, storageValue = 1},
	{storage = Storage.CultsOfTibia.MotA.Respostas, storageValue = 1},
	{storage = Storage.CultsOfTibia.MotA.Perguntaid, storageValue = 1},
	{storage = Storage.CultsOfTibia.Barkless.Mission, storageValue = 1},
	{storage = Storage.CultsOfTibia.Barkless.sulphur, storageValue = 1},
	{storage = Storage.CultsOfTibia.Barkless.tar, storageValue = 1},
	{storage = Storage.CultsOfTibia.Barkless.ice, storageValue = 1},
	{storage = Storage.CultsOfTibia.Barkless.Objects, storageValue = 1},
	{storage = Storage.CultsOfTibia.Barkless.Temp, storageValue = 1},
	{storage = Storage.CultsOfTibia.Barkless.bossTimer, storageValue = 1},
	{storage = Storage.CultsOfTibia.Orcs.Mission, storageValue = 1},
	{storage = Storage.CultsOfTibia.Orcs.lookType, storageValue = 1},
	{storage = Storage.CultsOfTibia.Orcs.bossTimer, storageValue = 1},
	{storage = Storage.CultsOfTibia.Life.Mission, storageValue = 1},
	{storage = Storage.CultsOfTibia.Life.bossTimer, storageValue = 1},
	{storage = Storage.CultsOfTibia.Humans.Mission, storageValue = 1},
	{storage = Storage.CultsOfTibia.Humans.Vaporized, storageValue = 1},
	{storage = Storage.CultsOfTibia.Humans.Decaying, storageValue = 1},
	{storage = Storage.CultsOfTibia.Humans.bossTimer, storageValue = 1},
	{storage = Storage.CultsOfTibia.Misguided.Mission, storageValue = 1},
	{storage = Storage.CultsOfTibia.Misguided.Monsters, storageValue = 1},
	{storage = Storage.CultsOfTibia.Misguided.Exorcisms, storageValue = 1},
	{storage = Storage.CultsOfTibia.Misguided.Time, storageValue = 1},
	{storage = Storage.CultsOfTibia.Misguided.bossTimer, storageValue = 1},

	-- The Explorer Society
	{storage = Storage.ExplorerSociety.QuestLine, storageValue = 1}, -- Joining the Explorers
	{storage = Storage.ExplorerSociety.QuestLine, storageValue = 4},
	{storage = Storage.ExplorerSociety.QuestLine, storageValue = 7},
	{storage = Storage.ExplorerSociety.QuestLine, storageValue = 16},
	{storage = Storage.ExplorerSociety.QuestLine, storageValue = 26},
	{storage = Storage.ExplorerSociety.QuestLine, storageValue = 29},
	{storage = Storage.ExplorerSociety.QuestLine, storageValue = 32},
	{storage = Storage.ExplorerSociety.QuestLine, storageValue = 35},
	{storage = Storage.ExplorerSociety.QuestLine, storageValue = 38},
	{storage = Storage.ExplorerSociety.QuestLine, storageValue = 41},
	{storage = Storage.ExplorerSociety.QuestLine, storageValue = 43},
	{storage = Storage.ExplorerSociety.QuestLine, storageValue = 46},
	{storage = Storage.ExplorerSociety.QuestLine, storageValue = 47},
	{storage = Storage.ExplorerSociety.QuestLine, storageValue = 50},
	{storage = Storage.ExplorerSociety.QuestLine, storageValue = 55},
	{storage = Storage.ExplorerSociety.QuestLine, storageValue = 56},
	{storage = Storage.ExplorerSociety.QuestLine, storageValue = 58},
	{storage = Storage.ExplorerSociety.QuestLine, storageValue = 61},
	{storage = Storage.ExplorerSociety.CalassaQuest, storageValue = 2},

	-- The Forgotten Knowledge
	{storage = Storage.ForgottenKnowledge.Tomes, storageValue = 1},
	{storage = Storage.ForgottenKnowledge.LastLoreKilled, storageValue = 1},
	{storage = Storage.ForgottenKnowledge.TimeGuardianKilled, storageValue = 1},
	{storage = Storage.ForgottenKnowledge.HorrorKilled, storageValue = 1},
	{storage = Storage.ForgottenKnowledge.DragonkingKilled, storageValue = 1},
	{storage = Storage.ForgottenKnowledge.ThornKnightKilled, storageValue = 1},
	{storage = Storage.ForgottenKnowledge.LloydKilled, storageValue = 1},
	 {storage = Storage.ForgottenKnowledge.LadyTenebrisKilled, storageValue = 1},
	{storage = Storage.ForgottenKnowledge.AccessMachine, storageValue = 1},

	-- Barbarian Test Quest.
	{storage = Storage.BarbarianTest.Questline, storageValue = 1},
	{storage = Storage.BarbarianTest.Mission01, storageValue = 3},
	{storage = Storage.BarbarianTest.Mission02, storageValue = 3},
	{storage = Storage.BarbarianTest.Mission03, storageValue = 3},
	{storage = Storage.BarbarianTest.Mission03, storageValue = 3},

	-- Children of the Revolution Quest.
	{storage = Storage.ChildrenoftheRevolution.Questline, storageValue = 21},
	{storage = Storage.ChildrenoftheRevolution.Mission00, storageValue = 2},
	{storage = Storage.ChildrenoftheRevolution.Mission01, storageValue = 3},
	{storage = Storage.ChildrenoftheRevolution.Mission02, storageValue = 5},
	{storage = Storage.ChildrenoftheRevolution.Mission03, storageValue = 3},
	{storage = Storage.ChildrenoftheRevolution.Mission04, storageValue = 6},
	{storage = Storage.ChildrenoftheRevolution.Mission05, storageValue = 3},
	{storage = Storage.ChildrenoftheRevolution.SpyBuilding01, storageValue = 1},
	{storage = Storage.ChildrenoftheRevolution.SpyBuilding02, storageValue = 1},
	{storage = Storage.ChildrenoftheRevolution.SpyBuilding03, storageValue = 1},
	{storage = Storage.ChildrenoftheRevolution.StrangeSymbols, storageValue = 1},

	-- Factions
	{storage = Storage.DjinnWar.Faction.Greeting, storageValue = 2},
	{storage = Storage.DjinnWar.Faction.Marid, storageValue = 2},
	{storage = Storage.DjinnWar.Faction.Efreet, storageValue = 2},
	-- Efreet
	{storage = Storage.DjinnWar.EfreetFaction.Start, storageValue = 1},
	{storage = Storage.DjinnWar.EfreetFaction.Mission01, storageValue = 3},
	{storage = Storage.DjinnWar.EfreetFaction.Mission02, storageValue = 3},
	{storage = Storage.DjinnWar.EfreetFaction.Mission03, storageValue = 3},
	-- Marid
	{storage = Storage.DjinnWar.MaridFaction.Start, storageValue = 1},
	{storage = Storage.DjinnWar.MaridFaction.Mission01, storageValue = 2},
	{storage = Storage.DjinnWar.MaridFaction.Mission02, storageValue = 2},
	{storage = Storage.DjinnWar.MaridFaction.RataMari, storageValue = 2},
	{storage = Storage.DjinnWar.MaridFaction.Mission03, storageValue = 3},

	-- The Way to Yalahar
	{storage = Storage.TheWayToYalahar.QuestLine, storageValue = 1},
	{storage = Storage.SearoutesAroundYalahar.TownsCounter, storageValue = 1},
	{storage = Storage.SearoutesAroundYalahar.AbDendriel, storageValue = 1},
	{storage = Storage.SearoutesAroundYalahar.Darashia, storageValue = 1},
	{storage = Storage.SearoutesAroundYalahar.Venore, storageValue = 1},
	{storage = Storage.SearoutesAroundYalahar.Ankrahmun, storageValue = 1},
	{storage = Storage.SearoutesAroundYalahar.PortHope, storageValue = 1},
	{storage = Storage.SearoutesAroundYalahar.Thais, storageValue = 1},
	{storage = Storage.SearoutesAroundYalahar.LibertyBay, storageValue = 1},
	{storage = Storage.SearoutesAroundYalahar.Carlin, storageValue = 1},

	-- The Hidden City of Beregar
	{storage = Storage.HiddenCityOfBeregar.DefaultStart, storageValue = 1},
	{storage = Storage.HiddenCityOfBeregar.GoingDown, storageValue = 1},

	-- The Ice Islands Quest
	{storage = Storage.TheIceIslands.Questline, storageValue = 12},
	{storage = Storage.TheIceIslands.Mission01, storageValue = 3},
	{storage = Storage.TheIceIslands.Mission02, storageValue = 5},
	{storage = Storage.TheIceIslands.Mission03, storageValue = 3},
	{storage = Storage.TheIceIslands.Mission04, storageValue = 2},
	{storage = Storage.TheIceIslands.Mission05, storageValue = 6},
	{storage = Storage.TheIceIslands.Mission06, storageValue = 8},
	{storage = Storage.TheIceIslands.Mission07, storageValue = 3},
	{storage = Storage.TheIceIslands.Mission08, storageValue = 4},
	{storage = Storage.TheIceIslands.Mission09, storageValue = 2},
	{storage = Storage.TheIceIslands.Mission10, storageValue = 2},
	{storage = Storage.TheIceIslands.Mission11, storageValue = 2},
	{storage = Storage.TheIceIslands.Mission12, storageValue = 6},

	-- The Inquisition
	{storage = Storage.TheInquisition.Questline, storageValue = 25},
	{storage = Storage.TheInquisition.Mission01, storageValue = 7},
	{storage = Storage.TheInquisition.Mission02, storageValue = 3},
	{storage = Storage.TheInquisition.Mission03, storageValue = 6},
	{storage = Storage.TheInquisition.Mission04, storageValue = 3},
	{storage = Storage.TheInquisition.Mission05, storageValue = 3},
	{storage = Storage.TheInquisition.Mission06, storageValue = 3},
	{storage = Storage.TheInquisition.Mission07, storageValue = 1},
	{storage = Storage.TheInquisition.GrofGuard, storageValue = 1},
	{storage = Storage.TheInquisition.KulagGuard, storageValue = 1},
	{storage = Storage.TheInquisition.TimGuard, storageValue = 1},
	{storage = Storage.TheInquisition.WalterGuard, storageValue = 1},
	{storage = Storage.TheInquisition.StorkusVampiredust, storageValue = 1},

	-- The New Frontier
	{storage = Storage.Quest.U8_54.TheNewFrontier.Questline, storageValue = 28},
	{storage = Storage.Quest.U8_54.TheNewFrontier.Mission01, storageValue = 3},
	{storage = Storage.Quest.U8_54.TheNewFrontier.Mission02, storageValue = 6},
	{storage = Storage.Quest.U8_54.TheNewFrontier.Mission03, storageValue = 3},
	{storage = Storage.Quest.U8_54.TheNewFrontier.Mission04, storageValue = 2},
	{storage = Storage.Quest.U8_54.TheNewFrontier.Mission05, storageValue = 7},
	{storage = Storage.Quest.U8_54.TheNewFrontier.Mission06, storageValue = 3},
	{storage = Storage.Quest.U8_54.TheNewFrontier.Mission07, storageValue = 3},
	{storage = Storage.Quest.U8_54.TheNewFrontier.Mission08, storageValue = 2},
	{storage = Storage.Quest.U8_54.TheNewFrontier.Mission09, storageValue = 3},
	{storage = Storage.Quest.U8_54.TheNewFrontier.Mission10, storageValue = 1},
	{storage = Storage.Quest.U8_54.TheNewFrontier.TomeofKnowledge, storageValue = 12},
	{storage = Storage.Quest.U8_54.TheNewFrontier.Beaver1, storageValue = 1},
	{storage = Storage.Quest.U8_54.TheNewFrontier.Beaver2, storageValue = 1},
	{storage = Storage.Quest.U8_54.TheNewFrontier.Beaver3, storageValue = 1},
	{storage = Storage.Quest.U8_54.TheNewFrontier.BribeKing, storageValue = 1},
	{storage = Storage.Quest.U8_54.TheNewFrontier.BribeLeeland, storageValue = 1},
	{storage = Storage.Quest.U8_54.TheNewFrontier.BribeExplorerSociety, storageValue = 1},
	{storage = Storage.Quest.U8_54.TheNewFrontier.BribeWydrin, storageValue = 1},
	{storage = Storage.Quest.U8_54.TheNewFrontier.BribeTelas, storageValue = 1},

	-- The ice islands
	-- player:setStorageValue(12200, 1) -- Storage through the Quest
	-- player:setStorageValue(12201, 3) -- Befriending the Musher
	-- player:setStorageValue(12202, 5) -- Nibelor 1: Breaking the Ice
	-- player:setStorageValue(12203, 3) -- Nibelor 2: Ecological Terrorism
	-- player:setStorageValue(12204, 2) -- Nibelor 3: Artful Sabotage
	-- player:setStorageValue(12205, 6) -- Nibelor 4: Berserk Brewery
	-- player:setStorageValue(12206, 8) -- Nibelor 5: Cure the Dogs
	-- player:setStorageValue(12207, 3) -- The Secret of Helheim
	-- player:setStorageValue(12208, 4) -- The Contact
	-- player:setStorageValue(12209, 2) -- Formorgar Mines 1: The Mission
	-- player:setStorageValue(12210, 2) -- Formorgar Mines 2: Ghostwhisperer
	-- player:setStorageValue(12211, 2) -- Formorgar Mines 3: The Secret
	-- player:setStorageValue(12212, 1) -- Formorgar Mines 4: Retaliation

	-- The Shattered Isles
	{storage = Storage.TheShatteredIsles.DefaultStart, storageValue = 3},
	{storage = Storage.TheShatteredIsles.TheGovernorDaughter, storageValue = 3},
	{storage = Storage.TheShatteredIsles.TheErrand, storageValue = 2},
	{storage = Storage.TheShatteredIsles.AccessToMeriana, storageValue = 1},
	{storage = Storage.TheShatteredIsles.APoemForTheMermaid, storageValue = 3},
	{storage = Storage.TheShatteredIsles.ADjinnInLove, 5},
	{storage = Storage.TheShatteredIsles.AccessToLagunaIsland, storageValue = 1},
	{storage = Storage.TheShatteredIsles.AccessToGoroma, storageValue = 1},
	{storage = Storage.TheShatteredIsles.Shipwrecked, storageValue = 2},
	{storage = Storage.TheShatteredIsles.DragahsSpellbook, storageValue = 1},
	{storage = Storage.TheShatteredIsles.TheCounterspell, storageValue = 4},

	-- The Thieves Guild.
	{storage = Storage.ThievesGuild.Quest, storageValue = 1},
	{storage = Storage.ThievesGuild.Mission01, storageValue = 2},
	{storage = Storage.ThievesGuild.Mission02, storageValue = 3},
	{storage = Storage.ThievesGuild.Mission03, storageValue = 3},
	{storage = Storage.ThievesGuild.Mission04, storageValue = 8},
	{storage = Storage.ThievesGuild.Mission05, storageValue = 2},
	{storage = Storage.ThievesGuild.Mission06, storageValue = 4},
	{storage = Storage.ThievesGuild.Mission07, storageValue = 2},
	{storage = Storage.ThievesGuild.Mission08, storageValue = 1},

	-- The Travelling Trader Quest
	{storage = Storage.TravellingTrader.Mission01, storageValue = 1},
	{storage = Storage.TravellingTrader.Mission01, storageValue = 2},
	{storage = Storage.TravellingTrader.Mission02, storageValue = 5},
	{storage = Storage.TravellingTrader.Mission03, storageValue = 3},
	{storage = Storage.TravellingTrader.Mission04, storageValue = 3},
	{storage = Storage.TravellingTrader.Mission05, storageValue = 3},
	{storage = Storage.TravellingTrader.Mission06, storageValue = 2},
	{storage = Storage.TravellingTrader.Mission07, storageValue = 1},

	-- The Ultimate Challenges Quest.
	{storage = Storage.SvargrondArena.QuestLogGreenhorn, storageValue = 1},

	-- Tibia Tales.
	{storage = Storage.TibiaTales.DefaultStart, storageValue = 1},
	{storage = Storage.TibiaTales.ToAppeaseTheMightyQuest, storageValue = 1},

	-- The Postman
	-- player:setStorageValue(12450, 6) -- Mission 1 - Check Postal Routes
	-- player:setStorageValue(12451, 3) -- Mission 2 - Fix Mailbox
	-- player:setStorageValue(12452, 3) -- Mission 3 - Bill Delivery
	-- player:setStorageValue(12453, 2) -- Mission 4 - Aggressive Dogs
	-- player:setStorageValue(12454, 4) -- Mission 5 - Present Delivery
	-- player:setStorageValue(12455, 13) -- Mission 6 - New Uniforms
	-- player:setStorageValue(12456, 8) -- Mission 7 - Measurements
	-- player:setStorageValue(12457, 3) -- Mission 8 - Missing Courier
	-- player:setStorageValue(12458, 4) -- Mission 9 - Dear Santa
	-- player:setStorageValue(12459, 3) -- Mission 10 - Mintwallin
	-- player:setStorageValue(12460, 5)  -- Postman Rank

	-- Unnatural Selection
	{storage = Storage.UnnaturalSelection.Questline, storageValue = 1}, -- Storage through the Quest
	{storage = Storage.UnnaturalSelection.Mission01, storageValue = 3}, -- Mission 1: Skulled
	{storage = Storage.UnnaturalSelection.Mission02, storageValue = 13}, -- Mission 2: All Around the World
	{storage = Storage.UnnaturalSelection.Mission03, storageValue = 3}, -- Mission 3: Dance Dance Evolution
	{storage = Storage.UnnaturalSelection.Mission04, storageValue = 2}, -- Mission 4: Bits and Pieces
	{storage = Storage.UnnaturalSelection.Mission05, storageValue = 3}, -- Mission 5: Ray of Light
	{storage = Storage.UnnaturalSelection.Mission06, storageValue = 3}, -- Mission 6: Firewater Burn

	-- Friends and Traders
	{storage = Storage.FriendsandTraders.DefaultStart, storageValue = 1},
	{storage = Storage.FriendsandTraders.TheSweatyCyclops, storageValue = 2},
	{storage = Storage.FriendsandTraders.TheMermaidMarina, storageValue = 2},
	{storage = Storage.FriendsandTraders.TheBlessedStake, storageValue = 12},

	-- Killing in the Name of...
	{storage = Storage.KillingInTheNameOf.QuestLogEntry, storageValue = 1},
	-- {storage = Storage.2500, storageValue = 0},

	-- KilmareshQuest
	-- {storage = Storage.22000, storageValue = 5}, -- Town Counter

	-- Wrath of the Emperor
	{storage = Storage.WrathoftheEmperor.Questline, storageValue = 1},
	{storage = Storage.WrathoftheEmperor.Mission01, storageValue = 3},
	{storage = Storage.WrathoftheEmperor.Mission02, storageValue = 3},
	{storage = Storage.WrathoftheEmperor.Mission03, storageValue = 3},
	{storage = Storage.WrathoftheEmperor.Mission04, storageValue = 3},
	{storage = Storage.WrathoftheEmperor.Mission05, storageValue = 3},
	{storage = Storage.WrathoftheEmperor.Mission06, storageValue = 4},
	{storage = Storage.WrathoftheEmperor.Mission07, storageValue = 6},
	{storage = Storage.WrathoftheEmperor.Mission08, storageValue = 2},
	{storage = Storage.WrathoftheEmperor.Mission09, storageValue = 2},
	{storage = Storage.WrathoftheEmperor.Mission10, storageValue = 6},
	{storage = Storage.WrathoftheEmperor.Mission11, storageValue = 1},

	-- The Ape City Quest.
	{storage = Storage.TheApeCity.Started, storageValue = 1},
	{storage = Storage.TheApeCity.Questline, storageValue = 18},

	-- Oramond.
	{storage = Storage.Oramond.QuestLine, storageValue = 1},
	{storage = Storage.Oramond.MissionToTakeRoots, storageValue = 3000},

	-- Dangerous Depths.
	{storage = Storage.DangerousDepths.Questline, storageValue = 1},
	{storage = Storage.DangerousDepths.Dwarves.Home, storageValue = 2},
	{storage = Storage.DangerousDepths.Dwarves.Subterranean, storageValue = 2},
	{storage = Storage.DangerousDepths.Gnomes.Measurements, storageValue = 2},
	{storage = Storage.DangerousDepths.Gnomes.Ordnance, storageValue = 3},
	{storage = Storage.DangerousDepths.Gnomes.Charting, storageValue = 2},
	{storage = Storage.DangerousDepths.Scouts.Growth, storageValue = 2},
	{storage = Storage.DangerousDepths.Scouts.Diremaw, storageValue = 2},

	-- Threatened Dreams
	{storage = Storage.Quest.U11_40.ThreatenedDreams.Start, storageValue = 1},
	{storage = Storage.Quest.U11_40.ThreatenedDreams.TroubledMission01, storageValue = 4},

	-- Adventurers Guild.
	{storage = Storage.AdventurersGuild.GreatDragonHunt.WarriorSkeleton, storageValue = 1},
	{storage = Storage.AdventurersGuild.GreatDragonHunt.WarriorSkeleton, storageValue = 2},

	-- Dawnport
	{storage = Storage.Quest.U10_55.Dawnport.Questline, storageValue = 1},
	{storage = Storage.Quest.U10_55.Dawnport.GoMain, storageValue = 1},
	--

	--PR
	{storage = Storage.Quest.U11_80.TheSecretLibrary.ScourgeOfOblivionDoor, storageValue = 1},
	{storage = Storage.Quest.U12_20.GraveDanger.Bosses.KingZelosDoor, storageValue = 1},
	{storage = Storage.Quest.U12_30.FeasterOfSouls.FearFeasterKilled, storageValue = 1},
	{storage = Storage.Quest.U12_30.FeasterOfSouls.DreadMaidenKilled, storageValue = 1},
	{storage = Storage.Quest.U12_30.FeasterOfSouls.UnwelcomeKilled, storageValue = 1},
	{storage = Storage.Quest.U12_00.TheDreamCourts.PlaguerootKilled, storageValue = 1},
	{storage = Storage.Quest.U12_00.TheDreamCourts.MalofurKilled, storageValue = 1},
	{storage = Storage.Quest.U12_00.TheDreamCourts.MaxxeniusKilled, storageValue = 1},
	{storage = Storage.Quest.U12_00.TheDreamCourts.AlptramunKilled, storageValue = 1},
	{storage = Storage.Quest.U12_00.TheDreamCourts.IzcandarKilled, storageValue = 1},
	--You can also do this for SoulWar Bosses, but i don't recommend because of the reward:
	{storage = Storage.Quest.U12_40.SoulWar.GoshnarMaliceKilled, storageValue = 1},
	{storage = Storage.Quest.U12_40.SoulWar.GoshnarHatredKilled, storageValue = 1},
	{storage = Storage.Quest.U12_40.SoulWar.GoshnarSpiteKilled, storageValue = 1},
	{storage = Storage.Quest.U12_40.SoulWar.GoshnarCrueltyKilled, storageValue = 1},
	{storage = Storage.Quest.U12_40.SoulWar.GoshnarGreedKilled, storageValue = 1},
}

local function playerFreeQuestStart(playerId, index)
	local player = Player(playerId)
	if not player then
		return
	end

	for i = 1, 5 do
		index = index + 1
		if not questTable[index] then
			player:sendTextMessage(MESSAGE_INFO_DESCR, "Player FreeQuest is complete.")
			player:setStorageValue(Storage.FreeQuests, stage)
			return
		end

		if player:getStorageValue(questTable[index].storage) ~= questTable[index].storageValue then
			player:setStorageValue(questTable[index].storage, questTable[index].storageValue)
		end
	end

	addEvent(playerFreeQuestStart, 500, playerId, index)
end

local freeQuests = CreatureEvent("FreeQuests")

function freeQuests.onLogin(player)
	if not configManager.getBoolean(configKeys.TOGGLE_FREE_QUEST) or
	player:getStorageValue(Storage.FreeQuests) == stage then
		return true
	end

	player:sendTextMessage(MESSAGE_INFO_DESCR, "Player FreeQuest in progress..")
	addEvent(playerFreeQuestStart, 500, player:getId(), 0)
	return true
end

freeQuests:register()
