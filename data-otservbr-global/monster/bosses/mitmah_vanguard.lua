local mType = Game.createMonsterType("Mitmah Vanguard")
local monster = {}

monster.description = "Mitmah Vanguard"
monster.experience = 300000
monster.outfit = {
	lookType = 1716,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 2464,
	bossRace = RARITY_ARCHFOE,
}

monster.events = {
	"iksupanBossesDeath",
}

monster.health = 200000
monster.maxHealth = 200000
monster.race = "blood"
monster.corpse = 44687
monster.speed = 350
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 0,
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
	{ text = "Die, human. Now!", yell = true },
	{ text = "FEAR THE CURSE!", yell = true },
	{ text = "You're the intruder.", yell = false },
	{ text = "Awrrrgh!", yell = false },
	{ text = "The iks have always been ours.", yell = true },
	{ text = "Hwaaarrrh!!!", yell = true },
	{ text = "Wraaahgh?!", yell = true },
	{ text = "NOW TREMBLE!", yell = true },
}

monster.loot = {
	{ name = "gold coin", chance = 100000, minCount = 1, maxCount = 360 },
	{ name = "platinum coin", chance = 20000, maxCount = 60 },
	{ name = "great health potion", chance = 40000, maxCount = 13 },
	{ name = "broken mitmah necklace", chance = 40000, maxCount = 1 },
	{ name = "crystal of the mitmah", chance = 40000, maxCount = 1 },
	{ name = "great spirit potion", chance = 25530, maxCount = 9 },
	{ name = "great mana potion", chance = 34040, maxCount = 13 },
	{ name = "white gem", chance = 15000 },
	{ name = "yellow gem", chance = 15000, maxCount = 2 },
	{ name = "blue gem", chance = 15000 },
	{ name = "broken mitmah chestplate", chance = 9000 },
	{ name = "giant sapphire", chance = 9000 },
	{ name = "splintered mitmah gem", chance = 9000 },
	{ name = "amber with a bug", chance = 3190 },
	{ name = "amber", chance = 5320 },
	{ name = "stoic iks boots", chance = 452 },
	{ name = "stoic iks casque", chance = 372 },
	{ name = "stoic iks chestplate", chance = 545 },
	{ name = "stoic iks robe", chance = 545 },
	{ name = "stoic iks culet", chance = 362 },
	{ name = "stoic iks faulds", chance = 460 },
	{ name = "stoic iks headpiece", chance = 552 },
	{ name = "stoic iks sandals", chance = 665 },
	{ name = "stoic iks cuirass", chance = 382 },
}

monster.attacks = {
	{ name = "melee", interval = 1500, chance = 100, minDamage = -600, maxDamage = -800 },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -300, maxDamage = -400, range = 8, effect = CONST_ME_ENERGYHIT, shootType = CONST_ANI_BOLT, target = true }, -- bolt
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -500, maxDamage = -1200, length = 12, spread = 0, effect = CONST_ME_ENERGYHIT, target = false }, -- beam
	{ name = "combat", interval = 4000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -4300, maxDamage = -5970, radius = 10, effect = CONST_ME_SLASH, target = false }, -- slash ring
	{ name = "boulder ring", interval = 2000, chance = 20, minDamage = -460, maxDamage = -850, target = false },
	{ name = "root", interval = 4000, chance = 10, target = true },
}

monster.defenses = {
	defense = 150,
	armor = 150,
	--	mitigation = ???,
	{ name = "combat", interval = 10000, chance = 10, type = COMBAT_HEALING, minDamage = 1000, maxDamage = 2500, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType.onThink = function(monster, interval) end

mType.onAppear = function(monster, creature)
	if monster:getType():isRewardBoss() then
		monster:setReward(true)
	end
end

mType.onDisappear = function(monster, creature) end

mType.onMove = function(monster, creature, fromPosition, toPosition) end

mType.onSay = function(monster, creature, type, message) end

mType:register(monster)
