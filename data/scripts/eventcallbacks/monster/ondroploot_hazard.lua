local callback = EventCallback("MonsterOnDropLootHazard")

function callback.monsterOnDropLoot(monster, corpse)
	if not monster:hazard() then
		return
	end
	local player = Player(corpse:getCorpseOwner())
	if not player or not player:canReceiveLoot() then
		return
	end
	local mType = monster:getType()
	if not mType then
		return
	end

	local factor = 1.0
	local msgSuffix = ""
	local chance = (2 * player:getHazardSystemPoints() * configManager.getNumber(configKeys.HAZARD_LOOT_BONUS_MULTIPLIER))
	local rolls = chance / 100
	if math.random(0, 100) < (rolls % 1) * 100 then
		rolls = math.ceil(rolls)
	else
		rolls = math.floor(rolls)
	end

	local existingSuffix = corpse:getAttribute(ITEM_ATTRIBUTE_LOOTMESSAGE_SUFFIX) or ""

	if configManager.getBoolean(configKeys.PARTY_SHARE_LOOT_BOOSTS) and rolls > 1 then
		msgSuffix = string.len(existingSuffix) > 0 and string.format(", hazard system %s extra rolls", rolls) or string.format("hazard system %s extra rolls", rolls)
	elseif rolls == 1 then
		msgSuffix = string.len(existingSuffix) > 0 and ", hazard system" or "hazard system"
	end

	local lootTable = {}
	for _ = 1, rolls do
		lootTable = mType:generateLootRoll({ factor = factor, gut = false }, lootTable, player)
	end
	corpse:addLoot(lootTable)
	corpse:setAttribute(ITEM_ATTRIBUTE_LOOTMESSAGE_SUFFIX, existingSuffix .. msgSuffix)
end

callback:register()
