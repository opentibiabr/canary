local config = {
	monsterName = "Grand Commander Soeren",
	bossPosition = Position(33376, 31320, 2),
	centerPosition = Position(33376, 31320, 2),
	rangeX = 50,
	rangeY = 50,
}

local grandCommander = GlobalEvent("grand commander")
function grandCommander.onThink(interval, lastExecution)
	checkBoss(config.centerPosition, config.rangeX, config.rangeY, config.monsterName, config.bossPosition)
	return true
end

grandCommander:interval(15 * 60 * 1000) -- 15 minutes
grandCommander:register()
