local helheim = MoveEvent()

function helheim.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.TheIceIslands.Questline) ~= 30 then
		return true
	end

	-- Questlog The Ice Islands Quest, The Secret of Helheim
	player:setStorageValue(Storage.TheIceIslands.Mission07, 3)
	player:setStorageValue(Storage.TheIceIslands.Questline, 31)
	player:say("You discovered the necromantic altar and should report about it.", TALKTYPE_MONSTER_SAY)
	position:sendMagicEffect(CONST_ME_MAGIC_RED)

	for x = -1, 1 do
		for y = -1, 1 do
			if y ~= 0 or x ~= 0 then
				Position(position.x + x, position.y + y, position.z):sendMagicEffect(CONST_ME_MORTAREA)
			end
		end
	end

	Position(position.x, position.y - 1, position.z):sendMagicEffect(CONST_ME_YALAHARIGHOST)
	return true
end

helheim:type("stepin")
helheim:uid(1061)
helheim:register()
