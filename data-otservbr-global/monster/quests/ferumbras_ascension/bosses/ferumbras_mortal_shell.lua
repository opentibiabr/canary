local mType = Game.createMonsterType("Ferumbras Mortal Shell")
local monster = {}

monster.description = "Ferumbras Mortal Shell"
monster.experience = 2000000
monster.outfit = {
	lookType = 229,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"AscendantBossesDeath",
}

monster.health = 300000
monster.maxHealth = 300000
monster.race = "venom"
monster.corpse = 6078
monster.speed = 195
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
}

monster.bosstiary = {
	bossRaceId = 1204,
	bossRace = RARITY_NEMESIS,
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 2500,
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
	maxSummons = 3,
	summons = {
		{ name = "Demon", chance = 100, interval = 1000, count = 3 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "INSECTS!", yell = true },
	{ text = "If you strike me down, I shall become more powerful than you could possibly imagine!", yell = false },
	{ text = "I' STILL POWERFUL ENOUGH TO CRUSH YOU!", yell = true },
	{ text = "I WILL MAKE ALL OF YOU SUFFER!", yell = true },
	{ text = "THE POWER WAS MINE!", yell = true },
}

monster.loot = {
	{ id = 822, chance = 800 }, -- lightning legs
	{ id = 8041, chance = 400 }, -- greenwood coat
	{ id = 3029, chance = 10000, maxCount = 10 }, -- small sapphire
	{ id = 7416, chance = 800 }, -- bloody edge
	{ id = 7427, chance = 800 }, -- chaos mace
	{ id = 3360, chance = 800 }, -- golden armor
	{ id = 8102, chance = 400 }, -- emerald sword
	{ id = 22773, chance = 800 }, -- boots of homecoming
	{ id = 3031, chance = 100000, maxCount = 100 }, -- gold coin
	{ id = 3032, chance = 10000, maxCount = 10 }, -- small emerald
	{ id = 281, chance = 1000 }, -- giant shimmering pearl (green)
	{ id = 3039, chance = 1000 }, -- red gem
	{ id = 8040, chance = 300 }, -- velvet mantle
	{ id = 3010, chance = 1000 }, -- emerald bangle
	{ id = 7423, chance = 300 }, -- skullcrusher
	{ id = 3033, chance = 10000, maxCount = 10 }, -- small amethyst
	{ id = 22764, chance = 800 }, -- ferumbras' staff
	{ id = 7422, chance = 800 }, -- jade hammer
	{ id = 3026, chance = 10000, maxCount = 5 }, -- white pearl
	{ id = 7418, chance = 600 }, -- nightmare blade
	{ id = 3439, chance = 800 }, -- phoenix shield
	{ id = 3420, chance = 800 }, -- demon shield
	{ id = 30146, chance = 150 }, -- elven parchment
	{ id = 3031, chance = 100000, maxCount = 100 }, -- gold coin
	{ id = 823, chance = 800 }, -- glacier kilt
	{ id = 3366, chance = 400 }, -- magic plate armor
	{ id = 22758, chance = 100, unique = true }, -- death gaze
	{ id = 7403, chance = 800 }, -- berserker
	{ id = 22866, chance = 500 }, -- rift bow
	{ id = 8098, chance = 300 }, -- demonwing axe
	{ id = 22731, chance = 3000 }, -- rift tapestry
	{ id = 7410, chance = 800 }, -- queen's sceptre
	{ id = 3041, chance = 800 }, -- blue gem
	{ id = 3035, chance = 100000, maxCount = 25 }, -- platinum coin
	{ id = 8100, chance = 400 }, -- obsidian truncheon
	{ id = 7414, chance = 800 }, -- abyss hammer
	{ id = 5903, chance = 100, unique = true }, -- ferumbras' hat
	{ id = 22769, chance = 800 }, -- ferumbras' mana keg
	{ id = 7382, chance = 800 }, -- demonrage sword
	{ id = 3038, chance = 4000 }, -- green gem
	{ id = 3414, chance = 600 }, -- mastermind shield
	{ id = 7435, chance = 800 }, -- impaler
	{ id = 22516, chance = 1000000, maxCount = 3 }, -- silver token
	{ id = 3027, chance = 10000, maxCount = 5 }, -- black pearl
	{ id = 3028, chance = 10000, maxCount = 10 }, -- small diamond
	{ id = 22771, chance = 800 }, -- scroll of ascension
	{ id = 9057, chance = 10000, maxCount = 10 }, -- small topaz
	{ id = 22767, chance = 800 }, -- ferumbras' amulet
	{ id = 22867, chance = 500 }, -- rift crossbow
	{ id = 8057, chance = 800 }, -- divine plate
	{ id = 3303, chance = 700 }, -- great axe
	{ id = 3422, chance = 100, unique = true }, -- great shield
	{ id = 821, chance = 800 }, -- magma legs
	{ id = 9058, chance = 800 }, -- gold ingot
	{ id = 7405, chance = 800 }, -- havoc blade
	{ id = 7411, chance = 400 }, -- ornamented axe
	{ id = 22737, chance = 3500 }, -- folded rift carpet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 90, attack = 200 },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 20, minDamage = -250, maxDamage = -520, radius = 6, effect = CONST_ME_POISONAREA, target = false },
	{ name = "ferumbras electrify", interval = 2000, chance = 18, target = false },
	{ name = "combat", interval = 2000, chance = 16, type = COMBAT_MANADRAIN, minDamage = -225, maxDamage = -410, radius = 6, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_MANADRAIN, minDamage = -425, maxDamage = -810, radius = 9, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "combat", interval = 2000, chance = 21, type = COMBAT_ENERGYDAMAGE, minDamage = -400, maxDamage = -650, radius = 9, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "combat", interval = 2000, chance = 21, type = COMBAT_LIFEDRAIN, minDamage = -200, maxDamage = -450, radius = 6, effect = CONST_ME_POFF, target = false },
	{ name = "ferumbras soulfire", interval = 2000, chance = 20, range = 7, target = false },
	{ name = "combat", interval = 2000, chance = 17, type = COMBAT_LIFEDRAIN, minDamage = -590, maxDamage = -1050, length = 8, spread = 0, effect = CONST_ME_HITBYPOISON, target = false },
}

monster.defenses = {
	defense = 120,
	armor = 100,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 23, type = COMBAT_HEALING, minDamage = 600, maxDamage = 2490, effect = CONST_ME_MAGIC_GREEN, target = false },
	{ name = "combat", interval = 2000, chance = 3, type = COMBAT_HEALING, minDamage = 20000, maxDamage = 35000, effect = CONST_ME_MAGIC_GREEN, target = false },
	{ name = "speed", interval = 2000, chance = 14, speedChange = 700, effect = CONST_ME_MAGIC_BLUE, target = false, duration = 7000 },
	{ name = "invisible", interval = 2000, chance = 10, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 65 },
	{ type = COMBAT_EARTHDAMAGE, percent = 65 },
	{ type = COMBAT_FIREDAMAGE, percent = 65 },
	{ type = COMBAT_LIFEDRAIN, percent = 65 },
	{ type = COMBAT_MANADRAIN, percent = 65 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 65 },
	{ type = COMBAT_HOLYDAMAGE, percent = 65 },
	{ type = COMBAT_DEATHDAMAGE, percent = 65 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
