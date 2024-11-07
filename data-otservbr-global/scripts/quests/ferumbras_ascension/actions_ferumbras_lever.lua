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

local config = {
	centerRoom = Position(33392, 31473, 14),
	BossPosition = Position(33392, 31473, 14),
	playerPositions = {
		Position(33269, 31477, 14),
		Position(33269, 31478, 14),
		Position(33269, 31479, 14),
		Position(33269, 31480, 14),
		Position(33269, 31481, 14),
		Position(33270, 31477, 14),
		Position(33270, 31478, 14),
		Position(33270, 31479, 14),
		Position(33270, 31480, 14),
		Position(33270, 31481, 14),
		Position(33271, 31477, 14),
		Position(33271, 31478, 14),
		Position(33271, 31479, 14),
		Position(33271, 31480, 14),
		Position(33271, 31481, 14),
	},
	newPosition = Position(33392, 31479, 14),
}

local leverFerumbras = Action()

function leverFerumbras.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local playersTable = {}
	if item.itemid == 8911 then
		if player:getPosition() ~= Position(33270, 31477, 14) then
			item:transform(8912)
			return true
		end
	end
	if item.itemid == 8911 then
		if player:doCheckBossRoom("Ascending Ferumbras", Position(33379, 31460, 14), Position(33405, 31485, 14)) then
			Game.createMonster("Ascending Ferumbras", config.BossPosition, true, true)
			for b = 1, 10 do
				local xrand = math.random(-10, 10)
				local yrand = math.random(-10, 10)
				local position = Position(33392 + xrand, 31473 + yrand, 14)
				if Game.createMonster("rift invader", position) then
				end
			end
			for x = 33269, 33271 do
				for y = 31477, 31481 do
					local playerTile = Tile(Position(x, y, 14)):getTopCreature()
					if playerTile and playerTile:isPlayer() then
						playerTile:getPosition():sendMagicEffect(CONST_ME_POFF)
						playerTile:teleportTo(config.newPosition)
						playerTile:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
						playerTile:setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.FerumbrasTimer, os.time() + 60 * 60 * 20 * 24)
						table.insert(playersTable, playerTile:getId())
					end
				end
			end
			Game.setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.Crystals.AllCrystals, 0)
			Game.setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.FerumbrasEssence, 0)
			for _, crystal in pairs(crystals) do
				local pos = crystal.crystalPosition
				local stg = crystal.globalStorage
				local sqm = Tile(pos)
				if sqm then
					local item = sqm:getItemById(14961)
					if item then
						item:transform(14955)
					end
				end
				Game.setStorageValue(stg, 0)
			end
			addEvent(kickPlayersAfterTime, 30 * 60 * 1000, playersTable, Position(33379, 31460, 14), Position(33405, 31485, 14), Position(33319, 32318, 13))
			item:transform(8912)
		end
	elseif item.itemid == 8912 then
		item:transform(8911)
	end
	return true
end

leverFerumbras:uid(1021)
leverFerumbras:register()
