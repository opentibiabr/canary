-- Drops custom loot for all monsters
local allLootConfig = {
	--{ id = 6526, chance = 100000 }, -- Example of loot (100% chance)
}

-- Custom loot for specific monsters (this has the same usage options as normal monster loot)
local customLootConfig = {
	["Dragon"] = { items = {
		{ name = "platinum coin", chance = 1000, maxCount = 1 },
	} },
}

-- Global loot addition for all monsters
local callback = EventCallback("MonsterOnDropLootCustom")

function callback.monsterOnDropLoot(monster, corpse)
	if not monster or not corpse then
		return
	end
	local player = Player(corpse:getCorpseOwner())
	if not player or not player:canReceiveLoot() then
		return
	end
	corpse:addLoot(monster:generateCustomLoot())
end

-- Register the callback only if there is loot to be dropped
if #allLootConfig > 0 then
	callback:register()
end

function Monster:generateCustomLoot()
	local mType = self:getType()
	if not mType then
		return {}
	end

	local loot = {}

	for _, lootInfo in ipairs(allLootConfig) do
		local roll = math.random(1, 10000)
		if roll <= lootInfo.chance then
			if loot[lootInfo.id] then
				loot[lootInfo.id].count = loot[lootInfo.id].count + 1
			else
				loot[lootInfo.id] = { count = 1 }
			end
		end
	end

	return loot
end

local customMonsterLoot = GlobalEvent("CreateCustomMonsterLoot")

function customMonsterLoot.onStartup()
	for monsterName, _ in pairs(customLootConfig) do
		local mtype = Game.getMonsterTypeByName(monsterName)
		if mtype then
			local lootTable = customLootConfig[mtype:getName()]
			if not lootTable then
				logger.error("[customMonsterLoot.onStartup] - No custom loot found for monster: {}", self:getName())
				return
			end

			if #lootTable.items > 0 then
				mtype:createLoot(lootTable.items)
				logger.debug("[customMonsterLoot.onStartup] - Custom loot registered for monster: {}", mtype:getName())
			end
		end
	end
end

customMonsterLoot:register()
