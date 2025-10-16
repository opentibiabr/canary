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
	{ id = 238, chance = 80000 }, -- great mana potion
	{ id = 23373, chance = 80000, maxCount = 15 }, -- ultimate mana potion
	{ id = 239, chance = 80000, maxCount = 15 }, -- great health potion
	{ id = 7642, chance = 80000 }, -- great spirit potion
	{ id = 7643, chance = 80000, maxCount = 12 }, -- ultimate health potion
	{ id = 32769, chance = 80000 }, -- white gem
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 32622, chance = 80000 }, -- giant amethyst
	{ id = 44602, chance = 80000 }, -- lesser guardian gem
	{ id = 44603, chance = 80000 }, -- guardian gem
	{ id = 44611, chance = 80000 }, -- lesser mystic gem
	{ id = 44612, chance = 80000 }, -- mystic gem
	{ id = 44605, chance = 80000 }, -- lesser marksman gem
	{ id = 44608, chance = 80000 }, -- lesser sage gem
	{ id = 44648, chance = 80000 }, -- stoic iks boots
	{ id = 44636, chance = 80000 }, -- stoic iks casque
	{ id = 44620, chance = 80000 }, -- stoic iks chestplate
	{ id = 44619, chance = 80000 }, -- stoic iks cuirass
	{ id = 44642, chance = 80000 }, -- stoic iks culet
	{ id = 44643, chance = 80000 }, -- stoic iks faulds
	{ id = 44637, chance = 80000 }, -- stoic iks headpiece
	{ id = 44649, chance = 80000 }, -- stoic iks sandals
	{ id = 30060, chance = 80000 }, -- giant emerald
	{ id = 30061, chance = 80000 }, -- giant sapphire
	{ id = 32623, chance = 80000 }, -- giant topaz
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
