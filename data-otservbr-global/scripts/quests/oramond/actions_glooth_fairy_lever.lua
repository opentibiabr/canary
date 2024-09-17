local function clearMonstersAndTeleportPlayers()
	local leverRoomFromPos = Position(33658, 31934, 9)
	local leverRoomToPos = Position(33670, 31940, 9)
	local bossRoomFromPos = Position(33678, 31922, 9)
	local bossRoomToPos = Position(33699, 31943, 9)
	local exitPos = Position(33657, 31943, 9)
	local destinationPos = Position(33684, 31932, 9)

	for x = leverRoomFromPos.x, leverRoomToPos.x do
		for y = leverRoomFromPos.y, leverRoomToPos.y do
			for z = leverRoomFromPos.z, leverRoomToPos.z do
				local currentTile = Tile(Position({ x = x, y = y, z = z }))
				if currentTile then
					local topCreature = currentTile:getTopCreature()
					if topCreature and topCreature:isPlayer() then
						topCreature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
						topCreature:teleportTo(exitPos)
						topCreature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					end
				end
			end
		end
	end

	for x = bossRoomFromPos.x, bossRoomToPos.x do
		for y = bossRoomFromPos.y, bossRoomToPos.y do
			for z = bossRoomFromPos.z, bossRoomToPos.z do
				local currentTile = Tile(Position({ x = x, y = y, z = z }))
				if currentTile then
					local topCreature = currentTile:getTopCreature()
					if topCreature and topCreature:isMonster() then
						topCreature:remove()
					end
				end
			end
		end
	end

	for x = bossRoomFromPos.x, bossRoomToPos.x do
		for y = bossRoomFromPos.y, bossRoomToPos.y do
			for z = bossRoomFromPos.z, bossRoomToPos.z do
				local currentTile = Tile(Position({ x = x, y = y, z = z }))
				if currentTile then
					local topCreature = currentTile:getTopCreature()
					if topCreature and topCreature:isPlayer() then
						topCreature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
						topCreature:teleportTo(destinationPos)
						topCreature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					end
				end
			end
		end
	end

	Game.createMonster("Glooth Fairy", Position(33688, 31937, 9), false, true)
end

local gloothFairyLever = Action()

function gloothFairyLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if Game.getStorageValue(GlobalStorage.GloothFairyTimer) >= os.time() then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to wait 15 minutes to use again.")
		return true
	end

	player:say("Everyone in this place will be teleported into Glooth Fairy's hideout in one minute. No way back!!!", TALKTYPE_MONSTER_SAY)
	Game.setStorageValue(GlobalStorage.GloothFairyTimer, os.time() + 15 * 60)
	addEvent(clearMonstersAndTeleportPlayers, 60 * 1000)
	return true
end

gloothFairyLever:uid(1020)
gloothFairyLever:register()
