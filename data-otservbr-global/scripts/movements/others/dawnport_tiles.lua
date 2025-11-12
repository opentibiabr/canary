local chestRooms = {
	entrances = {
		[25010] = { destination = { x = 32054, y = 31883, z = 6 } },
		[25011] = { destination = { x = 32073, y = 31883, z = 6 } },
		[25012] = { destination = { x = 32059, y = 31883, z = 6 } },
		[25013] = { destination = { x = 32068, y = 31883, z = 6 } },
		[29004] = { destination = { x = 32064, y = 31883, z = 6 } },
	},
	exits = {
		[25014] = { vocation = VOCATION.ID.SORCERER, destination = { x = 32054, y = 31879, z = 6 } },
		[25015] = { vocation = VOCATION.ID.DRUID, destination = { x = 32073, y = 31879, z = 6 } },
		[25016] = { vocation = VOCATION.ID.PALADIN, destination = { x = 32059, y = 31879, z = 6 } },
		[25017] = { vocation = VOCATION.ID.KNIGHT, destination = { x = 32068, y = 31879, z = 6 } },
		[29005] = { vocation = VOCATION.ID.MONK, destination = { x = 32064, y = 31879, z = 6 } },
	},
}

local effects = {
	CONST_ME_TUTORIALARROW,
	CONST_ME_TUTORIALSQUARE,
}

local chestRoomTile = MoveEvent()

function chestRoomTile.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	local chestRoomExit = chestRooms.exits[item.actionid]
	if chestRoomExit then
		if player:getVocation():getId() == chestRoomExit.vocation then
			if player:getStorageValue(Storage.Quest.U10_55.Dawnport.VocationReward) == -1 then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You should check the chest for your " .. player:getVocation():getName() .. " equipment.")
			elseif player:getStorageValue(Storage.Quest.U10_55.Dawnport.VocationReward) == 1 then
				player:teleportTo(chestRoomExit.destination, true)
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You should leave for the Mainland now. Go left to reach the ship.")
			end
		elseif player:getVocation():getId() ~= chestRoomExit.vocation then
			player:teleportTo(chestRoomExit.destination, true)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have not the right vocation to enter this room.")
		end
		return true
	end
	local chestRoomEntrance = chestRooms.entrances[item.actionid]
	if chestRoomEntrance then
		if player:getStorageValue(Storage.Dawnport.DoorVocation) == player:getVocation():getId() then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have chosen your vocation. You cannot go back.")
			player:teleportTo(chestRoomEntrance.destination, true)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		end
		return true
	end
	return true
end

for index, value in pairs(chestRooms.entrances) do
	chestRoomTile:aid(index)
end

for index, value in pairs(chestRooms.exits) do
	chestRoomTile:aid(index)
end

chestRoomTile:register()

-- Oressa stair, back if have reached level 20 or have chosen vocation
local templeStairs = MoveEvent()

function templeStairs.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	if player:getStorageValue(Storage.Dawnport.DoorVocation) == player:getVocation():getId() then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You cannot go upstairs. You have chosen a vocation and must now leave for the Mainlands.")
		player:teleportTo({ x = 32063, y = 31891, z = 6 }, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	elseif player:getLevel() >= 20 then
		player:teleportTo(fromPosition, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

templeStairs:aid(25009)
templeStairs:register()

-- First tutorial tile, on the first dawnport town
local tutorialTile = MoveEvent()

function tutorialTile.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getLastLoginSaved() == 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Use these stairs to enter the Adventurer's Outpost on Dawnport.")
		player:sendTutorial(1)
		for i = 1, #effects do
			Position({ x = 32075, y = 31900, z = 6 }):sendMagicEffect(effects[i])
		end
	end

	return true
end

tutorialTile:position({ x = 32069, y = 31901, z = 6 })
tutorialTile:register()

-- Before up stair on the first dawnport town
local tutorialTile1 = MoveEvent()

function tutorialTile1.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	if player:getStorageValue(Storage.Quest.U10_55.Dawnport.Questline) == 1 then
		return true
	end
	if player:getStorageValue(Storage.Quest.U10_55.Dawnport.Questline) < 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Welcome to Dawnport! Walk around and explore on your own, or talk to Inigo if you need directions.")
		player:sendTutorial(2)
		player:setStorageValue(Storage.Quest.U10_55.Dawnport.Questline, 1)
		player:setStorageValue(Storage.Quest.U10_55.Dawnport.GoMain, 1)
		player:setTown(Town(TOWNS_LIST.DAWNPORT))
	end
	return true
end

tutorialTile1:position({ x = 32075, y = 31898, z = 5 })
tutorialTile1:register()

-- Tutorial tile for not back to dawnport first town
local tutorialTile2 = MoveEvent()

function tutorialTile2.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	if item.itemid == 20344 then
		player:teleportTo({ x = 32070, y = 31900, z = 6 }, true)
	elseif item.itemid == 21374 then
		player:teleportTo({ x = 32075, y = 31899, z = 5 }, true)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "<krrk> <krrrrrk> You move away hurriedly.")
	end
	return true
end

tutorialTile2:id(20344, 21374)
tutorialTile2:register()

-- Message on step in the stair for go to NPC's
local tutorialTile3 = MoveEvent()

function tutorialTile3.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	if player:getStorageValue(Storage.Dawnport.Tutorial) ~= 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "To walk on STAIRS, use your arrow keys on your keyboard. You can also use them to walk in general.")
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:setStorageValue(Storage.Dawnport.Tutorial, 0)
	end
	return true
end

local positions = {
	{ x = 32075, y = 31896, z = 5 },
	{ x = 32074, y = 31896, z = 5 },
	{ x = 32073, y = 31896, z = 5 },
	{ x = 32072, y = 31896, z = 5 },
	{ x = 32072, y = 31895, z = 5 },
}

for i = 1, #positions do
	tutorialTile3:position(positions[i])
end

tutorialTile3:register()

-- Message before down stairs of vocation tiles
local tutorialTile4 = MoveEvent()

function tutorialTile4.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	if player:getStorageValue(Storage.Dawnport.MessageStair) < 1 then
		player:sendTextMessage(
			MESSAGE_EVENT_ADVANCE,
			"To ATTACK, click on a target in the battle list next to the game window. \z
			A red frame shows which enemy you're attacking."
		)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:setStorageValue(Storage.Dawnport.MessageStair, 1)
	end

	return true
end

local positions = {
	{ x = 32063, y = 31906, z = 6 },
	{ x = 32064, y = 31906, z = 6 },
	{ x = 32065, y = 31906, z = 6 },
	{ x = 32049, y = 31890, z = 6 },
	{ x = 32049, y = 31891, z = 6 },
	{ x = 32049, y = 31892, z = 6 },
	{ x = 32079, y = 31890, z = 6 },
	{ x = 32079, y = 31891, z = 6 },
	{ x = 32079, y = 31892, z = 6 },
	{ x = 32063, y = 31875, z = 6 },
	{ x = 32064, y = 31875, z = 6 },
	{ x = 32065, y = 31875, z = 6 },
}

for i = 1, #positions do
	tutorialTile4:position(positions[i])
end

tutorialTile4:register()

-- Cure poison tiles at dawnport outpost entrances
local cureTile = MoveEvent()

function cureTile.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	if player:getCondition(CONDITION_POISON) then
		player:removeCondition(CONDITION_POISON)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are cured.")
	end
	return true
end

cureTile:aid(20001)
cureTile:register()
