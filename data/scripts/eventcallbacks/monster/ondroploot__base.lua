local callback = EventCallback()

function callback.monsterOnDropLoot(monster, corpse)
	local player = Player(corpse:getCorpseOwner())
	local factor = 1.0
	local msgSuffix = ""
	if player and player:getStamina() > 840 then
		local config = player:calculateLootFactor(monster)
		factor = config.factor
		msgSuffix = config.msgSuffix
	end
	local mType = monster:getType()
	if not mType then
		logger.warning("monsterOnDropLoot: monster has no type")
		return
	end

	local charm = player and player:getCharmMonsterType(CHARM_GUT)
	local gut = charm and charm:raceId() == mType:raceId()

	local lootTable = mType:generateLootRoll({ factor = factor, gut = gut }, {})
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
