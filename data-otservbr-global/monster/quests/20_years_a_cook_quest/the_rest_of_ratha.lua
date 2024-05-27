local monsterName = "The Rest of Ratha"
local mType = Game.createMonsterType(monsterName)
local monster = {}

monster.description = monsterName
monster.experience = 0
monster.outfit = {
	lookType = 1692,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {}

monster.health = 200
monster.maxHealth = 200
monster.race = "undead"
monster.corpse = 0
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 0,
	chance = 0,
}

monster.strategiesTarget = {
	nearest = 0,
	random = 0,
}

monster.flags = {
	canTarget = false,
	summonable = false,
	attackable = false,
	hostile = false,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 0,
	targetDistance = 0,
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

monster.summon = {}

monster.voices = {}

monster.loot = {}

monster.attacks = {}

monster.defenses = {}

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

mType.onThink = function(monster, interval)
	local monsterPosition = monster:getPosition()
	if monster then
		for i, player in pairs(Game.getSpectators(monsterPosition, false, true, 0, 1, 0, 1)) do
			if player:getStorageValue(Storage.Quest.U13_30.TwentyYearsACook.QuestLine) == 2 then
				player:setStorageValue(Storage.Quest.U13_30.TwentyYearsACook.QuestLine, 3)
			end
		end
	end
end

mType:register(monster)
