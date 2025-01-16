local config = {
	days = {
		["Sunday"] = { "Ferumbras" },
	},
	spawnTime = "21:30",
}

-- Function that is called by the global events when it reaches the time configured
-- interval is the time between the event start and the boss created, it will send a notify message when start
local BossRespawn2 = GlobalEvent("BossRespawn2")
function BossRespawn2.onTime(interval)
	local cfg = config.days[os.date("%A")]
	if cfg then
		local returnValue = Game.startRaid("ferumbras")
		if returnValue ~= RETURNVALUE_NOERROR then
			logger.info("Raid info: {}", Game.getReturnMessage(returnValue))
		else
			logger.info("Raid started.")
		end
	end
	return true
end

BossRespawn2:time(config.spawnTime)
--BossRespawn2:register()
