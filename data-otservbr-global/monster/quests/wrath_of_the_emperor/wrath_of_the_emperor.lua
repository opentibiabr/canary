local mType = Game.createMonsterType("Wrath of the Emperor")
local monster = {}

monster.description = "Wrath of the Emperor"
monster.experience = 600
monster.outfit = {
	lookType = 351,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"WrathOfTheEmperorBossDeath",
}

monster.health = 55000
monster.maxHealth = 55000
monster.race = "undead"
monster.corpse = 11361
monster.speed = 205
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 366,
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

monster.summon = {
	maxSummons = 2,
	summons = {
		{ name = "Draken Warmaster", chance = 10, interval = 2000, count = 2 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "YOU DON'T EVEN UNDERSTAND WHOM YOU ARE SERVING!", yell = true },
	{ text = "FLEE AND NEVER RETURN!", yell = true },
	{ text = "YOU HAVE BEEN USED AND FOOLED!", yell = true },
	{ text = "I WILL STOP YOU ONCE AND FOR ALL!", yell = true },
}

monster.loot = {

}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 55, attack = 115 },
	{ name = "combat", interval = 3000, chance = 17, type = COMBAT_PHYSICALDAMAGE, minDamage = -150, maxDamage = -250, length = 8, spread = 3, effect = CONST_ME_LOSEENERGY, target = false },
	{ name = "combat", interval = 3000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -500, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = false },
	{ name = "speed", interval = 1000, chance = 10, speedChange = -600, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 20000 },
	{ name = "combat", interval = 2000, chance = 21, type = COMBAT_LIFEDRAIN, minDamage = -200, maxDamage = -450, radius = 6, effect = CONST_ME_POFF, target = false },
}

monster.defenses = {
	defense = 35,
	armor = 45,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 60 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
