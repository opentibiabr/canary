local callback = EventCallback()

function callback.monsterOnDropLoot(monster, corpse)
	if configManager.getNumber(configKeys.RATE_LOOT) == 0 then return end
	local mType = monster:getType()
	if mType:isRewardBoss() then corpse:registerReward() return end

	local player = Player(corpse:getCorpseOwner())
	local factor = 1.0
	local msgSuffix = ""
	if player and player:getStamina() > 840 then
		local config = player:calculateLootFactor(monster)
		factor = config.factor
		msgSuffix = config.msgSuffix
	end

	local charm = player and player:getCharmMonsterType(CHARM_GUT)
	local gut = charm and charm:raceId() == mType:raceId()

	local lootTable = mType:generateLootRoll({ factor = factor, gut = gut, }, {})
	corpse:addLoot(lootTable)
	for _, item in ipairs(lootTable) do
		if item.gut then
			msgSuffix = msgSuffix .. " (active charm bonus)"
		end
	end
	local existingSuffix = corpse:getAttribute(ITEM_ATTRIBUTE_LOOTMESSAGE_SUFFIX) or ""
	corpse:setAttribute(ITEM_ATTRIBUTE_LOOTMESSAGE_SUFFIX, existingSuffix .. msgSuffix)
end

callback:register()
