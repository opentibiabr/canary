local bossName = "Faceless Bane"

local facelessBaneOnDeath = CreatureEvent("facelessBaneOnDeath")
function facelessBaneOnDeath.onDeath(creature)

	if creature:getName() == bossName then
		onDeathForDamagingPlayers(creature, function(creature, player)
				-- reset global storage state to default / ensure sqm's reset for the next team
				Game.setStorageValue(GlobalStorage.FacelessBaneDeaths, -1)
				Game.setStorageValue(GlobalStorage.FacelessBaneStepsOn, -1)
				Game.setStorageValue(GlobalStorage.FacelessBaneResetSteps, 1)
		end)
	end
	return true
end

facelessBaneOnDeath:register()
