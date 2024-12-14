local randLoot = {
	{ itemId = 3577 },
	{ itemId = 3582 },
	{ itemId = 836 },
	{ itemId = 3587 },
	{ itemId = 3591 },
	{ itemId = 3593 },
	{ itemId = 3586 },
	{ itemId = 3601 },
	{ itemId = 30059 },
	{ itemId = 30060 },
	{ itemId = 30061 },
}

local uglyMonster = nil
local removeEvent = nil
local creatureToSpawn = {}

local uglyMonsterSpawn = CreatureEvent("UglyMonsterSpawn")
function uglyMonsterSpawn.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if not creature then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end
	if creatureToSpawn[creature:getId()] then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end
	local chance = math.random(1, 1000000)
	if chance < (primaryDamage + secondaryDamage) and Game.getStorageValue(GlobalStorage.UglyMonster) ~= 1 then
		uglyMonster = Game.createMonster("Ugly Monster", creature:getPosition())
		creatureToSpawn[creature:getId()] = true
		removeEvent = addEvent(function()
			if uglyMonster then
				uglyMonster:remove()
				Game.setStorageValue(GlobalStorage.UglyMonster, 0)
			end
		end, 60 * 1000)
		Game.setStorageValue(GlobalStorage.UglyMonster, 1)
	end
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

uglyMonsterSpawn:register()

local uglyMonsterCleanup = CreatureEvent("UglyMonsterCleanup")
function uglyMonsterCleanup.onDeath(creature, corpse, killer, mostDamage, unjustified, mostDamage_unjustified)
	if not creature then
		return true
	end
	if not creatureToSpawn[creature:getId()] then
		return true
	end
	table.remove(creatureToSpawn, creature:getId())
	return true
end

uglyMonsterCleanup:register()

local uglyMonsterDeath = CreatureEvent("UglyMonsterDeath")
function uglyMonsterDeath.onDeath(creature, corpse, killer, mostDamage, unjustified, mostDamage_unjustified)
	if removeEvent then
		stopEvent(removeEvent)
	end
	Game.setStorageValue(GlobalStorage.UglyMonster, 0)
end

uglyMonsterDeath:register()

local uglyMonsterDrop = CreatureEvent("UglyMonsterDrop")
function uglyMonsterDrop.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	local chance = math.random(100)
	if chance == 100 then
		chance = math.random(100)
		if chance >= 98 then
			chance = math.random(9, 11)
			Game.createItem(randLoot[chance].itemId, 1, creature:getPosition())
		else
			chance = math.random(8)
			Game.createItem(randLoot[chance].itemId, 1, creature:getPosition())
		end
	end
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

uglyMonsterDrop:register()
