local mType = Game.createMonsterType("Mozradek")
local monster = {}

monster.description = "Mozradek"
monster.experience = 21000
monster.outfit = {
	lookType = 240,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"MozradekDeath",
}

monster.bosstiary = {
	bossRaceId = 1829,
	bossRace = RARITY_BANE,
}

monster.health = 28000
monster.maxHealth = 28000
monster.race = "fire"
monster.corpse = 12838
monster.speed = 105
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 10,
	random = 10,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 100,
	targetDistance = 1,
	runHealth = 10,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 3,
	color = 206,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 3039, chance = 60000 }, -- red gem
	{ id = 31369, chance = 9000 }, -- gryphon mask
	{ name = "sea horse figurine", chance = 6000 },
	{ id = 31557, chance = 3500 }, -- blister ring
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -600 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -400, maxDamage = -550, radius = 4, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 2000, chance = 16, type = COMBAT_DEATHDAMAGE, minDamage = -450, maxDamage = -666, range = 7, radius = 3, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true },
	{ name = "combat", interval = 2000, chance = 14, type = COMBAT_FIREDAMAGE, minDamage = -450, maxDamage = 600, range = 7, radius = 1, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_EXPLOSIONHIT, target = true },
}

monster.defenses = {
	defense = 84,
	armor = 84,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -30 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 25 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
