local mType = Game.createMonsterType("Death Dragon")
local monster = {}

monster.description = "a death dragon"
monster.experience = 7200
monster.outfit = {
	lookType = 231,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 8350
monster.maxHealth = 8350
monster.race = "undead"
monster.corpse = 0
monster.speed = 165
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 5
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 700,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false
}

monster.events = {
	"DeathDragon"
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{text = "FEEEED MY ETERNAL HUNGER!", yell = true},
	{text = "I SENSE LIFE", yell = true}
}

monster.loot = {
	{id = 6499, chance = 14580}, -- demonic essence
	{id = 3031, chance = 100000, maxCount = 198}, -- gold coin
	{id = 239, chance = 23740, maxCount = 3}, -- great health potion
	{id = 238, chance = 25660, maxCount = 3}, -- great mana potion
	{id = 5925, chance = 14580}, -- hardened bone
	{id = 3035, chance = 49790, maxCount = 5}, -- platinum coin
	{id = 9058, chance = 1630}, -- gold ingot
	{id = 10316, chance = 32260}, -- unholy bone
	{id = 3061, chance = 1140}, -- life crystal
	{id = 7430, chance = 4290}, -- dragonbone staff
	{id = 3342, chance = 1630}, -- war axe
	{id = 7368, chance = 24630, maxCount = 5}, -- assassin star
	{id = 3450, chance = 15720, maxCount = 15}, -- power bolt
	{id = 3360, chance = 850}, -- golden armor
	{id = 10438, chance = 850}, -- spellweaver's robe
	{id = 3370, chance = 4930}, -- knight armor
	{id = 8057, chance = 500}, -- divine plate
	{id = 8061, chance = 530}, -- skullcracker armor
	{id = 3027, chance = 21290, maxCount = 2}, -- black pearl
	{id = 3029, chance = 27610, maxCount = 2}, -- small sapphire
	{id = 3041, chance = 1170}, -- blue gem
	{id = 3392, chance = 920}, -- royal helmet
	{id = 6299, chance = 1950}, -- death ring
	{id = 2903, chance = 5040} -- golden mug
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, skill = 150, attack = 60},
	{name ="combat", interval = 2000, chance = 9, type = COMBAT_EARTHDAMAGE, minDamage = -100, maxDamage = -400, range = 7, radius = 4, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = true},
	{name ="combat", interval = 2000, chance = 9, type = COMBAT_LIFEDRAIN, minDamage = -100, maxDamage = -400, range = 7, radius = 4, shootEffect = CONST_ANI_DEATH, target = true},
	{name ="combat", interval = 2000, chance = 11, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -615, range = 7, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_MORTAREA, target = false},
	{name ="undead dragon curse", interval = 2000, chance = 9, target = false},
	{name ="combat", interval = 2000, chance = 9, type = COMBAT_LIFEDRAIN, minDamage = -200, maxDamage = -700, length = 8, spread = 3, effect = CONST_ME_MAGIC_RED, target = false},
	{name ="combat", interval = 2000, chance = 9, type = COMBAT_DEATHDAMAGE, minDamage = -400, maxDamage = -550, length = 8, spread = 3, effect = CONST_ME_SMALLCLOUDS, target = false}
}

monster.defenses = {
	defense = 63,
	armor = 45,
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 200, maxDamage = 250, effect = CONST_ME_MAGIC_RED, target = false}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 10},
	{type = COMBAT_ENERGYDAMAGE, percent = 0},
	{type = COMBAT_EARTHDAMAGE, percent = 100},
	{type = COMBAT_FIREDAMAGE, percent = 100},
	{type = COMBAT_LIFEDRAIN, percent = 100},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 50},
	{type = COMBAT_HOLYDAMAGE , percent = -25},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
