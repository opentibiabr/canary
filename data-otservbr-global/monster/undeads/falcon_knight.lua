local mType = Game.createMonsterType("Falcon Knight")
local monster = {}

monster.description = "a falcon knight"
monster.experience = 6300
monster.outfit = {
	lookType = 1071,
	lookHead = 57,
	lookBody = 96,
	lookLegs = 38,
	lookFeet = 105,
	lookAddons = 1,
	lookMount = 0,
}

monster.raceId = 1646
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

monster.health = 9000
monster.maxHealth = 9000
monster.race = "blood"
monster.corpse = 28621
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
	staticAttackChance = 90,
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
	{ text = "Mmmhaarrrgh...", yell = false },
    { text = "Nnngh!", yell = false },
}

monster.loot = {
    { id = 3582, chance = 90080, maxCount = 8 }, -- ham
    { name = "soul orb", chance = 48530 },
    { name = "great mana potion", chance = 33000, maxCount = 3 },
    { name = "great health potion", chance = 33000, maxCount = 3 },
    { name = "flask of demonic blood", chance = 30000, maxCount = 4 },
    { name = "small amethyst", chance = 47280, maxCount = 2 },
    { name = "assassin star", chance = 30170, maxCount = 10 },
    { name = "small diamond", chance = 48190, maxCount = 2 },
    { name = "small ruby", chance = 23600, maxCount = 2 },
    { name = "small emerald", chance = 46710, maxCount = 2 },
    { name = "onyx arrow", chance = 18440, maxCount = 15 },
    { name = "small topaz", chance = 23500, maxCount = 2 },
    { name = "titan axe", chance = 3000 },
    { id = 282, chance = 2020 }, -- giant shimmering pearl (green)
    { name = "spiked squelcher", chance = 2200 },
    { name = "knight armor", chance = 1980 },
    { name = "falcon crest", chance = 990 },
    { name = "war axe", chance = 1230 },
    { name = "violet gem", chance = 5340 },
    { name = "damaged armor plates", chance = 1190 },
    { name = "green gem", chance = 5680 },
    { name = "golden armor", chance = 320 },
    { name = "mastermind shield", chance = 410 },
    { name = "heavy mace", chance = 460 },
    { id = 3481, chance = 370 }, -- closed trap
    { id = 3019, chance = 100 }, -- demonbone amulet
}

monster.attacks = {
	{ name = "melee", group = MONSTER_SPELL_GROUP_BASIC, chance = 100, minDamage = -100, maxDamage = -400 },
	{ name = "combat", group = MONSTER_SPELL_GROUP_ATTACK, chance = 25, type = COMBAT_EARTHDAMAGE, minDamage = -400, maxDamage = -500, radius = 3, effect = CONST_ME_GROUNDSHAKER, target = false },    
	{ name = "combat", group = MONSTER_SPELL_GROUP_ATTACK, chance = 35, type = COMBAT_HOLYDAMAGE, minDamage = -290, maxDamage = -360, length = 4, spread = 0, effect = CONST_ME_HOLYDAMAGE, target = false },
}

monster.defenses = {
	defense = 86,
	armor = 86,
	mitigation = 2.37,
	{ name = "speed", interval = 2000, chance = 20, speedChange = 160, effect = CONST_ME_MAGIC_RED, target = false, duration = 4000 },
	{ name = "combat", interval = 2000, chance = 60, effect = CONST_ME_FIREATTACK, target = false }, -- Flame Dance (unknown maybe buff)
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
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
