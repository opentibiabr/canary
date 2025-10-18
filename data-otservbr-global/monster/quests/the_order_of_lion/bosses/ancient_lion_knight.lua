local mType = Game.createMonsterType("Ancient Lion Knight")
local monster = {}

monster.description = "an ancient lion knight"
monster.experience = 8100
monster.outfit = {
	lookType = 1071,
	lookHead = 57,
	lookBody = 78,
	lookLegs = 76,
	lookFeet = 76,
	lookAddons = 1,
	lookMount = 0,
}

monster.health = 9100
monster.maxHealth = 9100
monster.race = "blood"
monster.corpse = 28621
monster.speed = 130
monster.manaCost = 0

monster.faction = FACTION_LIONUSURPERS
monster.enemyFactions = { FACTION_PLAYER, FACTION_LION }

monster.changeTarget = {
	interval = 4000,
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
	staticAttackChance = 70,
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
}

monster.loot = {
	{ id = 3035, chance = 100000, maxCount = 5 }, -- Platinum Coin
	{ id = 3582, chance = 53827, maxCount = 3 }, -- Ham
	{ id = 24382, chance = 17792 }, -- Bug Meat
	{ id = 3122, chance = 33165 }, -- Dirty Cape
	{ id = 3105, chance = 50846 }, -- Dirty Fur
	{ id = 3111, chance = 2252 }, -- Fishbone
	{ id = 3116, chance = 4167 }, -- Big Bone
	{ id = 3130, chance = 13660 }, -- Twigs
	{ id = 3114, chance = 21943 }, -- Skull (Item)
	{ id = 3291, chance = 25786 }, -- Knife
	{ id = 3292, chance = 6304 }, -- Combat Knife
	{ id = 3565, chance = 5067 }, -- Cape
	{ id = 11453, chance = 28717 }, -- Broken Helmet
	{ id = 3426, chance = 6361 }, -- Studded Shield
	{ id = 3425, chance = 3829 }, -- Dwarven Shield
	{ id = 3421, chance = 4335 }, -- Dark Shield
	{ id = 3357, chance = 5688 }, -- Plate Armor
	{ id = 3383, chance = 15653 }, -- Dark Armor
	{ id = 17813, chance = 4561 }, -- Life Preserver
	{ id = 34156, chance = 1000 }, -- Lion Spangenhelm
	{ id = 34157, chance = 1000 }, -- Lion Plate
	{ id = 34154, chance = 174 }, -- Lion Shield
	{ id = 34155, chance = 200 }, -- Lion Longsword
	{ id = 34254, chance = 165 }, -- Lion Hammer
	{ id = 34253, chance = 1000 }, -- Lion Axe
	{ id = 34150, chance = 1000 }, -- Lion Longbow
	{ id = 34153, chance = 140 }, -- Lion Spellbook
	{ id = 34152, chance = 1000 }, -- Lion Wand
	{ id = 34151, chance = 1000 }, -- Lion Rod
	{ id = 34158, chance = 1000 }, -- Lion Amulet
	{ id = 50162, chance = 1000 }, -- Lion Claws
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -750, effect = CONST_ME_DRAWBLOOD },
	{ name = "combat", interval = 6000, chance = 30, type = COMBAT_HOLYDAMAGE, minDamage = -450, maxDamage = -750, length = 8, spread = 0, effect = CONST_ME_HOLYAREA, target = false },
	{ name = "combat", interval = 2750, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -400, maxDamage = -800, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2500, chance = 22, type = COMBAT_DEATHDAMAGE, minDamage = -400, maxDamage = -500, radius = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 3300, chance = 24, type = COMBAT_ICEDAMAGE, minDamage = -250, maxDamage = -350, length = 4, spread = 0, effect = CONST_ME_ICEATTACK, target = false },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -200, maxDamage = -500, radius = 4, effect = CONST_ME_BIGCLOUDS, target = false },
}

monster.defenses = {
	defense = 60,
	armor = 0,
	--	mitigation = ???,
	{ name = "speed", interval = 1000, chance = 10, speedChange = 160, effect = CONST_ME_POFF, target = false, duration = 4000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = -30 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
