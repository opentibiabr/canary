local mType = Game.createMonsterType("The Enraged Thorn Knight")
local monster = {}

monster.description = "the enraged Thorn Knight"
monster.experience = 30000
monster.outfit = {
	lookType = 512,
	lookHead = 81,
	lookBody = 121,
	lookLegs = 121,
	lookFeet = 121,
	lookAddons = 3,
	lookMount = 0,
}

monster.events = {
	"ForgottenKnowledgeBossDeath",
	"HealthForgotten",
}

monster.bosstiary = {
	bossRaceId = 1297,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 90000
monster.maxHealth = 90000
monster.race = "blood"
monster.corpse = 111
monster.speed = 175
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 0,
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
	runHealth = 15,
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
	{ text = "You've killed my only friend!", yell = false },
	{ text = "You will pay for this!", yell = false },
	{ text = "NOOOOO!", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 50320, maxCount = 165 }, -- gold coin
	{ id = 3035, chance = 50320, maxCount = 30 }, -- platinum coin
	{ id = 16119, chance = 9660, maxCount = 5 }, -- blue crystal shard
	{ id = 16120, chance = 9660, maxCount = 5 }, -- violet crystal shard
	{ id = 16121, chance = 9660, maxCount = 5 }, -- green crystal shard
	{ id = 3032, chance = 9660, maxCount = 5 }, -- small emerald
	{ id = 3030, chance = 7360, maxCount = 5 }, -- small ruby
	{ id = 9057, chance = 7350, maxCount = 5 }, -- small topaz
	{ id = 3033, chance = 7150, maxCount = 5 }, -- small amethyst
	{ id = 5887, chance = 5909, maxCount = 2 }, -- piece of royal steel
	{ id = 238, chance = 22120, maxCount = 3 }, -- great mana potion
	{ id = 7643, chance = 19500, maxCount = 3 }, -- ultimate health potion
	{ id = 7642, chance = 18250, maxCount = 3 }, -- great spirit potion
	{ id = 3041, chance = 5000 }, -- blue gem
	{ id = 3039, chance = 2200 }, -- red gem
	{ id = 3038, chance = 5000 }, -- green gem
	{ id = 3037, chance = 5000 }, -- yellow gem
	{ id = 6499, chance = 14460 }, -- demonic essence
	{ id = 7439, chance = 14460 }, -- berserk potion
	{ id = 7443, chance = 14460 }, -- bullseye potion
	{ id = 281, chance = 7000 }, -- giant shimmering pearl (green)
	{ id = 3295, chance = 20000 }, -- bright sword
	{ id = 7453, chance = 100 }, -- executioner
	{ id = 24966, chance = 100 }, -- forbidden fruit
	{ id = 5014, chance = 500 }, -- mandrake
	{ id = 3436, chance = 1000 }, -- medusa shield
	{ id = 9302, chance = 500 }, -- sacred tree amulet
	{ id = 5875, chance = 1000 }, -- sniper gloves
	{ id = 5884, chance = 1000 }, -- spirit container
	{ id = 8052, chance = 500 }, -- swamplair armor
	{ id = 20203, chance = 1000 }, -- trapped bad dream monster
	{ id = 24954, chance = 500, unique = true }, -- part of a rune
	{ id = 22721, chance = 100000 }, -- gold token
	{ id = 22516, chance = 100000 }, -- silver token
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -600, maxDamage = -1000 },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_LIFEDRAIN, minDamage = -400, maxDamage = -700, length = 4, spread = 0, effect = CONST_ME_POFF, target = false },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_MANADRAIN, minDamage = -1400, maxDamage = -1700, length = 9, spread = 0, effect = CONST_ME_CARNIPHILA, target = false },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_DEATHDAMAGE, minDamage = -400, maxDamage = -700, length = 9, spread = 0, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -250, radius = 10, effect = CONST_ME_BLOCKHIT, target = false },
}

monster.defenses = {
	defense = 60,
	armor = 60,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 1550, maxDamage = 2550, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 1000, chance = 12, speedChange = 620, effect = CONST_ME_MAGIC_RED, target = false, duration = 4000 },
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
	{ type = COMBAT_DEATHDAMAGE, percent = -100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

monster.heals = {
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

mType:register(monster)
