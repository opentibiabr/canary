local waterIds = {622, 4597, 4598, 4599, 4600, 4601, 4602, 4609, 4610, 4611, 4612, 4613, 4614, 629, 630, 631, 632, 633, 634, 7236, 9582, 13988, 13989}
local lootTrash = {3119, 3123, 3264, 3409, 3578}
local lootCommon = {3035, 3051, 3052, 3580, 236, 237}
local lootRare = {3026, 3029, 3032, 7158, 7159}
local lootVeryRare = {281, 282, 9303}
local useWorms = true

local mechanicalFishing = Action()

function mechanicalFishing.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not isInArray(waterIds, target.itemid) then
		return false
	end

	local targetId = target.itemid
	if targetId == 9582 then
		local owner = target:getAttribute(ITEM_ATTRIBUTE_CORPSEOWNER)
		if owner ~= 0 and owner ~= player.uid then
			player:sendTextMessage(MESSAGE_FAILURE, "You are not the owner.")
			return true
		end

		toPosition:sendMagicEffect(CONST_ME_WATERSPLASH)
		target:remove()

		local rareChance = math.random(100)
		if rareChance == 1 then
			player:addItem(lootVeryRare[math.random(#lootVeryRare)], 1)
		elseif rareChance <= 3 then
			player:addItem(lootRare[math.random(#lootRare)], 1)
		elseif rareChance <= 10 then
			player:addItem(lootCommon[math.random(#lootCommon)], 1)
		else
			player:addItem(lootTrash[math.random(#lootTrash)], 1)
		end
		return true
	end

	if targetId ~= 7236 then
		toPosition:sendMagicEffect(CONST_ME_LOSEENERGY)
	end

	if targetId == 622 or targetId == 13989 then
		return true
	end

	player:addSkillTries(SKILL_FISHING, 1, true)
	if math.random(100) <= math.min(math.max(10 + (player:getEffectiveSkillLevel(SKILL_FISHING) - 10) * 0.597, 10), 50) then
		if useWorms and not player:removeItem("nail", 1) then
			return true
		end

		if targetId == 13988 then
			target:transform(targetId + 1)
			target:decay()

			if math.random(100) >= 97 then
				player:addItem(13992, 1)
				return true
			end
		elseif targetId == 7236 then
			target:transform(targetId + 1)
			target:decay()

			local rareChance = math.random(100)
			if rareChance == 1 then
				player:addItem(7158, 1)
				return true
			elseif rareChance <= 4 then
				player:addItem(3580, 1)
				return true
			elseif rareChance <= 10 then
				player:addItem(7159, 1)
				return true
			end
		end
		player:addItem("mechanical fish", 1)
	end
	return true
end

mechanicalFishing:id(9306)
mechanicalFishing:allowFarUse(true)
mechanicalFishing:register()

