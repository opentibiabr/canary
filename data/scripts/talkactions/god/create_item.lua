local createItem = TalkAction("/i")

function createItem.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	local split = param:split(",")

	local itemType = ItemType(split[1])
	if itemType:getId() == 0 then
		itemType = ItemType(tonumber(split[1]))
		if not tonumber(split[1]) or itemType:getId() == 0 then
			player:sendCancelMessage("There is no item with that id or name.")
			return true
		end
	end

	if itemType:getId() < 100 then
		return true
	end

	local charges = itemType:getCharges()
	local count = tonumber(split[2] or 1)
	if count then
		if itemType:isStackable() then
			local mainContainer = player:getSlotItem(CONST_SLOT_BACKPACK)
			if not mainContainer then
				player:addItemEx(Game.createItem(2854), CONST_SLOT_BACKPACK)
				mainContainer = player:getSlotItem(CONST_SLOT_BACKPACK)
			end
			local remainingCount = count
			local stackSize = itemType:getStackSize()

			while remainingCount > 0 do
				local freeSlots = mainContainer and (mainContainer:getCapacity() - mainContainer:getSize()) or 0
				if freeSlots <= 1 and mainContainer:getSize() ~= 0 then
					mainContainer = Game.createItem(2854)
					player:addItemEx(mainContainer)
				end

				local countToAdd = math.min(remainingCount, stackSize)
				local tmpItem = mainContainer:addItem(itemType:getId(), countToAdd)
				if tmpItem then
					remainingCount = remainingCount - countToAdd
				else
					logger.warn("Failed to add item: {}, to container", itemType:getName())
					break
				end
			end

			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
			return true
		elseif not itemType:isFluidContainer() then
			local min = 100
			if charges > 0 then
				min = charges
			end
			count = math.min(min, math.max(1, count))
		else
			count = math.max(0, count)
		end
	else
		if not itemType:isFluidContainer() then
			if charges > 0 then
				player:addItem(itemType:getId(), 0)
				return true
			else
				count = 1
			end
		else
			count = 0
		end
	end

	local result
	local tier = tonumber(split[3])
	if not tier then
		result = player:addItem(itemType:getId(), count)
	else
		if tier <= 0 or tier > 10 then
			player:sendCancelMessage("Invalid tier count.")
			return true
		else
			result = player:addItem(itemType:getId(), count, true, 0, CONST_SLOT_WHEREEVER, tier)
		end
	end

	if result then
		if not itemType:isStackable() then
			if type(result) == "table" then
				for _, item in ipairs(result) do
					item:decay()
				end
			else
				result:decay()
			end
		end
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	end
	return true
end

createItem:separator(" ")
createItem:groupType("god")
createItem:register()
