local mType = Game.createMonsterType("Mad Mage")
local monster = {}

monster.description = "mad mage"
monster.experience = 1800
monster.outfit = {
	lookType = 394,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 703,
	bossRace = RARITY_BANE,
}

monster.health = 2500
monster.maxHealth = 2500
monster.race = "blood"
monster.corpse = 12079
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 30,
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
	targetDistance = 4,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 4,
	color = 204,
}

monster.summon = {
	maxSummons = 1,
	summons = {
		{ name = "Golden Servant", chance = 10, interval = 1000, count = 1 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Did it not come to your mind that I placed them here for a reason?", yell = false },
	{ text = "Now I have to create new servants! Do you want to spread this pest beyond these safe walls?", yell = false },
	{ text = "What have you done!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 271 }, -- Gold Coin
	{ id = 3035, chance = 77000, maxCount = 8 }, -- Platinum Coin
	{ id = 236, chance = 52000, maxCount = 9 }, -- Strong Health Potion
	{ id = 237, chance = 47000, maxCount = 9 }, -- Strong Mana Potion
	{ id = 3049, chance = 23000, maxCount = 2 }, -- Stealth Ring
	{ id = 7368, chance = 20000, maxCount = 14 }, -- Assassin Star
	{ id = 3033, chance = 15300, maxCount = 3 }, -- Small Amethyst
	{ id = 5911, chance = 7000 }, -- Red Piece of Cloth
	{ id = 3062, chance = 4500 }, -- Mind Stone
	{ id = 3728, chance = 3200 }, -- Dark Mushroom
	{ id = 2995, chance = 3200 }, -- Piggy Bank
	{ id = 7443, chance = 2500 }, -- Bullseye Potion
	{ id = 825, chance = 1900 }, -- Lightning Robe
	{ id = 11454, chance = 1300 }, -- Luminous Orb
	{ id = 9027, chance = 640 }, -- Crystal of Focus
	{ id = 12599, chance = 640 }, -- Mage's Cap
	{ id = 8073, chance = 340 }, -- Spellbook of Warding
	{ id = 3006, chance = 340 }, -- Ring of the Sky
	{ id = 3079, chance = 670 }, -- Boots of Haste
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -30 },
	{ name = "combat", interval = 1000, chance = 12, type = COMBAT_FIREDAMAGE, minDamage = 0, maxDamage = -200, range = 7, shootEffect = CONST_ANI_FIRE, target = true },
	{ name = "combat", interval = 1400, chance = 24, type = COMBAT_MANADRAIN, minDamage = 0, maxDamage = -120, range = 6, shootEffect = CONST_ANI_ICE, target = false },
	{ name = "firefield", interval = 1600, chance = 20, range = 7, radius = 3, shootEffect = CONST_ANI_FIRE, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -100, maxDamage = -200, radius = 4, effect = CONST_ME_BIGCLOUDS, target = false },
}

monster.defenses = {
	defense = 20,
	armor = 20,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 35, maxDamage = 80, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
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
