dofile(DATA_DIRECTORY .. "/monster/quests/the_secret_library/bosses/grand_master_oberon_functions.lua")

local mType = Game.createMonsterType("Grand Master Oberon")
local monster = {}

monster.description = "Grand Master Oberon"
monster.experience = 20000
monster.outfit = {
	lookType = 1072,
	lookHead = 21,
	lookBody = 96,
	lookLegs = 21,
	lookFeet = 105,
	lookAddons = 1,
	lookMount = 0
}

monster.health = 30000
monster.maxHealth = 30000
monster.race = "blood"
monster.corpse = 28625
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10
}

monster.strategiesTarget = {
	nearest = 100,
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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true
}

monster.light = {
	level = 0,
	color = 0
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{id = 3115, chance = 30000, maxCount = 1}, -- bone
	{name = "brass shield", chance = 30000, maxCount = 1},
	{name = "spatial warp almanac", chance = 25000, maxCount = 1},
	{name = "viking helmet", chance = 23000, maxCount = 1},
	{name = "falcon battleaxe", chance = 500, maxCount = 1},
	{name = "falcon longsword", chance = 500, maxCount = 1},
	{name = "falcon mace", chance = 500, maxCount = 1},
	{name = "grant of arms", chance = 500, maxCount = 1},
	{name = "falcon bow", chance = 350, maxCount = 1},
	{name = "falcon circlet", chance = 350, maxCount = 1},
	{name = "falcon coif", chance = 350, maxCount = 1},
	{name = "falcon rod", chance = 350, maxCount = 1},
	{name = "falcon wand", chance = 350, maxCount = 1},
	{name = "falcon shield", chance = 200, maxCount = 1},
	{name = "falcon greaves", chance = 200, maxCount = 1},
	{name = "falcon plate", chance = 200, maxCount = 1},
}

monster.attacks = {
	{name ="melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1200},
	{name ="combat", interval = 6000, chance = 80, type = COMBAT_HOLYDAMAGE, minDamage = -1000, maxDamage = -2250, length = 8, spread = 3, effect = CONST_ME_HOLYAREA, target = false},
	{name ="combat", interval = 1000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -820, maxDamage = -1450, radius = 5, effect = CONST_ME_HITAREA, target = false},
	{name ="combat", interval = 2000, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -860, maxDamage = -1500, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = false}
}

monster.defenses = {
	defense = 60,
	armor = 82,
	{name ="speed", interval = 1000, chance = 10, speedChange = 180, effect = CONST_ME_POFF, target = false, duration = 4000}
}

monster.elements = {
	{type = COMBAT_PHYSICALDAMAGE, percent = 0},
	{type = COMBAT_ENERGYDAMAGE, percent = -5},
	{type = COMBAT_EARTHDAMAGE, percent = 5},
	{type = COMBAT_FIREDAMAGE, percent = -5},
	{type = COMBAT_LIFEDRAIN, percent = 0},
	{type = COMBAT_MANADRAIN, percent = 0},
	{type = COMBAT_DROWNDAMAGE, percent = 0},
	{type = COMBAT_ICEDAMAGE, percent = 0},
	{type = COMBAT_HOLYDAMAGE , percent = -25},
	{type = COMBAT_DEATHDAMAGE , percent = 100}
}

monster.immunities = {
	{type = "paralyze", condition = true},
	{type = "outfit", condition = true},
	{type = "invisible", condition = true},
	{type = "bleed", condition = false}
}

mType.onThink = function(monster, interval)
	if monster:getStorageValue(GrandMasterOberonConfig.Storage.Life) <= GrandMasterOberonConfig.AmountLife then
		local percentageHealth = (monster:getHealth()*100)/monster:getMaxHealth()
		if percentageHealth <= 20 then
			SendOberonAsking(monster)
		end
	end
end

mType.onAppear = function(monster, creature)
	if monster:getId() == creature:getId() then
		monster:setStorageValue(GrandMasterOberonConfig.Storage.Asking, 1)
		monster:setStorageValue(GrandMasterOberonConfig.Storage.Life, 1)
	end
	if monster:getType():isRewardBoss() then
		monster:setReward(true)
	end
end

mType.onDisappear = function(monster, creature)
end

mType.onMove = function(monster, creature, fromPosition, toPosition)
end

mType.onSay = function(monster, creature, type, message)
	local exhaust = GrandMasterOberonConfig.Storage.Exhaust
	if creature:isPlayer() and monster:getStorageValue(exhaust) <= os.time() then
		message = message:lower()
		monster:setStorageValue(exhaust, os.time() + 1)
		for i, v in pairs(GrandMasterOberonResponses) do
			if message == v.msg:lower() then
				local asking_storage = monster:getStorageValue(GrandMasterOberonConfig.Storage.Asking)
				if GrandMasterOberonAsking[i].msg:lower() == GrandMasterOberonAsking[asking_storage].msg:lower() then
					monster:unregisterEvent('OberonImmunity')
				end
			end
		end
	end
end

mType:register(monster)