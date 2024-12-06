local mType = Game.createMonsterType("Preceptor Lazare")
local monster = {}

monster.description = "Preceptor Lazare"
monster.experience = 10000
monster.outfit = {
	lookType = 1078,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1583,
	bossRace = RARITY_BANE,
}

monster.health = 16000
monster.maxHealth = 16000
monster.race = "blood"
monster.corpse = 28643
monster.speed = 105
monster.manaCost = 0

monster.events = {
	"killingLibrary",
}

monster.changeTarget = {
	interval = 2000,
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
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

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "There is nothing here for you and you will die alone.", yell = false },
	{ text = "You will obey and you will kneel and you will BOW TO US.", yell = false },
}

monster.loot = {
	{ name = "gold coin", chance = 100000, maxCount = 90 },
	{ name = "gold coin", chance = 100000, maxCount = 45 },
	{ name = "platinum coin", chance = 100000, maxCount = 3 },
	{ name = "great mana potion", chance = 100000, maxCount = 3 },
	{ name = "demonic essence", chance = 100000, maxCount = 5 },
	{ id = 3039, chance = 700, maxCount = 3 }, -- red gem
	{ name = "assassin star", chance = 100000, maxCount = 5 },
	{ name = "flask of demonic blood", chance = 100000, maxCount = 3 },
	{ name = "ham", chance = 100000, maxCount = 2 },
	{ name = "small emerald", chance = 100000, maxCount = 5 },
	{ name = "small diamond", chance = 100000, maxCount = 4 },
	{ name = "small amethyst", chance = 100000, maxCount = 3 },
	{ name = "knight armor", chance = 3100 },
	{ name = "golden armor", chance = 2200 },
	{ name = "patch of fine cloth", chance = 1800, maxCount = 3 },
	{ name = "violet gem", chance = 1800 },
	{ name = "titan axe", chance = 1600 },
	{ name = "war axe", chance = 1400 },
	{ name = "demonbone amulet", chance = 800 },
	{ name = "heavy mace", chance = 600 },
	{ name = "mastermind shield", chance = 500 },
	{ name = "falcon rod", chance = 200 },
	{ name = "falcon greaves", chance = 110 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -700 },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -300, maxDamage = -1100, range = 7, shootEffect = CONST_ANI_POWERBOLT, target = true },
	{ name = "combat", interval = 2400, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -400, maxDamage = -500, range = 7, shootEffect = CONST_ANI_ENERGYBALL, target = true },
	{ name = "combat", interval = 2700, chance = 20, type = COMBAT_HOLYDAMAGE, minDamage = -500, maxDamage = -600, range = 7, radius = 4, effect = CONST_ME_HOLYDAMAGE, target = false },
}

monster.defenses = {
	defense = 60,
	armor = 86,
	--	mitigation = ???,
	{ name = "combat", interval = 1500, chance = 20, type = COMBAT_HEALING, minDamage = 200, maxDamage = 800, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 50 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = 50 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
