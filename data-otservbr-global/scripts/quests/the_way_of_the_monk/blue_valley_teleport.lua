local TELEPORT_EFFECT_ID = 12

local config = {
	{ pos = Position(32456, 32290, 7), from = "peninsula" },
	{ pos = Position(32203, 32303, 6), from = "adventurer" },
	{ pos = Position(33615, 31491, 7) },
	{ pos = Position(33601, 31468, 7) },
	{ pos = Position(33605, 31468, 7) },
}

local backConfig = {
	["peninsula"] = { teleportTo = Position(32456, 32292, 7), effectPos = Position(32456, 32290, 7) },
	["adventurer"] = { teleportTo = Position(32203, 32304, 6), effectPos = Position(32203, 32303, 6) },
}

local teleportConfig = {
	teleportTo = Position(33614, 31494, 7),
	effectPos = Position(33615, 31491, 7),
}

local function performTeleport(player, teleportDestination, effectPos)
	player:teleportTo(teleportDestination, true)
	effectPos:sendMagicEffect(TELEPORT_EFFECT_ID)
	teleportDestination:sendMagicEffect(TELEPORT_EFFECT_ID)
end

local BlueValleyTeleport = Action()
function BlueValleyTeleport.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	for _, teleport in ipairs(config) do
		if fromPosition == teleport.pos then
			if teleport.from then
				player:kv():set("blue-valley-destination", teleport.from)
				performTeleport(player, teleportConfig.teleportTo, teleportConfig.effectPos)
			else
				local destinationString = player:kv():get("blue-valley-destination") or "peninsula"
				local destinationInfo = backConfig[destinationString]
				performTeleport(player, destinationInfo.teleportTo, destinationInfo.effectPos)
			end
		end
	end

	return true
end

for _, teleport in ipairs(config) do
	BlueValleyTeleport:position(teleport.pos)
end
BlueValleyTeleport:register()
