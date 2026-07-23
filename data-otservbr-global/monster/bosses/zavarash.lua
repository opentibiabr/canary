local mType = Game.createMonsterType("Zavarash")
local monster = {}

monster.description = "Zavarash"
monster.experience = 21000
monster.outfit = {
	lookType = 12,
	lookHead = 0,
	lookBody = 15,
	lookLegs = 57,
	lookFeet = 85,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 35000
monster.maxHealth = 35000
monster.race = "blood"
monster.corpse = 6068
monster.speed = 220
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
	targetDistance = 4,
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
	maxSummons = 2,
	summons = {
		{ name = "dark torturer", chance = 100, interval = 1000, count = 2 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Harrr, Harrr!", yell = false },
}

monster.loot = {
	{ id = 20062, chance = 100000 }, -- Cluster of Solace
	{ id = 3031, chance = 100000, maxCount = 197 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 50 }, -- Platinum Coin
	{ id = 5954, chance = 100000 }, -- Demon Horn
	{ id = 20264, chance = 59000 }, -- Unrealized Dream
	{ id = 6499, chance = 59000 }, -- Demonic Essence
	{ id = 281, chance = 43000 }, -- Giant Shimmering Pearl
	{ id = 16120, chance = 38000, maxCount = 8 }, -- Violet Crystal Shard
	{ id = 238, chance = 35000, maxCount = 10 }, -- Great Mana Potion
	{ id = 7642, chance = 33000, maxCount = 10 }, -- Great Spirit Potion
	{ id = 7643, chance = 32000, maxCount = 10 }, -- Ultimate Health Potion
	{ id = 16119, chance = 32000, maxCount = 8 }, -- Blue Crystal Shard
	{ id = 16121, chance = 30000, maxCount = 8 }, -- Green Crystal Shard
	{ id = 3038, chance = 20000 }, -- Green Gem
	{ id = 3315, chance = 16000 }, -- Guardian Halberd
	{ id = 3415, chance = 15900 }, -- Guardian Shield
	{ id = 3041, chance = 15500 }, -- Blue Gem
	{ id = 9058, chance = 15300 }, -- Gold Ingot
	{ id = 7428, chance = 15000 }, -- Bonebreaker
	{ id = 3340, chance = 13100 }, -- Heavy Mace
	{ id = 3419, chance = 11500 }, -- Crown Shield
	{ id = 20276, chance = 10600 }, -- Dream Warden Mask
	{ id = 8063, chance = 9600 }, -- Paladin Armor
	{ id = 7387, chance = 8400 }, -- Diamond Sceptre
	{ id = 3420, chance = 6300 }, -- Demon Shield
	{ id = 7421, chance = 4000 }, -- Onyx Flail
	{ id = 3414, chance = 1400 }, -- Mastermind Shield
	{ id = 7431, chance = 700 }, -- Demonbone
	{ id = 8061, chance = 520 }, -- Skullcracker Armor
	{ id = 8049, chance = 350 }, -- Lavos Armor
	{ id = 8100, chance = 170 }, -- Obsidian Truncheon
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -600 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -6000, range = 7, shootEffect = CONST_ANI_THROWINGKNIFE, target = false },
}

monster.defenses = {
	defense = 65,
	armor = 55,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_HEALING, minDamage = 400, maxDamage = 600, radius = 8, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 18, speedChange = 784, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 7000 },
	{ name = "invisible", interval = 2000, chance = 20, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 40 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 40 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 35 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
