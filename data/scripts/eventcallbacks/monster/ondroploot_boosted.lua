local callback = EventCallback("MonsterOnDropLootBoosted")

function callback.monsterOnDropLoot(monster, corpse)
	if not monster or not corpse then
		return
	end
	if monster:getName():lower() ~= Game.getBoostedCreature():lower() then
		return
	end
	local mType = monster:getType()
	if mType:isRewardBoss() then
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
	local existingSuffix = corpse:getAttribute(ITEM_ATTRIBUTE_LOOTMESSAGE_SUFFIX) or ""
	local msgSuffix = string.len(existingSuffix) > 0 and ", boosted loot" or "boosted loot"

	corpse:addLoot(mType:generateLootRoll({ factor = factor, gut = false }, {}, player))
	corpse:setAttribute(ITEM_ATTRIBUTE_LOOTMESSAGE_SUFFIX, existingSuffix .. msgSuffix)
end

callback:register()
