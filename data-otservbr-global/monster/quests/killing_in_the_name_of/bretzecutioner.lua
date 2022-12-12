local mType = Game.createMonsterType("Bretzecutioner")
local monster = {}

monster.description = "Bretzecutioner"
monster.experience = 3700
monster.outfit = {
	lookType = 236,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0
}

monster.health = 5600
monster.maxHealth = 5600
monster.race = "undead"
monster.corpse = 6319
monster.speed = 135
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
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
	canPushCreatures = true,
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{id = 3031, chance = 100000}, -- gold coin
	{id = 3031, chance = 100000, maxCount = 98}, -- gold coin
	{id = 3577, chance = 100000}, -- meat
	{id = 6499, chance = 64000}, -- demonic essence
	{id = 7368, chance = 100000, maxCount = 10}, -- assassin star
	{id = 3383, chance = 68000}, -- dark armor
	{id = 3033, chance = 28000, maxCount = 5}, -- small amethyst
	{id = 3029, chance = 40000, maxCount = 5}, -- small sapphire
	{id = 3028, chance = 32000, maxCount = 5}, -- small diamond
	{id = 10298, chance = 100000}, -- metal spike
	{id = 7452, chance = 32000}, -- spiked squelcher
	{id = 3035, chance = 100000, maxCount = 8}, -- platinum coin
	{id = 3281, chance = 24000}, -- giant sword
	{id = 239, chance = 44000, maxCount = 3}, -- great health potion
	{id = 238, chance = 44000, maxCount = 3}, -- great mana potion
	{id = 7642, chance = 44000, maxCount = 3}, -- great spirit potion
	{id = 281, chance = 48000}, -- giant shimmering pearl (green)
	{id = 282, chance = 48000}, -- giant shimmering pearl (brown)
	{id = 3554, chance = 4000}, -- steel boots
	{id = 7427, chance = 24000}, -- chaos mace
	{id = 7419, chance = 12000}, -- dreaded cleaver
	{id = 3008, chance = 24000}, -- crystal necklace
	{id = 3421, chance = 16000}, -- dark shield
	{id = 6299, chance = 100000}, -- death ring
	{id = 5741, chance = 4000} -- skull helmet
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -514},
	{name ="combat", interval = 2000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -200, range = 7, shootEffect = CONST_ANI_LARGEROCK, target = false}
}

monster.defenses = {
	defense = 30,
	armor = 30,
	{name ="speed", interval = 2000, chance = 15, speedChange = 420, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 25},
	{type = COMBAT_ENERGYDAMAGE, percent = 100},
	{type = COMBAT_EARTHDAMAGE, percent = 20},
	{type = COMBAT_FIREDAMAGE, percent = 30},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = -15},
	{type = COMBAT_HOLYDAMAGE , percent = -3},
	{type = COMBAT_DEATHDAMAGE , percent = 20}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = false},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType:register(monster)
