local anomalyTransform = CreatureEvent("AnomalyTransform")
function anomalyTransform.onThink(creature)
	if not creature or not creature:isMonster() then
		return false
	end

	local hp = (creature:getHealth() / creature:getMaxHealth()) * 100
	if hp <= 75 and Game.getStorageValue(14322) == 0 then
		creature:remove()
		Game.createMonster("spark of destruction", {x = 32267, y = 31253, z = 14}, false, true)
		Game.createMonster("spark of destruction", {x = 32274, y = 31255, z = 14}, false, true)
		Game.createMonster("spark of destruction", {x = 32274, y = 31249, z = 14}, false, true)
		Game.createMonster("spark of destruction", {x = 32267, y = 31249, z = 14}, false, true)
		Game.createMonster("charged anomaly", {x = 32271, y = 31249, z = 14}, false, true)
		Game.setStorageValue(14322, 1)
	elseif hp <= 50 and Game.getStorageValue(14322) == 1 then
		creature:remove()
		Game.createMonster("spark of destruction", {x = 32267, y = 31253, z = 14}, false, true)
		Game.createMonster("spark of destruction", {x = 32274, y = 31255, z = 14}, false, true)
		Game.createMonster("spark of destruction", {x = 32274, y = 31249, z = 14}, false, true)
		Game.createMonster("spark of destruction", {x = 32267, y = 31249, z = 14}, false, true)
		Game.createMonster("charged anomaly", {x = 32271, y = 31249, z = 14}, false, true)
		Game.setStorageValue(14322, 2)
	elseif hp <= 25 and Game.getStorageValue(14322) == 2 then
		creature:remove()
		Game.createMonster("spark of destruction", {x = 32267, y = 31253, z = 14}, false, true)
		Game.createMonster("spark of destruction", {x = 32274, y = 31255, z = 14}, false, true)
		Game.createMonster("spark of destruction", {x = 32274, y = 31249, z = 14}, false, true)
		Game.createMonster("spark of destruction", {x = 32267, y = 31249, z = 14}, false, true)
		Game.createMonster("charged anomaly", {x = 32271, y = 31249, z = 14}, false, true)
		Game.setStorageValue(14322, 3)
	elseif hp <= 5 and Game.getStorageValue(14322) == 3 then
		creature:remove()
		Game.createMonster("spark of destruction", {x = 32267, y = 31253, z = 14}, false, true)
		Game.createMonster("spark of destruction", {x = 32274, y = 31255, z = 14}, false, true)
		Game.createMonster("spark of destruction", {x = 32274, y = 31249, z = 14}, false, true)
		Game.createMonster("spark of destruction", {x = 32267, y = 31249, z = 14}, false, true)
		Game.createMonster("charged anomaly", {x = 32271, y = 31249, z = 14}, false, true)
		Game.setStorageValue(14322, 4)
	end
	return true
end

anomalyTransform:register()
