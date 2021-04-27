-- The Rookie Guard Quest - Mission 09: Rock 'n Troll

local missionTiles = {
	[50342] = {
		state = 1,
		message = "This is not the way to the troll caves. Go back down the stairs and walk north to find them.",
		arrowPosition = {x = 32089, y = 32147, z = 6}
	},
	[50343] = {
		state = 1,
		message = "This is not the way to the troll caves. Go back down the stairs and walk north to find them.",
		arrowPosition = {x = 32094, y = 32137, z = 7}
	},
	[50344] = {
		state = 1,
		newState = 2,
		message = "You've reached the newly dug troll tunnel. Take what you find in this chest and use it to bring down all support beams!",
		arrowPosition = {x = 32059, y = 32132, z = 10}
	},
	[50345] = {
		state = 7,
		newState = 8,
		message = "You hear a crumbling below you. The tunnel collapsed. Vascalir will be pleased to hear about that."
	}
}

-- Mission tutorial tiles

local missionGuide = MoveEvent()

function missionGuide.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission09)
	-- Skip if not was started or finished
	if missionState == -1 or missionState > 7 then
		return true
	end
	local missionTile = missionTiles[item.actionid]
	-- Check if the tile is active
	if missionState == missionTile.state then
		-- Check delayed notifications (message/arrow)
		if not isTutorialNotificationDelayed(player) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, missionTile.message)
			if missionTile.arrowPosition then
				Position(missionTile.arrowPosition):sendMagicEffect(CONST_ME_TUTORIALARROW)
			end
		end
		if missionTile.newState then
			player:setStorageValue(Storage.TheRookieGuard.Mission09, missionTile.newState)
		end
	end
	return true
end

for index, value in pairs(missionTiles) do
	missionGuide:aid(index)
end
missionGuide:register()

-- Troll caves dug tunnel hole

local tunnelHole = MoveEvent()

function tunnelHole.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission09)
	if missionState == -1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have no business down there.")
		player:teleportTo(fromPosition, true)
	elseif missionState >= 7 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The cave has collapsed. It's not safe to go down there anymore.")
		player:teleportTo(fromPosition, true)
	end
	return true
end

tunnelHole:uid(25028)
tunnelHole:register()

-- Trunk chests (gather leather legs and pick)

local CHEST_ID = {
	LEATHER_LEGS = 1,
	PICK = 2
}

local chests = {
	[40048] = {
		id = CHEST_ID.LEATHER_LEGS,
		itemId = 2649
	},
	[40049] = {
		id = CHEST_ID.PICK,
		itemId = 2553
	}
}

local trunkChest = Action()

function trunkChest.onUse(player, item, frompos, item2, topos)
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission09)
	-- Skip if not was started
	if missionState == -1 then
		return true
	end
	if missionState >= 2 then
		local chest = chests[item.uid]
		local chestsState = player:getStorageValue(Storage.TheRookieGuard.TrollChests)
		local hasOpenedChest = testFlag(chestsState, chest.id)
		if not hasOpenedChest then
			local reward = Game.createItem(chest.itemId, 1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found " .. reward:getArticle() .. " " .. reward:getName() .. ".")
			player:setStorageValue(Storage.TheRookieGuard.TrollChests, chestsState + chest.id)
			player:addItemEx(reward, true, CONST_SLOT_WHEREEVER)
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The " .. item:getName() .. " is empty.")
		end
	end
	return true
end

trunkChest:uid(40048, 40049)
trunkChest:register()

-- Pick (use pick on pillars)

local PILLAR_ID = {
	BOTOM_RIGHT = 1,
	BOTTOM_LEFT = 2,
	TOP_LEFT = 4,
	TOP_CENTER = 8,
	TOP_RIGHT = 16
}

local tunnelPillars = {
	[40050] = PILLAR_ID.BOTOM_RIGHT,
	[40051] = PILLAR_ID.BOTTOM_LEFT,
	[40052] = PILLAR_ID.TOP_LEFT,
	[40053] = PILLAR_ID.TOP_CENTER,
	[40054] = PILLAR_ID.TOP_RIGHT
}

-- /data/scripts/lib/register_actions.lua (onUsePick)
function onUsePickAtTunnelPillar(player, item, fromPosition, item2, toPosition)
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission09)
	local pillarId = tunnelPillars[item2.uid]
	if missionState >= 2 and missionState <= 7 and pillarId then
		local pillarsState = player:getStorageValue(Storage.TheRookieGuard.TunnelPillars)
		local hasDamagedPillar = testFlag(pillarsState, pillarId)
		if not hasDamagedPillar then
			local newMissionState = missionState + 1
			if table.find({3, 4, 5, 6}, newMissionState) then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "That should weaken the beam enough to make it collapse soon.")
			elseif newMissionState == 7 then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This was the last beam. Now, get out of here before the cave collapses!")
				player:addExperience(100, true)
			end
			player:say("<crack>", TALKTYPE_MONSTER_SAY, false, player, toPosition)
			toPosition:sendMagicEffect(CONST_ME_HITAREA)
			player:setStorageValue(Storage.TheRookieGuard.Mission09, newMissionState)			
			player:setStorageValue(Storage.TheRookieGuard.TunnelPillars, pillarsState + pillarId)
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You've already weakened this beam. Better leave it alone now so it won't collapse before you are out of here.")
		end
	end
	return true
end
