local config = {
	monsterName = "Tyrn",
	bossPosition = Position(33056, 32393, 14),
	centerPosition = Position(33056, 32393, 14),
	rangeX = 50,
	rangeY = 50,
}

local function checkBoss(centerPosition, rangeX, rangeY, bossName)
	local spectators, spec = Game.getSpectators(centerPosition, false, false, rangeX, rangeX, rangeY, rangeY)
	for i = 1, #spectators do
		spec = spectators[i]
		if spec:isMonster() then
			if spec:getName() == bossName then
				return true
			end
		end
	end
	return false
end

local tyrn = GlobalEvent("tyrn")
function tyrn.onThink(interval, lastExecution)
	if checkBoss(config.centerPosition, config.rangeX, config.rangeY, config.monsterName) then
		return true
	end
	addEvent(Game.broadcastMessage, 150, "Beware of Tyrn!", MESSAGE_EVENT_ADVANCE)
	local boss = Game.createMonster(config.monsterName, config.bossPosition, true, true)
	boss:setReward(true)
	return true
end

tyrn:interval(9 * 60 * 60 * 1000) -- spawns every 9 hours
tyrn:register()
