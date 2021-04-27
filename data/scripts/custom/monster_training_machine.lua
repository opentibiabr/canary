local mType = Game.createMonsterType("Training Machine")
local monster = {}
monster.description = "Training Machine"
monster.experience = 0
monster.outfit = {
	lookType = 1142
}

monster.health = 1000000
monster.maxHealth = monster.health
monster.race = "energy"
monster.corpse = 0
monster.speed = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 1*1000,
	chance = 0
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

monster.summons = {
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "I hope you are enjoying your sparring Sir or Ma'am!", yell = false},
	{text = "Threat level rising!", yell = false},
	{text = "Engaging in hostile interaction!", yell = false},
	{text = "Rrrtttarrrttarrrtta", yell = false},
	{text = "Please feel free to hit me Sir or Ma'am!", yell = false},
	{text = "klonk klonk klonk", yell = false},
	{text = "Self-diagnosis running.", yell = false},
	{text = "Battle simulation proceeding.", yell = false},
	{text = "Repairs initiated!", yell = false}
}

monster.loot = {
}

monster.attacks = {
	{name = "melee", attack = 130, interval = 2*1000, minDamage = -1, maxDamage = -2}
}

monster.defenses = {
	defense = 1,
	armor = 1,
	{name = "combat", type = COMBAT_HEALING, chance = 15, interval = 2*1000, minDamage = 10000, maxDamage = 50000, effect = CONST_ME_MAGIC_BLUE}
}

monster.elements = {
}

monster.immunities = {
}

mType:register(monster)
