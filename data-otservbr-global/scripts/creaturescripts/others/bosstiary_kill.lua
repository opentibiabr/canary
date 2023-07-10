local bosstiaryOnKill = CreatureEvent("BosstiaryOnKill")
function bosstiaryOnKill.onKill(player, creature, lastHit)
	if not player:isPlayer() or not creature:isMonster() or creature:hasBeenSummoned() or creature:isPlayer() then
		return true
	end

	local bosstiaryMultiplier = (configManager.getNumber(configKeys.BOSSTIARY_KILL_MULTIPLIER) or 1)
	local killBonus = (configManager.getNumber(configKeys.BOOSTED_BOSS_KILL_BONUS) or 3)
	for cid, damage in pairs(creature:getDamageMap()) do
		local participant = Player(cid)
		if participant and participant:isPlayer() then
			if creature:getName():lower() == (Game.getBoostedBoss()):lower() then
				participant:addBosstiaryKill(creature:getName(), bosstiaryMultiplier * killBonus)
			else
				participant:addBosstiaryKill(creature:getName(), bosstiaryMultiplier)
			end
		end
	end

	return true
end
bosstiaryOnKill:register()
