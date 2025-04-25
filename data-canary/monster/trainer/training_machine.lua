local mType = Game.createMonsterType("Training Machine")
local monster = {}

monster.description = "a training machine"
monster.experience = 0
monster.outfit = {
	lookType = 1142,
}

monster.health = 1000000
monster.maxHealth = monster.health
monster.race = "venom"
monster.corpse = 0
monster.speed = 0

monster.changeTarget = {
	interval = 1000,
	chance = 0,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	targetDistance = 1,
	staticAttackChance = 100,
}

monster.summons = {}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "I hope you are enjoying your sparring Sir or Ma'am!", yell = false },
	{ text = "Threat level rising!", yell = false },
	{ text = "Engaging in hostile interaction!", yell = false },
	{ text = "Rrrtttarrrttarrrtta", yell = false },
	{ text = "Please feel free to hit me Sir or Ma'am!", yell = false },
	{ text = "klonk klonk klonk", yell = false },
	{ text = "Self-diagnosis running.", yell = false },
	{ text = "Battle simulation proceeding.", yell = false },
	{ text = "Repairs initiated!", yell = false },
}

monster.loot = {}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -2, maxDamage = -7, attack = 130 },
}

monster.defenses = {
	defense = 10,
	armor = 7,
	{ name = "combat", type = COMBAT_HEALING, chance = 15, interval = 2000, minDamage = 10000, maxDamage = 50000, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {}

mType:register(monster)
