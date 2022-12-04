local invalidIds = {
	1, 2, 3, 4, 5, 6, 7, 10, 11, 13, 14, 15, 19, 21, 26, 27, 28, 35, 43
}

local createItem = TalkAction("/i")

function createItem.onSay(player, words, param)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	local split = param:split(",")

	local itemType = ItemType(split[1])
	if itemType:getId() == 0 then
		itemType = ItemType(tonumber(split[1]))
		if not tonumber(split[1]) or itemType:getId() == 0 then
			player:sendCancelMessage("There is no item with that id or name.")
			return false
		end
	end

	if table.contains(invalidIds, itemType:getId()) then
		return false
	end

	local charges = itemType:getCharges()
	local count = tonumber(split[2])
	if count then
		if itemType:isStackable() then
			count = math.min(10000, math.max(1, count))
		elseif not itemType:isFluidContainer() then
			local min = 100;
			if(charges > 0) then
				min = charges;
			end
			count = math.min(min, math.max(1, count))
		else
			count = math.max(0, count)
		end
	else
		if not itemType:isFluidContainer() then
			if charges > 0 then
				player:addItem(itemType:getId(), 0)
				return false
			else
				count = 1
			end
		else
			count = 0
		end
	end

	local tier = tonumber(split[3])
	if tier then
		if tier <= 0 or tier > 10 then
			player:sendCancelMessage("Invalid tier count.")
			return false
		end
	end

	local result = player:addItem(itemType:getId(), count, true, 0, CONST_SLOT_WHEREEVER, tier)
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
	return false
end

createItem:separator(" ")
createItem:register()
