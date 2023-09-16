local mType = Game.createMonsterType("Ugly Monster")
local monster = {}

monster.description = "an ugly monster"
monster.experience = 1000
monster.outfit = {
	lookType = 1218,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 10000
monster.maxHealth = 10000
monster.race = "blood"
monster.corpse = 31551
monster.speed = 340
monster.manaCost = 0

monster.events = {
	"UglyMonsterDeath",
	"UglyMonsterDrop",
}

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 4,
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

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ name = "cobra crossbow", chance = 300 },
	{ name = "cobra hood", chance = 300 },
	{ name = "cobra axe", chance = 300 },
	{ name = "cobra boots", chance = 300 },
	{ name = "cobra sword", chance = 300 },
	{ name = "cobra wand", chance = 300 },
	{ name = "cobra rod", chance = 300 },
	{ name = "cobra club", chance = 300 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -120 },
	{ name = "outfit", interval = 2000, chance = 10, range = 5, shootEffect = CONST_ANI_EARTH, target = false, duration = 10000, outfitMonster = "Ugly Monster" },
	{ name = "drunk", interval = 2000, chance = 10, range = 5, shootEffect = CONST_ANI_EARTH, target = false, duration = 5000 },
}

monster.defenses = {
	defense = 48,
	armor = 0,
	--	mitigation = ???,
	{ name = "invisible", interval = 2000, chance = 8, effect = CONST_ME_HITAREA },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
