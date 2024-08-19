local healthForgotten = CreatureEvent("HealthForgotten")
function healthForgotten.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	local name = creature:getName():lower()
	if name == "lady tenebris" then
		local spectators = Game.getSpectators(creature:getPosition(), false, false, 7, 7, 7, 7)
		for i = 1, #spectators do
			local spectator = spectators[i]
			if spectator:getName():lower() == "shadow tentacle" then
				return primaryDamage, primaryType, secondaryDamage, secondaryType
			end
		end
	elseif name == "mounted thorn knight" or name == "the shielded thorn knight" or name == "the enraged thorn knight" then
		local spectators = Game.getSpectators(creature:getPosition(), false, false, 7, 7, 7, 7)
		for i = 1, #spectators do
			local spectator = spectators[i]
			if spectator:getName():lower() == "possessed tree" then
				return primaryDamage, primaryType, secondaryDamage, secondaryType
			end
		end
	end
	primaryDamage = primaryDamage + 100 / 100. * primaryDamage
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

healthForgotten:register()
