local mType = Game.createMonsterType("Hellflayer")
local monster = {}

monster.description = "a hellflayer"
monster.experience = 11720
monster.outfit = {
	lookType = 856,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1198
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Grounds of Damnation, Grounds of Despair, Grounds of Destruction, Grounds of Fire, Grounds of Plague, Grounds of Undeath, Halls of Ascension and Hell Hub",
}

monster.health = 14000
monster.maxHealth = 14000
monster.race = "blood"
monster.corpse = 22784
monster.speed = 165
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	{ text = "Your tainted soul belongs to us anyway!", yell = false },
	{ text = "You should consider bargaining for your life!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 97222, maxCount = 200 }, -- Gold Coin
	{ id = 3035, chance = 96694, maxCount = 12 }, -- Platinum Coin
	{ id = 6558, chance = 26647, maxCount = 3 }, -- Flask of Demonic Blood
	{ id = 6499, chance = 22047 }, -- Demonic Essence
	{ id = 22729, chance = 19761 }, -- Pair of Hellflayer Horns
	{ id = 7642, chance = 17758, maxCount = 5 }, -- Great Spirit Potion
	{ id = 238, chance = 17869, maxCount = 5 }, -- Great Mana Potion
	{ id = 7643, chance = 15756, maxCount = 5 }, -- Ultimate Health Potion
	{ id = 3033, chance = 10541, maxCount = 5 }, -- Small Amethyst
	{ id = 3032, chance = 10223, maxCount = 5 }, -- Small Emerald
	{ id = 3028, chance = 9305, maxCount = 5 }, -- Small Diamond
	{ id = 9058, chance = 8597, maxCount = 2 }, -- Gold Ingot
	{ id = 3030, chance = 8870, maxCount = 5 }, -- Small Ruby
	{ id = 9057, chance = 8476, maxCount = 5 }, -- Small Topaz
	{ id = 281, chance = 4439 }, -- Giant Shimmering Pearl (Green)
	{ id = 3039, chance = 2377 }, -- Red Gem
	{ id = 3036, chance = 1578 }, -- Violet Gem
	{ id = 22727, chance = 1443 }, -- Rift Lance
	{ id = 818, chance = 1345 }, -- Magma Boots
	{ id = 821, chance = 1087 }, -- Magma Legs
	{ id = 3038, chance = 804 }, -- Green Gem
	{ id = 7413, chance = 744 }, -- Titan Axe
	{ id = 3414, chance = 661 }, -- Mastermind Shield
	{ id = 22726, chance = 715 }, -- Rift Shield
	{ id = 22867, chance = 634 }, -- Rift Crossbow
	{ id = 22866, chance = 398 }, -- Rift Bow
	{ id = 3360, chance = 472 }, -- Golden Armor
	{ id = 3019, chance = 210 }, -- Demonbone Amulet
	{ id = 5741, chance = 232 }, -- Skull Helmet
	{ id = 3366, chance = 84 }, -- Magic Plate Armor
	{ id = 8074, chance = 49 }, -- Spellbook of Mind Control
	{ id = 3340, chance = 59 }, -- Heavy Mace
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 200, maxDamage = -869, condition = { type = CONDITION_FIRE, totalDamage = 6, interval = 9000 } },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -170, maxDamage = -300, range = 7, shootEffect = CONST_ANI_POISON, target = false },
	{ name = "choking fear drown", interval = 2000, chance = 20, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -250, maxDamage = -500, radius = 4, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -50, maxDamage = -200, length = 8, spread = 0, effect = CONST_ME_PURPLEENERGY, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -300, maxDamage = -550, radius = 1, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREATTACK, target = true },
	{ name = "warlock skill reducer", interval = 2000, chance = 5, range = 5, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = 300, maxDamage = -500, radius = 1, shootEffect = CONST_ANI_EXPLOSION, effect = CONST_ME_SLEEP, target = true },
}

monster.defenses = {
	defense = 20,
	armor = 55,
	mitigation = 1.60,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 80, maxDamage = 95, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 70 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 25 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
