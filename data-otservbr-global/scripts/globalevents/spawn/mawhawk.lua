local config = {
	monsterName = "Mawhawk",
	bossPosition = Position(33703, 32461, 7),
	centerPosition = Position(33703, 32461, 7),
	rangeX = 50,
	rangeY = 50,
}

local mawhawk = GlobalEvent("mawhawk")
function mawhawk.onThink(interval, lastExecution)
	if not checkBoss(config.centerPosition, config.rangeX, config.rangeY, config.monsterName, config.bossPosition) then
		addEvent(Game.broadcastMessage, 150, "Beware! Mawhawk!", MESSAGE_EVENT_ADVANCE)
	end
	return true
end

mawhawk:interval(10 * 60 * 60 * 1000) -- spawns every 10 hours
mawhawk:register()
