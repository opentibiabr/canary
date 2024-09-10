local sparkOfDestructionPositions = {
	Position(32203, 31246, 14),
	Position(32205, 31251, 14),
	Position(32210, 31251, 14),
	Position(32212, 31246, 14),
}

local monsterTable = {
	[80] = { fromStage = 0, toStage = 1 },
	[60] = { fromStage = 1, toStage = 2 },
	[40] = { fromStage = 2, toStage = 3 },
	[20] = { fromStage = 3, toStage = 4 },
	[10] = { fromStage = 4, toStage = 5 },
}

local foreshockTransform = CreatureEvent("ForeshockTransform")

function foreshockTransform.onThink(creature)
	if not creature or not creature:isMonster() then
		return true
	end

	local hpPercent = (creature:getHealth() / creature:getMaxHealth()) * 100
	Game.setStorageValue(GlobalStorage.HeartOfDestruction.ForeshockHealth, creature:getHealth())
	local foreshockStage = Game.getStorageValue(GlobalStorage.HeartOfDestruction.ForeshockStage) > 0 and Game.getStorageValue(GlobalStorage.HeartOfDestruction.ForeshockStage) or 0

	for index, value in pairs(monsterTable) do
		if hpPercent <= index and foreshockStage == value.fromStage then
			local monster = Game.createMonster("Aftershock", Position(32208, 31248, 14), false, true)
			if monster then
				creature:remove()
				for i = 1, #sparkOfDestructionPositions do
					Game.createMonster("Spark of Destruction", sparkOfDestructionPositions[i], false, true)
				end
				local aftershockHealth = Game.getStorageValue(GlobalStorage.HeartOfDestruction.AftershockHealth) > 0 and Game.getStorageValue(GlobalStorage.HeartOfDestruction.AftershockHealth) or 0
				monster:addHealth(-monster:getHealth() + aftershockHealth, COMBAT_PHYSICALDAMAGE)
				Game.setStorageValue(GlobalStorage.HeartOfDestruction.ForeshockStage, value.toStage)
				return true
			end
		end
	end
	return true
end

foreshockTransform:register()
