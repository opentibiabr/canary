local mType = Game.createMonsterType("Ushuriel")
local monster = {}

monster.description = "Ushuriel"
monster.experience = 10000
monster.outfit = {
	lookType = 12,
	lookHead = 0,
	lookBody = 57,
	lookLegs = 0,
	lookFeet = 80,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"InquisitionBossDeath",
}

monster.health = 31500
monster.maxHealth = 31500
monster.race = "fire"
monster.corpse = 6068
monster.speed = 220
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
}

monster.bosstiary = {
	bossRaceId = 415,
	bossRace = RARITY_BANE,
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 85,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "You can't run or hide forever!", yell = false },
	{ text = "I'm the executioner of the Seven!", yell = false },
	{ text = "The final punishment awaits you!", yell = false },
	{ text = "The judgement is guilty! The sentence is death!", yell = false },
}

monster.loot = {
	{ id = 6499, chance = 100000 }, -- Demonic Essence
	{ id = 3725, chance = 97000, maxCount = 30 }, -- Brown Mushroom
	{ id = 3031, chance = 97000, maxCount = 192 }, -- Gold Coin
	{ id = 5880, chance = 45000 }, -- Iron Ore
	{ id = 5925, chance = 28000, maxCount = 20 }, -- Hardened Bone
	{ id = 7643, chance = 26000 }, -- Ultimate Health Potion
	{ id = 239, chance = 26000 }, -- Great Health Potion
	{ id = 7642, chance = 25000 }, -- Great Spirit Potion
	{ id = 3392, chance = 24000 }, -- Royal Helmet
	{ id = 5668, chance = 21000 }, -- Mysterious Voodoo Skull
	{ id = 238, chance = 21000 }, -- Great Mana Potion
	{ id = 3035, chance = 21000, maxCount = 30 }, -- Platinum Coin
	{ id = 5741, chance = 20000 }, -- Skull Helmet
	{ id = 9058, chance = 20000 }, -- Gold Ingot
	{ id = 3369, chance = 19700 }, -- Warrior Helmet
	{ id = 3061, chance = 19700 }, -- Life Crystal
	{ id = 3062, chance = 19600 }, -- Mind Stone
	{ id = 3280, chance = 19400 }, -- Fire Sword
	{ id = 7391, chance = 19100 }, -- Thaian Sword
	{ id = 3060, chance = 18700 }, -- Orb
	{ id = 8896, chance = 16900 }, -- Slightly Rusted Armor
	{ id = 5892, chance = 14400 }, -- Huge Chunk of Crude Iron
	{ id = 3307, chance = 12100 }, -- Scimitar
	{ id = 3281, chance = 11400 }, -- Giant Sword
	{ id = 5954, chance = 10300, maxCount = 2 }, -- Demon Horn
	{ id = 7402, chance = 10300 }, -- Dragon Slayer
	{ id = 3271, chance = 10000 }, -- Spike Sword
	{ id = 3373, chance = 9900 }, -- Strange Helmet
	{ id = 3385, chance = 9400 }, -- Crown Helmet
	{ id = 7385, chance = 8300 }, -- Crimson Sword
	{ id = 7417, chance = 8300 }, -- Runed Sword
	{ id = 5891, chance = 5500 }, -- Enchanted Chicken Wing
	{ id = 5884, chance = 5000 }, -- Spirit Container
	{ id = 6103, chance = 4400 }, -- Unholy Book
	{ id = 5885, chance = 3800 }, -- Flask of Warrior's Sweat
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1088 },
	{ name = "combat", interval = 1000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = -250, maxDamage = -500, length = 10, spread = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 1000, chance = 8, type = COMBAT_DEATHDAMAGE, minDamage = -30, maxDamage = -760, radius = 5, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 9, type = COMBAT_EARTHDAMAGE, minDamage = -200, maxDamage = -585, length = 8, spread = 3, effect = CONST_ME_SMALLPLANTS, target = false },
	{ name = "combat", interval = 1000, chance = 8, type = COMBAT_ICEDAMAGE, minDamage = 0, maxDamage = -430, radius = 6, effect = CONST_ME_ICETORNADO, target = false },
	{ name = "drunk", interval = 3000, chance = 11, radius = 6, effect = CONST_ME_SOUND_PURPLE, target = false },
	-- energy damage
	{ name = "condition", type = CONDITION_ENERGY, interval = 2000, chance = 15, minDamage = -250, maxDamage = -250, radius = 4, effect = CONST_ME_ENERGYHIT, target = false },
}

monster.defenses = {
	defense = 45,
	armor = 50,
	{ name = "combat", interval = 1000, chance = 12, type = COMBAT_HEALING, minDamage = 400, maxDamage = 600, effect = CONST_ME_MAGIC_GREEN, target = false },
	{ name = "speed", interval = 1000, chance = 4, speedChange = 400, effect = CONST_ME_MAGIC_BLUE, target = false, duration = 7000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 50 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 30 },
	{ type = COMBAT_EARTHDAMAGE, percent = 30 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 30 },
	{ type = COMBAT_HOLYDAMAGE, percent = 25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
