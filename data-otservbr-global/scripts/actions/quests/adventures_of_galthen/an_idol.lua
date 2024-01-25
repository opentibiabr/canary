local idol = {
	{ clickPos = { x = 32398, y = 32509, z = 7 }, destination = Position(32366, 32531, 8) },
}

local anidol = Action()
function anidol.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	for i = 1, #idol do
		if item:getPosition() == Position(idol[i].clickPos) then
			player:teleportTo(idol[i].destination)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end
	end
end

for j = 1, #idol do
	anidol:position(idol[j].clickPos)
end
anidol:register()
