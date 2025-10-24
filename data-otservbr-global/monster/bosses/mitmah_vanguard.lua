local mType = Game.createMonsterType("Mitmah Vanguard")
local monster = {}

monster.description = "Mitmah Vanguard"
monster.experience = 300000
monster.outfit = {
	lookType = 1716,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 2464,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 250000
monster.maxHealth = 250000
monster.race = "blood"
monster.corpse = 44687
monster.speed = 450
monster.manaCost = 0

monster.changeTarget = {
	interval = 10000,
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
	canPushCreatures = true,
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
	{ text = "Die, human. Now!", yell = true },
	{ text = "FEAR THE CURSE!", yell = true },
	{ text = "You're the intruder.", yell = true },
	{ text = "The Iks have always been ours.", yell = true },
	{ text = "NOW TREMBLE!", "GOT YOU NOW!", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 1000, maxCount = 400 }, -- Gold Coin
	{ id = 3035, chance = 1000, maxCount = 15 }, -- Platinum Coin
	{ id = 3043, chance = 1000 }, -- Crystal Coin
	{ id = 238, chance = 27329 }, -- Great Mana Potion
	{ id = 23373, chance = 16770, maxCount = 15 }, -- Ultimate Mana Potion
	{ id = 239, chance = 26086, maxCount = 15 }, -- Great Health Potion
	{ id = 7642, chance = 8074 }, -- Great Spirit Potion
	{ id = 7643, chance = 21739, maxCount = 12 }, -- Ultimate Health Potion
	{ id = 32769, chance = 29192 }, -- White Gem
	{ id = 3037, chance = 24844 }, -- Yellow Gem
	{ id = 3041, chance = 23602 }, -- Blue Gem
	{ id = 32622, chance = 5590 }, -- Giant Amethyst
	{ id = 44602, chance = 1242 }, -- Lesser Guardian Gem
	{ id = 44603, chance = 4968 }, -- Guardian Gem
	{ id = 44611, chance = 621 }, -- Lesser Mystic Gem
	{ id = 44612, chance = 1863 }, -- Mystic Gem
	{ id = 44605, chance = 1242 }, -- Lesser Marksman Gem
	{ id = 44608, chance = 2484 }, -- Lesser Sage Gem
	{ id = 44438, chance = 54658 }, -- Broken Mitmah Necklace
	{ id = 44439, chance = 45341 }, -- Crystal of the Mitmah
	{ id = 44727, chance = 3726 }, -- Broken Mitmah Chestplate
	{ id = 44728, chance = 3726 }, -- Splintered Mitmah Gem
	{ id = 50291, chance = 1000 }, -- Iks Footwraps
	{ id = 44648, chance = 1000 }, -- Stoic Iks Boots
	{ id = 44636, chance = 1000 }, -- Stoic Iks Casque
	{ id = 44620, chance = 1000 }, -- Stoic Iks Chestplate
	{ id = 44619, chance = 1000 }, -- Stoic Iks Cuirass
	{ id = 44642, chance = 1000 }, -- Stoic Iks Culet
	{ id = 44643, chance = 621 }, -- Stoic Iks Faulds
	{ id = 44637, chance = 1000 }, -- Stoic Iks Headpiece
	{ id = 50255, chance = 1000 }, -- Stoic Iks Robe
	{ id = 44649, chance = 1000 }, -- Stoic Iks Sandals
	{ id = 30060, chance = 3726 }, -- Giant Emerald
	{ id = 30061, chance = 5590 }, -- Giant Sapphire
	{ id = 32623, chance = 6832 }, -- Giant Topaz
}

monster.attacks = {
	{ name = "melee", interval = 1700, chance = 100, minDamage = -400, maxDamage = -856 },
	{ name = "melee", interval = 2500, chance = 100, minDamage = -500, maxDamage = -1256 },
	{ name = "hugeblackring", interval = 3500, chance = 20, minDamage = -700, maxDamage = -1500, target = false },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -4500, maxDamage = -6000, radius = 9, effect = CONST_ME_SLASH, target = false },
	{ name = "combat", interval = 2500, chance = 33, type = COMBAT_ENERGYDAMAGE, minDamage = -500, maxDamage = -1500, length = 8, spread = 0, effect = CONST_ME_PURPLEENERGY, target = false },
	{ name = "combat", interval = 2000, chance = 50, type = COMBAT_FIREDAMAGE, minDamage = -600, maxDamage = -1000, length = 8, spread = 2, effect = CONST_ME_HITBYFIRE, target = false },
	{ name = "combat", interval = 1000, chance = 30, type = COMBAT_ENERGYDAMAGE, minDamage = -400, maxDamage = -600, range = 7, radius = 2, shootEffect = CONST_ANI_BOLT, effect = CONST_ME_ENERGYHIT, target = true },
}

monster.defenses = {
	defense = 64,
	armor = 0,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
