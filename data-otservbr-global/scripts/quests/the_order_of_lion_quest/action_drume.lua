local config = {
	lionPosition = {
		Position(32444, 32512, 7),
		Position(32449, 32516, 7),
		Position(32444, 32520, 7),
	},
	usurperPosition = {
		Position(32450, 32520, 7),
		Position(32444, 32516, 7),
		Position(32448, 32512, 7),
	},
	firstPlayerPosition = Position(32457, 32508, 6),
	centerPosition = Position(32439, 32523, 7),
	exitPosition = Position(32453, 32503, 7),
	newPosition = Position(32453, 32510, 7),
	rangeX = 22,
	rangeY = 16,
	timeToKill = 20,
}

local currentEvent = nil

local function clearRoomDrume(centerPosition, rangeX, rangeY)
	local spectators = Game.getSpectators(centerPosition, false, false, rangeX, rangeX, rangeY, rangeY)
	for _, spectator in pairs(spectators) do
		if spectator:isMonster() then
			spectator:remove()
		end
		if spectator:isPlayer() then
			spectator:teleportTo(config.exitPosition)
			spectator:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your time is over.")
		end
	end
	currentEvent = nil
end

local drumeAction = Action()
function drumeAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getPosition() ~= config.firstPlayerPosition then
		return false
	end

	if player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.KesarMission) < 4 then
		return true
	end

	local spectators = Game.getSpectators(config.centerPosition, false, true, config.rangeX, config.rangeX, config.rangeY, config.rangeY)
	if #spectators ~= 0 then
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
	if #players == 0 then
		return false
	end

	for _, pi in pairs(players) do
		if pi:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.KesarMission) < 4 then
			return true
		end
	end

	for _, pi in pairs(players) do
		if not pi:canFightBoss("Drume") then
			player:sendCancelMessage("Someone of your team has already fought in the skirmish in the last twenty hours.")
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
		pi:setBossCooldown("Drume", os.time() + (configManager.getNumber(configKeys.BOSS_DEFAULT_TIME_TO_FIGHT_AGAIN)))
		pi:teleportTo(config.newPosition)
		pi:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have " .. config.timeToKill .. " minutes to defeat Drume.")
	end

	if currentEvent then
		stopEvent(currentEvent)
	end
	currentEvent = addEvent(clearRoomDrume, config.timeToKill * 60 * 1000, config.centerPosition, config.rangeX, config.rangeY)
	config.newPosition:sendMagicEffect(CONST_ME_TELEPORT)
	toPosition:sendMagicEffect(CONST_ME_POFF)
	Game.setStorageValue(GlobalStorage.TheOrderOfTheLion.Drume.TotalLionCommanders, totalLion)
	Game.setStorageValue(GlobalStorage.TheOrderOfTheLion.Drume.TotalUsurperCommanders, totalUsurper)
	return true
end

drumeAction:aid(59601)
drumeAction:register()
