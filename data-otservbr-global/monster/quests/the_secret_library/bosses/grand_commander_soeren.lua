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
	{ id = 3035, chance = 80000, maxCount = 5 }, -- platinum coin
	{ id = 238, chance = 80000, maxCount = 3 }, -- great mana potion
	{ id = 239, chance = 80000, maxCount = 3 }, -- great health potion
	{ id = 7368, chance = 80000, maxCount = 9 }, -- assassin star
	{ id = 9057, chance = 80000, maxCount = 2 }, -- small topaz
	{ id = 3032, chance = 80000, maxCount = 2 }, -- small emerald
	{ id = 3030, chance = 80000, maxCount = 2 }, -- small ruby
	{ id = 3033, chance = 80000, maxCount = 2 }, -- small amethyst
	{ id = 3028, chance = 80000, maxCount = 2 }, -- small diamond
	{ id = 7365, chance = 80000, maxCount = 15 }, -- onyx arrow
	{ id = 678, chance = 80000 }, -- small enchanted amethyst
	{ id = 3360, chance = 80000 }, -- golden armor
	{ id = 28822, chance = 80000 }, -- damaged armor plates
	{ id = 28823, chance = 5000 }, -- falcon crest
	{ id = 28821, chance = 5000 }, -- patch of fine cloth
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 36706, chance = 5000 }, -- red gem
	{ id = 3036, chance = 5000 }, -- violet gem
	{ id = 3414, chance = 260 }, -- mastermind shield
	{ id = 28715, chance = 260 }, -- falcon coif
	{ id = 28718, chance = 260 }, -- falcon bow
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
