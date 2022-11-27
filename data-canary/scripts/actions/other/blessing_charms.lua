dofile(CORE_DIRECTORY .. "/modules/scripts/blessings/blessings.lua")

local blessingCharms = Action()

function blessingCharms.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	return Blessings.useCharm(player, item)
end

for blessingId = 10341, 10345 do
	blessingCharms:id(blessingId)
end

blessingCharms:register()
