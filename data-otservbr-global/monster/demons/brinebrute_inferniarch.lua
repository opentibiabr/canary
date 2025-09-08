local mType = Game.createMonsterType("Brinebrute Inferniarch")
local monster = {}

monster.description = "a brinebrute inferniarch"
monster.experience = 20300
monster.outfit = {
	lookType = 1794,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2601
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Azzilon Castle Catacombs.",
}

monster.health = 32000
monster.maxHealth = 32000
monster.race = "fire"
monster.corpse = 49998
monster.speed = 160
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
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	isPreyExclusive = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Garrr...Garrr!", yell = true },
}

monster.loot = {
	{ name = "platinum coin", chance = 5000, maxCount = 40 },
	{ id = 36706, chance = 1500 }, -- red gem
	{ name = "green crystal shard", chance = 900, maxCount = 2 },
	{ name = "blue crystal splinter", chance = 300 },
	{ name = "ultimate health potion", chance = 1500, maxCount = 3 },
	{ name = "bloodstained scythe", chance = 800 },
	{ name = "crusader helmet", chance = 800 },
	{ name = "great spirit potion", chance = 1500, maxCount = 5 },
	{ name = "blue crystal shard", chance = 300, maxCount = 2 },
	{ name = "green crystal splinter", chance = 300 },
	{ name = "stone skin amulet", chance = 500 },
	{ name = "demonic matter", chance = 4761 },
	{ name = "gold ring", chance = 200 },
	{ name = "demon shield", chance = 150 },
	{ name = "brinebrute claw", chance = 2000 },
	{ name = "small sapphire", chance = 1500, maxCount = 4 },
	{ name = "violet crystal shard", chance = 1500, maxCount = 2 },
	{ name = "brown crystal splinter", chance = 300 },
	{ name = "might ring", chance = 900 },
	{ id = 3098, chance = 900 }, -- ring of healing
	{ name = "giant sword", chance = 300 },
	{ name = "demonic core essence", chance = 100 },
	{ name = "mummified demon finger", chance = 155 },
	{ name = "demonrage sword", chance = 300 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -520, maxDamage = -600 },
}

monster.defenses = {
	defense = 15,
	armor = 80,
	mitigation = 2.45,
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_HEALING, minDamage = 100, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
