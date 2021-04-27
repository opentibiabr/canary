dofile('data/modules/scripts/blessings/blessings.lua')

local blessingCharms = Action()

function blessingCharms.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	return Blessings.useCharm(player, item)
end

blessingCharms:id(11258, 11259, 11260, 11261, 11262, 28036, 28037)
blessingCharms:register()
