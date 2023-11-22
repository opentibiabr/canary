function getJackLastMissionState(player)
	if player:getStorageValue(Storage.TibiaTales.JackFutureQuest.LastMissionState) == 1 then
		return "You told Jack the truth about his personality. You also explained that you and Spectulus \z
		made a mistake by assuming him as the real Jack."
	else
		return "You lied to the confused Jack about his true personality. You and Spectulus made him \z
		believe that he is in fact a completely different person. Now he will never be able to find out the truth."
	end
end

function checkBoss(centerPosition, rangeX, rangeY, bossName, bossPos)
	local spectators, found = Game.getSpectators(centerPosition, false, false, rangeX, rangeX, rangeY, rangeY), false
	for i = 1, #spectators do
		local spec = spectators[i]
		if spec:isMonster() then
			if spec:getName() == bossName then
				found = true
				break
			end
		end
	end
	if not found then
		local boss = Game.createMonster(bossName, bossPos, true, true)
		boss:setReward(true)
	end
	return found
end

function clearBossRoom(playerId, centerPosition, onlyPlayers, rangeX, rangeY, exitPosition)
	local spectators, spectator = Game.getSpectators(centerPosition, false, onlyPlayers, rangeX, rangeX, rangeY, rangeY)
	for i = 1, #spectators do
		spectator = spectators[i]
		if spectator:isPlayer() and spectator.uid == playerId then
			spectator:teleportTo(exitPosition)
			exitPosition:sendMagicEffect(CONST_ME_TELEPORT)
		end

		if spectator:isMonster() then
			spectator:remove()
		end
	end
end

function roomIsOccupied(centerPosition, onlyPlayers, rangeX, rangeY)
	local spectators = Game.getSpectators(centerPosition, false, onlyPlayers, rangeX, rangeX, rangeY, rangeY)
	if #spectators ~= 0 then
		return true
	end
	return false
end

function clearForgotten(fromPosition, toPosition, exitPosition, storage)
	for x = fromPosition.x, toPosition.x do
		for y = fromPosition.y, toPosition.y do
			for z = fromPosition.z, toPosition.z do
				if Tile(Position(x, y, z)) then
					local creature = Tile(Position(x, y, z)):getTopCreature()
					if creature then
						if creature:isPlayer() then
							creature:teleportTo(exitPosition)
							exitPosition:sendMagicEffect(CONST_ME_TELEPORT)
							creature:say("Time out! You were teleported out by strange forces.", TALKTYPE_MONSTER_SAY)
						elseif creature:isMonster() then
							creature:remove()
						end
					end
				end
			end
		end
	end
	Game.setStorageValue(storage, 0)
end

function resetFerumbrasAscendantHabitats()
	Game.setStorageValue(GlobalStorage.FerumbrasAscendant.Habitats.Corrupted, 0)
	Game.setStorageValue(GlobalStorage.FerumbrasAscendant.Habitats.Desert, 0)
	Game.setStorageValue(GlobalStorage.FerumbrasAscendant.Habitats.Dimension, 0)
	Game.setStorageValue(GlobalStorage.FerumbrasAscendant.Habitats.Grass, 0)
	Game.setStorageValue(GlobalStorage.FerumbrasAscendant.Habitats.Ice, 0)
	Game.setStorageValue(GlobalStorage.FerumbrasAscendant.Habitats.Mushroom, 0)
	Game.setStorageValue(GlobalStorage.FerumbrasAscendant.Habitats.Roshamuul, 0)
	Game.setStorageValue(GlobalStorage.FerumbrasAscendant.Habitats.Venom, 0)
	Game.setStorageValue(GlobalStorage.FerumbrasAscendant.Habitats.AllHabitats, 0)

	for _, spec in pairs(Game.getSpectators(Position(33629, 32693, 12), false, false, 25, 25, 85, 85)) do
		if spec:isPlayer() then
			spec:teleportTo(Position(33630, 32648, 12))
			spec:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			spec:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You were teleported because the habitats are returning to their original form.")
		elseif spec:isMonster() then
			spec:remove()
		end
	end

	for x = 33611, 33625 do
		for y = 32658, 32727 do
			local position = Position(x, y, 12)
			local tile = Tile(position)
			if not tile then
				return
			end
			local ground = tile:getGround()
			if not ground then
				return
			end
			ground:remove()
			local items = tile:getItems()
			if items then
				for i = 1, #items do
					local item = items[i]
					item:remove()
				end
			end
		end
	end

	for x = 33634, 33648 do
		for y = 32658, 32727 do
			local position = Position(x, y, 12)
			local tile = Tile(position)
			if not tile then
				return
			end
			local ground = tile:getGround()
			if not ground then
				return
			end
			ground:remove()
			local items = tile:getItems()
			if items then
				for i = 1, #items do
					local item = items[i]
					item:remove()
				end
			end
		end
	end

	Game.loadMap(DATA_DIRECTORY .. "/world/quest/ferumbras_ascendant/habitats.otbm")
	return true
