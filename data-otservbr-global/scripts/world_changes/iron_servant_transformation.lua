local ironServantTransformation = EventCallback("IronServantTransformationOnSpawn")

ironServantTransformation.monsterOnSpawn = function(monster, position)
	if monster:getName():lower() ~= "iron servant replica" then
		return
	end

	local chance = math.random(100)
	if Game.getStorageValue(GlobalStorage.ForgottenKnowledge.MechanismDiamond) >= 1 and Game.getStorageValue(GlobalStorage.ForgottenKnowledge.MechanismGolden) >= 1 then
		if chance > 30 then
			local monsterType = math.random(2) == 1 and "diamond servant replica" or "golden servant replica"
			Game.createMonster(monsterType, monster:getPosition(), false, true)
			monster:remove()
		end
		return
	end

	if Game.getStorageValue(GlobalStorage.ForgottenKnowledge.MechanismDiamond) >= 1 and chance > 30 then
		Game.createMonster("diamond servant replica", monster:getPosition(), false, true)
		monster:remove()
		return
	end

	if Game.getStorageValue(GlobalStorage.ForgottenKnowledge.MechanismGolden) >= 1 and chance > 30 then
		Game.createMonster("golden servant replica", monster:getPosition(), false, true)
		monster:remove()
	end
	return true
end

ironServantTransformation:register()
