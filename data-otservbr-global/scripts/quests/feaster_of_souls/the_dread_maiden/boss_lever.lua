local config = {
	centerPos = Position({x = 33712, y = 31503, z = 14}),
	rangeX = 11,
	rangeY = 11,
	exitPos = Position({x = 33558, y = 31524, z = 10}),
	newPos = Position({x = 33713, y = 31509, z = 14}),
	bossPos = Position({x = 33713, y = 31501, z = 14}),
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

function bossLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getPosition() ~= Position({x = 33739, y = 31506, z = 14}) then
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
			player:sendCancelMessage("There's someone fighting the boss")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return true
		end
	end	
	local players = {}
	for x = 33739, 33739 + 4 do
		local tile = Tile(Position(x, 31506, 14))
		local creature = tile:getTopCreature()
		if creature then
			if creature:getStorageValue(Storage.Quest.FeasterOfSouls.Bosses.TheDreadMaiden.Timer) >= os.time() then
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
	Game.createMonster("The Dread Maiden", config.bossPos, false, true)
	for _, pid in pairs(players) do
		pid:setStorageValue(Storage.Quest.FeasterOfSouls.Bosses.TheDreadMaiden.Timer, os.time() + config.waitingTime)
		pid:getPosition():sendMagicEffect(CONST_ME_POFF)
		pid:teleportTo(config.newPos)
		addEvent(clearRoom, config.maxRoomTime * 1000, pid:getId())
	end
	config.newPos:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

bossLever:aid(49608)

bossLever:register()