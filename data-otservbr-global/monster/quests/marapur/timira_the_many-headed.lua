local mType = Game.createMonsterType("Timira the Many-Headed")
local monster = {}

monster.name = "Timira The Many-Headed"
monster.description = "Timira the Many-Headed"
monster.experience = 45500
monster.outfit = {
	lookType = 1542,
	lookAddons = 3,
}

monster.bosstiary = {
	bossRaceId = 2250,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 75000
monster.maxHealth = 75000
monster.race = "blood"
monster.corpse = 39712
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 25,
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

	healthHidden = false,

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
	{ text = "Harmony is just a vain illusion! ", yell = false },
	{ text = " I'm ashamed of my former self! ", yell = false },
	{ text = " You won't lead me astray!", yell = false },
}

monster.loot = {
	{ id = 39755, chance = 1872 }, -- Naga Basin
	{ id = 3043, chance = 100000, maxCount = 6 }, -- Crystal Coin
	{ id = 32622, chance = 6179 }, -- Giant Amethyst
	{ id = 30061, chance = 3183 }, -- Giant Sapphire
	{ id = 23373, chance = 32022, maxCount = 14 }, -- Ultimate Mana Potion
	{ id = 7440, chance = 17415, maxCount = 5 }, -- Mastermind Potion
	{ id = 7443, chance = 19475 }, -- Bullseye Potion
	{ id = 30060, chance = 4119 }, -- Giant Emerald
	{ id = 7643, chance = 33707, maxCount = 14 }, -- Ultimate Health Potion
	{ id = 7439, chance = 22471 }, -- Berserk Potion
	{ id = 30059, chance = 4868 }, -- Giant Ruby
	{ id = 39400, chance = 6741 }, -- Piece of Timira's Sensors
	{ id = 39399, chance = 3558 }, -- One of Timira's Many Heads
	{ id = 39158, chance = 1000 }, -- Frostflower Boots
	{ id = 39233, chance = 1000 }, -- Enchanted Turtle Amulet
	{ id = 39164, chance = 1000 }, -- Dawnfire Sherwani
	{ id = 39159, chance = 1000 }, -- Naga Crossbow
	{ id = 39161, chance = 1000 }, -- Feverbloom Boots
	{ id = 39157, chance = 1000 }, -- Naga Club
	{ id = 39165, chance = 1000 }, -- Midnight Tunic
	{ id = 32623, chance = 3745 }, -- Giant Topaz
	{ id = 39166, chance = 1000 }, -- Dawnfire Pantaloons
	{ id = 39167, chance = 1000 }, -- Midnight Sarong
	{ id = 39160, chance = 1000 }, -- Naga Quiver
	{ id = 39163, chance = 1000 }, -- Naga Rod
	{ id = 39155, chance = 1000 }, -- Naga Sword
	{ id = 39162, chance = 1000 }, -- Naga Wand
	{ id = 39156, chance = 1000 }, -- Naga Axe
	{ id = 50160, chance = 1000 }, -- Naga Katar
	{ id = 50262, chance = 1000 }, -- Naga Tanko
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -600 },
	{ name = "timira fire ring", interval = 3500, chance = 50, minDamage = -360, maxDamage = -425 },
	{ name = "death chain", interval = 2500, chance = 30, minDamage = -190, maxDamage = -225, range = 3, target = true },
	{ name = "mana drain chain", interval = 2500, chance = 20, minDamage = -100, maxDamage = -130 },
	{ name = "timira explosion", interval = 4200, chance = 40, minDamage = -350, maxDamage = -560 },
	{ name = "combat", interval = 5500, chance = 45, type = COMBAT_PHYSICALDAMAGE, minDamage = -580, maxDamage = -620, length = 6, spread = 2, effect = CONST_ME_EXPLOSIONAREA, target = false },
	{ name = "combat", interval = 5000, chance = 60, type = COMBAT_ENERGYDAMAGE, minDamage = -230, maxDamage = -450, range = 1, radius = 1, shootEffect = CONST_ANI_ENERGYBALL, effect = CONST_ME_ENERGYHIT, target = true },
}

monster.defenses = {
	defense = 60,
	armor = 82,
	mitigation = 2.07,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
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
