local setting = {
	{
		tpPos = { x = 33176, y = 31894, z = 15 },
		tpDestination = { x = 33166, y = 31894, z = 15 },
		boss = "The False God",
	},
	{
		tpPos = { x = 33125, y = 31950, z = 15 },
		tpDestination = { x = 33136, y = 31948, z = 15 },
		boss = "Ravenous Hunger",
	},
	{
		tpPos = { x = 33096, y = 31963, z = 15 },
		tpDestination = { x = 33095, y = 31953, z = 15 },
		boss = "Essence of Malice",
	},
	{
		tpPos = { x = 33114, y = 31887, z = 15 },
		tpDestination = { x = 33131, y = 31899, z = 15 },
		boss = "The Souldespoiler",
	},
	{
		tpPos = { x = 33072, y = 31871, z = 15 },
		tpDestination = { x = 33078, y = 31889, z = 15 },
		boss = "The Source Of Corruption",
	},
	{
		tpPos = { x = 33178, y = 31845, z = 15 },
		tpDestination = { x = 33164, y = 31866, z = 15 },
		boss = "The Armored Voidborn",
	},
}

local bossTimer = MoveEvent()

-- Utility function to localize time
local function formatTimeLeft(seconds)
	if seconds <= 0 then
		return "a few seconds"
	end

	local days = math.floor(seconds / 86400)
	local hours = math.floor((seconds % 86400) / 3600)
	local minutes = math.floor((seconds % 3600) / 60)
	local secs = seconds % 60

	local parts = {}

	if days > 0 then
		table.insert(parts, days .. " day" .. (days > 1 and "s" or ""))
	end
	if hours > 0 then
		table.insert(parts, hours .. " hour" .. (hours > 1 and "s" or ""))
	end
	if minutes > 0 then
		table.insert(parts, minutes .. " minute" .. (minutes > 1 and "s" or ""))
	end
	if secs > 0 and days == 0 then -- Only show seconds if cooldown is less than a day
		table.insert(parts, secs .. " second" .. (secs > 1 and "s" or ""))
	end

	-- Build readable string
	local message = ""
	for i = 1, #parts do
		message = message .. parts[i]
		if i < #parts - 1 then
			message = message .. ", "
		elseif i == #parts - 1 then
			message = message .. " and "
		end
	end
	return message
end

function bossTimer.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	for _, config in ipairs(setting) do
		if player:getPosition() == Position(config.tpPos) then
			if not player:canFightBoss(config.boss) then
				local cooldownTimestamp = player:getBossCooldown(config.boss)
				local timeLeft = cooldownTimestamp - os.time()

				if timeLeft > 0 then
					local timeString = formatTimeLeft(timeLeft)
					player:sendCancelMessage("You need to wait " .. timeString .. " before facing " .. config.boss .. " again.")
				else
					player:sendCancelMessage("You cannot face this boss yet.")
				end

				player:teleportTo(fromPosition)
				return false
			end

			player:teleportTo(Position(config.tpDestination))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			break
		end
	end
	return true
end

for _, config in ipairs(setting) do
	bossTimer:position(config.tpPos)
end

bossTimer:register()
