local bestiaryOnKill = CreatureEvent("BestiaryOnKill")
function bestiaryOnKill.onKill(player, creature, lastHit)
	if not player:isPlayer() or not creature:isMonster() or creature:hasBeenSummoned() or creature:isPlayer() then
		return true
	end

	local bestiaryMultiplier = (configManager.getNumber(configKeys.BESTIARY_KILL_MULTIPLIER) or 1)
	local bestiaryBetterment = Concoction.find(Concoction.Ids.BestiaryBetterment)
	if not bestiaryBetterment then
		Spdlog.warn("[BestiaryOnKill] - Could not find BestiaryBetterment concoction.")
	end
	for cid, damage in pairs(creature:getDamageMap()) do
		local participant = Player(cid)
		if participant and participant:isPlayer() then
			if bestiaryBetterment and bestiaryBetterment:active(participant) then
				bestiaryMultiplier = bestiaryMultiplier * bestiaryBetterment.config.multiplier
			end
			participant:addBestiaryKill(creature:getName(), bestiaryMultiplier)
		end
	end

	return true
end
bestiaryOnKill:register()
