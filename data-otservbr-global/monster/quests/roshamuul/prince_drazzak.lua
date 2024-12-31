local mType = Game.createMonsterType("Prince Drazzak")
local monster = {}

monster.description = "Prince Drazzak"
monster.experience = 210000
monster.outfit = {
	lookType = 12,
	lookHead = 77,
	lookBody = 78,
	lookLegs = 94,
	lookFeet = 55,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 330000
monster.maxHealth = 330000
monster.race = "fire"
monster.corpse = 6068
monster.speed = 240
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 25,
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
	targetDistance = 1,
	runHealth = 2000,
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
	{ text = "DIE!", yell = true },
	{ text = "All VOCATIONS must DIE!", yell = false },
	{ text = "GET OVER HERE!", yell = true },
	{ text = "CRUSH THEM ALL!", yell = true },
	{ text = "VARIPHOR WILL RULE!", yell = true },
	{ text = "They used you fools to escape and they left ME behind!!??", yell = false },
	{ text = "NOT EVEN AEONS OF IMPRISONMENT WILL STOP ME!", yell = true },
	{ text = "EVEN WITH ALL THAT TIME IN THE PRISON THAT WEAKENED ME, YOU ARE NO MATCH TO ME!", yell = true },
	{ text = "THEY WILL ALL PAY!", yell = true },
}

monster.loot = {
	{ id = 20063, chance = 100000 }, -- dream matter
	{ id = 20062, chance = 100000, maxCount = 2 }, -- cluster of solace
	{ id = 20264, chance = 93750, maxCount = 3 }, -- unrealized dream
	{ id = 6499, chance = 100000, maxCount = 2 }, -- demonic essence
	{ id = 5954, chance = 50000 }, -- demon horn
	{ id = 3035, chance = 100000, maxCount = 50 }, -- platinum coin
	{ id = 7643, chance = 100000, maxCount = 100 }, -- ultimate health potion
	{ id = 7642, chance = 100000, maxCount = 100 }, -- great spirit potion
	{ id = 238, chance = 100000, maxCount = 100 }, -- great mana potion
	{ id = 20279, chance = 25000 }, -- eye pod
	{ id = 20274, chance = 2500 }, -- nightmare horn
	{ id = 20277, chance = 25000 }, -- psychedelic tapestry
	{ id = 20278, chance = 25000 }, -- demonic tapestry
	{ id = 5741, chance = 2500 }, -- skull helmet
	{ id = 7417, chance = 2500, unique = true }, -- runed sword
	{ id = 20276, chance = 7000, unique = true }, -- dream warden mask
	{ id = 7418, chance = 1000 }, -- nightmare blade
	{ id = 820, chance = 1000 }, -- lightning boots
	{ id = 281, chance = 5000 }, -- giant shimmering pearl (green)
	{ id = 282, chance = 5000 }, -- giant shimmering pearl (brown)
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 190, attack = 100 },
	{ name = "combat", interval = 2000, chance = 18, type = COMBAT_DEATHDAMAGE, minDamage = -1000, maxDamage = -3000, length = 8, spread = 3, effect = CONST_ME_MORTAREA, target = false },
}

monster.defenses = {
	defense = 65,
	armor = 55,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 1500, maxDamage = 3000, effect = CONST_ME_MAGIC_RED, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 35 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 35 },
	{ type = COMBAT_EARTHDAMAGE, percent = 35 },
	{ type = COMBAT_FIREDAMAGE, percent = 35 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 35 },
	{ type = COMBAT_HOLYDAMAGE, percent = 35 },
	{ type = COMBAT_DEATHDAMAGE, percent = 35 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
