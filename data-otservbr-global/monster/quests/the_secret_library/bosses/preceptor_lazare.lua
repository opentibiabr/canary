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
	{ id = 3031, chance = 80000, maxCount = 182 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 15 }, -- platinum coin
	{ id = 7368, chance = 80000, maxCount = 8 }, -- assassin star
	{ id = 239, chance = 80000, maxCount = 3 }, -- great health potion
	{ id = 238, chance = 80000, maxCount = 3 }, -- great mana potion
	{ id = 3582, chance = 80000 }, -- ham
	{ id = 6499, chance = 80000 }, -- demonic essence
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 3028, chance = 80000, maxCount = 2 }, -- small diamond
	{ id = 3032, chance = 80000, maxCount = 2 }, -- small emerald
	{ id = 9057, chance = 80000, maxCount = 2 }, -- small topaz
	{ id = 9058, chance = 80000, maxCount = 2 }, -- gold ingot
	{ id = 7452, chance = 80000 }, -- spiked squelcher
	{ id = 3360, chance = 80000 }, -- golden armor
	{ id = 3370, chance = 80000 }, -- knight armor
	{ id = 7413, chance = 80000 }, -- titan axe
	{ id = 28821, chance = 80000 }, -- patch of fine cloth
	{ id = 3414, chance = 80000 }, -- mastermind shield
	{ id = 28720, chance = 260 }, -- falcon greaves
	{ id = 28716, chance = 260 }, -- falcon rod
	{ id = 3030, chance = 80000 }, -- small ruby
	{ id = 3342, chance = 80000 }, -- war axe
	{ id = 5944, chance = 80000 }, -- soul orb
	{ id = 6558, chance = 80000 }, -- flask of demonic blood
	{ id = 3033, chance = 80000 }, -- small amethyst
	{ id = 678, chance = 80000 }, -- small enchanted amethyst
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 7365, chance = 80000 }, -- onyx arrow
	{ id = 31925, chance = 80000 }, -- closed trap
	{ id = 3019, chance = 80000 }, -- demonbone amulet
	{ id = 3340, chance = 1000 }, -- heavy mace
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