end

function checkWallArito(item, toPosition)
	if not item:isItem() then
		return false
	end
	local wallTile = Tile(Position(33206, 32536, 6))
	if not wallTile or wallTile:getItemCountById(7181) > 0 then
		return false
	end
	local checkEqual = {
		[2886] = { Position(33207, 32537, 6), { 5858, -1 }, Position(33205, 32537, 6) },
		[3307] = { Position(33205, 32537, 6), { 2016, 1 }, Position(33207, 32537, 6), 5858 },
	}
	local it = checkEqual[item:getId()]
	if it and it[1] == toPosition and Tile(it[3]):getItemCountById(it[2][1], it[2][2]) > 0 then
		wallTile:getItemById(1085):transform(7181)

		if it[4] then
			item:transform(it[4])
		end

		addEvent(function()
			if Tile(Position(33206, 32536, 6)):getItemCountById(7476) > 0 then
				Tile(Position(33206, 32536, 6)):getItemById(7476):transform(1085)
			end
			if Tile(Position(33205, 32537, 6)):getItemCountById(5858) > 0 then
				Tile(Position(33205, 32537, 6)):getItemById(5858):remove()
			end
		end, 5 * 60 * 1000)
	else
		if it and it[4] and it[1] == toPosition then
			item:transform(it[4])
		end
	end
end

function isPlayerInArea(fromPos, toPos)
	for positionX = fromPos.x, toPos.x do
		for positionY = fromPos.y, toPos.y do
			for positionZ = fromPos.z, toPos.z do
				local tile = Tile(Position({ x = positionX, y = positionY, z = positionZ }))
				if tile then
					if tile:getTopCreature() and tile:getTopCreature():isPlayer() then
						return true
					end
				end
			end
		end
	end
	return false
end

