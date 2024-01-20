local function createSpawnWave(stage)
	Game.createMonster("Spark of Destruction", Position(32331, 31254, 14), false, true)
	Game.createMonster("Spark of Destruction", Position(32338, 31254, 14), false, true)
	Game.createMonster("Spark of Destruction", Position(32330, 31250, 14), false, true)
	Game.createMonster("Spark of Destruction", Position(32338, 31250, 14), false, true)
	Game.createMonster("Damage Resonance", Position(32332, 31250, 14), false, true)
	Game.setStorageValue(GlobalStorage.HeartOfDestruction.RuptureResonanceStage, stage)
	Game.setStorageValue(GlobalStorage.HeartOfDestruction.RuptureResonanceActive, 1)
end

local ruptureResonance = CreatureEvent("RuptureResonance")

function ruptureResonance.onThink(creature)
	if not creature or not creature:isMonster() then
		return false
	end

	local ruptureResonanceStage = Game.getStorageValue(GlobalStorage.HeartOfDestruction.RuptureResonanceStage)
	local resonanceActive = Game.setStorageValue(GlobalStorage.HeartOfDestruction.RuptureResonanceActive)

	local hpPercent = (creature:getHealth() / creature:getMaxHealth()) * 100
	if hpPercent <= 80 and ruptureResonanceStage == 0 and resonanceActive ~= 1 then
		createSpawnWave(1)
	elseif hpPercent <= 60 and ruptureResonanceStage == 1 and resonanceActive ~= 1 then
		createSpawnWave(2)
		Game.setStorageValue(GlobalStorage.HeartOfDestruction.RuptureResonanceStage, 0)
	elseif hpPercent <= 40 and ruptureResonanceStage == 2 and resonanceActive ~= 1 then
		createSpawnWave(3)
	elseif hpPercent <= 25 and ruptureResonanceStage == 3 and resonanceActive ~= 1 then
		createSpawnWave(4)
	elseif hpPercent <= 10 and ruptureResonanceStage == 4 and resonanceActive ~= 1 then
		createSpawnWave(-1)
	end

	return true
end

ruptureResonance:register()
