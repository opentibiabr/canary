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
	{ id = 3043, chance = 100000, maxCount = 91 }, -- Crystal Coin
	{ id = 23373, chance = 73000, maxCount = 107 }, -- Ultimate Mana Potion
	{ id = 32622, chance = 55000 }, -- Giant Amethyst
	{ id = 23375, chance = 45000, maxCount = 166 }, -- Supreme Health Potion
	{ id = 7443, chance = 45000, maxCount = 43 }, -- Bullseye Potion
	{ id = 3041, chance = 45000, maxCount = 2 }, -- Blue Gem
	{ id = 23374, chance = 36000, maxCount = 69 }, -- Ultimate Spirit Potion
	{ id = 3037, chance = 27000 }, -- Yellow Gem
	{ id = 3039, chance = 27000 }, -- Red Gem
	{ id = 3036, chance = 27000 }, -- Violet Gem
	{ id = 7440, chance = 27000, maxCount = 24 }, -- Mastermind Potion
	{ id = 30060, chance = 27000 }, -- Giant Emerald
	{ id = 281, chance = 18200 }, -- Giant Shimmering Pearl
	{ id = 3038, chance = 18200 }, -- Green Gem
	{ id = 49271, chance = 18200, maxCount = 33 }, -- Transcendence Potion
	{ id = 30061, chance = 18200 }, -- Giant Sapphire
	{ id = 33923, chance = 18200 }, -- Cruelty's Chest
	{ id = 33922, chance = 18200 }, -- Cruelty's Claw
	{ id = 7439, chance = 9100, maxCount = 32 }, -- Berserk Potion
	{ id = 9058, chance = 9100 }, -- Gold Ingot
	{ id = 32769, chance = 9100 }, -- White Gem
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

mType.onSpawn = function(monsterCallback)
	firstTime = 0
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
