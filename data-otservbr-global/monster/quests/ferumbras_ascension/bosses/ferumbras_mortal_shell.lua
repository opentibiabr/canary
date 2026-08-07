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
	{ id = 22516, chance = 99000, maxCount = 5 }, -- Silver Token
	{ id = 3031, chance = 66000, maxCount = 375 }, -- Gold Coin
	{ id = 281, chance = 54000 }, -- Giant Shimmering Pearl
	{ id = 3035, chance = 42000, maxCount = 35 }, -- Platinum Coin
	{ id = 5944, chance = 40000 }, -- Soul Orb
	{ id = 3010, chance = 39000 }, -- Emerald Bangle
	{ id = 3033, chance = 29000, maxCount = 19 }, -- Small Amethyst
	{ id = 22726, chance = 26000 }, -- Rift Shield
	{ id = 22727, chance = 25000 }, -- Rift Lance
	{ id = 22867, chance = 25000 }, -- Rift Crossbow
	{ id = 3027, chance = 24000, maxCount = 9 }, -- Black Pearl
	{ id = 22866, chance = 24000 }, -- Rift Bow
	{ id = 9058, chance = 23000 }, -- Gold Ingot
	{ id = 3026, chance = 23000, maxCount = 9 }, -- White Pearl
	{ id = 3028, chance = 22000, maxCount = 18 }, -- Small Diamond
	{ id = 3039, chance = 21000 }, -- Red Gem
	{ id = 9057, chance = 21000, maxCount = 18 }, -- Small Topaz
	{ id = 3041, chance = 20000 }, -- Blue Gem
	{ id = 3038, chance = 20000 }, -- Green Gem
	{ id = 3360, chance = 17500 }, -- Golden Armor
	{ id = 812, chance = 16200 }, -- Terra Legs
	{ id = 823, chance = 15600 }, -- Glacier Kilt
	{ id = 3029, chance = 14900, maxCount = 19 }, -- Small Sapphire
	{ id = 3032, chance = 13600, maxCount = 15 }, -- Small Emerald
	{ id = 821, chance = 13000 }, -- Magma Legs
	{ id = 7427, chance = 12300 }, -- Chaos Mace
	{ id = 3364, chance = 12300 }, -- Golden Legs
	{ id = 7407, chance = 12300 }, -- Haunted Blade
	{ id = 7382, chance = 12300 }, -- Demonrage Sword
	{ id = 22773, chance = 11000 }, -- Boots of Homecoming
	{ id = 22767, chance = 10400 }, -- Ferumbras' Amulet
	{ id = 822, chance = 9700 }, -- Lightning Legs
	{ id = 22764, chance = 9100 }, -- Ferumbras' Staff (Blunt)
	{ id = 22769, chance = 9100 }, -- Ferumbras' Mana Keg
	{ id = 3414, chance = 8400 }, -- Mastermind Shield
	{ id = 7451, chance = 8400 }, -- Shadow Sceptre
	{ id = 3420, chance = 7800 }, -- Demon Shield
	{ id = 8075, chance = 7800 }, -- Spellbook of Lost Souls
	{ id = 8041, chance = 7100 }, -- Greenwood Coat
	{ id = 8074, chance = 7100 }, -- Spellbook of Mind Control
	{ id = 22771, chance = 6500 }, -- Scroll of Ascension
	{ id = 22734, chance = 6500 }, -- Rift Lamp
	{ id = 7422, chance = 6500 }, -- Jade Hammer
	{ id = 7418, chance = 5200 }, -- Nightmare Blade
	{ id = 7388, chance = 4500 }, -- Vile Axe
	{ id = 8090, chance = 4500 }, -- Spellbook of Dark Mysteries
	{ id = 22737, chance = 4500 }, -- Folded Rift Carpet
	{ id = 7417, chance = 3900 }, -- Runed Sword
	{ id = 7416, chance = 3900 }, -- Bloody Edge
	{ id = 8057, chance = 3900 }, -- Divine Plate
	{ id = 7414, chance = 3900 }, -- Abyss Hammer
	{ id = 22731, chance = 3200 }, -- Rift Tapestry
	{ id = 7403, chance = 3200 }, -- Berserker
	{ id = 3366, chance = 2600 }, -- Magic Plate Armor
	{ id = 8098, chance = 2600 }, -- Demonwing Axe
	{ id = 8076, chance = 2600 }, -- Spellscroll of Prophecies
	{ id = 7411, chance = 1900 }, -- Ornamented Axe
	{ id = 8040, chance = 1900 }, -- Velvet Mantle
	{ id = 8102, chance = 1300 }, -- Emerald Sword
	{ id = 8100, chance = 1300 }, -- Obsidian Truncheon
	{ id = 8096, chance = 1300 }, -- Hellforged Axe
	{ id = 7435, chance = 1300 }, -- Impaler
	{ id = 3303, chance = 1300 }, -- Great Axe
	{ id = 3439, chance = 650 }, -- Phoenix Shield
	{ id = 5903, chance = 650 }, -- Ferumbras' Hat
	{ id = 7410, chance = 650 }, -- Queen's Sceptre
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
