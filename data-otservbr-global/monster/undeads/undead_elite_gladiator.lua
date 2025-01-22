local mType = Game.createMonsterType("Undead Elite Gladiator")
local monster = {}

monster.description = "an undead elite gladiator"
monster.experience = 5090
monster.outfit = {
	lookType = 306,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1675
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Deep Desert.",
}

monster.health = 8000
monster.maxHealth = 8000
monster.race = "undead"
monster.corpse = 8909
monster.speed = 150
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
	canWalkOnPoison = false,
    hasGroupedSpells = true,
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
    { name = "platinum coin", chance = 44000, maxCount = 40 },
    { name = "belted cape", chance = 24500 },
    { name = "throwing star", chance = 15190, maxCount = 18 },
    { id = 3307, chance = 11340 }, -- scimitar
    { name = "knight axe", chance = 8780 },
    { name = "ultimate health potion", chance = 8740, maxCount = 2 },
    { name = "plate legs", chance = 5260 },
    { name = "flask of warrior's sweat", chance = 5220 },
    { name = "great health potion", chance = 5190 },
    { name = "broken gladiator shield", chance = 5030 },
    { name = "hunting spear", chance = 5020 },
    { name = "protection amulet", chance = 2290 },
    { name = "plate armor", chance = 2060 },
    { name = "two handed sword", chance = 1910 },
    { name = "dark helmet", chance = 1540 },
    { id = 3049, chance = 980 }, -- stealth ring
    { name = "relic sword", chance = 190 },
    { name = "crusader helmet", chance = 110 },
}

monster.attacks = {
	{ name = "melee", group = MONSTER_SPELL_GROUP_BASIC, chance = 100, minDamage = -100, maxDamage = -500 },
	{ name = "combat", group = MONSTER_SPELL_GROUP_ATTACK, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -500, maxDamage = -600, range = 7, shootEffect = CONST_ANI_WHIRLWINDSWORD, target = true },
	{ name = "combat", group = MONSTER_SPELL_GROUP_ATTACK, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -320, maxDamage = -420, length = 3, spread = 2, effect = CONST_ME_YELLOW_RINGS, target = false },
	{ name = "combat", group = MONSTER_SPELL_GROUP_ATTACK, chance = 25, type = COMBAT_LIFEDRAIN, minDamage = -300, maxDamage = -500, range = 5, radius = 3, effect = CONST_ME_BLOCKHIT, target = false },        
}

monster.defenses = {
	defense = 45,
	armor = 85,
	mitigation = 2.40,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 80 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
