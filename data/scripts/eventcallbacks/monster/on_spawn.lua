local callback = EventCallback("MonsterOnSpawnBase")

function callback.monsterOnSpawn(monster, position)
	if not monster then
		return
	end

	HazardMonster.onSpawn(monster, position)

	if monster:getType():isRewardBoss() then
		monster:setReward(true)
	end

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
