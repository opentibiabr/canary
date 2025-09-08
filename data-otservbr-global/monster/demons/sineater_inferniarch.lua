local mType = Game.createMonsterType("Sineater Inferniarch")
local monster = {}

monster.description = "a sineater inferniarch"
monster.experience = 6750
monster.outfit = {
	lookType = 1795,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2602
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Azzilon Castle.",
}

monster.health = 9150
monster.maxHealth = 9150
monster.race = "fire"
monster.corpse = 50002
monster.speed = 160
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
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	isPreyExclusive = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Kah ... Thul... GROAR!", yell = true },
	{ text = "Bahrrr... Bharush!", yell = true },
}

monster.loot = {
	{ name = "platinum coin", chance = 5000, maxCount = 25 },
	{ name = "small ruby", chance = 4761, maxCount = 2 },
	{ name = "demonic core essence", chance = 100 },
	{ name = "demonic matter", chance = 4761 },
	{ name = "great mana potion", chance = 2846 },
	{ id = 36706, chance = 900 }, -- red gem
	{ name = "sineater wing", chance = 1000 },
	{ name = "mummified demon finger", chance = 155 },
	{ name = "ruby necklace", chance = 1052 },
	{ name = "wand of defiance", chance = 1846 },
	{ name = "wooden spellbook", chance = 628 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300 },
	{ name = "combat", interval = 2000, chance = 17, type = COMBAT_FIREDAMAGE, minDamage = -100, maxDamage = -500, range = 4, radius = 4, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true }, -- great fireball
	{ name = "big death wave", interval = 3500, chance = 25, minDamage = -150, maxDamage = -450, target = false },
	{ name = "combat", interval = 3000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -150, maxDamage = -450, range = 1, effect = CONST_ME_BIG_SCRATCH, target = true },
	{ name = "firefield", interval = 2000, chance = 10, range = 4, radius = 1, shootEffect = CONST_ANI_FIRE, target = true },
}

monster.defenses = {
	defense = 15,
	armor = 68,
	mitigation = 1.94,
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_HEALING, minDamage = 100, maxDamage = 350, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_PHYSICALDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
