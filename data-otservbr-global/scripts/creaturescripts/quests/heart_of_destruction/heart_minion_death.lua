local heartMinionDeath = CreatureEvent("HeartMinionDeath")
function heartMinionDeath.onDeath(creature)
	if not creature or not creature:isMonster() then -- éMonstro!
		return true
	end
	local monster = creature:getName():lower()
	if monster == "frenzy" then
		rageSummon = rageSummon - 1
		devourerSummon = devourerSummon - 1
	elseif monster == "damage resonance" then
		resonanceActive = false
	elseif monster == "disruption" or monster == "charged disruption" or monster == "overcharged disruption" then
		destructionSummon = destructionSummon - 1
		devourerSummon = devourerSummon - 1
	elseif monster == "the hunger" then
		devourerBossesKilled = devourerBossesKilled + 1
		theHungerKilled = true
	elseif monster == "the destruction" then
		devourerBossesKilled = devourerBossesKilled + 1
		theDestructionKilled = true
	elseif monster == "the rage" then
		devourerBossesKilled = devourerBossesKilled + 1
		theRageKilled = true
	end
	return true
end

heartMinionDeath:register()
