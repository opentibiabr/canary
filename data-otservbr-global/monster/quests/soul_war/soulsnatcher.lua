local mType = Game.createMonsterType("Soulsnatcher")
local monster = {}

monster.description = "a soulsnatcher"
monster.experience = 0
monster.outfit = {
	lookType = 1268,
	lookHead = 0,
	lookBody = 94,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 10000
monster.maxHealth = 10000
monster.race = "undead"
monster.corpse = 0
monster.speed = 80
monster.manaCost = 0

monster.events = {
	"GreedMonsterDeath",
}

monster.changeTarget = {
	interval = 4000,
	chance = 0,
}

monster.strategiesTarget = {
	nearest = 100,
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
	canPushCreatures = false,
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

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -1000, maxDamage = -1500 },
	{ name = "soulsnatcher-lifedrain-beam", interval = 2000, chance = 20, minDamage = -1000, maxDamage = -1500, target = false },
	{ name = "soulsnatcher-lifedrain-missile", interval = 2000, chance = 25, minDamage = -1000, maxDamage = -1500, target = true },
	{ name = "soulsnatcher-manadrain-ball", interval = 2000, chance = 30, minDamage = -500, maxDamage = -1000 },
}

monster.defenses = {
	defense = 80,
	armor = 90,
	mitigation = 0.51,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

local transformTimeCount = 0
mType.onThink = function(monster, interval)
	transformTimeCount = transformTimeCount + interval
	if transformTimeCount == 8000 then
		transformTimeCount = 0
		local zone = Zone("boss.goshnar's-greed")
		if zone then
			local players = zone:getPlayers()
			for _, player in ipairs(players) do
				player:addHealth(-math.random(500, 1000))
			end
		end
		CreateGoshnarsGreedMonster(monster:getName(), GreedMonsters[monster:getName()])
		monster:remove()
	end
end

mType.onSpawn = function(monster)
	transformTimeCount = 0
end

mType:register(monster)
