local mType = Game.createMonsterType("Melting Frozen Horror")
local monster = {}

monster.description = "a melting frozen horror"
monster.experience = 65000
monster.outfit = {
	lookType = 261,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"ForgottenKnowledgeBossDeath",
	"MeltingDeath",
}

monster.health = 70000
monster.maxHealth = 70000
monster.race = "undead"
monster.corpse = 7282
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 5,
}

monster.bosstiary = {
	bossRaceId = 1336,
	bossRace = RARITY_ARCHFOE,
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
	{ text = "Chrrrrrk! Chrrrk!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 200 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 30 }, -- platinum coin
	{ id = 9661, chance = 80000 }, -- frosty heart
	{ id = 16121, chance = 80000, maxCount = 3 }, -- green crystal shard
	{ id = 16120, chance = 80000, maxCount = 3 }, -- violet crystal shard
	{ id = 3033, chance = 80000, maxCount = 10 }, -- small amethyst
	{ id = 3028, chance = 80000, maxCount = 10 }, -- small diamond
	{ id = 3032, chance = 80000, maxCount = 10 }, -- small emerald
	{ id = 15793, chance = 80000, maxCount = 100 }, -- crystalline arrow
	{ id = 7643, chance = 80000, maxCount = 5 }, -- ultimate health potion
	{ id = 7642, chance = 80000, maxCount = 5 }, -- great spirit potion
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 3333, chance = 80000 }, -- crystal mace
	{ id = 7449, chance = 80000 }, -- crystal sword
	{ id = 16160, chance = 80000 }, -- crystalline sword
	{ id = 8050, chance = 80000 }, -- crystalline armor
	{ id = 15793, chance = 80000, maxCount = 100 }, -- crystalline arrow
	{ id = 8059, chance = 80000 }, -- frozen plate
	{ id = 7741, chance = 80000 }, -- ice cube
	{ id = 3284, chance = 80000 }, -- ice rapier
	{ id = 11652, chance = 80000 }, -- broken key ring
	{ id = 7459, chance = 80000 }, -- pair of earmuffs
	{ id = 19363, chance = 80000 }, -- runic ice shield
	{ id = 16175, chance = 80000 }, -- shiny blade
	{ id = 23518, chance = 80000 }, -- spark sphere
	{ id = 24978, chance = 80000 }, -- coal eyes
	{ id = 14247, chance = 80000 }, -- ornate crossbow
	{ id = 24977, chance = 1000 }, -- glowing carrot
	{ id = 22516, chance = 80000 }, -- silver token
	{ id = 22721, chance = 80000 }, -- gold token
	{ id = 238, chance = 80000 }, -- great mana potion
	{ id = 3391, chance = 80000 }, -- crusader helmet
	{ id = 7290, chance = 80000 }, -- shard
	{ id = 16119, chance = 80000 }, -- blue crystal shard
	{ id = 3030, chance = 80000 }, -- small ruby
	{ id = 9057, chance = 80000 }, -- small topaz
	{ id = 7368, chance = 80000 }, -- assassin star
	{ id = 3332, chance = 80000 }, -- hammer of wrath
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 3067, chance = 80000 }, -- hailstorm rod
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 7383, chance = 80000 }, -- relic sword
	{ id = 5892, chance = 80000 }, -- huge chunk of crude iron
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -70, maxDamage = -300 },
	{ name = "hirintror freeze", interval = 2000, chance = 15, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -750, maxDamage = -1050, range = 7, radius = 3, shootEffect = CONST_ANI_ICE, effect = CONST_ME_BLOCKHIT, target = true },
	{ name = "ice golem paralyze", interval = 2000, chance = 11, target = false },
	{ name = "hirintror skill reducer", interval = 2000, chance = 10, target = false },
}

monster.defenses = {
	defense = 60,
	armor = 60,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, radius = 7, effect = CONST_ME_BLOCKHIT, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 1 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = -1 },
}

monster.heals = {
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
