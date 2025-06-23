						--[[
[1] = {name = "Rats Infestation", start = Storage.HuntingTasks.Steps.XXXXX, monsters_list = {"Rat", "Cave Rat"}, level = 1, count = 10, points = 1, items = {}, reward = {}, exp = 300000, money = 300000},
]]--
taskSystem = {
    -- v1
		[1] = {name = "", start = 0000001, monsters_list = {}, level = 1, count = 10, points = 0, items = {}, reward = {}, exp = 0, money = 0},
		[2] = {name = "Rats Infestation", start = Storage.HuntingTasks.Steps.RatsInfestation, monsters_list = {"Rat", "Cave Rat"}, level = 1, count = 50, points = 1, items = {}, reward = {12548, 1}, exp = 25, money = 5000},
		[3] = {name = "Orc Fortress", start = Storage.HuntingTasks.Steps.OrcFortress, monsters_list = {"Orc", "Orc Shaman", "Orc Rider", "Orc Spearman", "Orc Warrior"}, level = 15, count = 100, points = 1, items = {}, reward = {}, exp = 750, money = 10000},
		[4] = {name = "Goblins Invasion", start = Storage.HuntingTasks.Steps.GoblinsInvasion, monsters_list = {"Goblin", "Goblin Leader", "Goblin Assassin", "Goblin Scavenger"}, level = 15, count = 100, points = 1, items = {}, reward = {}, exp = 550, money = 10000},
		[5] = {name = "Amazon's Camp", start = Storage.HuntingTasks.Steps.AmazonCamp, monsters_list = {"Amazon", "Valkyrie", "Witch"}, level = 15, count = 100, points = 1, items = {}, reward = {}, exp = 1800, money = 10000},
		[6] = {name = "Minotaur Fortress", start = Storage.HuntingTasks.Steps.MinotaurFortress, monsters_list = {"Minotaur", "Minotaur Archer", "Minotaur Guard", "Minotaur Mage"}, level = 20, count = 100, points = 1, items = {}, reward = {}, exp = 2400, money = 10000},
		[7] = {name = "Cyclops Rocks", start = Storage.HuntingTasks.Steps.CyclopsRocks, monsters_list = {"Cyclops", "Cyclops Drone", "Cyclops Smith"}, level = 20, count = 100, points = 1, items = {}, reward = {}, exp = 3820, money = 10000},
		[8] = {name = "Dragon's Tale I", start = Storage.HuntingTasks.Steps.DragonsTaleOne, monsters_list = {"Dragon", "Dragon Hatchling"}, level = 30, count = 100, points = 1, items = {}, reward = {}, exp = 10500, money = 10000},
		[9] = {name = "Coryms", start = Storage.HuntingTasks.Steps.Coryms, monsters_list = {"Corym Skirmisher", "Corym Vanguard", "Corym Charlatan"}, level = 30, count = 200, points = 1, items = {}, reward = {}, exp = 14700, money = 20000},
		[10] = {name = "Elf The Elders", start = Storage.HuntingTasks.Steps.ElfTheElders, monsters_list = {"Elf", "Elf Arcanist", "Elf Scout"}, level = 15, count = 200, points = 1, items = {}, reward = {}, exp = 5240, money = 20000},
		[11] = {name = "Nomad's Camp", start = Storage.HuntingTasks.Steps.NomadsCamp, monsters_list = {"Nomad"}, level = 20, count = 200, points = 1, items = {}, reward = {}, exp = 1800, money = 20000},
		[12] = {name = "Behemoth Lands", start = Storage.HuntingTasks.Steps.BehemothLands, monsters_list = {"Behemoth", "Giant Spider"}, level = 50, count = 200, points = 1, items = {}, reward = {}, exp = 75000, money = 20000},
		[13] = {name = "The Djinns", start = Storage.HuntingTasks.Steps.TheDjinns, monsters_list = {"Green Djinn", "Blue Djinn", "Efreet", "Marid"}, level = 50, count = 200, points = 1, items = {}, reward = {14053, 1}, exp = 12300, money = 20000},
		[14] = {name = "Deeplings", start = Storage.HuntingTasks.Steps.Deeplings, monsters_list = {"Deepling Brawler", "Deepling Elite", "Deepling Guard", "Deepling Master Librarian", "Deepling Scout", "Deepling Spellsinger", "Deepling Warrior"}, level = 70, count = 200, points = 1, items = {}, reward = {6529, 1}, exp = 90000, money = 20000},
		[15] = {name = "Dragons Tale II", start = Storage.HuntingTasks.Steps.DragonTaleTwo, monsters_list = {"Dragon Lord Hatchling", "Dragon Lord"}, level = 70, count = 250, points = 1, items = {}, reward = {}, exp = 78750, money = 25000},
		[16] = {name = "Exotic Cave", start = Storage.HuntingTasks.Steps.ExoticCave, monsters_list = {"Exotic Cave Spider", "Exotic Bat"}, level = 70, count = 250, points = 1, items = {}, reward = {}, exp = 52500, money = 25000},
		[17] = {name = "Glooth Envy", start = Storage.HuntingTasks.Steps.GloothEnvy, monsters_list = {"Glooth Bandit", "Glooth Anemone", "Glooth Blob", "Glooth Brigand", "Glooth Golem"}, level = 70, count = 250, points = 1, items = {}, reward = {}, exp = 75000, money = 25000},
		[18] = {name = "Hero Cave", start = Storage.HuntingTasks.Steps.HeroCave, monsters_list = {"Hero", "Demon Skeleton", "Priestess"}, level = 50, count = 250, points = 1, items = {}, reward = {}, exp = 45000, money = 25000},
		[19] = {name = "Hydra Jungle", start = Storage.HuntingTasks.Steps.HydraJungle, monsters_list = {"Hydra", "Stone Golem"}, level = 50, count = 250, points = 1, items = {}, reward = {11512, 1}, exp = 78750, money = 25000},
		[20] = {name = "Lizard Walls", start = Storage.HuntingTasks.Steps.LizardWalls, monsters_list = {"Lizard Chosen", "Lizard Dragon Priest", "Lizard High Guard", "Lizard Legionnaire", "Lizard Magistratus", "Lizard Snakecharmer", "Lizard Zaogun"}, level = 50, count = 250, points = 1, items = {}, reward = {}, exp = 94875, money = 25000},
		[21] = {name = "Lumbering Carnivor", start = Storage.HuntingTasks.Steps.LumberingCarn, monsters_list = {"Lumbering Carnivor"}, level = 100, count = 300, points = 1, items = {}, reward = {}, exp = 65340, money = 30000},
		[22] = {name = "Elementals I", start = Storage.HuntingTasks.Steps.ElementalsOne, monsters_list = {"Massive Earth Elemental", "Massive Energy Elemental", "Massive Fire Elemental", "Massive Water Elemental"}, level = 100, count = 300, points = 1, items = {}, reward = {22516, 5}, exp = 63000, money = 30000},
		[23] = {name = "Asura's Palace", start = Storage.HuntingTasks.Steps.AsuraPalace, monsters_list = {"Midnight Asura", "Frost Flower Asura", "Dawnfire Asura"}, level = 100, count = 300, points = 1, items = {}, reward = {22721, 5}, exp = 189000, money = 30000},
		[24] = {name = "Mutated Animals", start = Storage.HuntingTasks.Steps.MutatedAnimals, monsters_list = {"Mutated Tiger", "Mutated Bat"}, level = 100, count = 300, points = 1, items = {}, reward = {37317, 1}, exp = 33750, money = 30000},
		[25] = {name = "Ogre Island", start = Storage.HuntingTasks.Steps.OgreIsland, monsters_list = {"Ogre Brute", "Ogre Savage", "Ogre Shaman"}, level = 70, count = 300, points = 1, items = {}, reward = {8778, 1}, exp = 42750, money = 30000},

		-- v2
		[26] = {name = "Pirat Stolen", start = Storage.HuntingTasks.Steps.PiratStolen, monsters_list = {"Pirat Mate", "Pirat Bombardier", "Pirat Cutthroat", "Pirat Scoundrel"}, level = 100, count = 100, points = 2, items = {}, reward = {19136, 1}, exp = 36000, money = 100000},
		[27] = {name = "Quara's Determine", start = Storage.HuntingTasks.Steps.QuaraDetermine, monsters_list = {"Quara Constrictor Scout", "Quara Constrictor", "Quara Hydromancer Scout", "Quara Hydromancer", "Quara Mantassin", "Quara Pincher Scout", "Quara Pincher", "Quara Predator Scout", "Quara Predator"}, level = 100, count = 100, points = 2, items = {}, reward = {}, exp = 27750, money = 100000},
		[28] = {name = "Renegade Knight", start = Storage.HuntingTasks.Steps.RenegadeKnight, monsters_list = {"Renegade Knight", "Vile Grandmaster", "Vicious Squire"}, level = 100, count = 100, points = 2, items = {}, reward = {}, exp = 18000, money = 100000},
		[29] = {name = "Serpent Spawn", start = Storage.HuntingTasks.Steps.SerpentSpawn, monsters_list = {"Serpent Spawn"}, level = 100, count = 100, points = 2, items = {}, reward = {}, exp = 45750, money = 100000},
		[30] = {name = "Spidris", start = Storage.HuntingTasks.Steps.Spidris, monsters_list = {"Spidris", "Spidris Elite"}, level = 100, count = 100, points = 2, items = {}, reward = {}, exp = 60000, money = 100000},
		[31] = {name = "Stabilizing I", start = Storage.HuntingTasks.Steps.StabilizingOne, monsters_list = {"Stabilizing Dread Intruder", "Stabilizing Reality Reaver"}, level = 150, count = 100, points = 2, items = {}, reward = {9019, 1}, exp = 29250, money = 100000},
		[32] = {name = "The Shaper's", start = Storage.HuntingTasks.Steps.TheSphaper, monsters_list = {"Twisted Shaper", "Broken Shaper"}, level = 150, count = 200, points = 2, items = {}, reward = {}, exp = 61500, money = 200000},
		[33] = {name = "The Vampire's Diary", start = Storage.HuntingTasks.Steps.TheVampireDiar, monsters_list = {"Vampire Bride", "Vampire", "Werewolf"}, level = 100, count = 200, points = 2, items = {}, reward = {}, exp = 31500, money = 200000},
		[34] = {name = "Warlock's Magic", start = Storage.HuntingTasks.Steps.WarlocksMagic, monsters_list = {"Warlock", "Dark Magician", "Witch"}, level = 70, count = 200, points = 2, items = {}, reward = {}, exp = 120000, money = 200000},
		[35] = {name = "Were Monsters", start = Storage.HuntingTasks.Steps.WereMonsters, monsters_list = {"Werebear", "Wereboar", "Werebadger", "Werefox"}, level = 70, count = 200, points = 2, items = {}, reward = {}, exp = 63000, money = 200000},
		[36] = {name = "Wyrms", start = Storage.HuntingTasks.Steps.Wyrms, monsters_list = {"Wyrm", "Elder Wyrm"}, level = 70, count = 200, points = 2, items = {}, reward = {}, exp = 75000, money = 200000},
		[37] = {name = "Golems", start = Storage.HuntingTasks.Steps.Golems, monsters_list = {"Worker Golem", "War Golem"}, level = 70, count = 200, points = 2, items = {}, reward = {14053, 1}, exp = 80400, money = 200000},
		[38] = {name = "Island of Goanna's", start = Storage.HuntingTasks.Steps.IslandOfGoannas, monsters_list = {"Adult Goanna", "Young Goanna"}, level = 150, count = 250, points = 2, items = {}, reward = {12546, 1}, exp = 231925, money = 250000},
		[39] = {name = "Bashmu", start = Storage.HuntingTasks.Steps.Bashmu, monsters_list = {"Bashmu", "Juvenile Bashmu"}, level = 150, count = 250, points = 2, items = {}, reward = {}, exp = 187500, money = 250000},
		[40] = {name = "Fire Library", start = Storage.HuntingTasks.Steps.FireLibrary, monsters_list = {"Burning Book", "Rage Squid"}, level = 200, count = 250, points = 2, items = {}, reward = {}, exp = 611250, money = 250000},
		[41] = {name = "Energy Library", start = Storage.HuntingTasks.Steps.EnergyLibrary, monsters_list = {"Energetic Book", "Brain Squid"}, level = 200, count = 250, points = 2, items = {}, reward = {}, exp = 662700, money = 250000},
		[42] = {name = "Earth Library", start = Storage.HuntingTasks.Steps.EarthLibrary, monsters_list = {"Cursed Book", "Biting Book"}, level = 200, count = 250, points = 2, items = {}, reward = {}, exp = 500425, money = 250000},
		[43] = {name = "Ice Library", start = Storage.HuntingTasks.Steps.IceLibrary, monsters_list = {"Icecold Book", "Squid Warden"}, level = 200, count = 250, points = 2, items = {}, reward = {11512, 1}, exp = 573750, money = 250000},
		[44] = {name = "Burster Spectre", start = Storage.HuntingTasks.Steps.BursterSpectre, monsters_list = {"Burster Spectre"}, level = 70, count = 300, points = 2, items = {}, reward = {}, exp = 270000, money = 300000},
		[45] = {name = "Choking Fear", start = Storage.HuntingTasks.Steps.ChokingFear, monsters_list = {"Choking Fears"}, level = 100, count = 300, points = 2, items = {}, reward = {}, exp = 211500, money = 300000},
		[46] = {name = "Ripper Spectre", start = Storage.HuntingTasks.Steps.RipperSpectre, monsters_list = {"Ripper Spectre"}, level = 70, count = 300, points = 2, items = {}, reward = {22516, 10}, exp = 157500, money = 300000},
		[47] = {name = "Cobra's Island", start = Storage.HuntingTasks.Steps.CobrasIsland, monsters_list = {"Cobra Scout", "Cobra Assassin", "Cobra Vizier"}, level = 70, count = 300, points = 2, items = {}, reward = {22721, 10}, exp = 344250, money = 300000},
		[48] = {name = "Gazer Spectre", start = Storage.HuntingTasks.Steps.GazerSpectre, monsters_list = {"Gazer Spectre"}, level = 70, count = 300, points = 2, items = {}, reward = {37317, 3}, exp = 189000, money = 300000},
		[49] = {name = "Werelion", start = Storage.HuntingTasks.Steps.Werelion, monsters_list = {"Werelion", "Werelioness"}, level = 70, count = 300, points = 2, items = {}, reward = {39546, 1}, exp = 112500, money = 300000},

		-- v3
		[50] = {name = "Summer Court", start = Storage.HuntingTasks.Steps.SummerCourt, monsters_list = {"Crazed Summer Rearguard", "Crazed Summer Vanguard"}, level = 250, count = 300, points = 3, items = {}, reward = {23677, 1}, exp = 211500, money = 1000000},
		[51] = {name = "Winter Court", start = Storage.HuntingTasks.Steps.WinterCourt, monsters_list = {"Crazed Winter Rearguard", "Crazed Winter Vanguard"}, level = 250, count = 300, points = 3, items = {}, reward = {}, exp = 243000, money = 1000000},
		[52] = {name = "Demon Fields", start = Storage.HuntingTasks.Steps.DemonFields, monsters_list = {"Demon", "Fire Elemental"}, level = 100, count = 300, points = 3, items = {}, reward = {}, exp = 270000, money = 1000000},
		[53] = {name = "Draken's Tomb", start = Storage.HuntingTasks.Steps.DrakensTomb, monsters_list = {"Draken Elite", "Draken Abomination", "Draken Spellweaver"}, level = 100, count = 300, points = 3, items = {}, reward = {}, exp = 213750, money = 1000000},
		[54] = {name = "Flimsy Lost Soul", start = Storage.HuntingTasks.Steps.FlimsyLostSoul, monsters_list = {"Flimsy Lost Soul"}, level = 250, count = 300, points = 3, items = {}, reward = {}, exp = 202500, money = 1000000},
		[55] = {name = "Ghastly Dragon", start = Storage.HuntingTasks.Steps.GhastlyDragon, monsters_list = {"Ghastly Dragon"}, level = 150, count = 300, points = 3, items = {}, reward = {}, exp = 207000, money = 1000000},
		[56] = {name = "Grim Reaper", start = Storage.HuntingTasks.Steps.GrimReaper, monsters_list = {"Grim Reaper"}, level = 70, count = 300, points = 3, items = {}, reward = {9177, 1}, exp = 247500, money = 1000000},
		[57] = {name = "Iks Friends", start = Storage.HuntingTasks.Steps.IksFriends, monsters_list = {"Iks Ahpututu", "Iks Yapunac", "Iks Aucar", "Iks Chuka", "Iks Churrascan", "Iks Pututu"}, level = 250, count = 300, points = 3, items = {}, reward = {}, exp = 105300, money = 1000000},
		[58] = {name = "Lamassu", start = Storage.HuntingTasks.Steps.Lamassu, monsters_list = {"Lamassu", "Sphinx"}, level = 100, count = 450, points = 3, items = {}, reward = {}, exp = 607500, money = 1500000},
		[59] = {name = "Medusa's Lair", start = Storage.HuntingTasks.Steps.MedusaLair, monsters_list = {"Medusa"}, level = 150, count = 450, points = 3, items = {}, reward = {}, exp = 273375, money = 1500000},
		[60] = {name = "Naga's Dream", start = Storage.HuntingTasks.Steps.NagaDream, monsters_list = {"Naga Archer", "Naga Warrior"}, level = 150, count = 450, points = 3, items = {}, reward = {}, exp = 397575, money = 1500000},
		[61] = {name = "Usurper's Law", start = Storage.HuntingTasks.Steps.UsurperLaw, monsters_list = {"Usurper Archer", "Usurper Knight", "Usurper Warlock"}, level = 150, count = 450, points = 3, items = {}, reward = {}, exp = 472500, money = 1500000},
		[62] = {name = "True Dawnfire Asura", start = Storage.HuntingTasks.Steps.TrueDawnfire, monsters_list = {"True Dawnfire Asura"}, level = 150, count = 450, points = 3, items = {}, reward = {}, exp = 504540, money = 1500000},
		[63] = {name = "True Midnight Asura", start = Storage.HuntingTasks.Steps.TrueMidnight, monsters_list = {"True Midnight Asura"}, level = 150, count = 450, points = 3, items = {}, reward = {14053, 1}, exp = 493605, money = 1500000},
		[64] = {name = "Undead Dragon", start = Storage.HuntingTasks.Steps.UndeadDragon, monsters_list = {"Undead Dragon"}, level = 150, count = 450, points = 3, items = {}, reward = {12304, 1}, exp = 506250, money = 1500000},
		[65] = {name = "Vexclaw", start = Storage.HuntingTasks.Steps.Vexclaw, monsters_list = {"Vexclaw", "Grimeleech", "Hellflayer"}, level = 200, count = 450, points = 3, items = {}, reward = {}, exp = 791100, money = 1500000},
		[66] = {name = "Cursed Prospector", start = Storage.HuntingTasks.Steps.CursedProspector, monsters_list = {"Cursed Prospector"}, level = 250, count = 500, points = 3, items = {}, reward = {}, exp = 315000, money = 2000000},
		[67] = {name = "Evil Prospector", start = Storage.HuntingTasks.Steps.EvilProspector, monsters_list = {"Evil Prospector"}, level = 250, count = 500, points = 3, items = {}, reward = {}, exp = 675000, money = 2000000},
		[68] = {name = "Falcon's Ordeal", start = Storage.HuntingTasks.Steps.FalconsOrdeal, monsters_list = {"Falcon Knight", "Falcon Paladin"}, level = 100, count = 500, points = 3, items = {}, reward = {11512, 1}, exp = 517500, money = 2000000},
		[69] = {name = "Freakish Lost Soul", start = Storage.HuntingTasks.Steps.FreakishLostSoul, monsters_list = {"Freakish Lost Soul"}, level = 200, count = 500, points = 3, items = {}, reward = {}, exp = 526500, money = 2000000},
		[70] = {name = "Guzzlemaw's Valley", start = Storage.HuntingTasks.Steps.GuzzlemawValley, monsters_list = {"Guzzlemaw", "Frazzlemaw"}, level = 150, count = 500, points = 3, items = {}, reward = {22516, 25}, exp = 453750, money = 2000000},
		[71] = {name = "Hellhound's Fate", start = Storage.HuntingTasks.Steps.HellhoundFate, monsters_list = {"Hellhound", "Blightwalker"}, level = 150, count = 500, points = 3, items = {}, reward = {22721, 25}, exp = 480000, money = 2000000},
		[72] = {name = "Quara's Revenge", start = Storage.HuntingTasks.Steps.QuaraRevenge, monsters_list = {"Quara Plunderer", "Quara Raider", "Quara Looter"}, level = 150, count = 500, points = 3, items = {}, reward = {37317, 5}, exp = 810000, money = 2000000},
		[73] = {name = "Sight of Surrender", start = Storage.HuntingTasks.Steps.SightOfSurrender, monsters_list = {"Sight of Surrender"}, level = 150, count = 500, points = 3, items = {}, reward = {34109, 1}, exp = 1275000, money = 2000000},
}

