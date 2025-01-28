local mType = Game.createMonsterType("Girtablilu Warrior")
local monster = {}

monster.description = "a girtablilu warrior"
monster.experience = 5800
monster.outfit = {
	lookType = 1407,
	lookHead = 114,
	lookBody = 39,
	lookLegs = 113,
	lookFeet = 114,
	lookAddons = 1,
	lookMount = 0,
}

monster.raceId = 2099
monster.Bestiary = {
	class = "Magical",
	race = BESTY_RACE_MAGICAL,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Ruins of Nuur.",
}

monster.health = 8500
monster.maxHealth = 8500
monster.race = "blood"
monster.corpse = 36800
monster.speed = 180
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
	hasGroupedSpells = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "We won't give entrance to the land of darkness.", yell = false },
	{ text = "Our glance is death!", yell = false },
	{ text = "This is no place for mortals! Get thee gone!", yell = false },
}

monster.loot = {
	{ name = "platinum coin", chance = 76760, maxCount = 16 },
	{ name = "ultimate health potion", chance = 15610, maxCount = 4 },
	{ name = "gold ingot", chance = 13810 },
	{ name = "green crystal shard", chance = 6060 },
	{ name = "red crystal fragment", chance = 5500 },
	{ name = "cyan crystal fragment", chance = 4490 },
	{ name = "girtablilu warrior carapace", chance = 4410 },
	{ name = "scorpion charm", chance = 4290 },
	{ name = "green gem", chance = 3810 },
	{ name = "violet gem", chance = 3310 },
	{ name = "blue crystal shard", chance = 3190 },
	{ name = "crowbar", chance = 2870 },
	{ name = "diamond sceptre", chance = 2340 },
	{ name = "violet crystal shard", chance = 2930 },
	{ name = "yellow gem", chance = 2160 },
	{ name = "ice rapier", chance = 2570 },
	{ name = "magma coat", chance = 2130 },
	{ name = "epee", chance = 2070 },
	{ name = "dragonbone staff", chance = 2400 },
	{ name = "knight axe", chance = 2100 },
	{ name = "beastslayer axe", chance = 1300 },
	{ name = "green crystal fragment", chance = 1660 },
	{ name = "blue gem", chance = 1360 },
	{ id = 3039, chance = 1630 }, -- red gem
	{ name = "blue robe", chance = 1180 },
	{ name = "focus cape", chance = 830 },
	{ name = "fur armor", chance = 1060 },
	{ name = "glacier robe", chance = 920 },
}

monster.attacks = {
	{ name = "melee", group = MONSTER_SPELL_GROUP_BASIC, chance = 100, minDamage = -400, maxDamage = -450, group = 1 },
	{ name = "combat", group = MONSTER_SPELL_GROUP_ATTACK, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -500, maxDamage = -650, radius = 4, effect = CONST_ME_MORTAREA, target = false, group = 2 },
	{ name = "combat", group = MONSTER_SPELL_GROUP_ATTACK, chance = 25, type = COMBAT_EARTHDAMAGE, minDamage = -200, maxDamage = -450, range = 5, shootEffect = CONST_ANI_POISONARROW, target = true, group = 2 },
	{ name = "combat", group = MONSTER_SPELL_GROUP_ATTACK, chance = 30, type = COMBAT_EARTHDAMAGE, minDamage = -200, maxDamage = -400, length = 3, spread = 2, effect = CONST_ME_GREEN_RINGS, target = false, group = 2 },
}

monster.defenses = {
	defense = 76,
	armor = 76,
	mitigation = 2.22,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 150, maxDamage = 550, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
