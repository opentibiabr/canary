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
	{ id = 3031, chance = 100000, maxCount = 159 }, -- Gold Coin
	{ id = 3035, chance = 19250, maxCount = 24 }, -- Platinum Coin
	{ id = 9058, chance = 18966 }, -- Gold Ingot
	{ id = 7440, chance = 17530, maxCount = 2 }, -- Mastermind Potion
	{ id = 5944, chance = 30461, maxCount = 4 }, -- Soul Orb
	{ id = 7366, chance = 17360, maxCount = 50 }, -- Viper Star
	{ id = 7368, chance = 22640, maxCount = 30 }, -- Assassin Star
	{ id = 3033, chance = 1000, maxCount = 20 }, -- Small Amethyst
	{ id = 7439, chance = 18966, maxCount = 2 }, -- Berserk Potion
	{ id = 6528, chance = 22660, maxCount = 49 }, -- Infernal Bolt
	{ id = 3450, chance = 20380, maxCount = 82 }, -- Power Bolt
	{ id = 763, chance = 18490, maxCount = 99 }, -- Flaming Arrow
	{ id = 5954, chance = 13432, maxCount = 2 }, -- Demon Horn
	{ id = 281, chance = 44250, maxCount = 4 }, -- Giant Shimmering Pearl
	{ id = 7643, chance = 14329 }, -- Ultimate Health Potion
	{ id = 239, chance = 14943 }, -- Great Health Potion
	{ id = 7642, chance = 12070 }, -- Great Spirit Potion
	{ id = 238, chance = 11782 }, -- Great Mana Potion
	{ id = 3415, chance = 9256 }, -- Guardian Shield
	{ id = 3269, chance = 20119 }, -- Halberd
	{ id = 3315, chance = 20692 }, -- Guardian Halberd
	{ id = 3039, chance = 20114 }, -- Red Gem
	{ id = 3037, chance = 21264 }, -- Yellow Gem
	{ id = 3041, chance = 21837 }, -- Blue Gem
	{ id = 3038, chance = 19543 }, -- Green Gem
	{ id = 3036, chance = 17240 }, -- Violet Gem
	{ id = 3054, chance = 1000 }, -- Silver Amulet
	{ id = 3010, chance = 20400 }, -- Emerald Bangle
	{ id = 3049, chance = 1000 }, -- Stealth Ring
	{ id = 3098, chance = 1000 }, -- Ring of Healing
	{ id = 7387, chance = 8061 }, -- Diamond Sceptre
	{ id = 3420, chance = 4306 }, -- Demon Shield
	{ id = 3414, chance = 2988 }, -- Mastermind Shield
	{ id = 8896, chance = 60633 }, -- Slightly Rusted Armor
	{ id = 3419, chance = 13790 }, -- Crown Shield
	{ id = 3428, chance = 8906 }, -- Tower Shield
	{ id = 8063, chance = 10447 }, -- Paladin Armor
	{ id = 3340, chance = 29596 }, -- Heavy Mace
	{ id = 8061, chance = 1430 }, -- Skullcracker Armor
	{ id = 7421, chance = 12645 }, -- Onyx Flail
	{ id = 8100, chance = 1491 }, -- Obsidian Truncheon
	{ id = 7431, chance = 1493 }, -- Demonbone
	{ id = 8101, chance = 1190 }, -- The Stomper
	{ id = 8049, chance = 1192 }, -- Lavos Armor
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
