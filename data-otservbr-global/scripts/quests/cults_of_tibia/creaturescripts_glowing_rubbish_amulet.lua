local glowingRubbishAmulet = CreatureEvent("GlowingRubbishAmuletDeath")

function glowingRubbishAmulet.onDeath(creature, _corpse, _lastHitKiller, mostDamageKiller)
	onDeathForParty(creature, mostDamageKiller, function(creature, player)
		local amulet = player:getSlotItem(CONST_SLOT_NECKLACE)

		if player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.Misguided.Mission) ~= 3 then
			return true
		end

		local mStg = math.max(player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.Misguided.Monsters), 0)
		local eStg = math.max(player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.Misguided.Exorcisms), 0)

		if creature:getName():lower():trim() == "misguided shadow" then
			if eStg < 5 then
				player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.Misguided.Exorcisms, eStg + 1)
			end
			return true
		end

		if not amulet or amulet:getId() ~= 25296 then
			return true
		end

		if creature:getName():lower():trim() == "misguided bully" or creature:getName():lower():trim() == "misguided thief" then
			player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.Misguided.Monsters, mStg + 1)

			if player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.Misguided.Monsters) >= 10 then
				amulet:remove()
				local it = player:addItem(25297, 1)
				if it then
					it:decay()
				end
			end
		end
	end)
	return true
end

glowingRubbishAmulet:register()
