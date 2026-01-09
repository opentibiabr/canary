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
	{ id = 3035, chance = 1000, maxCount = 98 }, -- Platinum Coin
	{ id = 3041, chance = 37500, maxCount = 2 }, -- Blue Gem
	{ id = 3037, chance = 41666, maxCount = 2 }, -- Yellow Gem
	{ id = 3039, chance = 12500 }, -- Red Gem
	{ id = 237, chance = 41666, maxCount = 19 }, -- Strong Mana Potion
	{ id = 238, chance = 54166, maxCount = 9 }, -- Great Mana Potion
	{ id = 23373, chance = 25000, maxCount = 29 }, -- Ultimate Mana Potion
	{ id = 7642, chance = 12500, maxCount = 4 }, -- Great Spirit Potion
	{ id = 23374, chance = 33333, maxCount = 14 }, -- Ultimate Spirit Potion
	{ id = 7643, chance = 37500, maxCount = 19 }, -- Ultimate Health Potion
	{ id = 23375, chance = 20833, maxCount = 8 }, -- Supreme Health Potion
	{ id = 3320, chance = 8333 }, -- Fire Axe
	{ id = 3281, chance = 12500 }, -- Giant Sword
	{ id = 3081, chance = 12500 }, -- Stone Skin Amulet
	{ id = 817, chance = 4166 }, -- Magma Amulet
	{ id = 6299, chance = 4166 }, -- Death Ring
	{ id = 3052, chance = 4166 }, -- Life Ring
	{ id = 50061, chance = 4166 }, -- Demon Skull
	{ id = 50060, chance = 1000 }, -- Demon Claws
	{ id = 3373, chance = 12500 }, -- Strange Helmet
	{ id = 3356, chance = 8333 }, -- Devil Helmet
	{ id = 3284, chance = 12500 }, -- Ice Rapier
	{ id = 50189, chance = 1000 }, -- Demon Mengu
	{ id = 49534, chance = 1000 }, -- Demonfang Mask
	{ id = 49533, chance = 1000 }, -- Dreadfire Headpiece
	{ id = 49532, chance = 1000 }, -- Hellstalker Visor
	{ id = 49531, chance = 1000 }, -- Maliceforged Helmet
	{ id = 7382, chance = 4166 }, -- Demonrage Sword
	{ id = 3098, chance = 8333 }, -- Ring of Healing
	{ id = 30059, chance = 4166 }, -- Giant Ruby
	{ id = 30060, chance = 4166 }, -- Giant Emerald
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
