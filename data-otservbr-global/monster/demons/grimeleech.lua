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
	lookMount = 0,
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
	Locations = "Grounds of Damnation, Grounds of Deceit, Grounds of Despair, Grounds of Fire, Grounds of Plague, Halls of Ascension and Hell Hub.",
}

monster.health = 9500
monster.maxHealth = 9500
monster.race = "undead"
monster.corpse = 22780
monster.speed = 170
monster.manaCost = 0

monster.changeTarget = {
	interval = 3000,
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
	rewardBoss = false,
	illusionable = false,
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
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Death... Taste!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 91000, maxCount = 193 }, -- Gold Coin
	{ id = 3035, chance = 87000, maxCount = 4 }, -- Platinum Coin
	{ id = 7642, chance = 30000, maxCount = 3 }, -- Great Spirit Potion
	{ id = 238, chance = 27000, maxCount = 3 }, -- Great Mana Potion
	{ id = 6558, chance = 24000, maxCount = 3 }, -- Flask of Demonic Blood
	{ id = 239, chance = 20000, maxCount = 3 }, -- Great Health Potion
	{ id = 22730, chance = 18100 }, -- Some Grimeleech Wings
	{ id = 3731, chance = 12800, maxCount = 5 }, -- Fire Mushroom
	{ id = 6499, chance = 11700 }, -- Demonic Essence
	{ id = 3732, chance = 10600, maxCount = 5 }, -- Green Mushroom
	{ id = 9057, chance = 7400, maxCount = 4 }, -- Small Topaz
	{ id = 3030, chance = 7400, maxCount = 4 }, -- Small Ruby
	{ id = 8082, chance = 5300 }, -- Underworld Rod
	{ id = 8094, chance = 4300 }, -- Wand of Voodoo
	{ id = 3028, chance = 4300, maxCount = 4 }, -- Small Diamond
	{ id = 3033, chance = 4300, maxCount = 3 }, -- Small Amethyst
	{ id = 22727, chance = 1100 }, -- Rift Lance
	{ id = 22867, chance = 1100 }, -- Rift Crossbow
	{ id = 3356, chance = 1100 }, -- Devil Helmet
	{ id = 22726, chance = 1100 }, -- Rift Shield
	{ id = 3039, chance = 1100 }, -- Red Gem
	{ id = 3037, chance = 1100 }, -- Yellow Gem
	{ id = 821, chance = 3700 }, -- Magma Legs
	{ id = 3420, chance = 740 }, -- Demon Shield
	{ id = 7418, chance = 570 }, -- Nightmare Blade
	{ id = 3041, chance = 3700 }, -- Blue Gem
	{ id = 3554, chance = 230 }, -- Steel Boots
	{ id = 22866, chance = 340 }, -- Rift Bow
	{ id = 7414, chance = 180 }, -- Abyss Hammer
	{ id = 7388, chance = 130 }, -- Vile Axe
	{ id = 3366, chance = 80 }, -- Magic Plate Armor
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 70, attack = 80 },
	{ name = "melee", interval = 2000, chance = 2, skill = 153, attack = 100 },
	{ name = "combat", interval = 2000, chance = 14, type = COMBAT_LIFEDRAINDAMAGE, minDamage = 100, maxDamage = -565, range = 7, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_MORTAREA, target = true },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_LIFEDRAINDAMAGE, minDamage = -150, maxDamage = -220, length = 8, spread = 0, effect = CONST_ME_MAGIC_GREEN, target = false },
	{ name = "combat", interval = 2000, chance = 13, type = COMBAT_DEATHDAMAGE, minDamage = -225, maxDamage = -375, radius = 4, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 9, type = COMBAT_MANADRAINDAMAGE, minDamage = 0, maxDamage = -300, length = 8, spread = 3, effect = CONST_ME_MAGIC_RED, target = false },
}

monster.defenses = {
	defense = 30,
	armor = 65,
	mitigation = 1.74,
	{ name = "combat", interval = 2000, chance = 16, type = COMBAT_HEALING, minDamage = 130, maxDamage = 205, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "effect", interval = 2000, chance = 9, effect = CONST_ME_MAGIC_GREEN, target = false },
	{ name = "effect", interval = 2000, chance = 10, target = false },
	{ name = "speed", interval = 2000, chance = 12, speedChange = 532, effect = CONST_ME_MAGIC_RED, target = false, duration = 4000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 60 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
