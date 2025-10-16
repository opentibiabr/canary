local mType = Game.createMonsterType("Mirror Image")
local monster = {}

monster.description = "a mirror image"
monster.experience = 27000
monster.outfit = {
	lookType = 136,
	lookHead = 76,
	lookBody = 114,
	lookLegs = 76,
	lookFeet = 76,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"FourthTaintBossesPrepareDeath",
}

monster.health = 35000
monster.maxHealth = 35000
monster.race = "blood"
monster.corpse = 0
monster.speed = 117
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 0,
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
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 4,
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
	{ text = "Delusional!", yell = false },
	{ text = "I'll be your worst nightmare", yell = false },
	{ text = "The mirrors can't contain the night.", yell = false },
	{ text = "What a lovely reflection.", yell = false },
}

monster.loot = {}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -700 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = -800, maxDamage = -1100, range = 7, radius = 4, shootEffect = CONST_ANI_ICE, effect = CONST_ME_BIGCLOUDS, target = true },
	{ name = "combat", interval = 2000, chance = 17, type = COMBAT_HOLYDAMAGE, minDamage = -950, maxDamage = -1400, radius = 4, effect = CONST_ME_HOLYAREA, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HOLYDAMAGE, minDamage = -1080, maxDamage = -1350, range = 7, shootEffect = CONST_ANI_HOLY, effect = CONST_ME_HOLYDAMAGE, target = true },
	{ name = "ice chain", interval = 2000, chance = 15, minDamage = -900, maxDamage = -1300, range = 7 },
}

monster.defenses = {
	defense = 75,
	armor = 0,
	--	mitigation = ???,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 1 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -1 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 1 },
	{ type = COMBAT_HOLYDAMAGE, percent = 1 },
	{ type = COMBAT_DEATHDAMAGE, percent = -1 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

monster.events = {
	"MirrorImageTransform",
}

mType.onPlayerAttack = function(monster, attackerPlayer)
	logger.info("Player {}, attacking monster {}", attackerPlayer:getName(), monster:getName())

	local apparitionType = ""

	local sameVocationProbability = 70 -- 70% chance for create monster of first player attack vocation
	if attackerPlayer:isDruid() then
		apparitionType = "Druid's Apparition"
	elseif attackerPlayer:isKnight() then
		apparitionType = "Knight's Apparition"
	elseif attackerPlayer:isPaladin() then
		apparitionType = "Paladin's Apparition"
	elseif attackerPlayer:isSorcerer() then
		apparitionType = "Sorcerer's Apparition"
	end

	if math.random(100) > sameVocationProbability then
		repeat
			local randomIndex = math.random(#SoulWarQuest.apparitionNames)
			if SoulWarQuest.apparitionNames[randomIndex] ~= apparitionType then
				apparitionType = SoulWarQuest.apparitionNames[randomIndex]
				break
			end
		until false
	end

	Game.createMonster(apparitionType, monster:getPosition(), true, true)
	monster:remove()
end

mType:register(monster)