function getMonstersInArea(fromPos, toPos, monsterName, ignoreMonsterId)
	local monsters = {}
	for _x = fromPos.x, toPos.x do
		for _y = fromPos.y, toPos.y do
			for _z = fromPos.z, toPos.z do
				local tile = Tile(Position(_x, _y, _z))
				if tile and tile:getTopCreature() then
					for _, pid in pairs(tile:getCreatures()) do
						local mt = Monster(pid)
						if not ignoreMonsterId then
							if mt and mt:isMonster() and mt:getName():lower() == monsterName:lower() and not mt:getMaster() then
								monsters[#monsters + 1] = mt
							end
						else
							if mt and mt:isMonster() and mt:getName():lower() == monsterName:lower() and not mt:getMaster() and ignoreMonsterId ~= mt:getId() then
								monsters[#monsters + 1] = mt
							end
						end
					end
				end
			end
		end
	end
	return monsters
end

function cleanAreaQuest(frompos, topos, itemtable, blockmonsters)
	if not itemtable then
		itemtable = {}
	end
	if not blockmonsters then
		blockmonsters = {}
	end
	for _x = frompos.x, topos.x do
		for _y = frompos.y, topos.y do
			for _z = frompos.z, topos.z do
				local tile = Tile(Position(_x, _y, _z))
				if tile then
					local itc = tile:getItems()
					if itc and tile:getItemCount() > 0 then
						for _, pid in pairs(itc) do
							local itp = ItemType(pid:getId())
							if itp and itp:isCorpse() then
								pid:remove()
							end
						end
					end
					for _, pid in pairs(itemtable) do
						local _until = tile:getItemCountById(pid)
						if _until > 0 then
							for i = 1, _until do
								local it = tile:getItemById(pid)
								if it then
									it:remove()
								end
							end
						end
					end
					local mtempc = tile:getCreatures()
					if mtempc and tile:getCreatureCount() > 0 then
						for _, pid in pairs(mtempc) do
							if pid:isMonster() and not table.contains(blockmonsters, pid:getName():lower()) then
								-- broadcastMessage(pid:getName())
								pid:remove()
							end
						end
					end
				end
			end
		end
	end
	return true
end

function kickerPlayerRoomAfferMin(playername, fromPosition, toPosition, teleportPos, message, monsterName, minutes, firstCall, itemtable, blockmonsters)
	local players = false
	if type(playername) == table then
		players = true
	end
	local player = false
	if not players then
		player = Player(playername)
	end
	local monster = {}
	if monsterName ~= "" then
		monster = getMonstersInArea(fromPosition, toPosition, monsterName)
	end
	if player == false and players == false then
		return false
	end
	if not players and player then
		if player:getPosition():isInRange(fromPosition, toPosition) and minutes == 0 then
			if monsterName ~= "" then
				for _, pid in pairs(monster) do
					if pid:isMonster() then
						if pid:getStorageValue("playername") == playername then
							pid:remove()
						end
					end
				end
			else
				if not itemtable then
					itemtable = {}
				end
				if not blockmonsters then
					blockmonsters = {}
				end
				cleanAreaQuest(fromPosition, toPosition, itemtable, blockmonsters)
			end
			player:teleportTo(teleportPos, true)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
			return true
		end
	else
		if minutes == 0 then
			if monsterName ~= "" then
				for _, pid in pairs(monster) do
					if pid:isMonster() then
						if pid:getStorageValue("playername") == playername then
							pid:remove()
						end
					end
				end
			else
				if not itemtable then
					itemtable = {}
				end
				if not blockmonsters then
					blockmonsters = {}
				end
				cleanAreaQuest(fromPosition, toPosition, itemtable, blockmonsters)
			end
			for _, pid in pairs(playername) do
				local player = Player(pid)
				if player and player:getPosition():isInRange(fromPosition, toPosition) then
					player:teleportTo(teleportPos, true)
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
				end
			end
			return true
		end
	end
	local min = 60 -- Use the 60 for 1 minute
	if firstCall then
		addEvent(kickerPlayerRoomAfferMin, 1000, playername, fromPosition, toPosition, teleportPos, message, monsterName, minutes, false, itemtable, blockmonsters)
	else
		local subt = minutes - 1
		if monsterName ~= "" then
			if minutes > 3 and table.maxn(monster) == 0 then
				subt = 2
			end
		end
		addEvent(kickerPlayerRoomAfferMin, min * 1000, playername, fromPosition, toPosition, teleportPos, message, monsterName, subt, false, itemtable, blockmonsters)
	end
end

function checkWeightAndBackpackRoom(player, itemWeight, message)
	local backpack = player:getSlotItem(CONST_SLOT_BACKPACK)
	if not backpack or backpack:getEmptySlots(true) < 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message .. ", but you have no room to take it.")
		return false
	end
	if (player:getFreeCapacity() / 100) < itemWeight then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message .. ". Weighing " .. itemWeight .. " oz, it is too heavy for you to carry.")
		return false
	end
	return true
end

function doCreatureSayWithRadius(cid, text, type, radiusx, radiusy, position)
	if not position then
		position = Creature(cid):getPosition()
	end

	local spectators, spectator = Game.getSpectators(position, false, true, radiusx, radiusx, radiusy, radiusy)
	for i = 1, #spectators do
		spectator = spectators[i]
		spectator:say(text, type, false, spectator, position)
	end
end

function ReloadDataEvent(cid)
	local player = Player(cid)
	if not player then
		return
	end

	player:reloadData()
end
