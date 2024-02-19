local function handleCobra(monster)
	if monster:getName():lower() == "cobra scout" or monster:getName():lower() == "cobra vizier" or monster:getName():lower() == "cobra assassin" then
		if getGlobalStorageValue(GlobalStorage.CobraBastionFlask) >= os.time() then
			monster:setHealth(monster:getMaxHealth() * 0.75)
		end
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
