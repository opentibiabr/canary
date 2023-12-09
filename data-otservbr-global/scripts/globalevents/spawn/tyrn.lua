local config = {
	monsterName = "Tyrn",
	bossPosition = Position(33056, 32393, 14),
	centerPosition = Position(33056, 32393, 14),
	rangeX = 50,
	rangeY = 50,
}

local tyrn = GlobalEvent("tyrn")
function tyrn.onThink(interval, lastExecution)
	if not checkBoss(config.centerPosition, config.rangeX, config.rangeY, config.monsterName, config.bossPosition) then
		addEvent(Game.broadcastMessage, 150, "Beware of Tyrn!", MESSAGE_EVENT_ADVANCE)
	end
	return true
end

tyrn:interval(9 * 60 * 60 * 1000) -- spawns every 9 hours
tyrn:register()
