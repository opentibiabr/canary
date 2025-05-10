local callback = EventCallback("MonsterOnDropLootBaseEvent")

function callback.monsterOnDropLoot(monster, corpse)
	local player = Player(corpse:getCorpseOwner())
	local factor = 1.0
	local msgSuffix = ""
	if player and player:canReceiveLoot() then
		local config = player:calculateLootFactor(monster)
		factor = config.factor
		msgSuffix = config.msgSuffix
	end
	local mType = monster:getType()
	if not mType then
		logger.warn("monsterOnDropLoot: monster '{}' has no type", monster:getName())
		return
	end

	local mTypeCharm = player and player:getCharmMonsterType(CHARM_GUT)
	local gut = mTypeCharm and mTypeCharm:raceId() == mType:raceId()

	local lootTable = mType:generateLootRoll({ factor = factor, gut = gut }, {}, player)
	corpse:addLoot(lootTable)
	local charmMessage = false
	local existingSuffix = corpse:getAttribute(ITEM_ATTRIBUTE_LOOTMESSAGE_SUFFIX) or ""
	for _, item in pairs(lootTable) do
		if item.gut and not charmMessage then
			charmMessage = true
			msgSuffix = msgSuffix .. (string.len(msgSuffix) > 0 and ", gut charm" or "gut charm")
		end
	end
	corpse:setAttribute(ITEM_ATTRIBUTE_LOOTMESSAGE_SUFFIX, existingSuffix .. msgSuffix)
end

callback:register()
