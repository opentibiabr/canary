local mType = Game.createMonsterType("Goshnar's Megalomania Green")
local monster = {}

monster.name = "Goshnar's Megalomania"
monster.description = "Goshnar's Megalomania"
monster.experience = 3000000
monster.outfit = {
	lookType = 99,
	lookHead = 95,
	lookBody = 116,
	lookLegs = 119,
	lookFeet = 115,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1969,
	bossRace = RARITY_NEMESIS,
}

monster.health = 620000
monster.maxHealth = 620000
monster.race = "undead"
monster.corpse = 33889
monster.speed = 250
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.events = {
	"GoshnarsHatredBuff",
	"MegalomaniaDeath",
}

monster.strategiesTarget = {
	nearest = 80,
	health = 10,
	damage = 10,
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
	staticAttackChance = 80,
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

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {

}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -800, maxDamage = -2500 },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_DEATHDAMAGE, minDamage = -1550, maxDamage = -2620, length = 8, spread = 0, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_DEATHDAMAGE, minDamage = -1550, maxDamage = -2620, length = 8, spread = 0, effect = CONST_ME_BLACK_BLOOD, target = false },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_DEATHDAMAGE, minDamage = -1050, maxDamage = -2020, length = 8, spread = 3, effect = CONST_ME_GHOST_SMOKE, target = false },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_DEATHDAMAGE, minDamage = -1050, maxDamage = -2020, length = 8, spread = 3, effect = CONST_ME_SMALLCLOUDS, target = false },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_DEATHDAMAGE, minDamage = -950, maxDamage = -1400, radius = 3, effect = CONST_ME_MORTAREA, target = true },
	{ name = "soulwars fear", interval = 35000, chance = 100, target = true },
	{ name = "megalomania transform elemental", interval = SoulWarQuest.goshnarsCrueltyWaveInterval * 1000, chance = 50 },
	{ name = "combat", interval = 30000, chance = 100, type = COMBAT_LIFEDRAIN, minDamage = -1000, maxDamage = -1500, length = 8, radius = 5, spread = 0, effect = CONST_ME_PINK_ENERGY_SPARK, target = true },
}

monster.defenses = {
	defense = 55,
	armor = 55,
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
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

local intervalBetweenExecutions = 10000

local zone = Zone.getByName("boss.goshnar's-megalomania-purple")
local zonePositions = zone:getPositions()

mType.onThink = function(monsterCallback, interval)
	monsterCallback:onThinkGoshnarTormentCounter(interval, 36, intervalBetweenExecutions, SoulWarQuest.levers.goshnarsMegalomania.boss.position)
	monsterCallback:onThinkMegalomaniaWhiteTiles(interval, zonePositions, 8000)
	monsterCallback:goshnarsDefenseIncrease("cleansed-sanity-action")
end

mType.onDisappear = function(monster, creature)
	creature:removeGoshnarsMegalomaniaMonsters(zone)
end

mType:register(monster)
