--# Monster converted using Devm monster converter #--
local mType = Game.createMonsterType("Grimeleech")
local monster = {}

monster.description = "a grimeleech"
monster.experience = 7216
monster.outfit = {
	lookType = 855,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.raceId = 1196
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "The Dungeons of The Ruthless Seven."
	}

monster.health = 9500
monster.maxHealth = 9500
monster.race = "undead"
monster.corpse = 22780
monster.speed = 340
monster.manaCost = 0
monster.maxSummons = 0

monster.changeTarget = {
	interval = 3000,
	chance = 20
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true,
	pet = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "Death... Taste!", yell = true}
}

monster.loot = {
	{id = 3031, chance = 100000, maxCount = 197}, -- gold coin
	{id = 3035, chance = 100000, maxCount = 8}, -- platinum coin
	{id = 238, chance = 34850, maxCount = 3}, -- great mana potion
	{id = 239, chance = 34290, maxCount = 3}, -- great health potion
	{id = 7642, chance = 30860, maxCount = 3}, -- great spirit potion
	{id = 6558, chance = 23400, maxCount = 3}, -- concentrated demonic blood
	{id = 6499, chance = 19240}, -- demonic essence
	{id = 22730, chance = 19080}, -- some grimeleech wings
	{id = 3731, chance = 15360, maxCount = 5}, -- fire mushroom
	{id = 3732, chance = 14800, maxCount = 5}, -- green mushroom
	{id = 3028, chance = 11290, maxCount = 5}, -- small diamond
	{id = 3030, chance = 10750, maxCount = 5}, -- small ruby
	{id = 9057, chance = 9660, maxCount = 5}, -- small topaz
	{id = 3033, chance = 9640, maxCount = 5}, -- small amethyst
	{id = 8082, chance = 6890}, -- underworld rod
	{id = 8094, chance = 4810}, -- wand of voodoo
	{id = 3039, chance = 3930}, -- red gem
	{id = 3037, chance = 2900}, -- yellow gem
	{id = 3356, chance = 1360}, -- devil helmet
	{id = 821, chance = 1150}, -- magma legs
	{id = 3420, chance = 1010}, -- demon shield
	{id = 7418, chance = 930}, -- nightmare blade
	{id = 3041, chance = 780}, -- blue gem
	{id = 22867, chance = 720}, -- rift crossbow
	{id = 3554, chance = 640}, -- steel boots
	{id = 22726, chance = 620}, -- rift shield
	{id = 22727, chance = 580}, -- rift lance
	{id = 22866, chance = 370}, -- rift bow
	{id = 7414, chance = 210}, -- abyss hammer
	{id = 7388, chance = 180}, -- vile axe
	{id = 3366, chance = 60} -- magic plate armor
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 70, attack = 80},
	{name ="melee", interval = 2000, chance = 2, skill = 153, attack = 100},
	{name ="combat", interval = 2000, chance = 14, type = COMBAT_PHYSICALDAMAGE, minDamage = 100, maxDamage = -565, range = 7, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_MORTAREA, target = true},
	{name ="combat", interval = 2000, chance = 12, type = COMBAT_DEATHDAMAGE, minDamage = -150, maxDamage = -220, length = 8, spread = 3, target = false},
	{name ="combat", interval = 2000, chance = 13, type = COMBAT_DEATHDAMAGE, minDamage = -225, maxDamage = -375, radius = 4, target = false},
	{name ="combat", interval = 2000, chance = 9, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -300, length = 8, spread = 3, effect = CONST_ME_EXPLOSIONAREA, target = false}
}

monster.defenses = {
	defense = 30,
	armor = 30,
	{name ="combat", interval = 2000, chance = 16, type = COMBAT_HEALING, minDamage = 130, maxDamage = 205, effect = CONST_ME_MAGIC_RED, target = false},
	{name ="effect", interval = 2000, chance = 9, effect = CONST_ME_MAGIC_GREEN, target = false},
	{name ="effect", interval = 2000, chance = 10, target = false},
	{name ="speed", interval = 2000, chance = 12, speedChange = 532, effect = CONST_ME_MAGIC_RED, target = false, duration = 4000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 20},
	{type = COMBAT_ENERGYDAMAGE, percent = -10},
	{type = COMBAT_EARTHDAMAGE, percent = 40},
	{type = COMBAT_FIREDAMAGE, percent = -10},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 65},
	{type = COMBAT_HOLYDAMAGE , percent = -10},
	{type = COMBAT_DEATHDAMAGE , percent = 80}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
