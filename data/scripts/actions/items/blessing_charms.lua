dofile(CORE_DIRECTORY .. "/libs/systems/blessing.lua")

local blessingCharms = Action()

function blessingCharms.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	return Blessings.useCharm(player, item)
end

blessingCharms:id(10341, 10342, 10343, 10344, 10345, 25360, 25361)
blessingCharms:register()
