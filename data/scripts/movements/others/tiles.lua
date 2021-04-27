local increasing = {[416] = 417, [426] = 425, [446] = 447, [3216] = 3217, [3202] = 3215, [11062] = 11063}
local decreasing = {[417] = 416, [425] = 426, [447] = 446, [3217] = 3216, [3215] = 3202, [11063] = 11062}

-- onStepIn
local tiles = MoveEvent()

function tiles.onStepIn(creature, item, position, fromPosition)
	if not increasing[item.itemid] then
		return true
	end

	local player = creature:getPlayer()
	if not player or player:isInGhostMode() then
		return true
	end

	item:transform(increasing[item.itemid])

	if item.actionid >= 1000 then
		if player:getLevel() < item.actionid - 1000 then
			player:teleportTo(fromPosition, false)
			position:sendMagicEffect(CONST_ME_MAGIC_BLUE)
			player:sendTextMessage(MESSAGE_FAILURE, "The tile seems to be protected against unwanted intruders.")
		end
		return true
	end

	if position:getTile():hasFlag(TILESTATE_PROTECTIONZONE) then
		local lookPosition = player:getPosition()
		lookPosition:getNextPosition(player:getDirection())
		local depotItem = lookPosition:getTile():getItemByType(ITEM_TYPE_DEPOT)

		if depotItem ~= nil then
			local depotItems = 0
			for id = 1, configManager.getNumber("depotBoxes") do
				depotItems = depotItems + player:getDepotChest(id, true):getItemHoldingCount()
			end

			player:sendTextMessage(MESSAGE_FAILURE, "Your depot contains " .. depotItems .. " item" .. (depotItems > 1 and "s." or ".") .. "\
			Your supply stash contains " .. player:getStashCount() .. " item" .. (player:getStashCount()	 > 1 and "s." or "."))
			player:setSpecialContainersAvailable(true, true)
			return true
		end
	end

	if item.actionid ~= 0 and player:getStorageValue(item.actionid) <= 0 then
		player:teleportTo(fromPosition, false)
		position:sendMagicEffect(CONST_ME_MAGIC_BLUE)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The tile seems to be protected against unwanted intruders.")
		return true
	end
end

tiles:type("stepin")

for index, value in pairs(increasing) do
	tiles:id(index)
end

tiles:register()

tiles = MoveEvent()

function tiles.onStepOut(creature, item, position, fromPosition)
	if not decreasing[item.itemid] then
		return false
	end

	local player = creature:getPlayer()
	if not player or player:isInGhostMode() then
		return true
	end

	item:transform(decreasing[item.itemid])
	player:setSpecialContainersAvailable(false, false)
	return true
end

tiles:type("stepout")

for index, value in pairs(decreasing) do
	tiles:id(index)
end

tiles:register()
