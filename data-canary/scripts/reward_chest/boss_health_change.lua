local bossParticipation = CreatureEvent("BossParticipation")

function bossParticipation.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if not next(GlobalBosses) then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	if not creature or not attacker then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	local stats = creature:inBossFight()
	if not stats then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	local creatureId, attackerId = creature:getId(), attacker:getId()
	-- Update player id
	stats.playerId = creatureId

	-- Account for healing of others active in the boss fight
	if primaryType == COMBAT_HEALING and attacker:isPlayer() and attackerId ~= creatureId then
		local healerStats = GetPlayerStats(stats.bossId, attacker:getGuid(), true)
		healerStats.active = true
		-- Update player id
		healerStats.playerId = attackerId
		healerStats.healing = healerStats.healing + primaryDamage
	elseif stats.bossId == attackerId then
		-- Account for damage taken from the boss
		stats.damageIn = stats.damageIn + primaryDamage
	end
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

bossParticipation:register()

local loginBossPlayer = CreatureEvent("LoginBossPlayer")

function loginBossPlayer.onLogin(player)
	player:registerEvent("BossDeath")
	return true
end

loginBossPlayer:register()
