local mType = Game.createMonsterType("Arbaziloth")
local monster = {}

monster.description = "Arbaziloth"
monster.experience = 500000
monster.outfit = {
	lookType = 1802,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 2594,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 360000
monster.maxHealth = 360000
monster.race = "fire"
monster.corpse = 50029
monster.speed = 160
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 40,
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

monster.summon = {
	maxSummons = 2,
	summons = {
		{ name = "Overcharged Demon", chance = 12, interval = 2000, count = 2 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "I am superior!", yell = true },
	{ text = "You are mad to challange a demon prince!", yell = true },
	{ text = "You can't stop me or my plans!", yell = true },
	{ text = "Pesky humans!", yell = true },
	{ text = "This insolence!", yell = true },
	{ text = "Nobody can stop me!", yell = true },
	{ text = "All will have to bow to me!", yell = true },
	{ text = "With this power I can crush everyone!", yell = true },
	{ text = "All that energy is mine!", yell = true },
	{ text = "Face the power of hell!", yell = true },
	{ text = "AHHH! THE POWER!!", yell = true },
}

monster.loot = {
	{ id = 3043, chance = 100000, maxCount = 3 }, -- Crystal Coin
	{ id = 3035, chance = 100000, maxCount = 99 }, -- Platinum Coin
	{ id = 23374, chance = 51000, maxCount = 14 }, -- Ultimate Spirit Potion
	{ id = 7643, chance = 46000, maxCount = 20 }, -- Ultimate Health Potion
	{ id = 3041, chance = 38000, maxCount = 2 }, -- Blue Gem
	{ id = 238, chance = 38000, maxCount = 15 }, -- Great Mana Potion
	{ id = 237, chance = 35000, maxCount = 19 }, -- Strong Mana Potion
	{ id = 3037, chance = 35000, maxCount = 2 }, -- Yellow Gem
	{ id = 23373, chance = 27000, maxCount = 37 }, -- Ultimate Mana Potion
	{ id = 23375, chance = 18900, maxCount = 8 }, -- Supreme Health Potion
	{ id = 3039, chance = 16200, maxCount = 2 }, -- Red Gem
	{ id = 3284, chance = 10800 }, -- Ice Rapier
	{ id = 7642, chance = 10800, maxCount = 14 }, -- Great Spirit Potion
	{ id = 3281, chance = 10800 }, -- Giant Sword
	{ id = 3081, chance = 8100 }, -- Stone Skin Amulet
	{ id = 3373, chance = 8100 }, -- Strange Helmet
	{ id = 3054, chance = 8100 }, -- Silver Amulet
	{ id = 3098, chance = 8100 }, -- Ring of Healing
	{ id = 3320, chance = 8100 }, -- Fire Axe
	{ id = 50067, chance = 8100 }, -- Arbaziloth Shoulder Piece
	{ id = 8082, chance = 5400 }, -- Underworld Rod
	{ id = 30060, chance = 5400 }, -- Giant Emerald
	{ id = 3048, chance = 5400 }, -- Might Ring
	{ id = 6299, chance = 5400 }, -- Death Ring
	{ id = 3356, chance = 5400 }, -- Devil Helmet
	{ id = 3306, chance = 2700 }, -- Golden Sickle
	{ id = 3052, chance = 2700 }, -- Life Ring
	{ id = 817, chance = 2700 }, -- Magma Amulet
	{ id = 30059, chance = 2700 }, -- Giant Ruby
	{ id = 50061, chance = 2700 }, -- Demon Skull
	{ id = 7382, chance = 2700 }, -- Demonrage Sword
	{ id = 32622, chance = 2700 }, -- Giant Amethyst
	{ id = 2848, chance = 2700 }, -- Purple Tome
	{ id = 3071, chance = 2700 }, -- Wand of Inferno
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -1520, maxDamage = -2000 },
}

monster.defenses = {
	defense = 145,
	armor = 80,
	mitigation = 2.45,
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_HEALING, minDamage = 200, maxDamage = 600, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType.onAppear = function(monster, creature)
	if monster:getType():isRewardBoss() then
		monster:setReward(true)
	end
end

mType:register(monster)
