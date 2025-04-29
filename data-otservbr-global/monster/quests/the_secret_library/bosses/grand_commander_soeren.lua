local mType = Game.createMonsterType("Grand Commander Soeren")
local monster = {}

monster.description = "Grand Commander Soeren"
monster.experience = 12000
monster.outfit = {
	lookType = 1071,
	lookHead = 57,
	lookBody = 96,
	lookLegs = 76,
	lookFeet = 105,
	lookAddons = 2,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1582,
	bossRace = RARITY_BANE,
}

monster.health = 17000
monster.maxHealth = 17000
monster.race = "blood"
monster.corpse = 28726
monster.speed = 105
monster.manaCost = 0

monster.events = {
	"killingLibrary",
}

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 70,
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

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Flinch even once, and I will crush every fiber within you!", yell = false },
	{ text = "The Falcon reigns supreme!", yell = false },
}

monster.loot = {
	{ name = "small enchanted amethyst", chance = 15000, maxCount = 3 },
	{ name = "platinum coin", chance = 50000, maxCount = 3 },
	{ name = "great health potion", chance = 50000, maxCount = 3 },
	{ name = "small ruby", chance = 12700, maxCount = 3 },
	{ name = "onyx arrow", chance = 30000, maxCount = 3 },
	{ name = "golden armor", chance = 1000 },
	{ name = "green gem", chance = 1300 },
	{ name = "damaged armor plates", chance = 1800, maxCount = 3 },
	{ name = "falcon crest", chance = 400, maxCount = 3 },
	{ name = "patch of fine cloth", chance = 2500 },
	{ name = "falcon coif", chance = 200 },
	{ name = "falcon bow", chance = 200 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -150, maxDamage = -700 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -720, range = 7, shootEffect = CONST_ANI_ROYALSPEAR, target = false },
	{ name = "combat", interval = 1000, chance = 14, type = COMBAT_HOLYDAMAGE, minDamage = -500, maxDamage = -1000, length = 8, spread = 0, effect = CONST_ME_BLOCKHIT, target = false },
}

monster.defenses = {
	defense = 50,
	armor = 82,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 200, maxDamage = 650, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 50 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 50 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = 50 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = -25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
