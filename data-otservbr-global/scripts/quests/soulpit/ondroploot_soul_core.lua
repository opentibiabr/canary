local callback = EventCallback("MonsterOnDropLootSoulCore")

function callback.monsterOnDropLoot(monster, corpse)
	if not monster or not corpse then
		return
	end

	local player = Player(corpse:getCorpseOwner())
	if not player or not player:canReceiveLoot() then
		return
	end

	if monster:getMonsterForgeClassification() ~= FORGE_FIENDISH_MONSTER then
		return
	end

	local trySameMonsterSoulCore = math.random(100) <= SoulPit.SoulCoresConfiguration.chanceToGetSameMonsterSoulCore
	local mType = monster:getType()
	local lootTable = {}

	if math.random(100) < SoulPit.SoulCoresConfiguration.chanceToDropSoulCore then
		local soulCoreId
		if trySameMonsterSoulCore then
			soulCoreId = getItemIdByName(string.format("%s soul core", monster:getName():lower()))
		end

		if not soulCoreId and not trySameMonsterSoulCore then
			local race = mType:Bestiaryrace()
			local monstersInCategory = Game.getMonstersByRace(race)

			if monstersInCategory and #monstersInCategory > 0 then
				local randomMonster = monstersInCategory[math.random(#monstersInCategory)]
				soulCoreId = getItemIdByName(string.format("%s soul core", randomMonster:name():lower()))
			end
		end

		if soulCoreId then
			lootTable[soulCoreId] = { count = 1 }
			logger.debug("[monsterOnDropLoot.MonsterOnDropLootSoulCore] {} dropped {} for {}.", monster:getName(), ItemType(soulCoreId):getName(), player:getName())
		else
			return {}
		end
	end

	if math.random(100) < SoulPit.SoulCoresConfiguration.chanceToDropSoulPrism then
		local soulPrismId = getItemIdByName("soul prism")
		if soulPrismId then
			lootTable[soulPrismId] = { count = 1 }
			logger.debug("[monsterOnDropLoot.MonsterOnDropLootSoulCore] {} dropped {} for {}.", monster:getName(), ItemType(soulPrismId):getName(), player:getName())
		end
	end

	corpse:addLoot(mType:generateLootRoll({}, lootTable, player))
end

callback:register()
