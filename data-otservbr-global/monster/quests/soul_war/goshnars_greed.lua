local mType = Game.createMonsterType("Goshnar's Greed")
local monster = {}

monster.description = "Goshnar's Greed"
monster.experience = 150000
monster.outfit = {
	lookType = 1304,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"SoulWarBossesDeath",
}

monster.health = 300000
monster.maxHealth = 300000
monster.race = "undead"
monster.corpse = 33863
monster.speed = 200
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1905,
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

monster.summon = {
	maxSummons = 1,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 23373, chance = 53658 }, -- Ultimate Mana Potion
	{ id = 3043, chance = 100000 }, -- Crystal Coin
	{ id = 23375, chance = 51219 }, -- Supreme Health Potion
	{ id = 7439, chance = 36585 }, -- Berserk Potion
	{ id = 9058, chance = 24390 }, -- Gold Ingot
	{ id = 3041, chance = 19512 }, -- Blue Gem
	{ id = 32623, chance = 39024 }, -- Giant Topaz
	{ id = 34075, chance = 2439 }, -- The Skull of a Beast
	{ id = 3039, chance = 43902 }, -- Red Gem
	{ id = 30059, chance = 24390 }, -- Giant Ruby
	{ id = 3038, chance = 19512 }, -- Green Gem
	{ id = 3036, chance = 19512 }, -- Violet Gem
	{ id = 7443, chance = 26829 }, -- Bullseye Potion
	{ id = 7440, chance = 21951 }, -- Mastermind Potion
	{ id = 3037, chance = 46341 }, -- Yellow Gem
	{ id = 281, chance = 7317 }, -- Giant Shimmering Pearl
	{ id = 23374, chance = 58536 }, -- Ultimate Spirit Potion
	{ id = 30061, chance = 36585 }, -- Giant Sapphire
	{ id = 34073, chance = 1000 }, -- Spectral Saddle
	{ id = 34072, chance = 1000 }, -- Spectral Horseshoe
	{ id = 34021, chance = 1000 }, -- Figurine of Greed
	{ id = 33924, chance = 4878 }, -- Greed's Arm
	{ id = 34109, chance = 2439 }, -- Bag You Desire
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -5000 },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_DEATHDAMAGE, minDamage = -1500, maxDamage = -2000, range = 7, radius = 5, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_GROUNDSHAKER, target = true },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_FIREDAMAGE, minDamage = -1200, maxDamage = -2200, length = 8, spread = 0, effect = CONST_ME_FIREAREA, target = false },
	{ name = "singlecloudchain", interval = 6000, chance = 40, minDamage = -1300, maxDamage = -1700, range = 6, effect = CONST_ME_ENERGYHIT, target = true },
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

local immuneTimeCount = 0
local isImmune = nil
local createdSoulSphere = nil
mType.onThink = function(monsterCallback, interval)
	if GreedbeastKills >= 5 and isImmune == nil then
		isImmune = monsterCallback:immune(false)
		monsterCallback:teleportTo(Position(33741, 31659, 14))
		monsterCallback:setSpeed(0)
		createdSoulSphere = Game.createMonster("Soul Sphere", Position(33752, 31659, 14), true, true)
	end
	if isImmune ~= nil then
		immuneTimeCount = immuneTimeCount + interval
		logger.info("Immune time count {}", immuneTimeCount)
		if immuneTimeCount >= 45000 then
			monsterCallback:immune(true)
			monsterCallback:setSpeed(monster.speed)
			monsterCallback:teleportTo(Position(33746, 31666, 14))
			immuneTimeCount = 0
			GreedbeastKills = 0
			isImmune = nil
			if createdSoulSphere then
				createdSoulSphere:remove()
			end
		end
	end
end

mType.onSpawn = function(monster)
	if monster:getType():isRewardBoss() then
		monster:setReward(true)
	end

	isImmune = nil
	monster:immune(true)
	immuneTimeCount = 0
	GreedbeastKills = 0
end

mType.onDisappear = function(monster, creature)
	if creature:getName() == "Greedbeast" then
		logger.debug("GreedbeastKills {}", GreedbeastKills)
	end
	if creature:getName() == "Goshnar's Greed" then
		logger.debug("Killed goshnar's greed")
		if createdSoulSphere then
			logger.debug("Found soul sphere, remove it")
			createdSoulSphere:remove()
		end
	end
end

mType:register(monster)
