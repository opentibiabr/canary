local bossThink = CreatureEvent("BossThink")

function bossThink.onThink(creature, interval)
	if not creature then
		return true
	end

	ResetAndSetTargetList(creature)
end

bossThink:register()