dailyTasks = {
		--[[level 1 - 50]]--
		[74] = {name = "Bugs", monsters_list = {"Bug"}, count = 100, points = 1, items = {}, reward = {}, exp = 400000, money = 10000},
		[75] = {name = "Dromedary", monsters_list = {"Dromedary"}, count = 100, points = 1, items = {}, reward = {}, exp = 400000, money = 10000},
		[76] = {name = "Frost Troll", monsters_list = {"Frost Troll"}, count = 100, points = 1, items = {3130, 10}, reward = {}, exp = 400000, money = 10000},
		[77] = {name = "Adventurer", monsters_list = {"Adventurer"}, count = 100, points = 1, items = {}, reward = {}, exp = 400000, money = 10000},
		[78] = {name = "Bandit", monsters_list = {"Bandit"}, count = 100, points = 1, items = {}, reward = {}, exp = 400000, money = 10000},
		[79] = {name = "Carrion Worm", monsters_list = {"Carrion Worm"}, count = 100, points = 1, items = {10275, 20}, reward = {}, exp = 400000, money = 10000},
		--[[level 51 -100]]--
		[80] = {name = "Cyclops", monsters_list = {"Cyclops"}, count = 100, points = 1, items = {9657, 20}, reward = {}, exp = 1500000, money = 100000},
		[81] = {name = "Crocodile", monsters_list = {"Crocodile"}, count = 100, points = 1, items = {}, reward = {}, exp = 1500000, money = 100000},
		[82] = {name = "Minotaur", monsters_list = {"Minotaur"}, count = 100, points = 1, items = {}, reward = {}, exp = 1500000, money = 100000},
		[83] = {name = "Corym Charlatan", monsters_list = {"Corym Charlatan"}, count = 100, points = 1, items = {10279, 10}, reward = {}, exp = 1500000, money = 100000},
		[84] = {name = "Hero", monsters_list = {"Hero"}, count = 100, points = 1, items = {}, reward = {}, exp = 1500000, money = 100000},
		[85] = {name = "Death Blob", monsters_list = {"Death Blob"}, count = 100, points = 1, items = {}, reward = {}, exp = 1500000, money = 100000},
		[86] = {name = "Giant Spider", monsters_list = {"Giant Spider"}, count = 100, points = 1, items = {8031, 1}, reward = {}, exp = 1500000, money = 100000},
		--[[level 101 - 200]]--
		[87] = {name = "Bog Raider", monsters_list = {"Bog Raider"}, count = 200, points = 1, items = {9667, 10}, reward = {}, exp = 5000000, money = 250000},
		[88] = {name = "Dragon", monsters_list = {"Dragon"}, count = 200, points = 1, items = {}, reward = {}, exp = 5000000, money = 250000},
		[89] = {name = "Priestess", monsters_list = {"Priestess"}, count = 200, points = 1, items = {3674, 20}, reward = {}, exp = 5000000, money = 250000},
		[90] = {name = "Water Elemental", monsters_list = {"Water Elemental"}, count = 200, points = 1, items = {}, reward = {}, exp = 5000000, money = 250000},
		[91] = {name = "Vampire", monsters_list = {"Vampire"}, count = 200, points = 1, items = {9685, 20}, reward = {}, exp = 5000000, money = 250000},
		--[[level 201 - 300]]--
		[92] = {name = "Dragon Lord", monsters_list = {"Dragon Lord"}, count = 200, points = 2, items = {5882, 10}, reward = {}, exp = 24000000, money = 250000},
		[93] = {name = "Vile Grandmaster", monsters_list = {"Vile Grandmaster"}, count = 200, points = 2, items = {}, reward = {}, exp = 24000000, money = 250000},
		[94] = {name = "Nightmare", monsters_list = {"Nightmare"}, count = 200, points = 2, items = {6558, 20}, reward = {}, exp = 24000000, money = 250000},
		[95] = {name = "Yielothax", monsters_list = {"Yielothax"}, count = 200, points = 2, items = {}, reward = {}, exp = 24000000, money = 250000},
		[96] = {name = "Exotic Cave Spider", monsters_list = {"Exotic Cave Spider"}, count = 200, points = 2, items = {5879, 10}, reward = {}, exp = 24000000, money = 250000},
		--[[level 301 - 400]]--
		[97] = {name = "Vampire Bride", monsters_list = {"Vampire Bride"}, count = 250, points = 2, items = {9685, 20}, reward = {}, exp = 45000000, money = 500000},
		[98] = {name = "Draken Spellweaver", monsters_list = {"Draken Spellweaver"}, count = 250, points = 2, items = {}, reward = {}, exp = 45000000, money = 500000},
		[99] = {name = "Grim Reaper", monsters_list = {"Grim Reaper"}, count = 250, points = 2, items = {7418, 1}, reward = {}, exp = 45000000, money = 500000},
		[100] = {name = "Adult Goanna", monsters_list = {"Adult Goanna"}, count = 250, points = 2, items = {}, reward = {}, exp = 45000000, money = 500000},
		[101] = {name = "Choking Fear", monsters_list = {"Choking Fear"}, count = 250, points = 2, items = {20202, 5}, reward = {}, exp = 45000000, money = 500000},
		--[[level 401 - 600]]--
		[102] = {name = "Ghastly Dragon", monsters_list = {"Ghastly Dragon"}, count = 250, points = 2, items = {6499, 10}, reward = {}, exp = 50000000, money = 500000},
		[103] = {name = "Demon", monsters_list = {"Demon"}, count = 250, points = 2, items = {}, reward = {}, exp = 50000000, money = 500000},
		[104] = {name = "Fury", monsters_list = {"Fury"}, count = 250, points = 2, items = {8016, 20}, reward = {}, exp = 50000000, money = 500000},
		[105] = {name = "Infernalist", monsters_list = {"Infernalist"}, count = 250, points = 2, items = {}, reward = {}, exp = 50000000, money = 500000},
		[106] = {name = "Hellfire Fighter", monsters_list = {"Hellfire Fighter"}, count = 250, points = 2, items = {9636, 5}, reward = {}, exp = 50000000, money = 500000},
		--[[level 601 - 800]]--
		[107] = {name = "Lost Souls", monsters_list = {"Flimsy Lost Soul", "Mean Lost Soul"}, count = 300, points = 2, items = {32703, 1}, reward = {}, exp = 66000000, money = 1000000},
		[108] = {name = "Medusa", monsters_list = {"Medusa"}, count = 300, points = 2, items = {}, reward = {}, exp = 66000000, money = 1000000},
		[109] = {name = "Burning Gladiator", monsters_list = {"Burning Gladiator"}, count = 300, points = 2, items = {31443, 20}, reward = {}, exp = 66000000, money = 1000000},
		[110] = {name = "Black Sphinx Acolyte", monsters_list = {"Black Sphinx Acolyte"}, count = 300, points = 2, items = {}, reward = {}, exp = 66000000, money = 1000000},
		[111] = {name = "Crypt Creatures", monsters_list = {"Sphinx", "Crypt Warden"}, count = 300, points = 2, items = {31438, 5}, reward = {}, exp = 66000000, money = 1000000},
		--[[level 801 - 1100]]--
		[112] = {name = "Floating Savant", monsters_list = {"Floating Savant"}, count = 300, points = 2, items = {16126, 20}, reward = {}, exp = 72000000, money = 1000000},
		[113] = {name = "Hellhound", monsters_list = {"Hellhound"}, count = 300, points = 2, items = {}, reward = {}, exp = 72000000, money = 1000000},
		[114] = {name = "Juggernaut", monsters_list = {"Juggernaut"}, count = 300, points = 2, items = {31437, 10}, reward = {}, exp = 72000000, money = 1000000},
		[115] = {name = "Feral Sphinx", monsters_list = {"Feral Sphinx"}, count = 300, points = 2, items = {}, reward = {}, exp = 72000000, money = 1000000},
		[116] = {name = "Girtablilu Warrior", monsters_list = {"Girtablilu Warrior"}, count = 300, points = 2, items = {3326, 1}, reward = {}, exp = 72000000, money = 1000000},
		--[[level 1101 - 1300]]--
		[117] = {name = "Vexclaw", monsters_list = {"Vexclaw"}, count = 350, points = 3, items = {22727, 1}, reward = {}, exp = 98000000, money = 1500000},
		[118] = {name = "Falcon Knight", monsters_list = {"Falcon Knight"}, count = 350, points = 3, items = {}, reward = {}, exp = 98000000, money = 1500000},
		[119] = {name = "Sight of Surrender", monsters_list = {"Sight of Surrender"}, count = 350, points = 3, items = {3081, 10}, reward = {}, exp = 98000000, money = 1500000},
		[120] = {name = "Sulphur Spouter", monsters_list = {"Sulphur Spouter"}, count = 350, points = 3, items = {}, reward = {}, exp = 98000000, money = 1500000},
		[121] = {name = "Hulking Prehemoth", monsters_list = {"Hulking Prehemoth"}, count = 350, points = 3, items = {39383, 20}, reward = {}, exp = 98000000, money = 1500000},
		--[[level 1301 - 1600]]--
		[122] = {name = "Bony Sea Devil", monsters_list = {"Bony Sea Devil"}, count = 350, points = 3, items = {34014, 20}, reward = {}, exp = 115500000, money = 2000000},
		[123] = {name = "Brachiodemon", monsters_list = {"Brachiodemon"}, count = 350, points = 3, items = {21168, 1}, reward = {}, exp = 115500000, money = 2000000},
		[124] = {name = "Druid's Apparition", monsters_list = {"Druid's Apparition"}, count = 350, points = 3, items = {9302, 5}, reward = {}, exp = 115500000, money = 2000000},
		[125] = {name = "Knight's Apparition", monsters_list = {"Knight's Apparition"}, count = 350, points = 3, items = {3333, 10}, reward = {}, exp = 115500000, money = 2000000},
		[126] = {name = "Infernal Phantom", monsters_list = {"Infernal Phantom"}, count = 350, points = 3, items = {3043, 100}, reward = {}, exp = 115500000, money = 2000000},
		--[[level 1601+ ]]--
		[127] = {name = "Cloak of Terror", monsters_list = {"Cloak of Terror"}, count = 400, points = 3, items = {34023, 1}, reward = {}, exp = 144000000, money = 2000000},
		[128] = {name = "Rotten Golem", monsters_list = {"Rotten Golem"}, count = 400, points = 3, items = {21165, 1}, reward = {}, exp = 144000000, money = 2000000},
		[129] = {name = "Darklight Striker", monsters_list = {"Darklight Striker"}, count = 400, points = 3, items = {43853, 5}, reward = {}, exp = 144000000, money = 2000000},
		[130] = {name = "Sopping Carcass", monsters_list = {"Sopping Carcass"}, count = 400, points = 3, items = {}, reward = {}, exp = 144000000, money = 2000000},
		[131] = {name = "Sopping Corpus", monsters_list = {"Sopping Corpus"}, count = 400, points = 3, items = {43778, 5}, reward = {}, exp = 144000000, money = 2000000},
		[132] = {name = "Turbulent Elemental", monsters_list = {"Turbulent Elemental"}, count = 400, points = 3, items = {8050, 1}, reward = {}, exp = 144000000, money = 2000000},
		[133] = {name = "Mantosaurus", monsters_list = {"Mantosaurus"}, count = 400, points = 3, items = {24391, 1}, reward = {}, exp = 144000000, money = 2000000},
		[134] = {name = "Gorerilla", monsters_list = {"Gorerilla"}, count = 400, points = 3, items = {16163, 1}, reward = {}, exp = 144000000, money = 2000000},
		[135] = {name = "Darklight Matter", monsters_list = {"Darklight Matter"}, count = 400, points = 3, items = {7451, 1}, reward = {}, exp = 144000000, money = 2000000},
		[136] = {name = "Many Faces", monsters_list = {"Many Faces"}, count = 400, points = 3, items = {33932, 5}, reward = {}, exp = 144000000, money = 2000000},
		[137] = {name = "Bloated Man-Maggot", monsters_list = {"Bloated Man-Maggot"}, count = 400, points = 3, items = {43856, 5}, reward = {}, exp = 144000000, money = 2000000},
		[138] = {name = "Infernal Demon", monsters_list = {"Infernal Demon"}, count = 400, points = 3, items = {22193, 5}, reward = {}, exp = 144000000, money = 2000000},
		[139] = {name = "Darklight Construct", monsters_list = {"Darklight Construct"}, count = 400, points = 3, items = {43853, 10}, reward = {}, exp = 144000000, money = 2000000},
		[140] = {name = "Wandering Pillar", monsters_list = {"Wandering Pillar"}, count = 400, points = 3, items = {10315, 10}, reward = {}, exp = 144000000, money = 2000000},
		[141] = {name = "Walking Pillar", monsters_list = {"Walking Pillar"}, count = 400, points = 3, items = {43852, 10}, reward = {}, exp = 144000000, money = 2000000},
}

