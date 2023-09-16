local callback = EventCallback()

function callback.monsterOnDropLoot(monster, corpse)
	if configManager.getNumber(configKeys.RATE_LOOT) == 0 then
		return
	end
	local mType = monster:getType()
	if mType:isRewardBoss() then
		return
	end
	if monster:getName():lower() ~= Game.getBoostedCreature():lower() then
		return
	end
	local player = Player(corpse:getCorpseOwner())
	if not player then
		return
	end
	if player:getStamina() <= 840 then
		return
	end

	local factor = 1.0
	local msgSuffix = " (boosted loot)"
	corpse:addLoot(mType:generateLootRoll({ factor = factor, gut = false }, {}))

	local existingSuffix = corpse:getAttribute(ITEM_ATTRIBUTE_LOOTMESSAGE_SUFFIX) or ""
	corpse:setAttribute(ITEM_ATTRIBUTE_LOOTMESSAGE_SUFFIX, existingSuffix .. msgSuffix)
end

callback:register()
