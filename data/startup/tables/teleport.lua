-- Look README.md for see the reserved action/unique numbers

TeleportAction = {
	[35001] = { -- The Cursed Crystal teleports
		itemId = 21721,
		itemPos = {
			{x = 31973, y = 32905, z = 10},
			{x = 31973, y = 32905, z = 11},
			{x = 32009, y = 32928, z = 10},
			{x = 32009, y = 32928, z = 9}
		}
	},
	-- Path: data\scripts\movements\quests\the_queen_of_the_banshees\movement(2)-second_seal_pearl.lua
	[35002] = {
		itemId = 1387,
		itemPos = {
			{x = 32176, y = 31869, z = 15},
			{x = 32177, y = 31869, z = 15}
		}
	}
}

TeleportUnique = {
	-- The first dragon quest
	-- Path: data\scripts\movements\quests\first_dragon\entrance_teleport.lua
	-- Tazhadur entrance
	[35001] = {
		itemId = 9565,
		itemPos = {x = 33234, y = 32276, z = 12}
	},
	-- Kalyassa entrance
	[35002] = {
		itemId = 9562,
		itemPos = {x = 33160, y = 31320, z = 5}
	},
	-- Zorvorax entrance
	[35003] = {
		itemId = 9564,
		itemPos = {x = 33003, y = 31593, z = 11}
	},
	-- Gelidrazah entrance
	[35004] = {
		itemId = 9563,
		itemPos = {x = 32276, y = 31367, z = 4}
	},
	-- Tazhadur exit
	-- Path: data\scripts\movements\quests\first_dragon\exit_teleport.lua
	[35005] = {
		itemId = 9565,
		itemPos = {x = 32013, y = 32467, z = 8}
	},
	-- Kalyassa exit
	[35006] = {
		itemId = 9562,
		itemPos = {x = 32076, y = 32457, z = 8}
	},
	-- Zorvorax exit
	[35007] = {
		itemId = 9564,
		itemPos = {x = 32006, y = 32395, z = 8}
	},
	-- Gelidrazah exit
	[35008] = {
		itemId = 9563,
		itemPos = {x = 32077, y = 32404, z = 8}
	},
	-- Lions rock quest
	-- Path: data\scripts\movements\quests\lions_rock\lions_rock.lua
	[35009] = {
		itemId = 8058,
		itemPos = {x = 33128, y = 32308, z = 8}
	},
	-- Dawnport quest
	-- Sacred snake teleport
	-- Path: data\scripts\movements\quests\dawnport\legion_helmet.lua
	[35010] = {
		itemId = 1387,
		itemPos = {x = 32112, y = 31936, z = 8}
	},
	-- Draconia quest
	-- Exit teleport
	-- Path: data\scripts\movements\quests\draconia\movement-exit_teleport.lua
	[35011] = {
		itemId = 1387,
		itemPos = {x = 32805, y = 31587, z = 1}
	},
	-- Path: data\scripts\movements\quests\draconia\movement-escape.lua
	[35012] = {
		itemId = 1387,
		itemPos = {x = 32815, y = 31599, z = 9}
	},
	-- The queen of the banshees quest
	-- Path: data\scripts\movements\quests\the_queen_of_the_banshees\movement(1)-first_seal_flame.lua
	[35013] = {
		itemId = 8058,
		itemPos = {x = 32278, y = 31903, z = 13}
	},
	-- Path: data\scripts\movements\quests\the_queen_of_the_banshees\movement(2)-second_seal_flame.lua
	[35014] = {
		itemId = 8058,
		itemPos = {x = 32171, y = 31853, z = 15}
	},
	-- Path: data\scripts\movements\quests\the_queen_of_the_banshees\movement(3)-third_seal_flame.lua
	[35015] = {
		itemId = 8058,
		itemPos = {x = 32215, y = 31849, z = 15}
	},
	-- Path: data\scripts\movements\quests\the_queen_of_the_banshees\movement(4)-fourth_seal_flame.lua
	[35016] = {
		itemId = 8058,
		itemPos = {x = 32250, y = 31892, z = 14}
	},
	-- Path: data\scripts\movements\quests\the_queen_of_the_banshees\movement(5)-fifth_seal_flame.lua
	[35017] = {
		itemId = 8058,
		itemPos = {x = 32192, y = 31938, z = 14}
	},
	-- Path: data\scripts\movements\quests\the_queen_of_the_banshees\movement(6)-sixth_seal_flame.lua
	[35018] = {
		itemId = 8058,
		itemPos = {x = 32311, y = 31978, z = 13}
	},
	-- Path: data\scripts\movements\quests\the_queen_of_the_banshees\movement(7)-last_seal_flame.lua
	[35019] = {
		itemId = 1387,
		itemPos = {x = 32219, y = 31913, z = 15}
	},
	-- Path: data\scripts\movements\quests\nightmare_isles\teleport.lua
	[35020] = {
		itemId = 11796,
		itemPos = {x = 33498, y = 32613, z = 8}
	},

	-- Simple teleports (They are registered automatically, without just configuring the table correctly)
	-- Path: data\scripts\movements\others\teleport.lua

	-- Quests teleports
	-- Deeper fibula quest teleport
	-- Entrance
	[38001] = {
		itemId = 1387,
		itemPos = {x = 32208, y = 32433, z = 10},
		destination = {x = 32281, y = 32389, z = 10},
		effect = CONST_ME_TELEPORT
	},
	-- Exit
	[38002] = {
		itemId = 1387,
		itemPos = {x = 32234, y = 32502, z = 10},
		destination = {x = 32210, y = 32437, z = 10},
		effect = CONST_ME_TELEPORT
	},
	-- Draconia quest teleports
	[38003] = {
		itemId = 1387,
		itemPos = {x = 32675, y = 31646, z = 10},
		destination = {x = 32725, y = 31589, z = 12},
		effect = CONST_ME_TELEPORT
	},
	[38004] = {
		itemId = 1387,
		itemPos = {x = 32669, y = 31653, z = 10},
		destination = {x = 32679, y = 31673, z = 10},
		effect = CONST_ME_TELEPORT
	},
	[38005] = {
		itemId = 1387,
		itemPos = {x = 32794, y = 31576, z = 5},
		destination = {x = 32812, y = 31577, z = 5},
		effect = CONST_ME_TELEPORT
	},
	[38006] = {
		itemId = 1387,
		itemPos = {x = 32812, y = 31576, z = 5},
		destination = {x = 32794, y = 31577, z = 5},
		effect = CONST_ME_TELEPORT
	},
	-- Demom helmet quest teleports
	[38007] = {
		itemId = 1387,
		itemPos = {x = 33278, y = 31592, z = 11},
		destination = {x = 33281, y = 31592, z = 12},
		effect = CONST_ME_TELEPORT
	},
	[38008] = {
		itemId = 1387,
		itemPos = {x = 33286, y = 31589, z = 12},
		destination = {x = 33277, y = 31592, z = 11},
		effect = CONST_ME_TELEPORT
	},
	[38009] = {
		itemId = 1387,
		itemPos = {x = 33324, y = 31592, z = 14},
		destination = {x = 33324, y = 31575, z = 15},
		effect = CONST_ME_TELEPORT
	},
	-- Alawar's vault quest
	-- Entrance
	[38010] = {
		itemId = 1387,
		itemPos = {x = 32187, y = 31622, z = 8},
		destination = {x = 32107, y = 31567, z = 9},
		effect = CONST_ME_TELEPORT
	},
	-- Exit
	[38011] = {
		itemId = 1387,
		itemPos = {x = 32107, y = 31566, z = 9},
		destination = {x = 32189, y = 31625, z = 4},
		effect = CONST_ME_TELEPORT
	},
	-- Black knight quest entrance
	[38012] = {
		itemId = 1387,
		itemPos = {x = 32874, y = 31941, z = 12},
		destination = {x = 32874, y = 31948, z = 11},
		effect = CONST_ME_TELEPORT
	},
	-- Black knight quest exit
	[38013] = {
		itemId = 1387,
		itemPos = {x = 32874, y = 31955, z = 11},
		destination = {x = 32874, y = 31942, z = 12},
		effect = CONST_ME_TELEPORT
	},
	-- The queen of the banshees teleports
	[38014] = {
		itemId = 1387,
		itemPos = {x = 32262, y = 31889, z = 10},
		destination = {x = 32259, y = 31892, z = 10},
		effect = CONST_ME_TELEPORT
	},
	[38015] = {
		itemId = 1387,
		itemPos = {x = 32266, y = 31857, z = 12},
		destination = {x = 32266, y = 31864, z = 12},
		effect = CONST_ME_TELEPORT
	},
	[38016] = {
		itemId = 1387,
		itemPos = {x = 32266, y = 31863, z = 12},
		destination = {x = 32266, y = 31858, z = 12},
		effect = CONST_ME_TELEPORT
	},
	-- The annihilator quest room exit
	[38017] = {
		itemId = 1387,
		itemPos = {x = 33236, y = 31655, z = 13},
		destination = {x = 33213, y = 31671, z = 13},
		effect = CONST_ME_TELEPORT
	},
	-- The paradox tower quest
	[38018] = {
		itemId = 1387,
		itemPos = {x = 32476, y = 31904, z = 5},
		destination = {x = 32476, y = 31904, z = 6},
		effect = CONST_ME_TELEPORT
	},
	[38019] = {
		itemId = 1387,
		itemPos = {x = 32481, y = 31904, z = 4},
		destination = {x = 32481, y = 31905, z = 5},
		effect = CONST_ME_TELEPORT
	},
	[38020] = {
		itemId = 1387,
		itemPos = {x = 32476, y = 31904, z = 3},
		destination = {x = 32476, y = 31904, z = 4},
		effect = CONST_ME_TELEPORT
	},
	[38021] = {
		itemId = 1387,
		itemPos = {x = 32479, y = 31904, z = 2},
		destination = {x = 32479, y = 31904, z = 3},
		effect = CONST_ME_TELEPORT
	},
	[38022] = {
		itemId = 1387,
		itemPos = {x = 32481, y = 31905, z = 1},
		destination = {x = 32480, y = 31905, z = 2},
		effect = CONST_ME_TELEPORT
	},

	-- Others teleports
	-- Water elemental cave (Trapwood)
	[39001] = {
		itemId = 8632,
		itemPos = {x = 32600, y = 33009, z = 8},
		destination = {x = 32600, y = 33009, z = 9},
		effect = CONST_ME_TELEPORT
	},
	[39002] = {
		itemId = 7106,
		itemPos = {x = 32628, y = 33001, z = 9},
		destination = {x = 32624, y = 33001, z = 9},
		effect = CONST_ME_TELEPORT
	},
	[39003] = {
		itemId = 8632,
		itemPos = {x = 32649, y = 32985, z = 8},
		destination = {x = 32653, y = 32987, z = 9},
		effect = CONST_ME_TELEPORT
	},
	[39004] = {
		itemId = 7106,
		itemPos = {x = 32654, y = 32985, z = 9},
		destination = {x = 32651, y = 32983, z = 8},
		effect = CONST_ME_TELEPORT
	},
	[39005] = {
		itemId = 8632,
		itemPos = {x = 32610, y = 32977, z = 8},
		destination = {x = 32612, y = 32980, z = 9},
		effect = CONST_ME_TELEPORT
	},
	[39006] = {
		itemId = 7106,
		itemPos = {x = 32610, y = 32979, z = 9},
		destination = {x = 32608, y = 32978, z = 8},
		effect = CONST_ME_TELEPORT
	}
}
