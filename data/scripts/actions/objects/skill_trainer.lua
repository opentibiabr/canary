local setting = {
	[16198] = SKILL_SWORD,
	[16199] = SKILL_AXE,
	[16200] = SKILL_CLUB,
	[16201] = SKILL_DISTANCE,
	[16202] = SKILL_MAGLEVEL,
	[50296] = SKILL_FIST,
}

local skillTrainer = Action()

function skillTrainer.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local skill = setting[item:getId()]
	if not player:isPremium() and player:getSkillLevel(skill) > 50 then
		player:sendCancelMessage(RETURNVALUE_YOUNEEDPREMIUMACCOUNT)
		return true
	end

	if player:isPzLocked() then
		return false
	end

	player:setOfflineTrainingSkill(skill)
	player:remove(false)
	return true
end

for index, value in pairs(setting) do
	skillTrainer:id(index)
end

skillTrainer:register()
