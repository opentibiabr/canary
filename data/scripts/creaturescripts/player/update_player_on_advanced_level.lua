local updatePlayerOnAdvancedLevel = CreatureEvent("UpdatePlayerOnAdvancedLevel")

function updatePlayerOnAdvancedLevel.onAdvance(player, skill, oldLevel, newLevel)
	if skill ~= SKILL_LEVEL or newLevel <= oldLevel then
		return true
	end

	player:addHealth(player:getMaxHealth())
	player:addMana(player:getMaxMana())
	player:getFinalLowLevelBonus()
	player:save()
	return true
end

updatePlayerOnAdvancedLevel:register()
