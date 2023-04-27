local config = {
	centerPos = Position({x = 33708, y = 31539, z = 14}),
	rangeX = 11,
	rangeY = 8,
	exitPos = Position({x = 33609, y = 31500, z = 10}),
	newPos = Position({x = 33715, y = 31539, z = 14}),
	bossPos = {
		Position(33701, 31540, 14),
		Position(33701, 31540, 15),
	},
	waitingTime = 20 * 60 * 60,
	maxRoomTime = 15 * 60,
}

local bossLever = Action()

local function clearRoom(id)
	local player = Player(id)
	if player then
		local spectators = Game.getSpectators(config.centerPos, false, true, config.rangeX, config.rangeX, config.rangeY, config.rangeY)
		for _, pid in pairs(spectators) do
			if pid:getId() == id then
				player:teleportTo(config.exitPos)
				config.exitPos:sendMagicEffect(CONST_ME_TELEPORT)
				player:sendCancelMessage("Time's over!")
				break
			end
		end
	end
end

local function moveWorm(id, moveToRoom)
	local worm = Creature(id)	
	if not worm then return true end
	local spectators = Game.getSpectators(config.centerPos, false, true, config.rangeX, config.rangeX, config.rangeY, config.rangeY)
	if not spectators or #spectators == 0 then return true end
	if moveToRoom then
		worm:teleportTo(Position(33706, 31534, 14))
	else
		worm:teleportTo(config.bossPos[2])
	end
	addEvent(moveWorm, 20000, id, moveToRoom == false)
end		

function bossLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getPosition() ~= Position(33736, 31537, 14) then
		return false
	end
	if item:getId() == 8911 then
		item:transform(8912)
		return true
	end
	item:transform(8911)
	local spectators = Game.getSpectators(config.centerPos, false, false, config.rangeX, config.rangeX, config.rangeY, config.rangeY)
	for _, creature in pairs(spectators) do
		if creature:isPlayer() then
			player:sendCancelMessage("There's someone fighting the boss.")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return true
		end
	end	
	local players = {}
	for x = 33736, 33736 + 4 do
		local tile = Tile(Position(x, 31537, 14))
		local creature = tile:getTopCreature()
		if creature then
			if creature:getStorageValue(Storage.Quest.FeasterOfSouls.Bosses.TheUnwelcome.Timer) >= os.time() then
				player:sendCancelMessage("Someone of your team fought this boss in the last 20h.")
				player:getPosition():sendMagicEffect(CONST_ME_POFF)
				return true
			else
				table.insert(players, creature)
			end
		end
	end
	
	for _, creature in pairs(spectators) do
		creature:remove()
	end
	Game.createMonster("The Unwelcome", config.bossPos[1], false, true)
	if not Tile(config.bossPos[2]) then
		Game.createTile(config.bossPos[2])
		Game.createItem(17652, 1, config.bossPos[2])
	end
	local brother = Game.createMonster("Brother Worm", config.bossPos[2], false, true)
	for _, pid in pairs(players) do
		pid:setStorageValue(Storage.Quest.FeasterOfSouls.Bosses.TheUnwelcome.Timer, os.time() + config.waitingTime)
		pid:getPosition():sendMagicEffect(CONST_ME_POFF)
		pid:teleportTo(config.newPos)
		addEvent(clearRoom, config.maxRoomTime * 1000, pid:getId())
	end
	addEvent(moveWorm, 20000, brother:getId(), true)
	config.newPos:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

bossLever:aid(49607)

bossLever:register()