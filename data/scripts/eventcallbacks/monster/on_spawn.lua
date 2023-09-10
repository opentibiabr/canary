local function handleCobra(monster)
	if monster:getName():lower() == "cobra scout" or monster:getName():lower() == "cobra vizier" or monster:getName():lower() == "cobra assassin" then
		if getGlobalStorageValue(GlobalStorage.CobraBastionFlask) >= os.time() then
			monster:setHealth(monster:getMaxHealth() * 0.75)
		end
	end
end

local function handleIronServantReplica(monster)
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
end

local callback = EventCallback()

function callback.monsterOnSpawn(monster, position)
	if not monster then
		return
	end
	HazardMonster.onSpawn(monster, position)

	if monster:getType():isRewardBoss() then
		monster:setReward(true)
	end

	handleCobra(monster)
	handleIronServantReplica(monster)

	if not monster:getType():canSpawn(position) then
		monster:remove()
	else
		local spec = Game.getSpectators(position, false, false)
		for _, creatureId in pairs(spec) do
			local monster = Monster(creatureId)
			if monster and not monster:getType():canSpawn(position) then
				monster:remove()
			end
		end
	end
end

callback:register()
