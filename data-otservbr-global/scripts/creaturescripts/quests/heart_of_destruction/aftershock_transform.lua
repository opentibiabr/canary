local aftershockTransform = CreatureEvent("AftershockTransform")
function aftershockTransform.onThink(creature)
	if not creature:isMonster() then
		return true
	end

	local sparkOfDestructionPositions = {
		{x = 32203, y = 31246, z = 14},
		{x = 32205, y = 31251, z = 14},
		{x = 32210, y = 31251, z = 14},
		{x = 32212, y = 31246, z = 14}
	}
	
	local monsterTable = {
		[80] = {fromStage = 0, toStage = 1},
		[60] = {fromStage = 1, toStage = 2},
		[40] = {fromStage = 2, toStage = 3},
		[25] = {fromStage = 3, toStage = 4},
		[10] = {fromStage = 4, toStage = 5}
	}
	
	for index, value in pairs(monsterTable) do
		local hp = (creature:getHealth() / creature:getMaxHealth()) * 100
		if realityQuakeStage == 0 then
			local aftershockHealth = creature:getHealth()
			if hp <= index and aftershockStage == value.fromStage then
				creature:remove()
				for i = 1, #sparkOfDestructionPositions do
					Game.createMonster("spark of destruction", #sparkOfDestructionPositions[i], false, true)
				end
				local monster = Game.createMonster("foreshock", {x = 32208, y = 31248, z = 14}, false, true)
				monster:addHealth(-monster:getHealth() + aftershockHealth, COMBAT_PHYSICALDAMAGE)
				aftershockStage = value.toStage
			end
		end
	end
	return true
end

aftershockTransform:register()
