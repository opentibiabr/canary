local mType = Game.createMonsterType("Usurper Commander")
local monster = {}

monster.description = "an usurper commander"
monster.experience = 7200
monster.outfit = {
	lookType = 1317,
	lookHead = 40,
	lookBody = 95,
	lookLegs = 40,
	lookFeet = 95,
	lookAddons = 3,
	lookMount = 0,
}

monster.health = 8500
monster.maxHealth = 8500
monster.race = "blood"
monster.corpse = 0
monster.speed = 125
monster.manaCost = 0

monster.faction = FACTION_LIONUSURPERS
monster.enemyFactions = { FACTION_PLAYER, FACTION_LION }

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.events = {
	"UsurperCommanderDeath",
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
	maxSummons = 5,
	summons = {
		{ name = "hardened usurper archer", chance = 0, interval = 600000, count = 2 },
		{ name = "hardened usurper warlock", chance = 0, interval = 600000, count = 2 },
		{ name = "hardened usurper knight", chance = 0, interval = 600000, count = 2 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "FORMATION!", yell = true },
}

monster.loot = {
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 23533, chance = 80000 }, -- ring of red plasma
	{ id = 8073, chance = 80000 }, -- spellbook of warding
	{ id = 3035, chance = 80000 }, -- platinum coin
	{ id = 16119, chance = 80000 }, -- blue crystal shard
	{ id = 8084, chance = 80000 }, -- springsprout rod
	{ id = 3350, chance = 80000 }, -- bow
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 34162, chance = 80000 }, -- lion cloak patch
	{ id = 8094, chance = 80000 }, -- wand of voodoo
	{ id = 3274, chance = 80000 }, -- axe
	{ id = 34164, chance = 80000 }, -- fur shred
	{ id = 34160, chance = 80000 }, -- lion crest
	{ id = 23529, chance = 80000 }, -- ring of blue plasma
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 7443, chance = 80000 }, -- bullseye potion
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500, effect = CONST_ME_DRAWBLOOD },
	{ name = "combat", interval = 4000, chance = 14, type = COMBAT_DEATHDAMAGE, minDamage = -150, maxDamage = -300, radius = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 4000, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = -150, maxDamage = -400, length = 4, spread = 0, effect = CONST_ME_ICEATTACK, target = false },
	{ name = "singlecloudchain", interval = 6000, chance = 17, minDamage = -200, maxDamage = -450, range = 4, effect = CONST_ME_ENERGYHIT, target = true },
	{ name = "singledeathchain", interval = 6000, chance = 15, minDamage = -250, maxDamage = -530, range = 5, effect = CONST_ME_MORTAREA, target = true },
}

monster.defenses = {
	defense = 86,
	armor = 86,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 1 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 1 },
	{ type = COMBAT_DEATHDAMAGE, percent = -1 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType.onSpawn = function(monster, spawnPosition)
	local sum
	for i = 1, 5 do
		sum = Game.createMonster(monster:getType():getSummonList()[math.random(1, #monster:getType():getSummonList())].name, monster:getPosition(), true)
		if sum then
			monster:setSummon(sum)
			sum:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			sum:setStorageValue(Storage.TheOrderOfTheLion.Drume.Commander, 1)
		end
	end
	monster:setStorageValue(Storage.TheOrderOfTheLion.Drume.Commander, 1)
end

mType:register(monster)
