local config = {
	monsterName = "Thawing Dragon Lord",
	bossPosition = Position(33361, 31316, 5),
	centerPosition = Position(33361, 31316, 5),
	rangeX = 50,
	rangeY = 50,
}

local thawingDragonLord = GlobalEvent("thawing dragon lord")

function thawingDragonLord.onThink(interval, lastExecution)
	checkBoss(config.centerPosition, config.rangeX, config.rangeY, config.monsterName, config.bossPosition)
	return true
end

thawingDragonLord:interval(900000)
thawingDragonLord:register()
