local mType = Game.createMonsterType("Energized Raging Mage")
local monster = {}

monster.description = "energized raging mage"
monster.experience = 0
monster.outfit = {
	lookType = 423,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"EnergizedRagingMageDeath",
}

monster.health = 3500
monster.maxHealth = 3500
monster.race = "blood"
monster.corpse = 0
monster.speed = 115
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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 300,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 5,
	color = 65,
}

monster.summon = {
	maxSummons = 1,
	summons = {
		{ name = "Golden Servant", chance = 50, interval = 2000, count = 1 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Behold the all permeating powers I draw from this gate!!", yell = false },
	{ text = "ENERGY!!", yell = true },
	{ text = "I FEEL, I FEEEEEL... OMNIPOTENCE!!", yell = true },
	{ text = "MWAAAHAHAAA!! NO ONE!! NO ONE CAN DEFEAT MEEE!!!", yell = true },
}

monster.loot = {}

monster.attacks = {
	{ name = "energized raging mage skill reducer", interval = 3000, chance = 15, target = false },
	{ name = "energyfield", interval = 2000, chance = 20, range = 7, radius = 2, shootEffect = CONST_ANI_ENERGY, target = true },
	{ name = "melee", interval = 2000, chance = 100, skill = 32, attack = 37 },
	{ name = "thunderstorm rune", interval = 2000, chance = 40, minDamage = -150, maxDamage = -230, range = 7, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_MANADRAIN, minDamage = -100, maxDamage = -210, range = 7, target = false },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -200, maxDamage = -300, length = 8, spread = 3, effect = CONST_ME_BIGCLOUDS, target = false },
}

monster.defenses = {
	defense = 35,
	armor = 30,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 155, maxDamage = 200, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -50 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
