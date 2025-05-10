local mType = Game.createMonsterType("Iron Servant Replica")
local monster = {}

monster.description = "an iron servant replica"
monster.experience = 600
monster.outfit = {
	lookType = 395,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1325
monster.Bestiary = {
	class = "Construct",
	race = BESTY_RACE_CONSTRUCT,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Replica Dungeon",
}

monster.health = 1000
monster.maxHealth = 1000
monster.race = "venom"
monster.corpse = 12494
monster.speed = 95
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
	isPreyExclusive = true,
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
	{ id = 8775, chance = 4840 }, -- gear wheel
	{ id = 3031, chance = 82190, maxCount = 130 }, -- gold coin
	{ id = 266, chance = 1980 }, -- health potion
	{ id = 3269, chance = 1000 }, -- halberd
	{ id = 12601, chance = 310 }, -- slime mould
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 20, attack = 30 },
	{ name = "combat", interval = 2000, chance = 12, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -60, range = 7, shootEffect = CONST_ANI_EXPLOSION, effect = CONST_ME_EXPLOSIONAREA, target = false },
	{ name = "drunk", interval = 2000, chance = 14, range = 7, shootEffect = CONST_ANI_EXPLOSION, effect = CONST_ME_STUN, target = false, duration = 2000 },
}

monster.defenses = {
	defense = 45,
	armor = 17,
	mitigation = 0.62,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 25 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 25 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType.onSpawn = function(monster)
	local chance = math.random(100)
	if Game.getStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.MechanismDiamond) >= 1 and Game.getStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.MechanismGolden) >= 1 then
		if chance > 30 then
			local monsterType = math.random(2) == 1 and "diamond servant replica" or "golden servant replica"
			Game.createMonster(monsterType, monster:getPosition(), false, true)
			monster:remove()
		end
		return
	end

	if Game.getStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.MechanismDiamond) >= 1 and chance > 30 then
		Game.createMonster("diamond servant replica", monster:getPosition(), false, true)
		monster:remove()
		return
	end

	if Game.getStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.MechanismGolden) >= 1 and chance > 30 then
		Game.createMonster("golden servant replica", monster:getPosition(), false, true)
		monster:remove()
	end
end

mType:register(monster)
