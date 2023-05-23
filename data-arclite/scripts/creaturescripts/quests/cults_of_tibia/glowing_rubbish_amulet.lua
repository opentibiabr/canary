local glowingRubbishAmulet = CreatureEvent("GlowingRubbishAmulet")
function glowingRubbishAmulet.onKill(creature, killed)
	local player = Player(creature)
	if not player then
		return true
	end

	local monster = Monster(killed)
	if not monster then
		return true
	end

	local amulet = player:getSlotItem(CONST_SLOT_NECKLACE)
	if not amulet or amulet:getId() ~= 25296 then
		return true
	end

	if player:getStorageValue(Storage.CultsOfTibia.Misguided.Mission) ~= 3 then
		return true
	end

	local mStg = math.max(player:getStorageValue(Storage.CultsOfTibia.Misguided.Monsters), 0)
	local eStg = math.max(player:getStorageValue(Storage.CultsOfTibia.Misguided.Exorcisms), 0)
	if monster:getName():lower() == "misguided shadow" then
		if eStg < 5 then
			player:setStorageValue(Storage.CultsOfTibia.Misguided.Exorcisms, eStg+1)
		end
		return true
	end

	if monster:getName():lower() == "misguided bully" or monster:getName():lower() == "misguided thief" then
		player:setStorageValue(Storage.CultsOfTibia.Misguided.Monsters, mStg+1)
		if player:getStorageValue(Storage.CultsOfTibia.Misguided.Monsters) >= 10 then
			amulet:remove()
			local it = player:addItem(25297, 1)
			if it then
				it:decay()
			end
		end
	end
	return true
end

glowingRubbishAmulet:register()
