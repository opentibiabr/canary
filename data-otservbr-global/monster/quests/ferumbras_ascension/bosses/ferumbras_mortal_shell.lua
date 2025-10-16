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
	{ id = 3031, chance = 80000, maxCount = 200 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 25 }, -- platinum coin
	{ id = 22516, chance = 80000, maxCount = 3 }, -- silver token
	{ id = 8040, chance = 80000 }, -- velvet mantle
	{ id = 3414, chance = 80000 }, -- mastermind shield
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 22768, chance = 80000 }, -- ferumbras amulet
	{ id = 22772, chance = 80000 }, -- scroll of ascension
	{ id = 8074, chance = 80000 }, -- spellbook of mind control
	{ id = 8075, chance = 80000 }, -- spellbook of lost souls
	{ id = 823, chance = 80000 }, -- glacier kilt
	{ id = 822, chance = 80000 }, -- lightning legs
	{ id = 812, chance = 80000 }, -- terra legs
	{ id = 821, chance = 80000 }, -- magma legs
	{ id = 7407, chance = 80000 }, -- haunted blade
	{ id = 7414, chance = 80000 }, -- abyss hammer
	{ id = 7403, chance = 80000 }, -- berserker
	{ id = 7405, chance = 80000 }, -- havoc blade
	{ id = 7407, chance = 80000 }, -- haunted blade
	{ id = 7416, chance = 80000 }, -- bloody edge
	{ id = 7423, chance = 80000 }, -- skullcrusher
	{ id = 7427, chance = 80000 }, -- chaos mace
	{ id = 7435, chance = 80000 }, -- impaler
	{ id = 7422, chance = 80000 }, -- jade hammer
	{ id = 7382, chance = 80000 }, -- demonrage sword
	{ id = 7451, chance = 80000 }, -- shadow sceptre
	{ id = 3029, chance = 80000, maxCount = 10 }, -- small sapphire
	{ id = 3033, chance = 80000, maxCount = 10 }, -- small amethyst
	{ id = 3032, chance = 80000, maxCount = 10 }, -- small emerald
	{ id = 3028, chance = 80000, maxCount = 10 }, -- small diamond
	{ id = 3026, chance = 80000, maxCount = 5 }, -- white pearl
	{ id = 22866, chance = 80000 }, -- rift bow
	{ id = 22867, chance = 80000 }, -- rift crossbow
	{ id = 22726, chance = 80000 }, -- rift shield
	{ id = 22734, chance = 80000 }, -- rift lamp
	{ id = 22727, chance = 80000 }, -- rift lance
	{ id = 3010, chance = 80000 }, -- emerald bangle
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 5944, chance = 80000 }, -- soul orb
	{ id = 3360, chance = 80000 }, -- golden armor
	{ id = 3364, chance = 80000 }, -- golden legs
	{ id = 7417, chance = 80000 }, -- runed sword
	{ id = 22774, chance = 80000 }, -- boots of homecoming
	{ id = 8098, chance = 80000 }, -- demonwing axe
	{ id = 22770, chance = 80000 }, -- ferumbras mana keg
	{ id = 8076, chance = 80000 }, -- spellscroll of prophecies
	{ id = 7411, chance = 80000 }, -- ornamented axe
	{ id = 8057, chance = 80000 }, -- divine plate
	{ id = 8041, chance = 1000 }, -- greenwood coat
	{ id = 3422, chance = 1000 }, -- great shield
	{ id = 22865, chance = 260 }, -- mysterious scroll
	{ id = 5903, chance = 260 }, -- ferumbras hat
	{ id = 3027, chance = 80000 }, -- black pearl
	{ id = 22731, chance = 80000 }, -- rift tapestry
	{ id = 9057, chance = 80000 }, -- small topaz
	{ id = 3439, chance = 80000 }, -- phoenix shield
	{ id = 7410, chance = 80000 }, -- queens sceptre
	{ id = 8090, chance = 80000 }, -- spellbook of dark mysteries
	{ id = 3420, chance = 80000 }, -- demon shield
	{ id = 7388, chance = 80000 }, -- vile axe
	{ id = 3303, chance = 80000 }, -- great axe
	{ id = 3366, chance = 80000 }, -- magic plate armor
	{ id = 8100, chance = 80000 }, -- obsidian truncheon
	{ id = 7418, chance = 80000 }, -- nightmare blade
	{ id = 8102, chance = 80000 }, -- emerald sword
	{ id = 22737, chance = 80000 }, -- folded rift carpet
	{ id = 8096, chance = 80000 }, -- hellforged axe
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
