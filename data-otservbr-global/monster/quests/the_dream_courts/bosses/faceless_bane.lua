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
	{ id = 3035, chance = 80000, maxCount = 10 }, -- platinum coin
	{ id = 3029, chance = 80000, maxCount = 3 }, -- small sapphire
	{ id = 3277, chance = 23000, maxCount = 3 }, -- spear
	{ id = 3292, chance = 80000 }, -- combat knife
	{ id = 3291, chance = 23000 }, -- knife
	{ id = 3267, chance = 23000 }, -- dagger
	{ id = 3304, chance = 23000 }, -- crowbar
	{ id = 3066, chance = 23000 }, -- snakebite rod
	{ id = 3070, chance = 23000 }, -- moonlight rod
	{ id = 3284, chance = 23000 }, -- ice rapier
	{ id = 3069, chance = 23000 }, -- necrotic rod
	{ id = 3065, chance = 23000 }, -- terra rod
	{ id = 3067, chance = 23000 }, -- hailstorm rod
	{ id = 3061, chance = 23000 }, -- life crystal
	{ id = 16125, chance = 23000 }, -- cyan crystal fragment
	{ id = 16120, chance = 23000 }, -- violet crystal shard
	{ id = 3036, chance = 23000 }, -- violet gem
	{ id = 28571, chance = 1000 }, -- book backpack
	{ id = 29430, chance = 1000 }, -- ectoplasmic shield
	{ id = 29431, chance = 1000 }, -- spirit guide
	{ id = 30345, chance = 1000 }, -- enchanted pendulet
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 8082, chance = 80000 }, -- underworld rod
	{ id = 16121, chance = 80000 }, -- green crystal shard
	{ id = 16126, chance = 80000 }, -- red crystal fragment
	{ id = 10392, chance = 80000 }, -- twin hooks
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 816, chance = 80000 }, -- lightning pendant
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 30180, chance = 80000 }, -- hexagonal ruby
	{ id = 25700, chance = 80000 }, -- dream blossom staff
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 761, chance = 80000 }, -- flash arrow
	{ id = 3045, chance = 80000 }, -- strange talisman
	{ id = 8084, chance = 80000 }, -- springsprout rod
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
