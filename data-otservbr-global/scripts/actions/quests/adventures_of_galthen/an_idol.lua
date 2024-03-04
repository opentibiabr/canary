local idol = {
	{ clickPos = Position(32398, 32509, 7), destination = Position(32366, 32531, 8) },
}

local anIdolStatue = Action()
function anIdolStatue.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	for i = 1, #idol do
		if item:getPosition() == Position(idol[i].clickPos) then
			player:teleportTo(idol[i].destination)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			break
		end
	end
	return true
end

for j = 1, #idol do
	anIdolStatue:position(idol[j].clickPos)
end
anIdolStatue:register()
