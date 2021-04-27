dofile('data/modules/scripts/blessings/blessings.lua')

local checkBless = Action()

function checkBless.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	return Blessings.checkBless(player)
end

checkBless:id(6561, 12424)
checkBless:register()
