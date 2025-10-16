local mType = Game.createMonsterType("Annihilon")
local monster = {}

monster.description = "Annihilon"
monster.experience = 15000
monster.outfit = {
	lookType = 12,
	lookHead = 3,
	lookBody = 9,
	lookLegs = 77,
	lookFeet = 77,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"InquisitionBossDeath",
}

monster.bosstiary = {
	bossRaceId = 418,
	bossRace = RARITY_BANE,
}

monster.health = 46500
monster.maxHealth = 46500
monster.race = "fire"
monster.corpse = 6068
monster.speed = 66
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 85,
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
	{ text = "Flee as long as you can!", yell = false },
	{ text = "Annihilon's might will crush you all!", yell = false },
	{ text = "I am coming for you!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 159 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 24 }, -- platinum coin
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 7440, chance = 80000, maxCount = 2 }, -- mastermind potion
	{ id = 5944, chance = 80000, maxCount = 4 }, -- soul orb
	{ id = 7366, chance = 80000, maxCount = 50 }, -- viper star
	{ id = 7368, chance = 80000, maxCount = 30 }, -- assassin star
	{ id = 3033, chance = 80000, maxCount = 20 }, -- small amethyst
	{ id = 7439, chance = 80000, maxCount = 2 }, -- berserk potion
	{ id = 6528, chance = 80000, maxCount = 49 }, -- infernal bolt
	{ id = 3450, chance = 80000, maxCount = 82 }, -- power bolt
	{ id = 763, chance = 80000, maxCount = 99 }, -- flaming arrow
	{ id = 5954, chance = 80000, maxCount = 2 }, -- demon horn
	{ id = 7643, chance = 80000 }, -- ultimate health potion
	{ id = 239, chance = 80000 }, -- great health potion
	{ id = 7642, chance = 80000 }, -- great spirit potion
	{ id = 238, chance = 80000 }, -- great mana potion
	{ id = 3415, chance = 80000 }, -- guardian shield
	{ id = 3269, chance = 80000 }, -- halberd
	{ id = 3315, chance = 80000 }, -- guardian halberd
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 3054, chance = 80000 }, -- silver amulet
	{ id = 3010, chance = 80000 }, -- emerald bangle
	{ id = 3049, chance = 80000 }, -- stealth ring
	{ id = 3098, chance = 80000 }, -- ring of healing
	{ id = 7387, chance = 80000 }, -- diamond sceptre
	{ id = 3420, chance = 80000 }, -- demon shield
	{ id = 3414, chance = 80000 }, -- mastermind shield
	{ id = 8896, chance = 80000 }, -- slightly rusted armor
	{ id = 3419, chance = 80000 }, -- crown shield
	{ id = 3428, chance = 80000 }, -- tower shield
	{ id = 8063, chance = 80000 }, -- paladin armor
	{ id = 3340, chance = 80000 }, -- heavy mace
	{ id = 8061, chance = 1000 }, -- skullcracker armor
	{ id = 7421, chance = 1000 }, -- onyx flail
	{ id = 8100, chance = 1000 }, -- obsidian truncheon
	{ id = 7431, chance = 260 }, -- demonbone
	{ id = 8049, chance = 260 }, -- lavos armor
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1707 },
	{ name = "combat", interval = 1000, chance = 11, type = COMBAT_DEATHDAMAGE, minDamage = 0, maxDamage = -600, length = 8, spread = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -200, maxDamage = -700, radius = 4, effect = CONST_ME_ICEAREA, target = false },
	{ name = "combat", interval = 3000, chance = 18, type = COMBAT_PHYSICALDAMAGE, minDamage = -50, maxDamage = -255, radius = 5, effect = CONST_ME_GROUNDSHAKER, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -50, maxDamage = -600, radius = 6, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
}

monster.defenses = {
	defense = 55,
	armor = 60,
	--	mitigation = ???,
	{ name = "combat", interval = 1000, chance = 14, type = COMBAT_HEALING, minDamage = 400, maxDamage = 900, effect = CONST_ME_MAGIC_GREEN, target = false },
	{ name = "speed", interval = 1000, chance = 4, speedChange = 500, effect = CONST_ME_MAGIC_BLUE, target = false, duration = 7000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 95 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 95 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
