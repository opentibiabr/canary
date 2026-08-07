local mType = Game.createMonsterType("Ferumbras")
local monster = {}

monster.description = "Ferumbras"
monster.experience = 12000
monster.outfit = {
	lookType = 229,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 231,
	bossRace = RARITY_NEMESIS,
}

monster.health = 90000
monster.maxHealth = 90000
monster.race = "venom"
monster.corpse = 6078
monster.speed = 160
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	targetDistance = 2,
	runHealth = 2500,
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
	maxSummons = 4,
	summons = {
		{ name = "Demon", chance = 12, interval = 3000, count = 4 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "NO ONE WILL STOP ME THIS TIME!", yell = true },
	{ text = "THE POWER IS MINE!", yell = true },
	{ text = "I returned from death and you dream about defeating me?", yell = false },
	{ text = "Witness the first seconds of my eternal world domination!", yell = false },
	{ text = "Even in my weakened state I will crush you all!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 71000, maxCount = 346 }, -- Gold Coin
	{ id = 5944, chance = 37000 }, -- Soul Orb
	{ id = 3010, chance = 36000 }, -- Emerald Bangle
	{ id = 3027, chance = 22000, maxCount = 9 }, -- Black Pearl
	{ id = 3028, chance = 15400, maxCount = 19 }, -- Small Diamond
	{ id = 281, chance = 15400 }, -- Giant Shimmering Pearl
	{ id = 3026, chance = 12600, maxCount = 9 }, -- White Pearl
	{ id = 9057, chance = 11200, maxCount = 19 }, -- Small Topaz
	{ id = 3033, chance = 10500, maxCount = 19 }, -- Small Amethyst
	{ id = 9058, chance = 9800 }, -- Gold Ingot
	{ id = 3032, chance = 9800, maxCount = 16 }, -- Small Emerald
	{ id = 3029, chance = 9100, maxCount = 16 }, -- Small Sapphire
	{ id = 3039, chance = 8400 }, -- Red Gem
	{ id = 3035, chance = 7000, maxCount = 34 }, -- Platinum Coin
	{ id = 3041, chance = 7000 }, -- Blue Gem
	{ id = 7427, chance = 4900 }, -- Chaos Mace
	{ id = 3360, chance = 4900 }, -- Golden Armor
	{ id = 821, chance = 4200 }, -- Magma Legs
	{ id = 823, chance = 3500 }, -- Glacier Kilt
	{ id = 3038, chance = 3500 }, -- Green Gem
	{ id = 822, chance = 2800 }, -- Lightning Legs
	{ id = 7407, chance = 2800 }, -- Haunted Blade
	{ id = 8041, chance = 2800 }, -- Greenwood Coat
	{ id = 3420, chance = 2800 }, -- Demon Shield
	{ id = 812, chance = 2100 }, -- Terra Legs
	{ id = 7451, chance = 2100 }, -- Shadow Sceptre
	{ id = 7422, chance = 2100 }, -- Jade Hammer
	{ id = 3364, chance = 2100 }, -- Golden Legs
	{ id = 7416, chance = 2100 }, -- Bloody Edge
	{ id = 7417, chance = 1400 }, -- Runed Sword
	{ id = 7418, chance = 1400 }, -- Nightmare Blade
	{ id = 7423, chance = 1400 }, -- Skullcrusher
	{ id = 7403, chance = 1400 }, -- Berserker
	{ id = 5903, chance = 1400 }, -- Ferumbras' Hat
	{ id = 3414, chance = 700 }, -- Mastermind Shield
	{ id = 8090, chance = 700 }, -- Spellbook of Dark Mysteries
	{ id = 8100, chance = 700 }, -- Obsidian Truncheon
	{ id = 3439, chance = 700 }, -- Phoenix Shield
	{ id = 3422, chance = 700 }, -- Great Shield
	{ id = 8098, chance = 700 }, -- Demonwing Axe
	{ id = 8057, chance = 700 }, -- Divine Plate
	{ id = 8075, chance = 700 }, -- Spellbook of Lost Souls
	{ id = 7382, chance = 700 }, -- Demonrage Sword
	{ id = 8074, chance = 700 }, -- Spellbook of Mind Control
	{ id = 3030, chance = 4080, maxCount = 49 }, -- Small Ruby
	{ id = 3366, chance = 14290 }, -- Magic Plate Armor
	{ id = 8076, chance = 14290 }, -- Spellscroll of Prophecies
	{ id = 7414, chance = 6120 }, -- Abyss Hammer
	{ id = 7410, chance = 10200 }, -- Queen's Sceptre
	{ id = 7411, chance = 10200 }, -- Ornamented Axe
	{ id = 7388, chance = 8160 }, -- Vile Axe
	{ id = 8102, chance = 16330 }, -- Emerald Sword
	{ id = 2852, chance = 4080 }, -- Red Tome
	{ id = 8096, chance = 10200 }, -- Hellforged Axe
	{ id = 7435, chance = 4080 }, -- Impaler
	{ id = 3442, chance = 20410 }, -- Tempest Shield
	{ id = 8040, chance = 22450 }, -- Velvet Mantle
	{ id = 7405, chance = 16330 }, -- Havoc Blade
	{ id = 3303, chance = 4080 }, -- Great Axe
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -350 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_MANADRAIN, minDamage = -500, maxDamage = -700, range = 7, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_LIFEDRAIN, minDamage = -300, maxDamage = -450, length = 8, spread = 0, effect = CONST_ME_HITBYPOISON, target = false },
	{ name = "combat", interval = 2000, chance = 21, type = COMBAT_LIFEDRAIN, minDamage = -450, maxDamage = -500, radius = 6, effect = CONST_ME_POFF, target = false },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 15, minDamage = -20, maxDamage = -40, range = 7, shootEffect = CONST_ANI_POISON, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -900, maxDamage = -1000, range = 4, radius = 3, effect = CONST_ME_DRAWBLOOD, target = false },
	-- energy damage
	{ name = "condition", type = CONDITION_ENERGY, interval = 2000, chance = 18, minDamage = -300, maxDamage = -400, radius = 6, effect = CONST_ME_ENERGYHIT, target = false },
	-- fire
	{ name = "condition", type = CONDITION_FIRE, interval = 3000, chance = 20, minDamage = -500, maxDamage = -600, range = 7, radius = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
}

monster.defenses = {
	defense = 120,
	armor = 100,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 900, maxDamage = 1500, effect = CONST_ME_MAGIC_GREEN, target = false },
	{ name = "invisible", interval = 4000, chance = 20, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 90 },
	{ type = COMBAT_EARTHDAMAGE, percent = 90 },
	{ type = COMBAT_FIREDAMAGE, percent = 90 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
