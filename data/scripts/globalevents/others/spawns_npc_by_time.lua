-- enum LightState_t
-- LIGHT_STATE_DAY,
-- LIGHT_STATE_NIGHT,
-- LIGHT_STATE_SUNSET,
-- LIGHT_STATE_SUNRISE,
local periods = {
	[LIGHT_STATE_NIGHT] = "Night",
	[LIGHT_STATE_DAY] = "Day",
	[LIGHT_STATE_SUNRISE] = "Sunrise",
	[LIGHT_STATE_SUNSET] = "Sunset"
}

local spawns = {
	-- spawnByType day / night
	[1] = { -- spawn in night
		id = "ghostly_wolf",
		name = "Ghostly Wolf",
		spawn = LIGHT_STATE_SUNSET,
		despawn = LIGHT_STATE_SUNRISE,
		position = { x = 33332, y = 32052, z = 7 }
	},
	[2] = { -- spawn in night
		id = "talila",
		name = "Talila",
		spawn = LIGHT_STATE_SUNSET,
		despawn = LIGHT_STATE_SUNRISE,
		position = { x=33504 , y=32222 , z=7 }
	},
	[3] = { -- spawn in day
		id = "valindara",
		name = "Valindara",
		spawn = LIGHT_STATE_SUNRISE,
		despawn = LIGHT_STATE_SUNSET,
		position = { x=33504 , y=32222 , z=7 }
	}
}

local spawnsByTime = GlobalEvent("spawnsByTime")
function spawnsByTime.onPeriodChange(period, light)
	local time = getWorldTime()

	if configManager.getBoolean(configKeys.ALL_CONSOLE_LOG) then
		Spdlog.info(string.format("Starting %s Current light is %s and it's %s Tibian Time",
			periods[period], light, getFormattedWorldTime(time)))
	end
	for index, value in pairs(spawns) do
		if value.spawn == period then
			-- Adding
			local spawn = Game.createNpc(value.id, value.position)
			if spawn then
				if configManager.getBoolean(configKeys.ALL_CONSOLE_LOG) then
					Spdlog.info("NPC " .. value.name .. " added")
				end
				spawn:setMasterPos(value.position)
				spawn:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			end
		elseif value.despawn == period then
			-- Removing
			local target = Npc(value.name)
			if target then
				if configManager.getBoolean(configKeys.ALL_CONSOLE_LOG) then
					Spdlog.info("NPC " .. value.name .. " removed")
				end
				target:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				target:remove()
			end
		end
	end

	return true
end

spawnsByTime:register()
