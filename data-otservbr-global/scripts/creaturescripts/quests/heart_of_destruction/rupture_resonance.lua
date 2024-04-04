local function createSpawnWave(stage)
	Game.createMonster("Spark of Destruction", Position(32331, 31254, 14), false, true)
	Game.createMonster("Spark of Destruction", Position(32338, 31254, 14), false, true)
	Game.createMonster("Spark of Destruction", Position(32330, 31250, 14), false, true)
	Game.createMonster("Spark of Destruction", Position(32338, 31250, 14), false, true)
	Game.createMonster("Damage Resonance", Position(32332, 31250, 14), false, true)
	Game.setStorageValue(GlobalStorage.HeartOfDestruction.RuptureResonanceStage, stage + 1)
	Game.setStorageValue(GlobalStorage.HeartOfDestruction.RuptureResonanceActive, 1)
end

local ruptureResonance = CreatureEvent("RuptureResonance")

function ruptureResonance.onThink(creature)
	if not creature or not creature:isMonster() then
		return false
	end

	local ruptureResonanceStage = Game.getStorageValue(GlobalStorage.HeartOfDestruction.RuptureResonanceStage) > 0 and Game.getStorageValue(GlobalStorage.HeartOfDestruction.RuptureResonanceStage) or 0
	local resonanceActive = Game.getStorageValue(GlobalStorage.HeartOfDestruction.RuptureResonanceActive)

	local thresholds = {
		{ limit = 80, stage = 0 },
		{ limit = 60, stage = 1 },
		{ limit = 40, stage = 2 },
		{ limit = 25, stage = 3 },
		{ limit = 10, stage = 4 },
	}

	local hpPercent = (creature:getHealth() / creature:getMaxHealth()) * 100
	for _, threshold in ipairs(thresholds) do
		if hpPercent <= threshold.limit and ruptureResonanceStage == threshold.stage and resonanceActive ~= 1 then
			createSpawnWave(threshold.stage)
			break
		end
	end

	return true
end

ruptureResonance:register()
