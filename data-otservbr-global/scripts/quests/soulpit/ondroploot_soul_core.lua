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

	local soulCoreId = nil
	local trySameMonsterSoulCore = math.random(100) <= SoulPit.SoulCoresConfiguration.chanceToGetSameMonsterSoulCore
	local mType = monster:getType()
	local lootTable = {}

	if math.random(100) < SoulPit.SoulCoresConfiguration.chanceToDropSoulCore then
		if trySameMonsterSoulCore then
			local itemName = monster:getName():lower() .. " soul core"
			soulCoreId = getItemIdByName(itemName)
		end

		if not soulCoreId and not trySameMonsterSoulCore then
			local race = mType:Bestiaryrace()
			local monstersInCategory = Game.getMonstersByRace(race)

			if monstersInCategory and #monstersInCategory > 0 then
				local randomMonster = monstersInCategory[math.random(#monstersInCategory)]
				local itemName = randomMonster:name():lower() .. " soul core"
				soulCoreId = getItemIdByName(itemName)
				logger.info("soulcoreId: " .. soulCoreId)
			end
		end

		if soulCoreId then
			lootTable[soulCoreId] = {
				count = 1,
			}
		else
			return {}
		end
	end

	if math.random(100) < SoulPit.SoulCoresConfiguration.chanceToDropSoulPrism then
		local soulPrismId = getItemIdByName("soul prism")
		if soulPrismId then
			lootTable[soulPrismId] = {
				count = 1,
			}
		end
	end
	corpse:addLoot(mType:generateLootRoll({}, lootTable, player))
end

callback:register()
