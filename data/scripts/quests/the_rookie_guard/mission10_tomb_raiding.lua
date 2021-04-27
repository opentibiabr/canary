-- The Rookie Guard Quest - Mission 10: Tomb Raiding

local missionTiles = {
	[50346] = {
		{
			sarcophagus = -1,
			message = "This is not the way to the crypt. Go south-west to reach the graveyard.",
			arrowPosition = {x = 32124, y = 32177, z = 7}
		}
	},
	[50347] = {
		{
			sarcophagus = -1,
			message = "This is the crypt Vascalir was talking about. Explore it and search the coffins - one of them must hold a nice fleshy bone.",
			arrowPosition = {x = 32131, y = 32201, z = 7}
		}
	},
	[50348] = {
		{
			sarcophagus = -1,
			message = "This door seems to lead deeper into the crypt. Go downstairs and look for a special coffin. Beware of the walking dead!",
			arrowPosition = {x = 32147, y = 32185, z = 9}
		}
	},
	[50349] = {
		{
			sarcophagus = -1,
			message = "This sarcophagus seems special. Sarcophagi are said to conserve meat longer than normal coffins - maybe you get lucky.",
			arrowPosition = {x = 32145, y = 32204, z = 10}
		},
		{
			sarcophagus = 1,
			message = "Now that you have a fleshy bone, it's time to find out what Vascalir wanted with it.",
			arrowPosition = {x = 32136, y = 32202, z = 10}
		}
	}
}

-- Mission tutorial tiles

local missionGuide = MoveEvent()

function missionGuide.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission10)
	-- Skip if not was started or finished
	if missionState == -1 or missionState > 1 then
		return true
	end
	local missionTile = missionTiles[item.actionid]
	local sarcophagusState = player:getStorageValue(Storage.TheRookieGuard.Sarcophagus)
	-- Check mission state cases for the tile
	for i = 1, #missionTile do
		-- Check if the tile is active
		if missionState == 1 and sarcophagusState == missionTile[i].sarcophagus then
			-- Check delayed notifications (message/arrow)
			if not isTutorialNotificationDelayed(player) then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, missionTile[i].message)
				if missionTile[i].arrowPosition then
					Position(missionTile[i].arrowPosition):sendMagicEffect(CONST_ME_TUTORIALARROW)
				end
			end
			break
		end
	end
	return true
end

for index, value in pairs(missionTiles) do
	missionGuide:aid(index)
end
missionGuide:register()

-- Sarcophagus (gather fleshy bone)

local sarcophagus = Action()

function sarcophagus.onUse(player, item, frompos, item2, topos)
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission10)
	-- Skip if not was started
	if missionState == -1 then
		return true
	end
	if missionState >= 1 then
		local sarcophagusState = player:getStorageValue(Storage.TheRookieGuard.Sarcophagus)
		if sarcophagusState == -1 then
			local reward = Game.createItem(13830, 1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found " .. reward:getArticle() .. " " .. reward:getName() .. ".")
			player:setStorageValue(Storage.TheRookieGuard.Sarcophagus, 1)
			player:addItemEx(reward, true, CONST_SLOT_WHEREEVER)
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The " .. item:getName() .. " is empty.")
		end
	end
	return true
end

sarcophagus:uid(40055)
sarcophagus:register()

-- Unholy crypt chests

local CHEST_ID = {
	BOX = 1,
	COFFIN = 2
}

local chests = {
	[40077] = {
		id = CHEST_ID.BOX,
		item = {
			id = 2789,
			amount = 5
		}
	},
	[40078] = {
		id = CHEST_ID.COFFIN,
		item = {
			id = 8704,
			amount = 1
		}
	}
}

local unholyCryptChests = Action()

function unholyCryptChests.onUse(player, item, frompos, item2, topos)
	local missionState = player:getStorageValue(Storage.TheRookieGuard.Mission10)
	-- Skip if not was started
	if missionState == -1 then
		return true
	end
	local chest = chests[item.uid]
	local chestsState = player:getStorageValue(Storage.TheRookieGuard.UnholyCryptChests)
	local hasOpenedChest = testFlag(chestsState, chest.id)
	if not hasOpenedChest then
		local reward = Game.createItem(chest.item.id, chest.item.amount)
		if reward:getCount() == 1 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found " .. reward:getArticle() .. " " .. reward:getName() .. ".")
		elseif reward:getCount() > 1 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found " .. reward:getCount() .. " " .. reward:getPluralName() .. ".")
		end
		player:setStorageValue(Storage.TheRookieGuard.UnholyCryptChests, chestsState + chest.id)
		player:addItemEx(reward, true, CONST_SLOT_WHEREEVER)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The " .. item:getName() .. " is empty.")
	end
	return true
end

unholyCryptChests:uid(40077, 40078)
unholyCryptChests:register()
