local mType = Game.createMonsterType("Powerful Soul")
local monster = {}

monster.description = "a powerful soul"
monster.experience = 0
monster.outfit = {
	lookType = 568,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 30000
monster.maxHealth = 30000
monster.race = "undead"
monster.corpse = 0
monster.speed = 80
monster.manaCost = 0

monster.events = {
	"GreedMonsterDeath",
}

monster.changeTarget = {
	interval = 1000,
	chance = 0,
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -2000, maxDamage = -3000 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -2000, maxDamage = -3000, range = 1, effect = CONST_ME_MAGIC_RED, target = false },
}

monster.defenses = {
	defense = 80,
	armor = 90,
	mitigation = 2,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 100 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

local transformTimeCount = 0
mType.onThink = function(monster, interval)
	transformTimeCount = transformTimeCount + interval
	if transformTimeCount == 8000 then
		CreateGoshnarsGreedMonster("Weak Soul", GreedMonsters[monster:getName()])
		monster:remove()
		local boss = Creature("Goshnar's Greed")
		if boss then
			for elementType, reflectPercent in pairs(SoulWarReflectDamageMap) do
				boss:addReflectElement(elementType, reflectPercent)
			end
			boss:addDefense(10)
			boss:setMaxHealth(boss:getMaxHealth() + 10000)
			boss:addHealth(10000)
		end
		transformTimeCount = 0
	end
end

mType.onSpawn = function(monster)
	transformTimeCount = 0
end

mType:register(monster)
