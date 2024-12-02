local callback = EventCallback("MonsterOnDropLootSoulCore")
local soulCores = Game.getSoulCoreItems()

function callback.monsterOnDropLoot(monster, corpse)
	if not monster or not corpse then
		return
	end
	local player = Player(corpse:getCorpseOwner())
	if not player or not player:canReceiveLoot() then
		return
	end
	if monster:getMonsterForgeClassification() == FORGE_NORMAL_MONSTER then
		return
	end

	local soulCoreId = nil
	local trySameMonsterSoulCore = math.random() <= 0.3 -- 30% of chance to drop the same monster soul core | WIP: Externalize this to a lib like libs/soulpit.lua
	local mType = monster:getType()
	local lootTable = {}

	if math.random() < 0.5 then -- WIP: Externalize this to a lib like libs/soulpit.lua
		if trySameMonsterSoulCore then
			local itemName = monster:getName():lower() .. " soul core"
			soulCoreId = getItemIdByName(itemName)
		end

		if not soulCoreId and not trySameMonsterSoulCore then
			local race = mType:Bestiaryrace()
			local monstersInCategory = mType:getMonstersByRace(race)

			if monstersInCategory and #monstersInCategory > 0 then
				local randomMonster = monstersInCategory[math.random(#monstersInCategory)]
				local itemName = randomMonster:name():lower() .. " soul core"
				soulCoreId = getItemIdByName(itemName)
				logger.info("soulcoreId: " .. soulCoreId)
			end
		end

		if soulCoreId then
			lootTable = {
				[soulCoreId] = {
					count = 1,
				}
			}
		else
			return {}
		end
	end
	corpse:addLoot(mType:generateLootRoll({}, lootTable, player))
end

callback:register()
