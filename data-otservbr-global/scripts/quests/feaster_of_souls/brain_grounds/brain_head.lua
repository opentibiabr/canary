local yellowSmoke = MoveEvent()

function yellowSmoke.onStepIn(creature, item, position, fromPosition)
	if item.actionid == 0 then
		creature:teleportTo(fromPosition, true)
	end
	return true
end

yellowSmoke:id(32176)
yellowSmoke:register()

local config = {
	centerPos = Position({x = 31954, y = 32325, z = 10}),
	rangeX = 12,
	rangeY = 12,
	exitPos = Position({x = 31973, y = 32325, z = 10}),
	newPos = Position({x = 31963, y = 32325, z = 10}),
	cerebellumPos = {
		Position({x = 31961, y = 32331, z = 10}),
		Position({x = 31960, y = 32320, z = 10}),
		Position({x = 31945, y = 32320, z = 10}),
		Position({x = 31945, y = 32331, z = 10}),
		Position({x = 31953, y = 32324, z = 10}),
		Position({x = 31953, y = 32326, z = 10}),
		Position({x = 31955, y = 32324, z = 10}),
		Position({x = 31955, y = 32326, z = 10}),
	},
	bossPos = Position({x = 31954, y = 32325, z = 10}),
	waitingTime = 20 * 60 * 60,
	maxRoomTime = 5 * 60,
	hourglass = Position(31974, 32324, 10),
	hourglassEmpty = 32768,
	hourglassOccupied = 32767,
}

local brainHeadEntrance = MoveEvent()

local function clearRoom()
	local spectators = Game.getSpectators(config.centerPos, false, false, config.rangeX, config.rangeX, config.rangeY, config.rangeY)
	for _, creature in pairs(spectators) do
		if creature:isMonster() and not creature:getMaster() then
			creature:remove()
		end
		if creature:isPlayer() then
			creature:teleportTo(config.exitPos)
			config.exitPos:sendMagicEffect(CONST_ME_TELEPORT)
			creature:say("You failed in killing the brain head.", TALKTYPE_MONSTER_SAY, false, creature)
		end
	end
end
			

function brainHeadEntrance.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return true
	end
	if creature:getStorageValue(Storage.Quest.FeasterOfSouls.Bosses.BrainHead.Timer) >= os.time() then
		creature:teleportTo(fromPosition, true)
		creature:sendCancelMessage("You can face this boss only once in 20h.")
		return true
	end
	local hourglass = Tile(config.hourglass):getItemById(config.hourglassEmpty)
	if hourglass then
		hourglass:transform(config.hourglassOccupied)
		hourglass:decay()
		for _, pos in pairs(config.cerebellumPos) do
			Game.createMonster("Cerebellum", pos, false, true)
		end
		Game.createMonster("Brain Head", config.bossPos, false, true)
		addEvent(clearRoom, config.maxRoomTime * 1000)
	end
	creature:teleportTo(config.newPos)
	config.newPos:sendMagicEffect(CONST_ME_TELEPORT)
	position:sendMagicEffect(CONST_ME_TELEPORT)
	creature:setStorageValue(Storage.Quest.FeasterOfSouls.Bosses.BrainHead.Timer, os.time() + config.waitingTime)
	creature:say("The boss has to be killed within 5 minutes after the first player has entered the room.", TALKTYPE_MONSTER_SAY, false, creature)
	return true
end

brainHeadEntrance:type("stepin")

brainHeadEntrance:aid(4524)

brainHeadEntrance:register()

local brainHeadExit = MoveEvent()

function brainHeadExit.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return true
	end
	creature:teleportTo(config.exitPos)
	position:sendMagicEffect(CONST_ME_TELEPORT)
	config.exitPos:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

brainHeadExit:type("stepin")

brainHeadExit:aid(4525)

brainHeadExit:register()
