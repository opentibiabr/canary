local config = {
	lionPosition = {
		Position(32444, 32512, 7),
		Position(32449, 32516, 7),
		Position(32444, 32520, 7),
	},
	usurperPosition = {
		Position(32450, 32520, 7),
		Position(32444, 32516, 7),
		Position(32448, 32512, 7)
	},
	firstPlayerPosition = Position(32457, 32508, 6),
    centerPosition = Position(32439, 32523, 7), -- Center Room  
	exitPosition = Position(32453, 32503, 7), -- Exit Position
	newPosition = Position(32453, 32510, 7),
	rangeX = 22,
	rangeY = 16,
	timeToKill = 15, -- time in minutes to remove the player	
}	

local currentEvent = nil

local function RoomIsOccupied(centerPosition, rangeX, rangeY)
	local spectators = Game.getSpectators(config.centerPosition, false, true, config.rangeX, config.rangeX, config.rangeY, config.rangeY)
	if #spectators ~= 0 then
		return true
	end

	return false
end


local function clearRoomDrume(centerPosition, rangeX, rangeY, resetGlobalStorage)
	local spectators,
	spectator = Game.getSpectators(centerPosition, false, false, rangeX, rangeX, rangeY, rangeY)
	for i = 1, #spectators do
		spectator = spectators[i]
		if spectator:isMonster() then
			spectator:remove()
		end
		if spectator:isPlayer() then
			spectator:teleportTo(config.exitPosition)
			spectator:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your time is over.")
		end
	end
	if Game.getStorageValue(resetGlobalStorage) == 1 then
		Game.setStorageValue(resetGlobalStorage, -1)
	end
	currentEvent = nil
end

local drumeAction = Action()
function drumeAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getPosition() ~= config.firstPlayerPosition then return false end
	if RoomIsOccupied(config.centerPosition, config.rangeX, config.rangeY) then
		player:sendCancelMessage("There's someone already in the skirmish.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return true
	end
	local tempPos, tempTile, tempCreature
	local players = {}
	for x = config.firstPlayerPosition.x, config.firstPlayerPosition.x + 4 do
		tempPos = Position(x, config.firstPlayerPosition.y, config.firstPlayerPosition.z)
		tempTile = Tile(tempPos)
		if tempTile then
			tempCreature = tempTile:getTopCreature()
			if tempCreature and tempCreature:isPlayer() then
				table.insert(players, tempCreature)
			end
		end
	end
	if #players == 0 then return false end
	for _, pi in pairs(players) do
		if pi:getStorageValue(Storage.TheOrderOfTheLion.Drume.Timer) > os.time() then
			player:sendCancelMessage("Someone of your team has already fought in the skirmish in the last 20h.")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return true
		end
	end
	local spectators = Game.getSpectators(config.centerPosition, false, false, config.rangeX, config.rangeX, config.rangeY, config.rangeY)
	for _, creature in pairs(spectators) do
		if creature:isMonster() then
			creature:remove()
		end
	end
	local totalLion = 0
	local totalUsurper = 0
	local tempMonster
	for _, pos in pairs(config.lionPosition) do
		tempMonster = Game.createMonster("Lion Commander", pos)
		if not tempMonster then
			player:sendCancelMessage("There was an error, contact an admin.")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return true
		end
		totalLion = totalLion + 1
	end
	for _, pos in pairs(config.usurperPosition) do
		tempMonster = Game.createMonster("Usurper Commander", pos)
		if not tempMonster then
			player:sendCancelMessage("There was an error, contact an admin.")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return true
		end
		totalUsurper = totalUsurper + 1
	end
	for _, pi in pairs(players) do
		pi:setStorageValue(Storage.TheOrderOfTheLion.Drume.Timer, os.time() + (20 * 60 * 60))
		pi:teleportTo(config.newPosition)
		pi:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have " ..config.timeToKill.." minutes to defeat Drume.")
		
	end
	if currentEvent then
		stopEvent(currentEvent)
	end
	currentEvent = addEvent(clearRoomDrume, config.timeToKill * 60 * 1000, config.centerPosition, config.rangeX, config.rangeY, resetGlobalStorage)
	config.newPosition:sendMagicEffect(CONST_ME_TELEPORT)
	toPosition:sendMagicEffect(CONST_ME_POFF)
	Game.setStorageValue(Storage.TheOrderOfTheLion.Drume.TotalLionCommanders, totalLion)
	Game.setStorageValue(Storage.TheOrderOfTheLion.Drume.TotalUsurperCommanders, totalUsurper)
	return true
end
drumeAction:aid(59601)
drumeAction:register()
