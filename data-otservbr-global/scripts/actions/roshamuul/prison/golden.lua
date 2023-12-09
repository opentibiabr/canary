local setting = {
	timeToFightAgain = 10,
	ignorePlayersCount = true,
	clearRoomTime = 60, -- In minutes
	leverPosition = Position(33606, 32362, 11),
	centerRoom = Position(33528, 32334, 12),
	range = 10,
	storage = Storage.PrinceDrazzakTime,
	clearRoomStorage = GlobalStorage.PrinceDrazzakEventTime,
	bossName = "Prince Drazzak",
	bossPosition = Position(33528, 32333, 12),
}

local playerPositions = {
	{ fromPos = Position(33607, 32362, 11), toPos = Position(33526, 32341, 12) },
	{ fromPos = Position(33608, 32362, 11), toPos = Position(33527, 32341, 12) },
	{ fromPos = Position(33609, 32362, 11), toPos = Position(33528, 32341, 12) },
	{ fromPos = Position(33610, 32362, 11), toPos = Position(33529, 32341, 12) },
	{ fromPos = Position(33611, 32362, 11), toPos = Position(33530, 32341, 12) },
}

local golden = Action()

function golden.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if toPosition == setting.leverPosition and not setting.ignorePlayersCount then
		for i = 1, #playerPositions do
			local creature = Tile(playerPositions[i].fromPos):getTopCreature()
			if not creature then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need 5 players to fight with this boss.")
				return true
			end
		end
	end

	if toPosition == setting.leverPosition then
		if roomIsOccupied(setting.centerRoom, false, setting.range, setting.range) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Someone is fighting against the boss! You need wait awhile.")
			return true
		end
		if Game.getStorageValue(setting.clearRoomStorage) == 1 then
			Game.setStorageValue(setting.clearRoomStorage, 0)
			clearRoom(setting.centerRoom, setting.range, setting.range, setting.clearRoomStorage)
		end

		for i = 1, #playerPositions do
			local creature = Tile(playerPositions[i].fromPos):getTopCreature()
			if creature and creature:isPlayer() then
				if creature:getStorageValue(setting.storage) >= os.time() then
					creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have faced this boss in the last " .. setting.timeToFightAgain .. " hours.")
					return true
				end
				if creature:getStorageValue(setting.storage) < os.time() then
					creature:setStorageValue(setting.storage, os.time() + setting.timeToFightAgain * 60 * 60)
					creature:teleportTo(playerPositions[i].toPos)
					creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				end
			else
				if not setting.ignorePlayersCount then
					return false
				end
			end
		end
		item:remove()
		-- One hour for clean the room and other time goto again
		addEvent(clearRoom, setting.clearRoomTime * 60 * 1000, setting.centerRoom, setting.range, setting.range, setting.clearRoomStorage)
		Game.createMonster(setting.bossName, setting.bossPosition)
		Game.setStorageValue(setting.clearRoomStorage, 1)
	end
	return true
end

golden:id(20273)
golden:register()
