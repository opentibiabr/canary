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
	{ id = 34020, chance = 80000 }, -- figurine of hatred
	{ id = 33927, chance = 80000 }, -- vial of hatred
	{ id = 23373, chance = 80000 }, -- ultimate mana potion
	{ id = 3043, chance = 80000 }, -- crystal coin
	{ id = 23375, chance = 80000 }, -- supreme health potion
	{ id = 7443, chance = 80000 }, -- bullseye potion
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 30059, chance = 80000 }, -- giant ruby
	{ id = 24391, chance = 80000 }, -- coral brooch
	{ id = 7439, chance = 80000 }, -- berserk potion
	{ id = 34109, chance = 80000 }, -- bag you desire
	{ id = 34074, chance = 80000 }, -- spectral horse tack
	{ id = 34076, chance = 80000 }, -- bracelet of strengthening
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 32622, chance = 80000 }, -- giant amethyst
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 7440, chance = 80000 }, -- mastermind potion
	{ id = 9058, chance = 80000 }, -- gold ingot
	{ id = 23374, chance = 80000 }, -- ultimate spirit potion
	{ id = 32769, chance = 80000 }, -- white gem
	{ id = 30060, chance = 80000 }, -- giant emerald
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 34072, chance = 80000 }, -- spectral horseshoe
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
