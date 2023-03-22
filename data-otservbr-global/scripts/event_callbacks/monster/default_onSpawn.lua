local ec = EventCallback

function ec.onSpawn(monster, position)
	if monster:getType():isRewardBoss() then
		monster:setReward(true)
	end

	-- We won't run anything from here on down if we're opening the global pack
	if IsRunningGlobalDatapack() then
		if monster:getName():lower() == "cobra scout" or
			monster:getName():lower() == "cobra vizier" or
			monster:getName():lower() == "cobra assassin" then
			if getGlobalStorageValue(GlobalStorage.CobraBastionFlask) >= os.time() then
				monster:setHealth(monster:getMaxHealth() * 0.75)
			end
		end
	end

	if not monster:getType():canSpawn(position) then
		monster:remove()
	else
		local spec = Game.getSpectators(position, false, false)
		for _, pid in pairs(spec) do
			local monster = Monster(pid)
			if monster and not monster:getType():canSpawn(position) then
				monster:remove()
			end
		end

		if IsRunningGlobalDatapack() then
			if monster:getName():lower() == 'iron servant replica' then
				local chance = math.random(100)
				if Game.getStorageValue(GlobalStorage.ForgottenKnowledge.MechanismDiamond) >= 1
				and Game.getStorageValue(GlobalStorage.ForgottenKnowledge.MechanismGolden) >= 1 then
					if chance > 30 then
						local chance2 = math.random(2)
						if chance2 == 1 then
							Game.createMonster('diamond servant replica', monster:getPosition(), false, true)
						elseif chance2 == 2 then
							Game.createMonster('golden servant replica', monster:getPosition(), false, true)
						end
						monster:remove()
					end
					return true
				end
				if Game.getStorageValue(GlobalStorage.ForgottenKnowledge.MechanismDiamond) >= 1 then
					if chance > 30 then
						Game.createMonster('diamond servant replica', monster:getPosition(), false, true)
						monster:remove()
					end
				end
				if Game.getStorageValue(GlobalStorage.ForgottenKnowledge.MechanismGolden) >= 1 then
					if chance > 30 then
						Game.createMonster('golden servant replica', monster:getPosition(), false, true)
						monster:remove()
					end
				end
				return true
			end
		end
	end
	return true
end

ec:register(--[[0]])
