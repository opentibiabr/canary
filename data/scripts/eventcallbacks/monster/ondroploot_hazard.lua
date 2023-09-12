local callback = EventCallback()

function callback.monsterOnDropLoot(monster, corpse)
	if configManager.getNumber(configKeys.RATE_LOOT) == 0 then
		return
	end
	local mType = monster:getType()
	if mType:isRewardBoss() then
		return
	end
	if not monster:hazard() then
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
	local msgSuffix = ""
	local chance = (2 * player:getHazardSystemPoints() * configManager.getNumber(configKeys.HAZARD_LOOT_BONUS_MULTIPLIER))
	local rolls = chance / 100
	if math.random(0, 100) < (rolls % 1) * 100 then
		rolls = math.ceil(rolls)
	else
		rolls = math.floor(rolls)
	end

	if configManager.getBoolean(PARTY_SHARE_LOOT_BOOSTS) and rolls > 1 then
		msgSuffix = msgSuffix .. " (hazard system, " .. rolls .. " extra rolls)"
	elseif rolls == 1 then
		msgSuffix = msgSuffix .. " (hazard system)"
	end

	local lootTable = {}
	for _ = 1, rolls do
		lootTable = mType:generateLootRoll({ factor = factor, gut = false }, lootTable)
	end
	corpse:addLoot(lootTable)

	local existingSuffix = corpse:getAttribute(ITEM_ATTRIBUTE_LOOTMESSAGE_SUFFIX) or ""
	corpse:setAttribute(ITEM_ATTRIBUTE_LOOTMESSAGE_SUFFIX, existingSuffix .. msgSuffix)
end

callback:register()
