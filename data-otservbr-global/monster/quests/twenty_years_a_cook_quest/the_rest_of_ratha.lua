local monsterName = "The Rest of Ratha"
local mType = Game.createMonsterType(monsterName)
local monster = {}

monster.description = monsterName
monster.experience = 0
monster.outfit = {
	lookType = 1692,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {}

monster.health = 10000
monster.maxHealth = 10000
monster.race = "undead"
monster.corpse = 0
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 0,
	chance = 0,
}

monster.strategiesTarget = {
	nearest = 0,
	random = 0,
}

monster.flags = {
	canTarget = false,
	summonable = false,
	attackable = true,
	hostile = false,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 0,
	targetDistance = 0,
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

monster.summon = {}

monster.voices = {}

monster.loot = {}

monster.attacks = {}

monster.defenses = {
	{ name = "combat", type = COMBAT_HEALING, chance = 100, interval = 2000, minDamage = 10000, maxDamage = 10000, effect = CONST_ME_NONE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 100 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 100 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = true },
}

local effectSent = true

local function removeGhostItem(position)
	local tile = Tile(position)
	local ghostItem = tile:getItemById(TwentyYearsACookQuest.TheRestOfRatha.Items.GhostItem)
	if ghostItem then
		ghostItem:remove()
	end
end

local function createGhostItem(rathaPosition)
	local tile = Tile(rathaPosition)
	if tile and not tile:getItemById(TwentyYearsACookQuest.TheRestOfRatha.Items.GhostItem) then
		effectSent = false
		local item = Game.createItem(TwentyYearsACookQuest.TheRestOfRatha.Items.GhostItem, 1, rathaPosition)
		addEvent(removeGhostItem, 6 * 1000, rathaPosition)
	end
end

local function onConditionClear(ratha)
	effectSent = true

	local rathaPosition = ratha:getPosition()
	if ratha:getStorageValue(Storage.Quest.U13_30.TwentyYearsACook.RathaConditionsApplied) >= 2 then
		local positionIndex = math.random(1, #TwentyYearsACookQuest.TheRestOfRatha.PositionsToTeleport)
		rathaPosition:sendMagicEffect(CONST_ME_GHOST_SMOKE)
		ratha:teleportTo(TwentyYearsACookQuest.TheRestOfRatha.PositionsToTeleport[positionIndex])
	else
		rathaPosition:sendMagicEffect(CONST_ME_MORTAREA)
	end
end

local function onConditionApplied(ratha, conditionsTicks)
	local rathaPosition = ratha:getPosition()
	if conditionsTicks % 2000 == 0 then
		rathaPosition:sendMagicEffect(CONST_ME_BLACK_BLOOD)
	end
	createGhostItem(rathaPosition)
end

local function updateQuestLogOnRathaFound(rathaPosition)
	for i, player in pairs(Game.getSpectators(rathaPosition, false, true, 0, 1, 0, 1)) do
		if player:getStorageValue(Storage.Quest.U13_30.TwentyYearsACook.QuestLine) == 2 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found the friend of the Draccoon or what's left of him, You should tell the Draccoon about it!")
			player:setStorageValue(Storage.Quest.U13_30.TwentyYearsACook.QuestLine, 3)
		end
	end
end

mType.onThink = function(monster, interval)
	local monsterPosition = monster and monster:getPosition() or nil
	if monsterPosition and TwentyYearsACookQuest.TheRestOfRatha.MissionZone:isInZone(monsterPosition) then
		updateQuestLogOnRathaFound(monsterPosition)
	elseif monsterPosition and TwentyYearsACookQuest.TheRestOfRatha.BossZone:isInZone(monsterPosition) then
		local appliedCondition = monster:getCondition(CONDITION_PARALYZE)
		local conditionsTicks = appliedCondition and appliedCondition:getTicks() or 0
		if conditionsTicks > 0 then
			onConditionApplied(monster, conditionsTicks)
		elseif not effectSent then
			onConditionClear(monster)
		end
	end
end

mType:register(monster)
