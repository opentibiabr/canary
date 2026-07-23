local mType = Game.createMonsterType("Goshnar's Malice")
local monster = {}

monster.description = "Goshnar's Malice"
monster.experience = 75000
monster.outfit = {
	lookType = 1306,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"SoulWarBossesDeath",
	"Goshnar's-Malice",
}

monster.health = 300000
monster.maxHealth = 300000
monster.race = "undead"
monster.corpse = 33871
monster.speed = 150
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1901,
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
	canPushCreatures = true,
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
	{ id = 3043, chance = 100000, maxCount = 94 }, -- Crystal Coin
	{ id = 23373, chance = 81000, maxCount = 177 }, -- Ultimate Mana Potion
	{ id = 3037, chance = 50000 }, -- Yellow Gem
	{ id = 23374, chance = 44000, maxCount = 149 }, -- Ultimate Spirit Potion
	{ id = 7440, chance = 44000, maxCount = 48 }, -- Mastermind Potion
	{ id = 32622, chance = 44000 }, -- Giant Amethyst
	{ id = 30061, chance = 38000 }, -- Giant Sapphire
	{ id = 23375, chance = 38000, maxCount = 108 }, -- Supreme Health Potion
	{ id = 3036, chance = 25000 }, -- Violet Gem
	{ id = 3038, chance = 25000 }, -- Green Gem
	{ id = 3039, chance = 25000 }, -- Red Gem
	{ id = 281, chance = 25000 }, -- Giant Shimmering Pearl
	{ id = 7443, chance = 25000, maxCount = 30 }, -- Bullseye Potion
	{ id = 49271, chance = 18800, maxCount = 22 }, -- Transcendence Potion
	{ id = 32623, chance = 18800 }, -- Giant Topaz
	{ id = 32769, chance = 12500 }, -- White Gem
	{ id = 9058, chance = 12500 }, -- Gold Ingot
	{ id = 7439, chance = 12500, maxCount = 48 }, -- Berserk Potion
	{ id = 3041, chance = 12500, maxCount = 2 }, -- Blue Gem
	{ id = 33920, chance = 6200 }, -- Malice's Horn
	{ id = 30053, chance = 6200 }, -- Dragon Figurine
	{ id = 33921, chance = 6200 }, -- Malice's Spine
	{ id = 34076, chance = 6200 }, -- Bracelet of Strengthening
	{ id = 44612, chance = 6200 }, -- Mystic Gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -5000 },
	{ name = "combat", interval = 2000, chance = 22, type = COMBAT_ICEDAMAGE, minDamage = -2450, maxDamage = -4400, length = 10, spread = 4, effect = CONST_ME_ICEAREA, target = false },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_ICEDAMAGE, minDamage = -2350, maxDamage = -3000, range = 7, radius = 4, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEAREA, target = true },
}

monster.defenses = {
	defense = 160,
	armor = 160,
	mitigation = 5.40,
	{ name = "speed", interval = 1000, chance = 20, speedChange = 500, effect = CONST_ME_MAGIC_RED, target = false, duration = 10000 },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 1250, maxDamage = 3250, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 15 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
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

local zone = Zone.getByName("boss.goshnar's-malice")
local zonePositions = zone:getPositions()

local accumulatedTime = 0
local desiredInterval = 40000
mType.onThink = function(monster, interval)
	accumulatedTime = accumulatedTime + interval
	-- Execute only after 40 seconds
	if accumulatedTime >= desiredInterval then
		monster:createSoulWarWhiteTiles(SoulWarQuest.levers.goshnarsMalice.boss.position, zonePositions)
		accumulatedTime = 0
	end
end

mType:register(monster)