function Player:getTaskMission()
    return self:getStorageValue(Storage.HuntingTasks.Questline) < 0 and 0 or self:getStorageValue(Storage.HuntingTasks.Questline)
end

function Player:getDailyTaskMission()
    return self:getStorageValue(Storage.HuntingTasks.DailyTask) < 0 and 0 or self:getStorageValue(Storage.HuntingTasks.DailyTask)
end

function Player:getTaskPoints()
    return self:getStorageValue(Storage.HuntingTasks.Points) < 0 and 0 or self:getStorageValue(Storage.HuntingTasks.Points)
end

function Player:randomDailyTask()
    local t = {
        [{1, 50}] = {74, 79},
        [{51, 100}] = {80, 86},
        [{101, 200}] = {87, 91},
        [{201, 300}] = {92, 96},
        [{301, 400}] = {97, 101},
        [{401, 600}] = {102, 106},
        [{601, 800}] = {107, 111},
        [{801, 1100}] = {112, 116},
        [{1101, 1300}] = {117, 121},
        [{1301, 1600}] = {122, 126},
        [{1601, math.huge}] = {127, 141}
    }
    for a, b in pairs(t) do
        if self:getLevel() >= a[1] and self:getLevel() <= a[2] then
            return math.random(b[1], b[2])
        end
    end
    return 0
