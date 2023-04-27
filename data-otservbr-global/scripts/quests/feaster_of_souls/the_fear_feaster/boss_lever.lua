local config = {
	centerPos = Position({x = 33711, y = 31469, z = 14}),
	rangeX = 11,
	rangeY = 11,
	exitPos = Position({x = 33571, y = 31452, z = 10}),
	newPos = Position({x = 33711, y = 31473, z = 14}),
	bossPos = Position({x = 33712, y = 31466, z = 14}),
	totemPos = Position({x = 33780, y = 31471, z = 14}),
	totemRangeX = 4,
	totemRangeY = 4,
	summons = {
		Position({x = 33708, y = 31468, z = 14}),
		Position({x = 33711, y = 31468, z = 14}),
		Position({x = 33714, y = 31468, z = 14}),
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
				return true
			end
		end
		spectators = Game.getSpectators(config.totemPos, false, true, config.totemRangeX, config.totemRangeX, config.totemRangeY, config.totemRangeY)
		for _, pid in pairs(spectators) do
			if pid:getId() == id then
				player:teleportTo(config.exitPos)
				config.exitPos:sendMagicEffect(CONST_ME_TELEPORT)
				player:sendCancelMessage("Time's over!")
				return true
			end
		end
	end
end

local function tpBack(players)
	local tpSomeone = false
	local boss = Creature("The Fear Feaster")
	if not boss then
		return false
	end
	for _, pid in pairs(players) do
		if Player(pid) and Player(pid):getPosition():isInRange({x = 33700, y = 31459, z = 14}, {x = 33719, y = 31480, z = 14}) then
			Player(pid):teleportTo({x = 33777, y = 31470, z = 14})
			tpSomeone = true
		end
	end
	if tpSomeone then
		local symbol = Game.createMonster("Symbol of Fear", Position({x = 33780, y = 31471, z = 14}), false, true)
		symbol:say("Face your fear!")
	end
	return true
end

function bossLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getPosition() ~= Position({x = 33734, y = 31471, z = 14}) then
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
	local totemSpectators = Game.getSpectators(config.totemPos, false, false, config.totemRangeX, config.totemRangeX, config.totemRangeY, config.totemRangeY)	
	for _, creature in pairs(totemSpectators) do
		if creature:isPlayer() then
			player:sendCancelMessage("There's someone fighting the boss.")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return true
		end
	end
	local players = {}
	for x = 33734, 33734 + 4 do
		local tile = Tile(Position(x, 31471, 14))
		local creature = tile:getTopCreature()
		if creature then
			if creature:getStorageValue(Storage.Quest.FeasterOfSouls.Bosses.TheFearFeaster.Timer) >= os.time() then
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
	for _, creature in pairs(totemSpectators) do
		creature:remove()
	end
	Game.createMonster("The Fear Feaster", config.bossPos, false, true)
	Game.createMonster("Phobia", config.summons[1], false, true)
	Game.createMonster("Fear", config.summons[2], false, true)
	Game.createMonster("Horror", config.summons[3], false, true)
	local toTpPlayers = {}
	for _, pid in pairs(players) do
		pid:setStorageValue(Storage.Quest.FeasterOfSouls.Bosses.TheFearFeaster.Timer, os.time() + config.waitingTime)
		pid:getPosition():sendMagicEffect(CONST_ME_POFF)
		pid:teleportTo(config.newPos)
		addEvent(clearRoom, config.maxRoomTime * 1000, pid:getId())
		table.insert(toTpPlayers, pid:getId())
	end
	
	addEvent(tpBack, 30000, toTpPlayers)
	config.newPos:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

bossLever:aid(49609)

bossLever:register()