local mType = Game.createMonsterType("Faceless Bane")
local monster = {}

monster.description = "Faceless Bane"
monster.experience = 20000
monster.outfit = {
	lookType = 1119,
	lookHead = 0,
	lookBody = 2,
	lookLegs = 95,
	lookFeet = 97,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 35000
monster.maxHealth = 35000
monster.race = "blood"
monster.corpse = 30013
monster.speed = 125
monster.manaCost = 0

monster.events = {
	"dreamCourtsDeath",
	"facelessThink",
}

monster.changeTarget = {
	interval = 4000,
	chance = 20,
}

monster.reflects = {
	{ type = COMBAT_DEATHDAMAGE, percent = 90 },
}

monster.bosstiary = {
	bossRaceId = 1727,
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
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
	{ id = 3035, chance = 100000, maxCount = 19 }, -- Platinum Coin
	{ id = 3267, chance = 56000 }, -- Dagger
	{ id = 3029, chance = 45000, maxCount = 5 }, -- Small Sapphire
	{ id = 3065, chance = 24000 }, -- Terra Rod
	{ id = 3039, chance = 22000 }, -- Red Gem
	{ id = 3277, chance = 21000, maxCount = 5 }, -- Spear
	{ id = 3284, chance = 17800 }, -- Ice Rapier
	{ id = 16126, chance = 13900 }, -- Red Crystal Fragment
	{ id = 16125, chance = 13900 }, -- Cyan Crystal Fragment
	{ id = 3304, chance = 13900 }, -- Crowbar
	{ id = 3291, chance = 11900 }, -- Knife
	{ id = 3066, chance = 9900 }, -- Snakebite Rod
	{ id = 10392, chance = 7900 }, -- Twin Hooks
	{ id = 3061, chance = 6900 }, -- Life Crystal
	{ id = 9058, chance = 5900 }, -- Gold Ingot
	{ id = 16121, chance = 5900 }, -- Green Crystal Shard
	{ id = 3070, chance = 5000 }, -- Moonlight Rod
	{ id = 3067, chance = 5000 }, -- Hailstorm Rod
	{ id = 281, chance = 5000 }, -- Giant Shimmering Pearl
	{ id = 3041, chance = 5000 }, -- Blue Gem
	{ id = 16120, chance = 4000 }, -- Violet Crystal Shard
	{ id = 3069, chance = 4000 }, -- Necrotic Rod
	{ id = 3060, chance = 4000 }, -- Orb
	{ id = 30180, chance = 4000 }, -- Hexagonal Ruby
	{ id = 3038, chance = 4000 }, -- Green Gem
	{ id = 3037, chance = 3000 }, -- Yellow Gem
	{ id = 16096, chance = 2000 }, -- Wand of Defiance
	{ id = 8082, chance = 2000 }, -- Underworld Rod
	{ id = 761, chance = 2000, maxCount = 6 }, -- Flash Arrow
	{ id = 8084, chance = 2000 }, -- Springsprout Rod
	{ id = 816, chance = 990 }, -- Lightning Pendant
	{ id = 16117, chance = 990 }, -- Muck Rod
	{ id = 29430, chance = 990 }, -- Ectoplasmic Shield
	{ id = 28571, chance = 990 }, -- Book Backpack
	{ id = 16115, chance = 990 }, -- Wand of Everblazing
}

monster.attacks = {
	{ name = "melee", type = COMBAT_PHYSICALDAMAGE, interval = 2000, minDamage = 0, maxDamage = -575 },
	{ name = "combat", interval = 2000, chance = 65, type = COMBAT_FIREDAMAGE, minDamage = -350, maxDamage = -500, radius = 3, Effect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = false },
	{ name = "combat", interval = 2000, chance = 45, type = COMBAT_DEATHDAMAGE, minDamage = -335, maxDamage = -450, radius = 4, Effect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_PHYSICALDAMAGE, minDamage = -330, maxDamage = -380, length = 7, effect = CONST_ME_EXPLOSIONAREA, target = false },
	{ name = "combat", interval = 2000, chance = 35, type = COMBAT_FIREDAMAGE, minDamage = -300, maxDamage = -410, range = 4, radius = 4, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -385, maxDamage = -535, range = 4, radius = 1, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYAREA, target = true },
}

monster.defenses = {
	defense = 5,
	armor = 10,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 50 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType.onSpawn = function(monster, spawnPosition)
	if monster:getType():isRewardBoss() then
		-- reset global storage state to default / ensure sqm's reset for the next team
		Game.setStorageValue(GlobalStorage.TheDreamCourts.FacelessBane.Deaths, -1)
		Game.setStorageValue(GlobalStorage.TheDreamCourts.FacelessBane.StepsOn, -1)
		Game.setStorageValue(GlobalStorage.TheDreamCourts.FacelessBane.ResetSteps, 1)
		monster:registerEvent("facelessBaneImmunity")
		monster:setReward(true)
	end
end

mType:register(monster)
