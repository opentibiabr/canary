local monsterDeath = CreatureEvent("monsterDeath")

function monsterDeath.onDeath(creature, corpse, killer, mostDamage, unjustified, mostDamageUnjustified)
	if creature and creature:isMonster() then
		local self = creature:getStorageValue(MonsterStorage.Spawn.monster_spawn_object)
		self:executeFunctionMonster("onDeath", creature)
		self:deleteMonster(creature)
		return true
	end
	return true
end

monsterDeath:register()

local monsterDeathBoss = CreatureEvent("monsterDeathBoss")

function monsterDeathBoss.onDeath(creature, corpse, killer, mostDamage, unjustified, mostDamageUnjustified)
	if creature and creature:isMonster() then
		local self = creature:getStorageValue(MonsterStorage.Spawn.monster_spawn_object)
		self:removeSpawn()
		self:removeMonsters()
		return true
	end
	return true
end

monsterDeathBoss:register()
