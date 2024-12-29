local mType = Game.createMonsterType("The Unarmored Voidborn")
local monster = {}

monster.description = "The Unarmored Voidborn"
monster.experience = 15000
monster.outfit = {
	lookType = 987,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"CultsOfTibiaBossDeath",
}

monster.bosstiary = {
	bossRaceId = 1406,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 250000
monster.maxHealth = 250000
monster.race = "undead"
monster.corpse = 26133
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 50,
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
	canPushCreatures = false,
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
}

monster.loot = {
	{ name = "magic sulphur", chance = 8920, maxCount = 10 },
	{ name = "gold ingot", chance = 21200, maxCount = 10 },
	{ id = 282, chance = 26900 }, -- giant shimmering pearl (brown)
	{ name = "berserker", chance = 8920 },
	{ name = "abyss hammer", chance = 7620 },
	{ name = "skull helmet", chance = 9700 },
	{ name = "silver token", chance = 2732 },
	{ name = "gold token", chance = 1532 },
	{ name = "gold coin", chance = 100000, maxCount = 200 },
	{ name = "platinum coin", chance = 29840, maxCount = 25 },
	{ name = "yellow gem", chance = 29460 },
	{ name = "blue gem", chance = 21892 },
	{ name = "skull fetish", chance = 7270 },
	{ name = "bonebreaker", chance = 9510 },
	{ name = "mysterious remains", chance = 100000 },
	{ name = "small diamond", chance = 12760, maxCount = 10 },
	{ name = "small amethyst", chance = 14700, maxCount = 10 },
	{ name = "small topaz", chance = 11520, maxCount = 10 },
	{ name = "small sapphire", chance = 13790, maxCount = 10 },
	{ name = "small emerald", chance = 14700, maxCount = 10 },
	{ name = "small amethyst", chance = 12259, maxCount = 10 },
	{ name = "energy bar", chance = 16872, maxCount = 3 },
	{ name = "ultimate health potion", chance = 27652, maxCount = 10 },
	{ name = "great mana potion", chance = 33721, maxCount = 10 },
	{ name = "great spirit potion", chance = 25690, maxCount = 5 },
	{ id = 23542, chance = 12798 }, -- collar of blue plasma
	{ name = "piece of royal steel", chance = 15890 },
	{ name = "shadow sceptre", chance = 7890 },
	{ id = 23533, chance = 14542 }, -- ring of red plasma
	{ name = "terra hood", chance = 16892 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -550 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -400, length = 7, spread = 5, effect = CONST_ME_SMALLCLOUDS, target = false },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_ENERGYDAMAGE, minDamage = -250, maxDamage = -440, radius = 5, effect = CONST_ME_ENERGYHIT, target = false },
}

monster.defenses = {
	defense = 50,
	armor = 50,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -300 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -255 },
	{ type = COMBAT_EARTHDAMAGE, percent = -255 },
	{ type = COMBAT_FIREDAMAGE, percent = -255 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -300 },
	{ type = COMBAT_HOLYDAMAGE, percent = -300 },
	{ type = COMBAT_DEATHDAMAGE, percent = -300 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
