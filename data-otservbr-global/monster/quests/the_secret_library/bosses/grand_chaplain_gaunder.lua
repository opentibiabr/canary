local mType = Game.createMonsterType("Grand Chaplain Gaunder")
local monster = {}

monster.description = "Grand Chaplain Gaunder"
monster.experience = 14000
monster.outfit = {
	lookType = 1071,
	lookHead = 57,
	lookBody = 96,
	lookLegs = 23,
	lookFeet = 105,
	lookAddons = 1,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1579,
	bossRace = RARITY_BANE,
}

monster.health = 18000
monster.maxHealth = 18000
monster.race = "blood"
monster.corpse = 28733
monster.speed = 105
monster.manaCost = 0

monster.events = {
	"killingLibrary",
}

monster.changeTarget = {
	interval = 3000,
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
	{ text = "Witness the might of The Order of the Falcon!", yell = false },
	{ text = "Suffer, for you are disobedient!", yell = false },
}

monster.loot = {
	{ name = "flask of demonic blood", chance = 50000, maxCount = 2 },
	{ name = "ham", chance = 50000, maxCount = 2 },
	{ name = "onyx arrow", chance = 35000, maxCount = 3 },
	{ name = "small diamond", chance = 30000, maxCount = 3 },
	{ name = "small emerald", chance = 30000, maxCount = 3 },
	{ name = "small enchanted amethyst", chance = 20000, maxCount = 3 },
	{ name = "damaged armor plates", chance = 2350, maxCount = 3 },
	{ id = 281, chance = 12000, maxCount = 1 }, -- giant shimmering pearl (green)
	{ name = "knight armor", chance = 7000 },
	{ name = "patch of fine cloth", chance = 1800 },
	{ name = "spiked squelcher", chance = 3200 },
	{ name = "titan axe", chance = 2400 },
	{ name = "falcon battleaxe", chance = 200 },
	{ name = "falcon longsword", chance = 200 },
	{ name = "falcon mace", chance = 210 },
	{ name = "falcon plate", chance = 100 },
	{ name = "falcon shield", chance = 100 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -150, maxDamage = -850 },
	{ name = "combat", interval = 1500, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -380, maxDamage = -890, range = 4, radius = 4, effect = CONST_ME_HITBYPOISON, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -290, maxDamage = -720, range = 7, shootEffect = CONST_ANI_ETHEREALSPEAR, target = false },
	{ name = "combat", interval = 1500, chance = 14, type = COMBAT_HOLYDAMAGE, minDamage = -300, maxDamage = -1000, length = 8, spread = 0, effect = CONST_ME_BLOCKHIT, target = false },
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -200, maxDamage = -700, range = 5, radius = 3, effect = CONST_ME_SMALLCLOUDS, target = false },
}

monster.defenses = {
	defense = 50,
	armor = 82,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 200, maxDamage = 550, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 1000, chance = 10, speedChange = 220, effect = CONST_ME_POFF, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 80 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 50 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = 50 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
