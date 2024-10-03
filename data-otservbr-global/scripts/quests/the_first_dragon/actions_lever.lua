local lever = Action()

local config = {
	centerRoom = { x = 33616, y = 31022, z = 14 },
	range = 10,
	storage = Storage.Quest.U11_02.TheFirstDragon.FirstDragonTimer,
	monsterPosition = {
		{ position = Position(33574, 31013, 14) },
		{ position = Position(33592, 31013, 14) },
		{ position = Position(33583, 31022, 14) },
		{ position = Position(33574, 31031, 14) },
		{ position = Position(33592, 31031, 14) },
	},
	playerPositions = {
		Position(33582, 30993, 14),
		Position(33583, 30993, 14),
		Position(33584, 30993, 14),
		Position(33582, 30994, 14),
		Position(33583, 30994, 14),
		Position(33584, 30994, 14),
		Position(33582, 30995, 14),
		Position(33583, 30995, 14),
		Position(33584, 30995, 14),
		Position(33582, 30996, 14),
		Position(33583, 30996, 14),
		Position(33584, 30996, 14),
		Position(33582, 30997, 14),
		Position(33583, 30997, 14),
		Position(33584, 30997, 14),
	},
	toPosition1 = Position(33574, 31017, 14),
	roomTile1 = {
		{ fromPosition = Position(33582, 30993, 14) },
		{ fromPosition = Position(33583, 30993, 14) },
		{ fromPosition = Position(33584, 30993, 14) },
	},
	toPosition2 = Position(33592, 31017, 14),
	roomTile2 = {
		{ fromPosition = Position(33582, 30994, 14) },
		{ fromPosition = Position(33583, 30994, 14) },
		{ fromPosition = Position(33584, 30994, 14) },
	},
	toPosition3 = Position(33592, 31035, 14),
	roomTile3 = {
		{ fromPosition = Position(33582, 30995, 14) },
		{ fromPosition = Position(33583, 30995, 14) },
		{ fromPosition = Position(33584, 30995, 14) },
	},
	toPosition4 = Position(33574, 31035, 14),
	roomTile4 = {
		{ fromPosition = Position(33582, 30996, 14) },
		{ fromPosition = Position(33583, 30996, 14) },
		{ fromPosition = Position(33584, 30996, 14) },
	},
	toPosition5 = Position(33583, 31026, 14),
	roomTile5 = {
		{ fromPosition = Position(33582, 30997, 14) },
		{ fromPosition = Position(33583, 30997, 14) },
		{ fromPosition = Position(33584, 30997, 14) },
	},
	clearArea = {
		from = Position(33566, 31006, 14),
		to = Position(33626, 31032, 14),
	},
}

local function clearMonstersInArea(fromPos, toPos)
	for z = fromPos.z, toPos.z do
		for y = fromPos.y, toPos.y do
			for x = fromPos.x, toPos.x do
				local tile = Tile(Position(x, y, z))
				if tile then
					local creature = tile:getTopCreature()
					if creature and creature:isMonster() then
						creature:remove()
					end
				end
			end
		end
	end
end

local function isRoomOccupied(fromPos, toPos)
	for z = fromPos.z, toPos.z do
		for y = fromPos.y, toPos.y do
			for x = fromPos.x, toPos.x do
				local tile = Tile(Position(x, y, z))
				if tile then
					local creature = tile:getTopCreature()
					if creature and creature:isPlayer() then
						return true
					end
				end
			end
		end
	end
	return false
end

function lever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 8911 then
		for i = 1, #config.playerPositions do
			local creature = Tile(config.playerPositions[i]):getTopCreature()
			if not creature then
				item:transform(8912)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need 15 players to fight with this boss.")
				return true
			end
		end
	end

	if item.itemid == 8911 then
		if isRoomOccupied(config.clearArea.from, config.clearArea.to) then
			player:say("Someone is fighting against the boss! You need to wait awhile.", TALKTYPE_MONSTER_SAY)
			return true
		else
			clearMonstersInArea(config.clearArea.from, config.clearArea.to)
		end

		for d = 1, 5 do
			Game.createMonster("unbeatable dragon", Position(math.random(33610, 33622), math.random(31016, 31030), 14), true, true)
		end
		for b = 1, #config.monsterPosition do
			Game.createMonster("fallen challenger", config.monsterPosition[b].position, true, true)
		end

		for i = 1, #config.playerPositions do
			local creature = Tile(config.playerPositions[i]):getTopCreature()
			if creature then
				for i = 1, #config.roomTile1 do
					local toRoom1 = Tile(config.roomTile1[i].fromPosition):getTopCreature()
					if toRoom1 then
						toRoom1:teleportTo(config.toPosition1)
					end
					local toRoom2 = Tile(config.roomTile2[i].fromPosition):getTopCreature()
					if toRoom2 then
						toRoom2:teleportTo(config.toPosition2)
					end
					local toRoom3 = Tile(config.roomTile3[i].fromPosition):getTopCreature()
					if toRoom3 then
						toRoom3:teleportTo(config.toPosition3)
					end
					local toRoom4 = Tile(config.roomTile4[i].fromPosition):getTopCreature()
					if toRoom4 then
						toRoom4:teleportTo(config.toPosition4)
					end
					local toRoom5 = Tile(config.roomTile5[i].fromPosition):getTopCreature()
					if toRoom5 then
						toRoom5:teleportTo(config.toPosition5)
					end
				end
				creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				creature:setStorageValue(config.storage, os.time() + 20 * 3600)
				creature:setStorageValue(Storage.Quest.U11_02.TheFirstDragon.SomewhatBeatable, 0)
			end
		end

		addEvent(clearRoom, 60 * 60 * 1000, Position(33583, 31022, 14), 50, 50, config.storage)
		Game.createMonster("spirit of fertility", Position(33625, 31021, 14), true, true)
		item:transform(8912)
	elseif item.itemid == 8912 then
		item:transform(8911)
	end
	return true
end

lever:uid(30003)
lever:register()
