local mType = Game.createMonsterType("Goshnar's Cruelty")
local monster = {}

monster.description = "Goshnar's Cruelty"
monster.experience = 75000
monster.outfit = {
	lookType = 1303,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"SoulWarBossesDeath",
	"GoshnarsCrueltyBuff",
}

monster.health = 300000
monster.maxHealth = 300000
monster.race = "undead"
monster.corpse = 33859
monster.speed = 200
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1902,
	bossRace = RARITY_ARCHFOE,
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 95,
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
	{ name = "crystal coin", chance = 55000, minCount = 70, maxCount = 75 },
	{ id = 281, chance = 1150 }, -- giant shimmering pearl (green)
	{ name = "giant sapphire", chance = 10000, maxCount = 1 },
	{ name = "giant topaz", chance = 10000, maxCount = 1 },
	{ name = "violet gem", chance = 6000, maxCount = 1 },
	{ name = "blue gem", chance = 10000, maxCount = 3 },
	{ id = 3039, chance = 10000, maxCount = 3 }, -- red gem
	{ name = "green gem", chance = 10000, maxCount = 3 },
	{ name = "yellow gem", chance = 10000, maxCount = 3 },
	{ name = "white gem", chance = 6000, maxCount = 3 },
	{ name = "dragon figurine", chance = 10000 },
	{ name = "bullseye potion", chance = 15000, minCount = 10, maxCount = 25 },
	{ name = "mastermind potion", chance = 15000, minCount = 10, maxCount = 25 },
	{ name = "berserk potion", chance = 15000, minCount = 10, maxCount = 25 },
	{ name = "ultimate mana potion", chance = 18000, minCount = 50, maxCount = 100 },
	{ name = "supreme health potion", chance = 18000, minCount = 50, maxCount = 100 },
	{ name = "ultimate spirit potion", chance = 18000, minCount = 50, maxCount = 100 },
	{ name = "cruelty's chest", chance = 2000 },
	{ name = "cruelty's claw", chance = 2000 },
	{ name = "figurine of cruelty", chance = 400 },
	{ name = "spectral saddle", chance = 400 },
	{ name = "spectral horse tack", chance = 400 },
	{ name = "bag you desire", chance = 100 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -5000 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -1400, maxDamage = -1800, length = 8, spread = 0, effect = CONST_ME_EXPLOSIONAREA, target = false },
	{ name = "singlecloudchain", interval = 6000, chance = 40, minDamage = -1700, maxDamage = -2500, range = 6, effect = CONST_ME_ENERGYHIT, target = true },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_PHYSICALDAMAGE, minDamage = -1000, maxDamage = -2500, range = 7, radius = 4, shootEffect = CONST_ANI_EXPLOSION, effect = CONST_ME_DRAWBLOOD, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -1500, maxDamage = -3000, radius = 3, effect = CONST_ME_GROUNDSHAKER, target = false },
	{ name = "cruelty transform elemental", interval = SoulWarQuest.goshnarsCrueltyWaveInterval * 1000, chance = 50 },
}

monster.defenses = {
	defense = 160,
	armor = 160,
	mitigation = 5.40,
	{ name = "speed", interval = 1000, chance = 20, speedChange = 500, effect = CONST_ME_MAGIC_RED, target = false, duration = 10000 },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 1250, maxDamage = 3250, effect = CONST_ME_MAGIC_BLUE, target = false },
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

local firstTime = 0
mType.onThink = function(monster, interval)
	firstTime = firstTime + interval
	-- Run only 15 seconds before creation
	if firstTime >= 15000 then
		monster:goshnarsDefenseIncrease("greedy-maw-action")
	end
end

mType.onDisappear = function(monster, creature)
	if creature:getName() == "Goshnar's Cruelty" then
		local eyeCreature = Creature("A Greedy Eye")
		if eyeCreature then
			eyeCreature:remove()
		end
	end
end

mType:register(monster)
