local randLoot = {
	{itemId = 3577},
	{itemId = 3582},
	{itemId = 836},
	{itemId = 3587},
	{itemId = 3591},
	{itemId = 3593},
	{itemId = 3586},
	{itemId = 3601},
	{itemId = 30059},
	{itemId = 30060},
	{itemId = 30061}
}

local uglyMonster = CreatureEvent("UglyMonster")
function uglyMonster.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	local chance = math.random(100)
	if chance == 100 and Game.getStorageValue(GlobalStorage.UglyMonster) ~= 1 then
		Game.createMonster("Ugly Monster", creature:getPosition())
		Game.setStorageValue(GlobalStorage.UglyMonster, 1)
	end
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end
uglyMonster:register()

local uglyMonsterDeath = CreatureEvent("UglyMonsterDeath")
function uglyMonsterDeath.onDeath(creature, corpse, killer, mostDamage, unjustified, mostDamage_unjustified)
	Game.setStorageValue(GlobalStorage.UglyMonster, 0)
end
uglyMonsterDeath:register()

local uglyMonsterDrop = CreatureEvent("UglyMonsterDrop")
function uglyMonsterDrop.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	local chance = math.random(100)
	if chance == 100 then
		chance = math.random(100)
		if chance >= 98 then
			chance = math.random(9,11)
			Game.createItem(randLoot[chance].itemId, 1, creature:getPosition())
		else
			chance = math.random(8)
			Game.createItem(randLoot[chance].itemId, 1, creature:getPosition())
		end
	end
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end
uglyMonsterDrop:register()
