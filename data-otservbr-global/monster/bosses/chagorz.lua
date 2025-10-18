local mType = Game.createMonsterType("Chagorz")
local monster = {}

monster.description = "Chagorz"
monster.experience = 3250000
monster.outfit = {
	lookType = 1666,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"RottenBloodBossDeath",
}

monster.bosstiary = {
	bossRaceId = 2366,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 350000
monster.maxHealth = 350000
monster.race = "undead"
monster.corpse = 44024
monster.speed = 250
monster.manaCost = 0

monster.changeTarget = {
	interval = 10000,
	chance = 20,
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
	staticAttackChance = 98,
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

monster.summon = {}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "The light... that... drains!", yell = false },
	{ text = "RAAAR!", yell = false },
	{ text = "WILL ... PUNISH ... YOU!", yell = false },
	{ text = "Darkness ... devours!", yell = false },
}

monster.loot = {
	{ id = 0, chance = 1000 }, -- This creature drops no loot.
	{ id = 43860, chance = 2777 }, -- Bag You Covet
	{ id = 7439, chance = 11111, maxCount = 40 }, -- Berserk Potion
	{ id = 3041, chance = 19512 }, -- Blue Gem
	{ id = 7443, chance = 29268, maxCount = 31 }, -- Bullseye Potion
	{ id = 3043, chance = 100000, maxCount = 100 }, -- Crystal Coin
	{ id = 43961, chance = 2777 }, -- Darklight Figurine
	{ id = 32623, chance = 26829 }, -- Giant Topaz
	{ id = 30061, chance = 24390 }, -- Giant Sapphire
	{ id = 9058, chance = 8333 }, -- Gold Ingot
	{ id = 3038, chance = 41463 }, -- Green Gem
	{ id = 7440, chance = 36585, maxCount = 27 }, -- Mastermind Potion
	{ id = 33778, chance = 1000 }, -- Raw Watermelon Tourmaline
	{ id = 3039, chance = 41463 }, -- Red Gem
	{ id = 23375, chance = 58536, maxCount = 164 }, -- Supreme Health Potion
	{ id = 43504, chance = 1000 }, -- The Essence of Chagorz
	{ id = 30054, chance = 2777 }, -- Unicorn Figurine
	{ id = 23373, chance = 48780, maxCount = 98 }, -- Ultimate Mana Potion
	{ id = 23374, chance = 39024, maxCount = 127 }, -- Ultimate Spirit Potion
	{ id = 3036, chance = 21951 }, -- Violet Gem
	{ id = 32769, chance = 9756, maxCount = 3 }, -- White Gem
	{ id = 3037, chance = 39024 }, -- Yellow Gem
	{ id = 49372, chance = 2777 }, -- Spiritualist Gem
	{ id = 43966, chance = 2777 }, -- Chagorz Igneous Obsidian
	{ id = 32622, chance = 48780, maxCount = 2 }, -- Giant Amethyst
	{ id = 49271, chance = 27777, maxCount = 39 }, -- Transcendence Potion
	{ id = 30053, chance = 2777 }, -- Dragon Figurine
	{ id = 43900, chance = 2777 }, -- Darklight Geode
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -1300, maxDamage = -2250 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -500, maxDamage = -900, radius = 4, effect = CONST_ME_GREEN_RINGS, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -500, maxDamage = -900, range = 4, radius = 4, effect = 241, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -1000, maxDamage = -1200, length = 10, spread = 0, effect = CONST_ME_POFF, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -1500, maxDamage = -1900, length = 10, spread = 0, effect = 225, target = false },
	{ name = "speed", interval = 2000, chance = 20, speedChange = -600, radius = 7, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 20000 },
}

monster.defenses = {
	defense = 105,
	armor = 105,
	{ name = "combat", interval = 3000, chance = 10, type = COMBAT_HEALING, minDamage = 700, maxDamage = 1500, effect = 236, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 15 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType.onThink = function(monster, interval) end

mType.onAppear = function(monster, creature)
	if monster:getType():isRewardBoss() then
		monster:setReward(true)
	end
end

mType.onDisappear = function(monster, creature) end

mType.onMove = function(monster, creature, fromPosition, toPosition) end

mType.onSay = function(monster, creature, type, message) end

mType:register(monster)
