local mType = Game.createMonsterType("Lion Commander")
local monster = {}

monster.description = "a lion commander"
monster.experience = 0
monster.outfit = {
	lookType = 1317,
	lookHead = 24,
	lookBody = 78,
	lookLegs = 24,
	lookFeet = 78,
	lookAddons = 3,
	lookMount = 0,
}

monster.health = 8500
monster.maxHealth = 8500
monster.race = "blood"
monster.corpse = 0
monster.speed = 125
monster.manaCost = 0

monster.faction = FACTION_LION
monster.enemyFactions = { FACTION_LIONUSURPERS }

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.events = {
	"LionCommanderDeath",
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
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.summon = {
	maxSummons = 6,
	summons = {
		{ name = "lion archer", chance = 0, interval = 600000, count = 2 },
		{ name = "lion knight", chance = 0, interval = 600000, count = 2 },
		{ name = "lion warlock", chance = 0, interval = 600000, count = 2 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -550, effect = CONST_ME_DRAWBLOOD },
	{ name = "combat", interval = 4000, chance = 17, type = COMBAT_HOLYDAMAGE, minDamage = -400, maxDamage = -650, radius = 3, effect = CONST_ME_HOLYAREA, target = false },
	{ name = "combat", interval = 4000, chance = 17, type = COMBAT_HOLYDAMAGE, minDamage = -200, maxDamage = -650, radius = 4, effect = CONST_ME_HOLYAREA, target = false },
	{ name = "singlecloudchain", interval = 6000, chance = 17, minDamage = -200, maxDamage = -450, range = 4, effect = CONST_ME_ENERGYHIT, target = true },
	{ name = "singledeathchain", interval = 6000, chance = 15, minDamage = -250, maxDamage = -530, range = 5, effect = CONST_ME_MORTAREA, target = true },
}

monster.defenses = {
	defense = 86,
	armor = 86,
	--	mitigation = ???,
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

mType.onSpawn = function(monster, spawnPosition)
	for i = 1, 5 do
		local sum = Game.createMonster(monster:getType():getSummonList()[math.random(1, #monster:getType():getSummonList())].name, monster:getPosition(), true)
		if sum then
			monster:setSummon(sum)
			sum:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			sum:setStorageValue(Storage.TheOrderOfTheLion.Drume.Commander, 1)
		end
	end
	monster:setStorageValue(Storage.TheOrderOfTheLion.Drume.Commander, 1)
end

mType:register(monster)
