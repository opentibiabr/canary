local mType = Game.createMonsterType("Goshnar's Hatred")
local monster = {}

monster.description = "Goshnar's Hatred"
monster.experience = 75000
monster.outfit = {
	lookType = 1307,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"GoshnarsHatredBuff",
	"SoulWarBossesDeath",
}

monster.health = 300000
monster.maxHealth = 300000
monster.race = "undead"
monster.corpse = 33875
monster.speed = 150
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1904,
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
	{ id = 34020, chance = 6250 }, -- Figurine of Hatred
	{ id = 33927, chance = 5172 }, -- Vial of Hatred
	{ id = 23373, chance = 58620 }, -- Ultimate Mana Potion
	{ id = 3043, chance = 100000 }, -- Crystal Coin
	{ id = 23375, chance = 60344 }, -- Supreme Health Potion
	{ id = 7443, chance = 31034 }, -- Bullseye Potion
	{ id = 3041, chance = 29310 }, -- Blue Gem
	{ id = 3037, chance = 25862 }, -- Yellow Gem
	{ id = 30059, chance = 41379 }, -- Giant Ruby
	{ id = 24391, chance = 5172 }, -- Coral Brooch
	{ id = 7439, chance = 34482 }, -- Berserk Potion
	{ id = 34109, chance = 3333 }, -- Bag You Desire
	{ id = 34074, chance = 1000 }, -- Spectral Horse Tack
	{ id = 34076, chance = 1000 }, -- Bracelet of Strengthening
	{ id = 3036, chance = 17241 }, -- Violet Gem
	{ id = 32622, chance = 31034 }, -- Giant Amethyst
	{ id = 3039, chance = 31034 }, -- Red Gem
	{ id = 7440, chance = 27586 }, -- Mastermind Potion
	{ id = 9058, chance = 12068 }, -- Gold Ingot
	{ id = 23374, chance = 60344 }, -- Ultimate Spirit Potion
	{ id = 32769, chance = 20689 }, -- White Gem
	{ id = 30060, chance = 27586 }, -- Giant Emerald
	{ id = 3038, chance = 27586 }, -- Green Gem
	{ id = 34072, chance = 6250 }, -- Spectral Horseshoe
	{ id = 281, chance = 21739 }, -- Giant Shimmering Pearl
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -5000 },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_DEATHDAMAGE, minDamage = -1350, maxDamage = -1700, range = 7, radius = 5, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_GROUNDSHAKER, target = true },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -1400, maxDamage = -2200, length = 8, spread = 0, effect = CONST_ME_GROUNDSHAKER, target = false },
	{ name = "singlecloudchain", interval = 6000, chance = 40, minDamage = -1700, maxDamage = -2500, range = 6, effect = CONST_ME_ENERGYHIT, target = true },
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

mType.onDisappear = function(monster, creature)
	if creature:getName() == "Goshnar's Hatred" then
		for _, monsterName in pairs(SoulWarQuest.burningHatredMonsters) do
			local ashesCreature = Creature(monsterName)
			if ashesCreature then
				ashesCreature:remove()
			end
		end
	end
end

mType.onSpawn = function(monster)
	monster:resetHatredDamageMultiplier()
end

mType:register(monster)
