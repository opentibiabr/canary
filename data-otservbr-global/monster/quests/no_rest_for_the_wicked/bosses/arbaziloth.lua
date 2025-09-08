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
	{ name = "crystal coin", chance = 5000, minCount = 1, maxCount = 3 },
	{ name = "platinum coin", chance = 5000, minCount = 50, maxCount = 100 },
	{ name = "strong mana potion", chance = 3500, minCount = 11, maxCount = 20 },
	{ name = "great mana potion", chance = 3000, minCount = 2, maxCount = 15 },
	{ name = "great spirit potion", chance = 2900, maxCount = 6 },
	{ name = "ultimate mana potion", chance = 3000, minCount = 20, maxCount = 40 },
	{ name = "ultimate health potion", chance = 3500, minCount = 10, maxCount = 20 },
	{ name = "supreme health potion", chance = 2900, minCount = 5, maxCount = 10 },
	{ name = "ultimate spirit potion", chance = 3500, minCount = 2, maxCount = 14 },
	{ name = "blue gem", chance = 2900, maxCount = 2 },
	{ id = 3039, chance = 2500, maxCount = 2 }, -- red gem
	{ name = "yellow gem", chance = 2000, maxCount = 2 },
	{ id = 6299, chance = 1900 }, -- death ring
	{ name = "devil helmet", chance = 1800 },
	{ name = "fire axe", chance = 1700 },
	{ name = "fire sword", chance = 1600 },
	{ name = "giant sword", chance = 1500 },
	{ name = "gold ring", chance = 1400 },
	{ name = "golden sickle", chance = 1300 },
	{ name = "ice rapier", chance = 1200 },
	{ id = 3052, chance = 1150 }, -- life ring
	{ name = "magma amulet", chance = 1100 },
	{ name = "magma legs", chance = 1050 },
	{ id = 3048, chance = 1890 }, -- might ring
	{ name = "platinum amulet", chance = 1000 },
	{ name = "purple tome", chance = 1000 },
	{ id = 3098, chance = 1300 }, -- ring of healing
	{ name = "silver amulet", chance = 1000 },
	{ name = "skull staff", chance = 1000 },
	{ name = "spellweaver's robe", chance = 1300 },
	{ name = "stone skin amulet", chance = 900 },
	{ name = "strange helmet", chance = 1000 },
	{ name = "underworld rod", chance = 1600 },
	{ name = "wand of inferno", chance = 1600 },
	{ name = "arbaziloth shoulder piece", chance = 900 },
	{ name = "demon shield", chance = 900 },
	{ name = "demonbone amulet", chance = 900 },
	{ name = "demonrage sword", chance = 900 },
	{ name = "giant amethyst", chance = 900 },
	{ name = "giant emerald", chance = 900 },
	{ name = "giant ruby", chance = 900 },
	{ name = "giant sapphire", chance = 900 },
	{ name = "golden legs", chance = 900 },
	{ name = "magic plate armor", chance = 900 },
	{ name = "demon claws", chance = 100 }, -- first addon fiend slayer
	{ id = 50061, chance = 100 }, -- demon skull second addon fiend slayer
	{ name = "demon in a green box", chance = 90 }, -- primal demonosaur mount
	{ name = "inferniarch arbalest", chance = 100 },
	{ name = "inferniarch battleaxe", chance = 100 },
	{ name = "inferniarch blade", chance = 100 },
	{ name = "inferniarch bow", chance = 100 },
	-- { name = "inferniarch claws", chance = 100 }, -- monk item, not implemented
	{ name = "inferniarch flail", chance = 100 },
	{ name = "inferniarch greataxe", chance = 100 },
	{ name = "inferniarch rod", chance = 100 },
	{ name = "inferniarch slayer", chance = 100 },
	{ name = "inferniarch wand", chance = 100 },
	{ name = "inferniarch warhammer", chance = 100 },
	{ name = "maliceforged helmet", chance = 100 },
	{ name = "hellstalker visor", chance = 100 },
	{ name = "dreadfire headpiece", chance = 100 },
	{ name = "demonfang mask", chance = 100 },
	-- { name = "demon mengu", chance = 300 }, -- monk item, not implemented
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
