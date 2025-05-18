local vortexHunger = MoveEvent()

function vortexHunger.onStepIn(creature, item, position, fromPosition)
	local monster = creature:getMonster()
	if not monster then
		return true
	end

	if item.itemid == 23469 then
		if monster:getName():lower() == "the hunger" then
			local tile = Tile({ x = 32244, y = 31371, z = 14 })
			if tile then
				local ground = tile:getGround()
				if ground then
					ground:transform(23470)
					ground:decay()
				end
			end
		elseif monster:getName():lower() == "world devourer" then
			local tile = Tile({ x = 32271, y = 31346, z = 14 })
			if tile then
				local ground = tile:getGround()
				if ground then
					ground:transform(23470)
					ground:decay()
				end
			end
		end
	elseif item.itemid == 23470 then
		if monster:getName():lower() == "greed" then
			monster:remove()
			hungerSummon = hungerSummon - 1
			devourerSummon = devourerSummon - 1
		end
	end
	return true
end

vortexHunger:type("stepin")
vortexHunger:id(23469, 23470)
vortexHunger:register()
