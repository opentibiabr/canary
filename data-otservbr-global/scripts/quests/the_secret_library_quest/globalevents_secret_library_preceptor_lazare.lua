local config = {
	monsterName = "Preceptor Lazare",
	bossPosition = Position(33374, 31338, 3),
	range = 50,
}

local preceptorLazare = GlobalEvent("PreceptorLazareRespawn")
function preceptorLazare.onThink(interval, lastExecution)
	checkBoss(config.bossPosition, config.range, config.range, config.monsterName, config.bossPosition)
	return true
end

preceptorLazare:interval(15 * 60 * 1000) -- 15 minutes
preceptorLazare:register()
