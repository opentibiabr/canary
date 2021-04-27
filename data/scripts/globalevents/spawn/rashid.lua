local positionByDay = {
	[1] = {position = Position(32328, 31782, 6), city = "Carlin"}, -- Sunday
	[2] = {position = Position(32207, 31155, 7), city = "Svarground"}, -- Monday
	[3] = {position = Position(32300, 32837, 7), city = "Liberty Bay"}, -- Tuesday
	[4] = {position = Position(32577, 32753, 7), city = "Port Hope"}, -- Wednesday
	[5] = {position = Position(33066, 32879, 6), city = "Ankrahmun"}, -- Thursday
	[6] = {position = Position(33235, 32483, 7), city = "Darashia"}, -- Friday
	[7] = {position = Position(33166, 31810, 6), city = "Edron"}  -- Saturday
}

local rashid = GlobalEvent("rashid")
function rashid.onStartup()

	local today = os.date("*t").wday

	local config = positionByDay[today]
	if config then
		local rashid = Game.createNpc("rashid", config.position)
		rashid:setMasterPos(config.position)
		rashid:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		Spdlog.info(string.format("Rashid arrived at %s", config.city))
	else
		Spdlog.warn(string.format("[rashid.onStartup] - Cannot create Rashid. Day: %s",
			os.date("%A")))
	end

	return true

end
rashid:register()

local rashidSpawnOnTime = GlobalEvent("rashidSpawnOnTime")
function rashidSpawnOnTime.onTime(interval)

	local today = os.date("*t").wday

	local rashidTarget = Npc("rashid")

	if rashidTarget then
		Spdlog.info("Rashid is traveling to " .. os.date("%A") .. "s location.")
		rashidTarget:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		rashidTarget:teleportTo(positionByDay[today])
		rashidTarget:setMasterPos(positionByDay[today])
		rashidTarget:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end

	return true

end
rashidSpawnOnTime:time("00:01")
rashidSpawnOnTime:register()
