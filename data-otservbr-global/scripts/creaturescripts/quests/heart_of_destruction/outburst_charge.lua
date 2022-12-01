local outburstCharge = CreatureEvent("OutburstCharge")
function outburstCharge.onThink(creature)
	if not creature or not creature:isMonster() then
		return false
	end

	local hp = (creature:getHealth() / creature:getMaxHealth()) * 100
	if hp <= 80 and outburstStage == 0 then
		outburstHealth = creature:getHealth()
		creature:remove()
		Game.createMonster("spark of destruction", {x = 32229, y = 31282, z = 14}, false, true)
		Game.createMonster("spark of destruction", {x = 32230, y = 31287, z = 14}, false, true)
		Game.createMonster("spark of destruction", {x = 32237, y = 31287, z = 14}, false, true)
		Game.createMonster("spark of destruction", {x = 32238, y = 31282, z = 14}, false, true)
		Game.createMonster("charging outburst", {x = 32234, y = 31284, z = 14}, false, true)
		outburstStage = 1
		chargingOutKilled = false
	elseif hp <= 60 and outburstStage == 1 then
		outburstHealth = creature:getHealth()
		creature:remove()
		Game.createMonster("spark of destruction", {x = 32229, y = 31282, z = 14}, false, true)
		Game.createMonster("spark of destruction", {x = 32230, y = 31287, z = 14}, false, true)
		Game.createMonster("spark of destruction", {x = 32237, y = 31287, z = 14}, false, true)
		Game.createMonster("spark of destruction", {x = 32238, y = 31282, z = 14}, false, true)
		Game.createMonster("charging outburst", {x = 32234, y = 31284, z = 14}, false, true)
		outburstStage = 2
		chargingOutKilled = false
	elseif hp <= 40 and outburstStage == 2 then
		outburstHealth = creature:getHealth()
		creature:remove()
		Game.createMonster("spark of destruction", {x = 32229, y = 31282, z = 14}, false, true)
		Game.createMonster("spark of destruction", {x = 32230, y = 31287, z = 14}, false, true)
		Game.createMonster("spark of destruction", {x = 32237, y = 31287, z = 14}, false, true)
		Game.createMonster("spark of destruction", {x = 32238, y = 31282, z = 14}, false, true)
		Game.createMonster("charging outburst", {x = 32234, y = 31284, z = 14}, false, true)
		outburstStage = 3
		chargingOutKilled = false
	elseif hp <= 20 and outburstStage == 3 then
		outburstHealth = creature:getHealth()
		creature:remove()
		Game.createMonster("spark of destruction", {x = 32229, y = 31282, z = 14}, false, true)
		Game.createMonster("spark of destruction", {x = 32230, y = 31287, z = 14}, false, true)
		Game.createMonster("spark of destruction", {x = 32237, y = 31287, z = 14}, false, true)
		Game.createMonster("spark of destruction", {x = 32238, y = 31282, z = 14}, false, true)
		Game.createMonster("charging outburst", {x = 32234, y = 31284, z = 14}, false, true)
		outburstStage = 4
		chargingOutKilled = false
	end
	return true
end

outburstCharge:register()
