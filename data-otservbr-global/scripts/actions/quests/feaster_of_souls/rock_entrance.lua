local rocks = {
	{ clickPos = { x = 33221, y = 31703, z = 7 }, destination = Position(33876, 31884, 8) }, -- Edron
	{ clickPos = { x = 33876, y = 31883, z = 8 }, destination = Position(33220, 31704, 7) }, -- Barren Drift
}

local feasterrocks = Action()
function feasterrocks.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	for i = 1, #rocks do
		if item:getPosition() == Position(rocks[i].clickPos) then
			player:teleportTo(rocks[i].destination)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end
	end
end

for j = 1, #rocks do
	feasterrocks:position(rocks[j].clickPos)
end
feasterrocks:register()