end

function Player:getRankTask()
    local ranks = {
        [{1, 20}] = "Novice Adventurer",
        [{21, 60}] = "Apprentice Explorer",
        [{61, 100}] = "Seasoned Traveler",
        [{101, 140}] = "Skilled Warrior",
        [{141, 180}] = "Masterful Duelist",
        [{181, 220}] = "Legendary Hero",
        [{221, 260}] = "Godlike Champion",
        [{261, 300}] = "Immortal Guardian",
        [{301, 340}] = "Supreme Overlord",
        [{341, math.huge}] = "Eternal Deity"
    }

    local defaultRank = "Newbie"

    for v, r in pairs(ranks) do
        if self:getTaskPoints() >= v[1] and self:getTaskPoints() <= v[2] then
            return r
        end
    end

    return defaultRank
end

function getItemsFromList(items)
    local str = ''
    if #items > 0 then
        for i = 1, #items do
            local itemID = items[i][1]
            local itemName = ItemType(itemID):getName()
            if itemName then
                str = str .. items[i][2] .. ' ' .. itemName
            else
                str = str .. items[i][2] .. ' ' .. "Item ID: " .. itemID
            end
            if i ~= #items then str = str .. ', ' end
        end
    end
    return str
end


function Player:doRemoveItemsFromList(items)
    local count = 0
    if #items > 0 then
        for i = 1, #items do
            if self:getItemCount(items[i][1]) >= items[i][2] then
                count = count + 1
            end
        end
    end
    if count == #items then
        for i = 1, #items do
            self:removeItem(items[i][1], items[i][2])
        end
    else
        return false
    end
    return true
end

function getMonsterFromList(monster)
    local str = ''
    if #monster > 0 then
        for i = 1, #monster do
            str = str .. monster[i]
            if i ~= #monster then str = str .. ', ' end
        end
    end
    return str
end

function Player:giveRewardsTask(items)
    local backpack = self:addItem(2870, 1)
    for _, i_i in ipairs(items) do
        local item, amount = i_i[1], i_i[2]
        if ItemType(item):isStackable() or amount == 1 then
            backpack:addItem(item, amount)
        else
            for i = 1, amount do
                backpack:addItem(item, 1)
            end
        end
    end
end
