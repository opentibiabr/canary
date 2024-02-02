local function createSpawnChargingOutburst(stage)
	Game.createMonster("Spark of Destruction", Position(32229, 31282, 14), false, true)
	Game.createMonster("Spark of Destruction", Position(32230, 31287, 14), false, true)
	Game.createMonster("Spark of Destruction", Position(32237, 31287, 14), false, true)
	Game.createMonster("Spark of Destruction", Position(32238, 31282, 14), false, true)
	Game.createMonster("Charging Outburst", Position(32234, 31284, 14), false, true)

	Game.setStorageValue(GlobalStorage.HeartOfDestruction.OutburstStage, stage)
	Game.setStorageValue(GlobalStorage.HeartOfDestruction.OutburstChargingKilled, -1)
end

local outburstCharge = CreatureEvent("OutburstCharge")

function outburstCharge.onThink(creature)
	if not creature or not creature:isMonster() then
		return false
	end

	local outburstStage = Game.getStorageValue(GlobalStorage.HeartOfDestruction.OutburstStage) > 0 and Game.getStorageValue(GlobalStorage.HeartOfDestruction.OutburstStage) or 0
	Game.setStorageValue(GlobalStorage.HeartOfDestruction.OutburstHealth, creature:getHealth())

	local hpPercent = (creature:getHealth() / creature:getMaxHealth()) * 100
	if hpPercent <= 80 and outburstStage == 0 then
		creature:remove()
		createSpawnChargingOutburst(1)
	elseif hpPercent <= 60 and outburstStage == 1 then
		creature:remove()
		createSpawnChargingOutburst(2)
	elseif hpPercent <= 40 and outburstStage == 2 then
		creature:remove()
		createSpawnChargingOutburst(3)
	elseif hpPercent <= 20 and outburstStage == 3 then
		creature:remove()
		createSpawnChargingOutburst(4)
	end
	return true
end

outburstCharge:register()
