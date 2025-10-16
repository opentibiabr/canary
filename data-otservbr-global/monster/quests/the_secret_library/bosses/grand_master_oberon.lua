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
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1576,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 60000
monster.maxHealth = 60000
monster.race = "blood"
monster.corpse = 28625
monster.speed = 115
monster.manaCost = 0

monster.events = {
	"killingLibrary",
}

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	{ id = 28865, chance = 80000 }, -- the spatial warp almanac
	{ id = 28718, chance = 80000 }, -- falcon bow
	{ id = 28721, chance = 80000 }, -- falcon shield
	{ id = 28719, chance = 80000 }, -- falcon plate
	{ id = 28714, chance = 80000 }, -- falcon circlet
	{ id = 28724, chance = 80000 }, -- falcon battleaxe
	{ id = 28715, chance = 80000 }, -- falcon coif
	{ id = 28725, chance = 80000 }, -- falcon mace
	{ id = 28723, chance = 80000 }, -- falcon longsword
	{ id = 28720, chance = 80000 }, -- falcon greaves
	{ id = 28716, chance = 80000 }, -- falcon rod
	{ id = 28717, chance = 80000 }, -- falcon wand
	{ id = 28824, chance = 80000 }, -- grant of arms
	{ id = 3411, chance = 80000 }, -- brass shield
	{ id = 11050, chance = 80000 }, -- torch
	{ id = 11481, chance = 80000 }, -- pelvis bone
	{ id = 3286, chance = 80000 }, -- mace
	{ id = 3031, chance = 80000 }, -- gold coin
	{ id = 3264, chance = 80000 }, -- sword
	{ id = 3276, chance = 80000 }, -- hatchet
	{ id = 23986, chance = 80000 }, -- heavy old tome
	{ id = 7573, chance = 80000 }, -- bone
	{ id = 3367, chance = 80000 }, -- viking helmet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1400 },
	{ name = "combat", interval = 3000, chance = 40, type = COMBAT_HOLYDAMAGE, minDamage = -800, maxDamage = -1200, length = 8, effect = CONST_ME_HOLYAREA, target = false },
	{ name = "combat", interval = 4250, chance = 35, type = COMBAT_EARTHDAMAGE, minDamage = -500, maxDamage = -1000, radius = 5, effect = CONST_ME_HITAREA, target = false },
	{ name = "combat", interval = 5000, chance = 37, type = COMBAT_DEATHDAMAGE, minDamage = -500, maxDamage = -1000, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = false },
}

monster.defenses = {
	defense = 60,
	armor = 82,
	--	mitigation = ???,
	{ name = "speed", interval = 1000, chance = 10, speedChange = 180, effect = CONST_ME_POFF, target = false, duration = 4000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType.onSpawn = function(monster, spawnPosition)
	monster:setStorageValue(GrandMasterOberonConfig.Storage.Asking, 1)
	monster:setStorageValue(GrandMasterOberonConfig.Storage.Life, 1)
end

mType.onThink = function(monster, interval)
	if monster:getStorageValue(GrandMasterOberonConfig.Storage.Life) <= GrandMasterOberonConfig.AmountLife then
		local percentageHealth = (monster:getHealth() * 100) / monster:getMaxHealth()
		if percentageHealth <= 20 then
			SendOberonAsking(monster)
		end
	end
end

mType.onSay = function(monster, creature, type, message)
	if type ~= TALKTYPE_SAY then
		return false
	end
	local exhaust = GrandMasterOberonConfig.Storage.Exhaust
	if creature:isPlayer() and monster:getStorageValue(exhaust) <= os.time() then
		message = message:lower()

		monster:setStorageValue(exhaust, os.time() + 1)
		local asking_storage = monster:getStorageValue(GrandMasterOberonConfig.Storage.Asking)
		local oberonMessagesTable = GrandMasterOberonResponses[asking_storage]

		if oberonMessagesTable then
			if message == oberonMessagesTable.msg:lower() or message == oberonMessagesTable.msg2:lower() then
				monster:say("GRRRAAANNGH!", TALKTYPE_MONSTER_SAY)
				monster:unregisterEvent("OberonImmunity")
			else
				monster:say("HAHAHAHA!", TALKTYPE_MONSTER_SAY)
			end
		end
	end
end

mType:register(monster)
