local familiarOnAdvance = CreatureEvent("AdvanceFamiliar")

function familiarOnAdvance.onAdvance(player, skill, oldLevel, newLevel)
	local vocation = FAMILIAR_ID[player:getVocation():getBaseId()]
	if vocation and newLevel >= 200 and player:isPremium() then
		if player:getFamiliarLooktype() == 0 then
				player:setFamiliarLooktype(vocation.id)
		end
		if not player:hasFamiliar(vocation.id) then
			player:addFamiliar(vocation.id)
		end
	end
	return true
end

familiarOnAdvance:register()
