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
	{ id = 3031, chance = 100000, maxCount = 197 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 50 }, -- Platinum Coin
	{ id = 16120, chance = 38120, maxCount = 8 }, -- Violet Crystal Shard
	{ id = 16121, chance = 29665, maxCount = 8 }, -- Green Crystal Shard
	{ id = 16119, chance = 32213, maxCount = 7 }, -- Blue Crystal Shard
	{ id = 5954, chance = 100000 }, -- Demon Horn
	{ id = 6499, chance = 59230 }, -- Demonic Essence
	{ id = 238, chance = 33812, maxCount = 10 }, -- Great Mana Potion
	{ id = 7643, chance = 32380, maxCount = 10 }, -- Ultimate Health Potion
	{ id = 20264, chance = 59230 }, -- Unrealized Dream
	{ id = 7642, chance = 33815, maxCount = 10 }, -- Great Spirit Potion
	{ id = 20062, chance = 100000 }, -- Cluster of Solace
	{ id = 281, chance = 43858 }, -- Giant Shimmering Pearl
	{ id = 9058, chance = 14512 }, -- Gold Ingot
	{ id = 20276, chance = 11326 }, -- Dream Warden Mask
	{ id = 3419, chance = 10846 }, -- Crown Shield
	{ id = 3041, chance = 15794 }, -- Blue Gem
	{ id = 3315, chance = 16110 }, -- Guardian Halberd
	{ id = 3038, chance = 20092 }, -- Green Gem
	{ id = 7387, chance = 7972 }, -- Diamond Sceptre
	{ id = 3415, chance = 16264 }, -- Guardian Shield
	{ id = 3420, chance = 6378 }, -- Demon Shield
	{ id = 3340, chance = 12922 }, -- Heavy Mace
	{ id = 7421, chance = 4309 }, -- Onyx Flail
	{ id = 8063, chance = 9088 }, -- Paladin Armor
	{ id = 3414, chance = 1390 }, -- Mastermind Shield
	{ id = 7431, chance = 700 }, -- Demonbone
	{ id = 7428, chance = 14830 }, -- Bonebreaker
	{ id = 8049, chance = 350 }, -- Lavos Armor
	{ id = 8100, chance = 315 }, -- Obsidian Truncheon
	{ id = 8061, chance = 520 }, -- Skullcracker Armor
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
