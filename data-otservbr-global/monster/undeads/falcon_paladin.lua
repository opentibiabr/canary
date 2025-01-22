local mType = Game.createMonsterType("Falcon Paladin")
local monster = {}

monster.description = "a falcon paladin"
monster.experience = 6900
monster.outfit = {
	lookType = 1071,
	lookHead = 57,
	lookBody = 96,
	lookLegs = 38,
	lookFeet = 105,
	lookAddons = 2,
	lookMount = 0,
}

monster.raceId = 1647
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Falcon Bastion.",
}

monster.health = 8500
monster.maxHealth = 8500
monster.race = "blood"
monster.corpse = 28862
monster.speed = 110
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
    hasGroupedSpells = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Repent Heretic!", yell = false },
    { text = "Uuunngh!", yell = false },
    { text = "Ooooaaah!", yell = false },
}

monster.loot = {
    { name = "platinum coin", chance = 90080, maxCount = 6 },
    { name = "great spirit potion", chance = 48530, maxCount = 2 },
    { name = "small diamond", chance = 48190, maxCount = 2 },
    { name = "small amethyst", chance = 47280, maxCount = 2 },
    { name = "small emerald", chance = 46710, maxCount = 2 },
    { name = "assassin star", chance = 30170, maxCount = 10 },
    { name = "small ruby", chance = 23600, maxCount = 2 },
    { name = "small topaz", chance = 23500, maxCount = 2 },
    { name = "onyx arrow", chance = 18440, maxCount = 15 },
    { id = 3039, chance = 8870, maxCount = 1 }, -- red gem
    { name = "green gem", chance = 5680 },
    { name = "violet gem", chance = 5340 },
    { id = 282, chance = 2020 }, -- giant shimmering pearl (green)
    { name = "damaged armor plates", chance = 1190 },
    { name = "falcon crest", chance = 990 },
    { name = "mastermind shield", chance = 410 },
    { name = "golden armor", chance = 320 },
}

monster.attacks = {
	{ name = "melee", group = MONSTER_SPELL_GROUP_BASIC, chance = 100, minDamage = -100, maxDamage = -250 },
	{ name = "combat", group = MONSTER_SPELL_GROUP_BASIC, chance = 30, type = COMBAT_PHYSICALDAMAGE, minDamage = -400, maxDamage = -550, range = 5, shootEffect = CONST_ANI_ROYALSPEAR, target = true },    
	{ name = "combat", group = MONSTER_SPELL_GROUP_ATTACK, chance = 30, type = COMBAT_PHYSICALDAMAGE, minDamage = -200, maxDamage = -500, range = 5, shootEffect = CONST_ANI_BOLT, target = true },
	{ name = "combat", group = MONSTER_SPELL_GROUP_ATTACK, chance = 45, type = COMBAT_ENERGYDAMAGE, minDamage = -500, maxDamage = -600, range = 7, radius = 3, shootEffect = CONST_ANI_POWERBOLT, effect = CONST_ME_ENERGYAREA, target = true },
    { name = "combat", group = MONSTER_SPELL_GROUP_ATTACK, chance = 30, type = COMBAT_ENERGYDAMAGE, minDamage = -250, maxDamage = -350, length = 4, spread = 0, effect = CONST_ME_ENERGYHIT, target = false },
}

monster.defenses = {
	defense = 50,
	armor = 82,
	mitigation = 2.31,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
