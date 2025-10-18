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
	{ id = 3031, chance = 98729, maxCount = 182 }, -- Gold Coin
	{ id = 3035, chance = 98729, maxCount = 15 }, -- Platinum Coin
	{ id = 7368, chance = 26056, maxCount = 8 }, -- Assassin Star
	{ id = 239, chance = 33755, maxCount = 3 }, -- Great Health Potion
	{ id = 238, chance = 32562, maxCount = 3 }, -- Great Mana Potion
	{ id = 3582, chance = 69262 }, -- Ham
	{ id = 6499, chance = 44481 }, -- Demonic Essence
	{ id = 3036, chance = 1432 }, -- Violet Gem
	{ id = 3038, chance = 2940 }, -- Green Gem
	{ id = 3028, chance = 19383, maxCount = 2 }, -- Small Diamond
	{ id = 3032, chance = 20250, maxCount = 2 }, -- Small Emerald
	{ id = 9057, chance = 19696, maxCount = 2 }, -- Small Topaz
	{ id = 9058, chance = 8654, maxCount = 2 }, -- Gold Ingot
	{ id = 7452, chance = 5003 }, -- Spiked Squelcher
	{ id = 3360, chance = 715 }, -- Golden Armor
	{ id = 3370, chance = 5641 }, -- Knight Armor
	{ id = 7413, chance = 8261 }, -- Titan Axe
	{ id = 28821, chance = 1293 }, -- Patch of Fine Cloth
	{ id = 3414, chance = 630 }, -- Mastermind Shield
	{ id = 28720, chance = 1000 }, -- Falcon Greaves
	{ id = 28716, chance = 184 }, -- Falcon Rod
	{ id = 3030, chance = 18905 }, -- Small Ruby
	{ id = 3342, chance = 2778 }, -- War Axe
	{ id = 5944, chance = 32643 }, -- Soul Orb
	{ id = 6558, chance = 28512 }, -- Flask of Demonic Blood
	{ id = 281, chance = 7467 }, -- Giant Shimmering Pearl
	{ id = 3033, chance = 20494 }, -- Small Amethyst
	{ id = 678, chance = 77681 }, -- Small Enchanted Amethyst
	{ id = 3039, chance = 14614 }, -- Red Gem
	{ id = 7365, chance = 14300 }, -- Onyx Arrow
	{ id = 3481, chance = 420 }, -- Closed Trap
	{ id = 3019, chance = 530 }, -- Demonbone Amulet
	{ id = 3340, chance = 420 }, -- Heavy Mace
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
