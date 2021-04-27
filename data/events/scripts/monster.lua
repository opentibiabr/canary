function Monster:onDropLoot(corpse)
	if configManager.getNumber(configKeys.RATE_LOOT) == 0 then
		return
	end

	local mType = self:getType()
	if mType:isRewardBoss() then
		corpse:registerReward()
		return
	end

	local player = Player(corpse:getCorpseOwner())
	local mType = self:getType()
	if not player or player:getStamina() > 840 then
		local monsterLoot = mType:getLoot()
		for i = 1, #monsterLoot do
			local boolCharm = false
			if player then
				local charmType = player:getCharmMonsterType(CHARM_GUT)
				if charmType and charmType:raceId() == mType:raceId() then
					boolCharm = true
				end
			end
		
			local item = corpse:createLootItem(monsterLoot[i], boolCharm)
			if self:getName():lower() == (Game.getBoostedCreature()):lower() then
				local itemBoosted = corpse:createLootItem(monsterLoot[i], boolCharm)
			end
			if not item then
				Spdlog.warn("[Monster:onDropLoot] - Could not add loot item to corpse.")
			end
		end

		if player then
			local text = {}
			if self:getName():lower() == (Game.getBoostedCreature()):lower() then
				 text = ("Loot of %s: %s (boosted loot)"):format(mType:getNameDescription(), corpse:getContentDescription())
			else
				 text = ("Loot of %s: %s"):format(mType:getNameDescription(), corpse:getContentDescription())			
			end
			local party = player:getParty()
			if party then
				party:broadcastPartyLoot(text)
			else
				player:sendTextMessage(MESSAGE_LOOT, text)
			end
			player:updateKillTracker(self, corpse)
		end
	else
		local text = ("Loot of %s: nothing (due to low stamina)"):format(mType:getNameDescription())
		local party = player:getParty()
		if party then
			party:broadcastPartyLoot(text)
		else
			player:sendTextMessage(MESSAGE_LOOT, text)
		end
	end
end

function Monster:onSpawn(position)
	if self:getType():isRewardBoss() then
		self:setReward(true)
	end

	if self:getName():lower() == "cobra scout" or 
		self:getName():lower() == "cobra vizier" or 
		self:getName():lower() == "cobra assassin" then
		if getGlobalStorageValue(GlobalStorage.CobraBastionFlask) >= os.time() then
			self:setHealth(self:getMaxHealth() * 0.75)
		end
	end

	if not self:getType():canSpawn(position) then
		self:remove()
	else
		local spec = Game.getSpectators(position, false, false)
		for _, pid in pairs(spec) do
			local monster = Monster(pid)
			if monster and not monster:getType():canSpawn(position) then
				monster:remove()
			end
		end

		if self:getName():lower() == 'iron servant replica' then
			local chance = math.random(100)
			if Game.getStorageValue(GlobalStorage.ForgottenKnowledge.MechanismDiamond) >= 1
			and Game.getStorageValue(GlobalStorage.ForgottenKnowledge.MechanismGolden) >= 1 then
				if chance > 30 then
					local chance2 = math.random(2)
					if chance2 == 1 then
						Game.createMonster('diamond servant replica', self:getPosition(), false, true)
					elseif chance2 == 2 then
						Game.createMonster('golden servant replica', self:getPosition(), false, true)
					end
					self:remove()
				end
				return true
			end
			if Game.getStorageValue(GlobalStorage.ForgottenKnowledge.MechanismDiamond) >= 1 then
				if chance > 30 then
					Game.createMonster('diamond servant replica', self:getPosition(), false, true)
					self:remove()
				end
			end
			if Game.getStorageValue(GlobalStorage.ForgottenKnowledge.MechanismGolden) >= 1 then
				if chance > 30 then
					Game.createMonster('golden servant replica', self:getPosition(), false, true)
					self:remove()
				end
			end
			return true
		end
	end
end
