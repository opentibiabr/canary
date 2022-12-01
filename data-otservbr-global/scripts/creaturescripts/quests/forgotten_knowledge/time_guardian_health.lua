local timeGuardianHealth = CreatureEvent("TimeGuardianHealth")
function timeGuardianHealth.onPrepareDeath(creature, lastHitKiller, mostDamageKiller)
	if not creature:getName():lower() == "the freezing time guardian" or creature:getName():lower() == "the blazing time guardian" and creature:isMonster() then
		return true
	end
	creature:addHealth(1, false)
	return true
end
timeGuardianHealth:register()
