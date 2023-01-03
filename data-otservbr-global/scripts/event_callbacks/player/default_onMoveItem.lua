CONTAINER_WEIGHT_CHECK = true -- true = enable / false = disable
CONTAINER_WEIGHT_MAX = 1000000 -- 1000000 = 10k = 10000.00 oz

-- Players cannot throw items on teleports if set to true
local blockTeleportTrashing = true

local config = {
	maxItemsPerSeconds = 1,
	exhaustTime = 2000,
}

if not pushDelay then
	pushDelay = { }
end

local function antiPush(player, item, count, fromPosition, toPosition, fromCylinder, toCylinder)
	if toPosition.x == CONTAINER_POSITION then
		return true
	end

	local tile = Tile(toPosition)
	if not tile then
		player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		return false
	end

	local cid = player:getId()
	if not pushDelay[cid] then
		pushDelay[cid] = {items = 0, time = 0}
	end

	pushDelay[cid].items = pushDelay[cid].items + 1

	local currentTime = systemTime()
	if pushDelay[cid].time == 0 then
		pushDelay[cid].time = currentTime
	elseif pushDelay[cid].time == currentTime then
		pushDelay[cid].items = pushDelay[cid].items + 1
	elseif currentTime > pushDelay[cid].time then
		pushDelay[cid].time = 0
		pushDelay[cid].items = 0
	end

	if pushDelay[cid].items > config.maxItemsPerSeconds then
		pushDelay[cid].time = currentTime + config.exhaustTime
	end

	if pushDelay[cid].time > currentTime then
		player:sendCancelMessage("You can't move that item so fast.")
		return false
	end

	return true
end

local ec = EventCallback

function ec.onMoveItem(player, item, count, fromPosition, toPosition, fromCylinder, toCylinder)
	-- No move items with actionID = 100
	if item:getActionId() == NOT_MOVEABLE_ACTION then
		player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		return false
	end

	-- No move if item count > 20 items
	local tile = Tile(toPosition)
	if tile and tile:getItemCount() > 20 then
		player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		return false
	end

	-- No move parcel very heavy
	if CONTAINER_WEIGHT_CHECK and ItemType(item:getId()):isContainer()
	and item:getWeight() > CONTAINER_WEIGHT_MAX then
		player:sendCancelMessage("Your cannot move this item too heavy.")
		return false
	end

	-- Players cannot throw items on teleports
	if blockTeleportTrashing and toPosition.x ~= CONTAINER_POSITION then
		local thing = Tile(toPosition):getItemByType(ITEM_TYPE_TELEPORT)
		if thing then
			player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		end
	end

	-- SSA exhaust
	local exhaust = { }
	if toPosition.x == CONTAINER_POSITION and toPosition.y == CONST_SLOT_NECKLACE
	and item:getId() == ITEM_STONE_SKIN_AMULET then
		local pid = player:getId()
		if exhaust[pid] then
			player:sendCancelMessage(RETURNVALUE_YOUAREEXHAUSTED)
			return false
		else
			exhaust[pid] = true
			addEvent(function() exhaust[pid] = false end, 2000, pid)
			return true
		end
	end

	-- Store Inbox
	local containerIdFrom = fromPosition.y - 64
	local containerFrom = player:getContainerById(containerIdFrom)
	if (containerFrom) then
		if (containerFrom:getId() == ITEM_STORE_INBOX
		and toPosition.y >= 1 and toPosition.y <= 11 and toPosition.y ~= 3) then
			player:sendCancelMessage(RETURNVALUE_CONTAINERNOTENOUGHROOM)
			return false
		end
	end

	local containerTo = player:getContainerById(toPosition.y-64)
	if (containerTo) then
		if (containerTo:getId() == ITEM_STORE_INBOX) or (containerTo:getParent():isContainer() and containerTo:getParent():getId() == ITEM_STORE_INBOX and containerTo:getId() ~= ITEM_GOLD_POUCH) then
			player:sendCancelMessage(RETURNVALUE_CONTAINERNOTENOUGHROOM)
			return false
		end
		-- Gold Pouch
		if (containerTo:getId() == ITEM_GOLD_POUCH) then
			if (not (item:getId() == ITEM_CRYSTAL_COIN or item:getId() == ITEM_PLATINUM_COIN
			or item:getId() == ITEM_GOLD_COIN)) then
				player:sendCancelMessage("You can move only money to this container.")
				return false
			end
		end
	end


	-- Bath tube
	local toTile = Tile(toCylinder:getPosition())
	local topDownItem = toTile:getTopDownItem()
	if topDownItem and table.contains({ BATHTUB_EMPTY, BATHTUB_FILLED }, topDownItem:getId()) then
		return false
	end

	-- Handle move items to the ground
	if toPosition.x ~= CONTAINER_POSITION then
		return true
	end

	-- Check two-handed weapons
	if item:getTopParent() == player and bit.band(toPosition.y, 0x40) == 0 then
		local itemType, moveItem = ItemType(item:getId())
		if bit.band(itemType:getSlotPosition(), SLOTP_TWO_HAND) ~= 0 and toPosition.y == CONST_SLOT_LEFT then
			moveItem = player:getSlotItem(CONST_SLOT_RIGHT)
			if moveItem and itemType:getWeaponType() == WEAPON_DISTANCE and ItemType(moveItem:getId()):isQuiver() then
				return true
			end
		elseif itemType:getWeaponType() == WEAPON_SHIELD and toPosition.y == CONST_SLOT_RIGHT then
			moveItem = player:getSlotItem(CONST_SLOT_LEFT)
			if moveItem and bit.band(ItemType(moveItem:getId()):getSlotPosition(), SLOTP_TWO_HAND) == 0 then
				return true
			end
		end

		if moveItem then
			local parent = item:getParent()
			if parent:getSize() == parent:getCapacity() then
				player:sendTextMessage(MESSAGE_FAILURE, Game.getReturnMessage(RETURNVALUE_CONTAINERNOTENOUGHROOM))
				return false
			else
				return moveItem:moveTo(parent)
			end
		end
	end

	-- Reward System
	if toPosition.x == CONTAINER_POSITION then
		local containerId = toPosition.y - 64
		local container = player:getContainerById(containerId)
		if not container then
			return true
		end

		-- Do not let the player insert items into either the Reward Container or the Reward Chest
		local itemId = container:getId()
		if itemId == ITEM_REWARD_CONTAINER or itemId == ITEM_REWARD_CHEST then
			player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
			return false
		end

		-- The player also shouldn't be able to insert items into the boss corpse
		local tileCorpse = Tile(container:getPosition())
		for index, value in ipairs(tileCorpse:getItems() or { }) do
			if value:getAttribute(ITEM_ATTRIBUTE_CORPSEOWNER) == 2^31 - 1 and value:getName() == container:getName() then
				player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
				return false
			end
		end
	end

	-- Do not let the player move the boss corpse.
	if item:getAttribute(ITEM_ATTRIBUTE_CORPSEOWNER) == 2^31 - 1 then
		player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		return false
	end

	-- Players cannot throw items on reward chest
	local tileChest = Tile(toPosition)
	if tileChest and tileChest:getItemById(ITEM_REWARD_CHEST) then
		player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	if tile and tile:getItemById(370) then -- Trapdoor
		player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	if not antiPush(player, item, count, fromPosition, toPosition, fromCylinder, toCylinder) then
		return false
	end
	return true
end

ec:register(--[[0]])
