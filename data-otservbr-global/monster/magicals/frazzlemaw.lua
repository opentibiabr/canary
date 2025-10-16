local mType = Game.createMonsterType("Frazzlemaw")
local monster = {}

monster.description = "a frazzlemaw"
monster.experience = 3740
monster.outfit = {
	lookType = 594,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"RoshamuulKillsDeath",
}

monster.raceId = 1022
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Lower Roshamuul, Guzzlemaw Valley, the entrance to Upper Roshamuul.",
}

monster.health = 4100
monster.maxHealth = 4100
monster.race = "blood"
monster.corpse = 20233
monster.speed = 200
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	rewardBoss = false,
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

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Mwaaahgod! Overmwaaaaah! *gurgle*", yell = false },
	{ text = "Mwaaaahnducate youuuuuu *gurgle*, mwaaah!", yell = false },
	{ text = "MMMWAHMWAHMWAHMWAAAAH!", yell = true },
	{ text = "Mmmwhamwhamwhah, mwaaah!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 100 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 7 }, -- platinum coin
	{ id = 238, chance = 23000, maxCount = 3 }, -- great mana potion
	{ id = 239, chance = 23000, maxCount = 2 }, -- great health potion
	{ id = 20199, chance = 23000 }, -- frazzle skin
	{ id = 20198, chance = 23000 }, -- frazzle tongue
	{ id = 16123, chance = 23000 }, -- brown crystal splinter
	{ id = 11542, chance = 23000 }, -- fish tail
	{ id = 3104, chance = 23000 }, -- banana skin
	{ id = 3110, chance = 23000 }, -- piece of iron
	{ id = 3111, chance = 23000 }, -- fishbone
	{ id = 3125, chance = 23000 }, -- remains of a fish
	{ id = 7573, chance = 23000 }, -- bone
	{ id = 16279, chance = 23000 }, -- crystal rubbish
	{ id = 7885, chance = 23000, maxCount = 3 }, -- fish
	{ id = 16126, chance = 5000 }, -- red crystal fragment
	{ id = 3582, chance = 5000, maxCount = 2 }, -- ham
	{ id = 3116, chance = 5000 }, -- big bone
	{ id = 5895, chance = 5000 }, -- fish fin
	{ id = 5925, chance = 5000 }, -- hardened bone
	{ id = 16120, chance = 5000 }, -- violet crystal shard
	{ id = 5880, chance = 5000 }, -- iron ore
	{ id = 7407, chance = 5000 }, -- haunted blade
	{ id = 3265, chance = 5000 }, -- two handed sword
	{ id = 9058, chance = 5000 }, -- gold ingot
	{ id = 7418, chance = 1000 }, -- nightmare blade
	{ id = 7404, chance = 1000 }, -- assassin dagger
	{ id = 20062, chance = 260 }, -- cluster of solace
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	-- bleed
	{ name = "condition", type = CONDITION_BLEEDING, interval = 2000, chance = 10, minDamage = -300, maxDamage = -400, radius = 3, effect = CONST_ME_DRAWBLOOD, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = 0, maxDamage = -700, length = 5, spread = 0, effect = CONST_ME_EXPLOSIONAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -400, radius = 2, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_STONES, target = true },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -600, radius = 5, effect = CONST_ME_MAGIC_RED, target = false, duration = 15000 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -80, maxDamage = -150, radius = 4, effect = CONST_ME_MAGIC_RED, target = false },
}

monster.defenses = {
	defense = 30,
	armor = 74,
	mitigation = 2.31,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 250, maxDamage = 425, effect = CONST_ME_HITBYPOISON, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
