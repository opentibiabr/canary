local mType = Game.createMonsterType("Gorzindel")
local monster = {}

monster.description = "Gorzindel"
monster.experience = 100000
monster.outfit = {
	lookType = 1062,
	lookHead = 94,
	lookBody = 81,
	lookLegs = 10,
	lookFeet = 0,
	lookAddons = 1,
	lookMount = 0,
}

monster.events = {
	"gorzindelHealth",
}

monster.bosstiary = {
	bossRaceId = 1591,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 300000
monster.maxHealth = 300000
monster.race = "blood"
monster.corpse = 22495
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 4,
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
}

monster.loot = {
	{ name = "platinum coin", chance = 90000 },
	{ name = "crystal coin", chance = 90000, maxCount = 8 },
	{ name = "small amethyst", chance = 90000, maxCount = 12 },
	{ name = "small diamond", chance = 90000, maxCount = 12 },
	{ name = "small emerald", chance = 90000, maxCount = 12 },
	{ name = "small ruby", chance = 90000, maxCount = 12 },
	{ name = "small topaz", chance = 90000, maxCount = 12 },
	{ name = "onyx chip", chance = 90000, maxCount = 12 },
	{ name = "great spirit potion", chance = 90000, maxCount = 8 },
	{ name = "supreme health potion", chance = 90000, maxCount = 12 },
	{ name = "ultimate health potion", chance = 90000, maxCount = 18 },
	{ name = "ultimate mana potion", chance = 90000, maxCount = 8 },
	{ name = "ultimate spirit potion", chance = 90000, maxCount = 12 },
	{ name = "berserk potion", chance = 90000, maxCount = 2 },
	{ name = "bullseye potion", chance = 90000, maxCount = 2 },
	{ name = "mastermind potion", chance = 90000, maxCount = 2 },
	{ name = "chaos mace", chance = 30000 },
	{ name = "crown armor", chance = 30000 },
	{ name = "curious matter", chance = 30000 },
	{ name = "demon horn", chance = 30000 },
	{ name = "dreaded cleaver", chance = 30000 },
	{ id = 281, chance = 30000 }, -- giant shimmering pearl (green)
	{ name = "gold token", chance = 1000, maxCount = 6 },
	{ name = "green gem", chance = 1000 },
	{ name = "knowledgeable book", chance = 1000 },
	{ name = "ominous book", chance = 1000 },
	{ name = "magic sulphur", chance = 1000, maxCount = 2 },
	{ name = "muck rod", chance = 1000 },
	{ id = 3039, chance = 1000 }, -- red gem
	{ name = "slightly rusted shield", chance = 11760 },
	{ name = "silver Token", chance = 1000, maxCount = 6 },
	{ name = "sinister book", chance = 1000 },
	{ name = "spellbook of warding", chance = 1000 },
	{ name = "steel boots", chance = 1000 },
	{ name = "stone skin amulet", chance = 1000 },
	{ name = "wand of cosmic Energy", chance = 1000 },
	{ name = "yellow gem", chance = 1000 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 100, attack = 100 },
	{ name = "melee", interval = 2000, chance = 15, minDamage = -600, maxDamage = -2800 },
	{ name = "melee", interval = 1000, chance = 15, minDamage = -800, maxDamage = -1300 },
	{ name = "melee", interval = 1000, chance = 15, minDamage = -800, maxDamage = -1000 },
	{ name = "melee", interval = 1000, chance = 15, minDamage = -200, maxDamage = -800 },
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -200, maxDamage = -600, radius = 9, effect = CONST_ME_MAGIC_RED, target = false },
}

monster.defenses = {
	defense = 33,
	armor = 28,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
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
