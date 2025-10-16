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
	{ id = 3031, chance = 80000, maxCount = 197 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 50 }, -- platinum coin
	{ id = 16120, chance = 80000, maxCount = 8 }, -- violet crystal shard
	{ id = 16121, chance = 80000, maxCount = 8 }, -- green crystal shard
	{ id = 16119, chance = 80000, maxCount = 7 }, -- blue crystal shard
	{ id = 5954, chance = 80000 }, -- demon horn
	{ id = 6499, chance = 80000 }, -- demonic essence
	{ id = 238, chance = 80000, maxCount = 10 }, -- great mana potion
	{ id = 7643, chance = 80000, maxCount = 10 }, -- ultimate health potion
	{ id = 20264, chance = 80000 }, -- unrealized dream
	{ id = 7642, chance = 80000, maxCount = 10 }, -- great spirit potion
	{ id = 20062, chance = 80000 }, -- cluster of solace
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 20276, chance = 80000 }, -- dream warden mask
	{ id = 3419, chance = 80000 }, -- crown shield
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 3315, chance = 80000 }, -- guardian halberd
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 7387, chance = 80000 }, -- diamond sceptre
	{ id = 3415, chance = 80000 }, -- guardian shield
	{ id = 3420, chance = 80000 }, -- demon shield
	{ id = 3340, chance = 80000 }, -- heavy mace
	{ id = 7421, chance = 80000 }, -- onyx flail
	{ id = 8063, chance = 80000 }, -- paladin armor
	{ id = 3414, chance = 80000 }, -- mastermind shield
	{ id = 7431, chance = 80000 }, -- demonbone
	{ id = 7428, chance = 80000 }, -- bonebreaker
	{ id = 8049, chance = 260 }, -- lavos armor
	{ id = 8100, chance = 260 }, -- obsidian truncheon
	{ id = 8061, chance = 80000 }, -- skullcracker armor
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
