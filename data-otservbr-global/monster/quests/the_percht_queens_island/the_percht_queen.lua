local mType = Game.createMonsterType("The Percht Queen")
local monster = {}

monster.description = "The Percht Queen"
monster.experience = 500
monster.outfit = {
	lookTypeEx = 30340, -- (frozen) // lookTypeEx = 30341 (thawed)
}

monster.bosstiary = {
	bossRaceId = 1744,
	bossRace = RARITY_NEMESIS,
}

monster.health = 2300
monster.maxHealth = 2300
monster.race = "undead"
monster.corpse = 30272
monster.speed = 0
monster.manaCost = 0

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
	canPushItems = false,
	canPushCreatures = true,
	staticAttackChance = 90,
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
}

monster.loot = {
	{ id = 7414, chance = 1104 }, -- Abyss Hammer
	{ id = 9058, chance = 19658 }, -- Gold Ingot
	{ id = 25759, chance = 33760, maxCount = 100 }, -- Royal Star
	{ id = 282, chance = 1000 }, -- Giant Shimmering Pearl (Brown)
	{ id = 281, chance = 1000 }, -- Giant Shimmering Pearl (Green)
	{ id = 23509, chance = 99145 }, -- Mysterious Remains
	{ id = 7427, chance = 8119 }, -- Chaos Mace
	{ id = 3324, chance = 19658 }, -- Skull Staff
	{ id = 23526, chance = 9401 }, -- Collar of Blue Plasma
	{ id = 23543, chance = 11965 }, -- Collar of Green Plasma
	{ id = 23374, chance = 48717, maxCount = 20 }, -- Ultimate Spirit Potion
	{ id = 23373, chance = 58974, maxCount = 20 }, -- Ultimate Mana Potion
	{ id = 23375, chance = 52564, maxCount = 20 }, -- Supreme Health Potion
	{ id = 3035, chance = 99572, maxCount = 5 }, -- Platinum Coin
	{ id = 2995, chance = 99572 }, -- Piggy Bank
	{ id = 23535, chance = 97863 }, -- Energy Bar
	{ id = 3038, chance = 39316 }, -- Green Gem
	{ id = 3039, chance = 33760 }, -- Red Gem
	{ id = 3037, chance = 27777 }, -- Yellow Gem
	{ id = 3043, chance = 20512, maxCount = 2 }, -- Crystal Coin
	{ id = 5892, chance = 31623 }, -- Huge Chunk of Crude Iron
	{ id = 7443, chance = 14957, maxCount = 10 }, -- Bullseye Potion
	{ id = 7439, chance = 20085, maxCount = 10 }, -- Berserk Potion
	{ id = 7440, chance = 20940, maxCount = 10 }, -- Mastermind Potion
	{ id = 5809, chance = 3867 }, -- Soul Stone
	{ id = 5904, chance = 9829 }, -- Magic Sulphur
	{ id = 3006, chance = 4273 }, -- Ring of the Sky
	{ id = 23529, chance = 7692 }, -- Ring of Blue Plasma
	{ id = 23531, chance = 4273 }, -- Ring of Green Plasma
	{ id = 30195, chance = 3773 }, -- Golden Bell
	{ id = 23544, chance = 8974 }, -- Collar of Red Plasma
	{ id = 3036, chance = 8974 }, -- Violet Gem
	{ id = 23533, chance = 7264 }, -- Ring of Red Plasma
	{ id = 3041, chance = 14102 }, -- Blue Gem
	{ id = 30320, chance = 1666 }, -- Lucky Pig
	{ id = 30283, chance = 2762 }, -- Ice Hatchet
	{ id = 30281, chance = 1709 }, -- Frozen Chain
	{ id = 30277, chance = 7692 }, -- Icicle (Percht)
	{ id = 30322, chance = 1709 }, -- Small Ladybug
	{ id = 30318, chance = 1666 }, -- Horseshoe
	{ id = 30319, chance = 1000 }, -- Golden Horseshoe
	{ id = 30285, chance = 833 }, -- Golden Cotton Reel
	{ id = 30279, chance = 3867 }, -- Frozen Claw
	{ id = 30282, chance = 2631 }, -- Percht Broom
	{ id = 30284, chance = 1000 }, -- Percht Handkerchief
	{ id = 30280, chance = 2991 }, -- Percht Queen's Frozen Heart
	{ id = 30276, chance = 1000 }, -- The Crown of the Percht Queen (Ice)
	{ id = 30275, chance = 1000 }, -- The Crown of the Percht Queen (Fire)
	{ id = 30321, chance = 4624 }, -- Fly Agaric (Item)
	{ id = 30278, chance = 10256 }, -- Flames of the Percht Queen
	{ id = 30192, chance = 26923 }, -- Percht Skull
	{ id = 3341, chance = 2209 }, -- Arcane Staff
	{ id = 2958, chance = 1000 }, -- War Horn
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -200 },
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -100, maxDamage = -200, range = 7, shootEffect = CONST_ANI_ICE, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 79,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 90 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 80 },
	{ type = COMBAT_EARTHDAMAGE, percent = 80 },
	{ type = COMBAT_FIREDAMAGE, percent = 70 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 80 },
	{ type = COMBAT_DEATHDAMAGE, percent = 90 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
