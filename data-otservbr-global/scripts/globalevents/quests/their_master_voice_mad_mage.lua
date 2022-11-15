local spawns = {
	[1] = {position = Position(33339,31914,9), monster = 'Mad Mage'},
	[2] = {position = Position(33358,31914,9), monster = 'Mad Mage'},
	[3] = {position = Position(33348,31899,9), monster = 'Mad Mage'},
	[4] = {position = Position(33369,31873,9), monster = 'Mad Mage'},
	[5] = {position = Position(33360,31852,9), monster = 'Mad Mage'},
	[6] = {position = Position(33328,31860,9), monster = 'Mad Mage'},
	[7] = {position = Position(33335,31873,9), monster = 'Mad Mage'}
}

local mad = GlobalEvent("MadMage")
function mad.onThink(interval, lastExecution)
	local spawn = spawns[math.random(#spawns)]
	local monster = Game.createMonster(spawn.monster, spawn.position, true, true)
	monster:setReward(true)

	if not monster then
		Spdlog.error("[mad.onThink] - Failed to spawn ".. rand.bossName)
		return true
	end
	return true
end

mad:interval(14400000)
mad:register()
