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
	{ id = 3031, chance = 66611, maxCount = 200 }, -- Gold Coin
	{ id = 3035, chance = 43739, maxCount = 25 }, -- Platinum Coin
	{ id = 22516, chance = 99666, maxCount = 3 }, -- Silver Token
	{ id = 8040, chance = 1335 }, -- Velvet Mantle
	{ id = 3414, chance = 8848 }, -- Mastermind Shield
	{ id = 3041, chance = 18697 }, -- Blue Gem
	{ id = 3039, chance = 24207 }, -- Red Gem
	{ id = 3038, chance = 16360 }, -- Green Gem
	{ id = 22767, chance = 8514 }, -- Ferumbras' Amulet
	{ id = 22771, chance = 9015 }, -- Scroll of Ascension
	{ id = 8074, chance = 9015 }, -- Spellbook of Mind Control
	{ id = 8075, chance = 7679 }, -- Spellbook of Lost Souls
	{ id = 823, chance = 13188 }, -- Glacier Kilt
	{ id = 822, chance = 14190 }, -- Lightning Legs
	{ id = 812, chance = 14190 }, -- Terra Legs
	{ id = 821, chance = 12520 }, -- Magma Legs
	{ id = 7407, chance = 9849 }, -- Haunted Blade
	{ id = 7414, chance = 6176 }, -- Abyss Hammer
	{ id = 7403, chance = 4674 }, -- Berserker
	{ id = 7405, chance = 1082 }, -- Havoc Blade
	{ id = 7407, chance = 9849 }, -- Haunted Blade
	{ id = 7416, chance = 4340 }, -- Bloody Edge
	{ id = 7423, chance = 1515 }, -- Skullcrusher
	{ id = 7427, chance = 8514 }, -- Chaos Mace
	{ id = 7435, chance = 1731 }, -- Impaler
	{ id = 7422, chance = 5676 }, -- Jade Hammer
	{ id = 7382, chance = 10350 }, -- Demonrage Sword
	{ id = 7451, chance = 9015 }, -- Shadow Sceptre
	{ id = 3029, chance = 16694, maxCount = 10 }, -- Small Sapphire
	{ id = 3033, chance = 21035, maxCount = 10 }, -- Small Amethyst
	{ id = 3032, chance = 21202, maxCount = 10 }, -- Small Emerald
	{ id = 3028, chance = 19699, maxCount = 10 }, -- Small Diamond
	{ id = 3026, chance = 25709, maxCount = 5 }, -- White Pearl
	{ id = 22866, chance = 22370 }, -- Rift Bow
	{ id = 22867, chance = 27212 }, -- Rift Crossbow
	{ id = 22726, chance = 26043 }, -- Rift Shield
	{ id = 22734, chance = 4507 }, -- Rift Lamp
	{ id = 22727, chance = 24373 }, -- Rift Lance
	{ id = 281, chance = 49582 }, -- Giant Shimmering Pearl
	{ id = 3010, chance = 35726 }, -- Emerald Bangle
	{ id = 9058, chance = 24540 }, -- Gold Ingot
	{ id = 5944, chance = 37061 }, -- Soul Orb
	{ id = 3360, chance = 11185 }, -- Golden Armor
	{ id = 3364, chance = 11018 }, -- Golden Legs
	{ id = 7417, chance = 5676 }, -- Runed Sword
	{ id = 22773, chance = 10684 }, -- Boots of Homecoming
	{ id = 8098, chance = 834 }, -- Demonwing Axe
	{ id = 22769, chance = 9849 }, -- Ferumbras' Mana Keg
	{ id = 8076, chance = 3338 }, -- Spellscroll of Prophecies
	{ id = 7411, chance = 2337 }, -- Ornamented Axe
	{ id = 8057, chance = 4507 }, -- Divine Plate
	{ id = 8041, chance = 3839 }, -- Greenwood Coat
	{ id = 3422, chance = 1000 }, -- Great Shield
	{ id = 22865, chance = 1000 }, -- Mysterious Scroll
	{ id = 5903, chance = 1000 }, -- Ferumbras' Hat
	{ id = 22764, chance = 9849 }, -- Ferumbras' Staff (Blunt)
	{ id = 3027, chance = 26043 }, -- Black Pearl
	{ id = 22731, chance = 4006 }, -- Rift Tapestry
	{ id = 9057, chance = 21202 }, -- Small Topaz
	{ id = 3439, chance = 333 }, -- Phoenix Shield
	{ id = 7410, chance = 1000 }, -- Queen's Sceptre
	{ id = 8090, chance = 4173 }, -- Spellbook of Dark Mysteries
	{ id = 3420, chance = 8347 }, -- Demon Shield
	{ id = 7388, chance = 4674 }, -- Vile Axe
	{ id = 3303, chance = 667 }, -- Great Axe
	{ id = 3366, chance = 2838 }, -- Magic Plate Armor
	{ id = 8100, chance = 2504 }, -- Obsidian Truncheon
	{ id = 7418, chance = 4674 }, -- Nightmare Blade
	{ id = 8102, chance = 1168 }, -- Emerald Sword
	{ id = 22737, chance = 5342 }, -- Folded Rift Carpet
	{ id = 8096, chance = 1001 }, -- Hellforged Axe
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
