local addLevelUpAnimation = CreatureEvent("addLevelUpAnimation")

function addLevelUpAnimation.onAdvance(player, skill, oldLevel, newLevel)

	if skill ~= SKILL_LEVEL or newLevel <= oldLevel then
		return true
	end

	local position = player:getPosition()
	local positions = {
		[1] = Position(position.x + 2, position.y, position.z),
		[2] = Position(position.x + 2, position.y + 2, position.z),
		[3] = Position(position.x, position.y + 2, position.z),
		[4] = Position(position.x - 2, position.y + 2, position.z),
		[5] = Position(position.x - 2, position.y, position.z),
		[6] = Position(position.x - 2, position.y - 2, position.z),
		[7] = Position(position.x, position.y - 2, position.z),
		[8] = Position(position.x + 2, position.y - 2, position.z)
	}
	
	local efeito = 50
	local shot = 31
	
	if newLevel > oldLevel then
		for _, pos in ipairs(positions) do
			position:sendDistanceEffect(pos, shot)
			pos:sendMagicEffect(efeito)
		end
		player:say("[LEVEL UP]", TALKTYPE_MONSTER_SAY)
		position:sendMagicEffect(40)
		player:save()
	end

	player:getFinalLowLevelBonus()
	
	return true
end

addLevelUpAnimation:register()