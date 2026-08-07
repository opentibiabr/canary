local mType = Game.createMonsterType("Annihilon")
local monster = {}

monster.description = "Annihilon"
monster.experience = 15000
monster.outfit = {
	lookType = 12,
	lookHead = 3,
	lookBody = 9,
	lookLegs = 77,
	lookFeet = 77,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"InquisitionBossDeath",
}

monster.bosstiary = {
	bossRaceId = 418,
	bossRace = RARITY_BANE,
}

monster.health = 46500
monster.maxHealth = 46500
monster.race = "fire"
monster.corpse = 6068
monster.speed = 66
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 85,
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
	{ text = "Flee as long as you can!", yell = false },
	{ text = "Annihilon's might will crush you all!", yell = false },
	{ text = "I am coming for you!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 100 }, -- Gold Coin
	{ id = 8896, chance = 62000 }, -- Slightly Rusted Armor
	{ id = 281, chance = 37000, maxCount = 2 }, -- Giant Shimmering Pearl
	{ id = 3340, chance = 28000 }, -- Heavy Mace
	{ id = 3041, chance = 22000 }, -- Blue Gem
	{ id = 3010, chance = 22000 }, -- Emerald Bangle
	{ id = 5944, chance = 22000, maxCount = 5 }, -- Soul Orb
	{ id = 3315, chance = 22000 }, -- Guardian Halberd
	{ id = 6528, chance = 21000, maxCount = 50 }, -- Infernal Bolt
	{ id = 3037, chance = 21000 }, -- Yellow Gem
	{ id = 7368, chance = 21000, maxCount = 50 }, -- Assassin Star
	{ id = 3450, chance = 20000, maxCount = 99 }, -- Power Bolt
	{ id = 3269, chance = 20000 }, -- Halberd
	{ id = 763, chance = 19700, maxCount = 100 }, -- Flaming Arrow
	{ id = 9058, chance = 19500 }, -- Gold Ingot
	{ id = 3039, chance = 19200 }, -- Red Gem
	{ id = 3038, chance = 18900 }, -- Green Gem
	{ id = 3035, chance = 18400, maxCount = 30 }, -- Platinum Coin
	{ id = 3036, chance = 18400 }, -- Violet Gem
	{ id = 7366, chance = 17900, maxCount = 70 }, -- Viper Star
	{ id = 7439, chance = 17100 }, -- Berserk Potion
	{ id = 239, chance = 16000 }, -- Great Health Potion
	{ id = 7643, chance = 14700 }, -- Ultimate Health Potion
	{ id = 238, chance = 14400 }, -- Great Mana Potion
	{ id = 7440, chance = 14400 }, -- Mastermind Potion
	{ id = 7642, chance = 13100 }, -- Great Spirit Potion
	{ id = 7421, chance = 12800 }, -- Onyx Flail
	{ id = 5954, chance = 11700, maxCount = 2 }, -- Demon Horn
	{ id = 3419, chance = 10700 }, -- Crown Shield
	{ id = 3428, chance = 9900 }, -- Tower Shield
	{ id = 8063, chance = 9900 }, -- Paladin Armor
	{ id = 7387, chance = 8300 }, -- Diamond Sceptre
	{ id = 3415, chance = 8000 }, -- Guardian Shield
	{ id = 3420, chance = 4500 }, -- Demon Shield
	{ id = 3414, chance = 4000 }, -- Mastermind Shield
	{ id = 8049, chance = 1900 }, -- Lavos Armor
	{ id = 7431, chance = 1100 }, -- Demonbone
	{ id = 8100, chance = 1100 }, -- Obsidian Truncheon
	{ id = 8101, chance = 530 }, -- The Stomper
	{ id = 8061, chance = 270 }, -- Skullcracker Armor
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1707 },
	{ name = "combat", interval = 1000, chance = 11, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -600, length = 8, spread = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -200, maxDamage = -700, radius = 4, effect = CONST_ME_ICEAREA, target = false },
	{ name = "combat", interval = 3000, chance = 18, type = COMBAT_PHYSICALDAMAGE, minDamage = -50, maxDamage = -255, radius = 5, effect = CONST_ME_GROUNDSHAKER, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -50, maxDamage = -600, radius = 6, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
}

monster.defenses = {
	defense = 55,
	armor = 60,
	--	mitigation = ???,
	{ name = "combat", interval = 1000, chance = 14, type = COMBAT_HEALING, minDamage = 400, maxDamage = 900, effect = CONST_ME_MAGIC_GREEN, target = false },
	{ name = "speed", interval = 1000, chance = 4, speedChange = 500, effect = CONST_ME_MAGIC_BLUE, target = false, duration = 7000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 95 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 95 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
