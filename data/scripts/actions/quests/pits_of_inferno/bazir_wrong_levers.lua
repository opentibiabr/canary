local pitsOfInfernoWrongLevers = Action()
function pitsOfInfernoWrongLevers.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 1945 then
		player:teleportTo(Position(32806, 32328, 15))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		item:transform(1946)
 	end
 	return true
end

for value = 50095, 50104 do
	pitsOfInfernoWrongLevers:uid(value)
end
pitsOfInfernoWrongLevers:register()