local config = {
	teleportId = 1387,
	days = {
		["Saturday"] = {Position(33649, 31261, 11), Position(33647, 31254, 11)}, -- tanjis
		["Friday"] = {Position(33558, 31282, 11), Position(33545, 31263, 11)}, -- jaul
		["Sunday"] = {Position(33438, 31248, 11), Position(33419, 31255, 11)}, -- obujos
	}
}

local gray = GlobalEvent("gray island bosses")
function gray.onStartup()
	local day = config.days[os.date("%A")]
	if day then
		local item = Game.createItem(config.teleportId, 1, day[1])
		if not item:isTeleport() then
			item:remove()
			return false
		end
		item:setDestination(day[2])
	end
	return true
end

gray:register()
