local mType = Game.createMonsterType("Arbaziloth")
local monster = {}

monster.description = "Arbaziloth"
monster.experience = 500000
monster.outfit = {
	lookType = 1802,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 2594,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 360000
monster.maxHealth = 360000
monster.race = "fire"
monster.corpse = 50029
monster.speed = 160
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 40,
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
		{ name = "Overcharged Demon", chance = 12, interval = 2000, count = 2 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "I am superior!", yell = true },
	{ text = "You are mad to challange a demon prince!", yell = true },
	{ text = "You can't stop me or my plans!", yell = true },
	{ text = "Pesky humans!", yell = true },
	{ text = "This insolence!", yell = true },
	{ text = "Nobody can stop me!", yell = true },
	{ text = "All will have to bow to me!", yell = true },
	{ text = "With this power I can crush everyone!", yell = true },
	{ text = "All that energy is mine!", yell = true },
	{ text = "Face the power of hell!", yell = true },
	{ text = "AHHH! THE POWER!!", yell = true },
}

monster.loot = {
	{ id = 3043, chance = 80000, maxCount = 3 }, -- crystal coin
	{ id = 3041, chance = 80000, maxCount = 2 }, -- blue gem
	{ id = 3037, chance = 80000, maxCount = 2 }, -- yellow gem
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 237, chance = 80000, maxCount = 19 }, -- strong mana potion
	{ id = 238, chance = 80000, maxCount = 9 }, -- great mana potion
	{ id = 23373, chance = 80000, maxCount = 29 }, -- ultimate mana potion
	{ id = 7642, chance = 80000, maxCount = 4 }, -- great spirit potion
	{ id = 23374, chance = 80000, maxCount = 14 }, -- ultimate spirit potion
	{ id = 7643, chance = 80000, maxCount = 19 }, -- ultimate health potion
	{ id = 23375, chance = 80000, maxCount = 8 }, -- supreme health potion
	{ id = 3320, chance = 80000 }, -- fire axe
	{ id = 3281, chance = 80000 }, -- giant sword
	{ id = 3081, chance = 80000 }, -- stone skin amulet
	{ id = 817, chance = 80000 }, -- magma amulet
	{ id = 6299, chance = 80000 }, -- death ring
	{ id = 3052, chance = 80000 }, -- life ring
	{ id = 50061, chance = 80000 }, -- demon skull
	{ id = 50060, chance = 80000 }, -- demon claws
	{ id = 3373, chance = 80000 }, -- strange helmet
	{ id = 3356, chance = 80000 }, -- devil helmet
	{ id = 3284, chance = 80000 }, -- ice rapier
	{ id = 49534, chance = 80000 }, -- demonfang mask
	{ id = 49533, chance = 80000 }, -- dreadfire headpiece
	{ id = 49532, chance = 80000 }, -- hellstalker visor
	{ id = 49531, chance = 80000 }, -- maliceforged helmet
	{ id = 7382, chance = 80000 }, -- demonrage sword
	{ id = 3098, chance = 80000 }, -- ring of healing
	{ id = 30059, chance = 80000 }, -- giant ruby
	{ id = 30060, chance = 80000 }, -- giant emerald
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -1520, maxDamage = -2000 },
}

monster.defenses = {
	defense = 145,
	armor = 80,
	mitigation = 2.45,
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_HEALING, minDamage = 200, maxDamage = 600, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType.onAppear = function(monster, creature)
	if monster:getType():isRewardBoss() then
		monster:setReward(true)
	end
end

mType:register(monster)
