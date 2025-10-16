local mType = Game.createMonsterType("The Source of Corruption")
local monster = {}

monster.description = "The Source Of Corruption"
monster.experience = 0
monster.outfit = {
	lookType = 979,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"CultsOfTibiaBossDeath",
}

monster.bosstiary = {
	bossRaceId = 1500,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 500000
monster.maxHealth = 500000
monster.race = "undead"
monster.corpse = 23567
monster.speed = 60
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 20,
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
	canPushCreatures = false,
	staticAttackChance = 95,
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
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 200 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 30 }, -- platinum coin
	{ id = 3030, chance = 80000, maxCount = 20 }, -- small ruby
	{ id = 3029, chance = 80000, maxCount = 20 }, -- small sapphire
	{ id = 3033, chance = 80000, maxCount = 33 }, -- small amethyst
	{ id = 9057, chance = 80000, maxCount = 20 }, -- small topaz
	{ id = 3032, chance = 80000, maxCount = 23 }, -- small emerald
	{ id = 16120, chance = 80000, maxCount = 7 }, -- violet crystal shard
	{ id = 236, chance = 80000, maxCount = 2 }, -- strong health potion
	{ id = 238, chance = 80000, maxCount = 5 }, -- great mana potion
	{ id = 7643, chance = 80000, maxCount = 5 }, -- ultimate health potion
	{ id = 7642, chance = 80000, maxCount = 8 }, -- great spirit potion
	{ id = 239, chance = 80000, maxCount = 3 }, -- great health potion
	{ id = 5888, chance = 80000, maxCount = 5 }, -- piece of hell steel
	{ id = 23507, chance = 80000, maxCount = 10 }, -- crystallized anger
	{ id = 5904, chance = 80000, maxCount = 4 }, -- magic sulphur
	{ id = 22721, chance = 80000, maxCount = 4 }, -- gold token
	{ id = 22516, chance = 80000, maxCount = 3 }, -- silver token
	{ id = 5909, chance = 80000, maxCount = 4 }, -- white piece of cloth
	{ id = 22194, chance = 80000, maxCount = 2 }, -- opal
	{ id = 23517, chance = 80000, maxCount = 11 }, -- solid rage
	{ id = 22193, chance = 80000 }, -- onyx chip
	{ id = 6068, chance = 80000 }, -- demon dust
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 5891, chance = 80000 }, -- enchanted chicken wing
	{ id = 9632, chance = 80000 }, -- ancient stone
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 23533, chance = 80000 }, -- ring of red plasma
	{ id = 3324, chance = 80000 }, -- skull staff
	{ id = 3356, chance = 80000 }, -- devil helmet
	{ id = 7437, chance = 80000 }, -- sapphire hammer
	{ id = 3340, chance = 80000 }, -- heavy mace
	{ id = 8098, chance = 80000 }, -- demonwing axe
	{ id = 9068, chance = 80000 }, -- yalahari figurine
	{ id = 7418, chance = 80000 }, -- nightmare blade
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 8029, chance = 80000 }, -- silkweaver bow
	{ id = 20067, chance = 80000 }, -- crude umbral slayer
	{ id = 20068, chance = 80000 }, -- umbral slayer
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 24392, chance = 80000 }, -- gemmed figurine
	{ id = 22866, chance = 80000 }, -- rift bow
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1500 },
	{ name = "source of corruption wave", interval = 2000, chance = 15, target = false },
}

monster.defenses = {
	defense = 30,
	armor = 30,
	--	mitigation = ???,
}

monster.reflects = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 15 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_LIFEDRAIN, percent = 15 },
	{ type = COMBAT_MANADRAIN, percent = 15 },
	{ type = COMBAT_DROWNDAMAGE, percent = 15 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
