local config = {
	boss = {
		name = "Ascending Ferumbras",
		position = Position(33392, 31473, 14),
	},
	timeToFightAgain = 60 * 60 * 20 * 24,
	playerPositions = {
		{ pos = Position(33270, 31477, 14), teleport = Position(33392, 31479, 14) },
		{ pos = Position(33269, 31477, 14), teleport = Position(33392, 31479, 14) },
		{ pos = Position(33269, 31478, 14), teleport = Position(33392, 31479, 14) },
		{ pos = Position(33269, 31479, 14), teleport = Position(33392, 31479, 14) },
		{ pos = Position(33269, 31480, 14), teleport = Position(33392, 31479, 14) },
		{ pos = Position(33269, 31481, 14), teleport = Position(33392, 31479, 14) },
		{ pos = Position(33270, 31478, 14), teleport = Position(33392, 31479, 14) },
		{ pos = Position(33270, 31479, 14), teleport = Position(33392, 31479, 14) },
		{ pos = Position(33270, 31480, 14), teleport = Position(33392, 31479, 14) },
		{ pos = Position(33270, 31481, 14), teleport = Position(33392, 31479, 14) },
		{ pos = Position(33271, 31477, 14), teleport = Position(33392, 31479, 14) },
		{ pos = Position(33271, 31478, 14), teleport = Position(33392, 31479, 14) },
		{ pos = Position(33271, 31479, 14), teleport = Position(33392, 31479, 14) },
		{ pos = Position(33271, 31480, 14), teleport = Position(33392, 31479, 14) },
		{ pos = Position(33271, 31481, 14), teleport = Position(33392, 31479, 14) },
	},
	specPos = {
		from = Position(33379, 31460, 14),
		to = Position(33405, 31485, 14),
	},
	exit = Position(33319, 32318, 13),
	monsters = {
		{ name = "rift invader", pos = Position(33385, 31466, 14) },
		{ name = "rift invader", pos = Position(33396, 31466, 14) },
		{ name = "rift invader", pos = Position(33392, 31480, 14) },
		{ name = "rift invader", pos = Position(33392, 31468, 14) },
		{ name = "rift invader", pos = Position(33385, 31473, 14) },
		{ name = "rift invader", pos = Position(33398, 31478, 14) },
		{ name = "rift invader", pos = Position(33384, 31478, 14) },
		{ name = "rift invader", pos = Position(33390, 31463, 14) },
		{ name = "rift invader", pos = Position(33400, 31473, 14) },
		{ name = "rift invader", pos = Position(33400, 31465, 14) },
	},
	onUseExtra = function(player)
		local crystals = {
			[1] = { crystalPosition = Position(33390, 31468, 14), globalStorage = Storage.Quest.U10_90.FerumbrasAscension.Crystals.Crystal1 },
			[2] = { crystalPosition = Position(33394, 31468, 14), globalStorage = Storage.Quest.U10_90.FerumbrasAscension.Crystals.Crystal2 },
			[3] = { crystalPosition = Position(33397, 31471, 14), globalStorage = Storage.Quest.U10_90.FerumbrasAscension.Crystals.Crystal3 },
			[4] = { crystalPosition = Position(33397, 31475, 14), globalStorage = Storage.Quest.U10_90.FerumbrasAscension.Crystals.Crystal4 },
			[5] = { crystalPosition = Position(33394, 31478, 14), globalStorage = Storage.Quest.U10_90.FerumbrasAscension.Crystals.Crystal5 },
			[6] = { crystalPosition = Position(33390, 31478, 14), globalStorage = Storage.Quest.U10_90.FerumbrasAscension.Crystals.Crystal6 },
			[7] = { crystalPosition = Position(33387, 31475, 14), globalStorage = Storage.Quest.U10_90.FerumbrasAscension.Crystals.Crystal7 },
			[8] = { crystalPosition = Position(33387, 31471, 14), globalStorage = Storage.Quest.U10_90.FerumbrasAscension.Crystals.Crystal8 },
		}
		Game.setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.Crystals.AllCrystals, 0)
		Game.setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.FerumbrasEssence, 0)
		for _, crystal in pairs(crystals) do
			local tile = Tile(crystal.crystalPosition)
			if tile then
				local item = tile:getItemById(14961)
				if item then
					item:transform(14955)
				end
			end
			Game.setStorageValue(crystal.globalStorage, 0)
		end
	end,
}

local leverFerumbras = BossLever(config)
leverFerumbras:position(Position(33270, 31476, 14))
leverFerumbras:register()
