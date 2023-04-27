local config = {
	centerPos = {Position({x = 33806, y = 31505, z = 14}), Position({x = 33806, y = 31505, z = 15})},
	rangeX = 12,
	rangeY = 12,
	exitPos = Position({x = 33572, y = 31452, z = 10}),
	newPos = Position({x = 33806, y = 31512, z = 14}),
	bossPos = {
		Position({x = 33811, y = 31505, z = 14}),
		Position({x = 33805, y = 31505, z = 15}),
	},
	waitingTime = 1 * 60,
	maxRoomTime = 15 * 60,
}

local bossLever = Action()

local function clearRoom(id)
	local player = Player(id)
	if player then
		local spectators = Game.getSpectators(config.centerPos[1], false, true, config.rangeX, config.rangeX, config.rangeY, config.rangeY)
		for _, pid in pairs(spectators) do
			if pid:getId() == id then
				player:teleportTo(config.exitPos)
				config.exitPos:sendMagicEffect(CONST_ME_TELEPORT)
				player:sendCancelMessage("Time's over!")
				break
			end
		end
		spectators = Game.getSpectators(config.centerPos[2], false, true, config.rangeX, config.rangeX, config.rangeY, config.rangeY)
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

local condition = Condition(CONDITION_HEX)
	Condition:setParameter(CONDITION_PARAM_TICKS, -1)
	Condition:setParameter(CONDITION_PARAM_SUBID, 1095)
	Condition:setParameter(CONDITION_PARAM_BUFF_HEALINGRECEIVED, 40)
	Condition:setParameter(CONDITION_PARAM_BUFF_DAMAGEDEALT, 40)
	Condition:setParameter(CONDITION_PARAM_HEALTHREDUCTIONPERCENT, 60)

function bossLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getPosition() ~= Position({x = 33772, y = 31504, z = 14}) then
		return false
	end
	if item:getId() == 8911 then
		item:transform(8912)
		return true
	end
	item:transform(8911)
	local spectators = Game.getSpectators(config.centerPos[1], false, false, config.rangeX, config.rangeX, config.rangeY, config.rangeY)
	for _, creature in pairs(spectators) do
		if creature:isPlayer() then
			player:sendCancelMessage("There's someone fighting the boss.")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return true
		end
	end
	local secondFloorSpectators = Game.getSpectators(config.centerPos[1], false, false, config.rangeX, config.rangeX, config.rangeY, config.rangeY)
	for _, creature in pairs(secondFloorSpectators) do
		if creature:isPlayer() then
			player:sendCancelMessage("There's someone fighting the boss.")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return true
		end
	end
	local players = {}
	if player:getStorageValue(Storage.Quest.FeasterOfSouls.Bosses.ThePaleWorm.Timer) >= os.time() then
		player:sendCancelMessage("Someone of your team fought this boss in the last 20h.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return true
	else
		table.insert(players, player)
	end
	for x = 33773, 33773 + 2 do
		for y = 31503, 31503 + 2 do
			local tile = Tile(Position(x, y, 14))
			local creature = tile:getTopCreature()
			if creature and creature:isPlayer() then
				if creature:getStorageValue(Storage.Quest.FeasterOfSouls.Bosses.ThePaleWorm.Timer) >= os.time() then
					player:sendCancelMessage("Someone of your team fought this boss in the last 20h.")
					player:getPosition():sendMagicEffect(CONST_ME_POFF)
					return true
				else
					table.insert(players, creature)
				end
			end
		end
	end
	
	for _, creature in pairs(spectators) do
		creature:remove()
	end
	for _, creature in pairs(secondFloorSpectators) do
		creature:remove()
	end
	Game.createMonster("The Pale Worm", config.bossPos[1], false, true)
	Game.createMonster("A Weak Spot", config.bossPos[2], false, true)
	for _, pid in pairs(players) do
		pid:setStorageValue(Storage.Quest.FeasterOfSouls.Bosses.ThePaleWorm.Timer, os.time() + config.waitingTime)
		pid:getPosition():sendMagicEffect(CONST_ME_POFF)
		pid:teleportTo(config.newPos)
		addEvent(clearRoom, config.maxRoomTime * 1000, pid:getId())
		pid:addCondition(condition)
	end
	addEvent(function()
		Game.createMonster("Hunger Worm", Position({x = 33805, y = 31499, z = 14}), false, true)
	end, 45000)
	config.newPos:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

bossLever:aid(49610)

bossLever:register()