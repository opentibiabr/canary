local bestiaryOnKill = CreatureEvent("BestiaryOnKill")
function bestiaryOnKill.onKill(player, creature, lastHit)
	if not player:isPlayer() or not creature:isMonster() or creature:hasBeenSummoned() or creature:isPlayer() then
		return true
	end

	local mType = MonsterType(creature:getName())
	if not mType then
		logger.error("[bestiaryOnKill.onKill] monster with name {} have wrong MonsterType", creature:getName())
		return true
	end

	if mType:Bestiaryrace() == 0 then
		return true
	end

	local bestiaryBetterment = Concoction.find(Concoction.Ids.BestiaryBetterment)
	if not bestiaryBetterment then
		logger.warn("[BestiaryOnKill] - Could not find BestiaryBetterment concoction.")
	end
	for cid, damage in pairs(creature:getDamageMap()) do
		local participant = Player(cid)
		if participant and participant:isPlayer() then
			local bestiaryMultiplier = (configManager.getNumber(configKeys.BESTIARY_KILL_MULTIPLIER) or 1)
			if bestiaryBetterment and bestiaryBetterment:active(participant) then
				bestiaryMultiplier = bestiaryMultiplier * bestiaryBetterment.config.multiplier
			end
			participant:addBestiaryKill(creature:getName(), bestiaryMultiplier)
		end
	end

	return true
end

bestiaryOnKill:register()
