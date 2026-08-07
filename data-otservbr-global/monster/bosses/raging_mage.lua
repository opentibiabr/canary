local mType = Game.createMonsterType("Raging mage")
local monster = {}

monster.description = "a raging mage"
monster.experience = 3250
monster.outfit = {
	lookType = 416,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"RagingMageDeath",
}

monster.health = 3500
monster.maxHealth = 3500
monster.race = "blood"
monster.corpse = 12678
monster.speed = 100
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 718,
	bossRace = RARITY_ARCHFOE,
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
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 300,
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
	{ text = "ENERGY!!", yell = false },
	{ text = "I WILL RETURN!! My death will just be a door to await my homecoming, my physical hull will be... my... argh...", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 259 }, -- Gold Coin
	{ id = 3035, chance = 80000, maxCount = 15 }, -- Platinum Coin
	{ id = 2995, chance = 60000 }, -- Piggy Bank
	{ id = 239, chance = 30000, maxCount = 4 }, -- Great Health Potion
	{ id = 7368, chance = 30000, maxCount = 11 }, -- Assassin Star
	{ id = 3029, chance = 30000, maxCount = 9 }, -- Small Sapphire
	{ id = 3062, chance = 20000 }, -- Mind Stone
	{ id = 3007, chance = 20000 }, -- Crystal Ring
	{ id = 3728, chance = 10000, maxCount = 2 }, -- Dark Mushroom
	{ id = 8074, chance = 10000 }, -- Spellbook of Mind Control
	{ id = 5911, chance = 10000 }, -- Red Piece of Cloth
	{ id = 8043, chance = 10000 }, -- Focus Cape
	{ id = 3081, chance = 10000 }, -- Stone Skin Amulet
	{ id = 238, chance = 23080, maxCount = 5 }, -- Great Mana Potion
	{ id = 7443, chance = 6510 }, -- Bullseye Potion
	{ id = 11454, chance = 4140 }, -- Luminous Orb
	{ id = 3049, chance = 4730 }, -- Stealth Ring
	{ id = 3006, chance = 1780 }, -- Ring of the Sky
	{ id = 9045, chance = 1180 }, -- Royal Tapestry
	{ id = 9067, chance = 590 }, -- Crystal of Power
	{ id = 5741, chance = 590 }, -- Skull Helmet
	{ id = 3079, chance = 590 }, -- Boots of Haste
	{ id = 12803, chance = 1180 }, -- Elemental Spikes
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -50 },
	{ name = "thunderstorm rune", interval = 2000, chance = 35, minDamage = -100, maxDamage = -200, range = 7, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_MANADRAIN, minDamage = -100, maxDamage = -200, range = 7, target = false },
	{ name = "energyfield", interval = 2000, chance = 15, range = 7, radius = 2, shootEffect = CONST_ANI_ENERGY, target = true },
}

monster.defenses = {
	defense = 25,
	armor = 25,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -25 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
