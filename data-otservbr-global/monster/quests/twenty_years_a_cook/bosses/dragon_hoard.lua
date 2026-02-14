local mType = Game.createMonsterType("Dragon Hoard")
local monster = {}

monster.description = "Dragon Hoard"
monster.experience = 0
monster.outfit = {
	lookTypeEx = 5674,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"TwentyYearsACookBossDeath",
}

monster.bosstiary = {
	bossRace = RARITY_ARCHFOE,
	bossRaceId = 2466,
}

monster.health = 999999
monster.maxHealth = 999999
monster.race = "blood"
monster.corpse = 0
monster.speed = 0
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 4,
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
	hostile = false,
	convinceable = false,
	pushable = false,
	boss = true,
	rewardBoss = true,
	illusionable = false,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 100,
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

monster.loot = {
	{ id = 3043, chance = 100000, maxCount = 4 }, -- Crystal coin
	{ id = 3035, chance = 100000, maxCount = 199 }, -- Platinum coin
	{ id = 3031, chance = 100000, maxCount = 384 }, -- Gold Coin
	{ id = 3041, chance = 31818, maxCount = 2 }, -- Blue Gem
	{ id = 32769, chance = 31818, maxCount = 2 }, -- White Gem
	{ id = 7441, chance = 27273 }, -- ice Cube
	{ id = 3373, chance = 22727 }, -- Strange Helmet
	{ id = 6499, chance = 22727, maxCount = 2 }, -- Demonic Essence
	{ id = 3061, chance = 22727 }, -- Life Crystal
	{ id = 3037, chance = 22727, maxCount = 2 }, -- Yellow Gem
	{ id = 3392, chance = 18182 }, -- Royal Helmet
	{ id = 3071, chance = 13636 }, -- Wand of Inferno
	{ id = 7290, chance = 9091 }, -- Shard
	{ id = 3297, chance = 9091 }, -- Serpent Sword
	{ id = 10388, chance = 9091 }, -- Drakinata
	{ id = 7402, chance = 9091 }, -- Dragon Slayer
	{ id = 3280, chance = 9091 }, -- Fire Sword
	{ id = 44603, chance = 4545, maxCount = 2 }, -- Guardian Gem
	{ id = 7430, chance = 4545 }, -- Dragonbone Staff
	{ id = 44609, chance = 4545, maxCount = 2 }, -- Sage Gem
	{ id = 44605, chance = 4545, maxCount = 2 }, -- Lesser Marksman Gem
	{ id = 8057, chance = 4545 }, -- Divine Plate
	{ id = 32622, chance = 4245 }, -- Giant Amethyst
	{ id = 32623, chance = 3245 }, -- Giant Topaz
	{ id = 10451, chance = 2745 }, -- Jade Hat
	{ id = 44602, chance = 5545, maxCount = 2 }, -- Lesser Guardian Gem
	{ id = 30061, chance = 4545 }, -- Giant Sapphire
	{ id = 3428, chance = 7545 }, -- Tower Shield
	{ id = 44623, chance = 1143 }, -- Arcane Dragon Robe
	{ id = 44621, chance = 1427 }, -- Dauntless Dragon Scale Armor
	{ id = 44622, chance = 1556 }, -- Unerring Dragon Scale Armor
	{ id = 44624, chance = 1285 }, -- Mystical Dragon Robe
	{ id = 50264, chance = 1285 }, -- Merudri Battle Mail
	{ id = 44753, chance = 862 }, -- Herald's Insignia
	{ id = 44754, chance = 920 }, -- Herald's Wings
}

monster.attacks = {}

monster.defenses = {
	defense = 40,
	armor = 40,
	--	mitigation = ???,
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
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = true },
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
