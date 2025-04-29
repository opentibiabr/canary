dofile(CORE_DIRECTORY .. "/libs/systems/blessing.lua")

local checkBless = Action()

function checkBless.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	return Blessings.checkBless(player)
end

checkBless:id(6561, 11468)
checkBless:register()
