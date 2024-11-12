local mType = Game.createMonsterType("Gaffir")
local monster = {}

monster.description = "Gaffir"
monster.experience = 25000
monster.outfit = {
	lookType = 1217,
	lookHead = 16,
	lookBody = 74,
	lookLegs = 94,
	lookFeet = 50,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1778,
	bossRace = RARITY_BANE,
}

monster.health = 48500
monster.maxHealth = 48500
monster.race = "blood"
monster.corpse = 31307
monster.speed = 95
monster.manaCost = 0

monster.events = {
	"UglyMonsterSpawn",
	"UglyMonsterCleanup",
}

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
	rewardBoss = true,
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

monster.summon = {
	maxSummons = 1,
	summons = {
		{ name = "Black Cobra", chance = 10, interval = 2000, count = 1 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ name = "platinum coin", chance = 100000, maxCount = 17 },
	{ name = "small amethyst", chance = 33500, maxCount = 2 },
	{ name = "small ruby", chance = 33500, maxCount = 2 },
	{ name = "small sapphire", chance = 33500 },
	{ name = "small topaz", chance = 33500 },
	{ name = "small diamond", chance = 33500 },
	{ name = "great spirit potion", chance = 26400 },
	{ name = "terra rod", chance = 24000, maxCount = 3 },
	{ name = "springsprout rod", chance = 21000 },
	{ name = "blue crystal shard", chance = 21000 },
	{ name = "blue gem", chance = 21000 },
	{ name = "cobra crest", chance = 12560 },
	{ name = "violet crystal shard", chance = 14800 },
	{ id = 281, chance = 14520 }, -- giant shimmering pearl (green)
	{ name = "gold ingot", chance = 14500 },
	{ name = "spellbook of warding", chance = 6500 },
	{ id = 3098, chance = 5400 }, -- ring of healing
	{ name = "terra hood", chance = 1600 },
	{ name = "amulet of loss", chance = 3400 },
	{ name = "wand of everblazing", chance = 2900 },
	{ name = "cobra wand", chance = 100 },
	{ name = "cobra axe", chance = 100 },
	{ name = "cobra rod", chance = 100 },
	{ name = "cobra crest", chance = 100 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -550 },
	{ name = "combat", interval = 2000, chance = 8, type = COMBAT_PHYSICALDAMAGE, minDamage = -450, maxDamage = -650, radius = 3, effect = CONST_ME_GROUNDSHAKER, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_EARTHDAMAGE, minDamage = -400, maxDamage = -580, length = 5, spread = 0, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "combat", interval = 3000, chance = 14, type = COMBAT_FIREDAMAGE, minDamage = -500, maxDamage = -750, shootEffect = CONST_ANI_FIRE, target = true },
	{ name = "combat", interval = 2000, chance = 16, type = COMBAT_EARTHDAMAGE, minDamage = -500, maxDamage = -620, radius = 4, shootEffect = CONST_ANI_EARTH, effect = CONST_ME_GREEN_RINGS, target = true },
	{ name = "combat", interval = 3000, chance = 12, type = COMBAT_EARTHDAMAGE, minDamage = -320, maxDamage = -500, radius = 2, effect = CONST_ME_GREEN_RINGS, target = false },
}

monster.defenses = {
	defense = 83,
	armor = 83,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
