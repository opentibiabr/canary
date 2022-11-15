local SPECIAL_QUESTS = {3099, 3100, 9628, 11418, 11557, 23644, 24632, 14338}

local walkback = MoveEvent()

function walkback.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()

	if not player or (player:getAccountType() ~= ACCOUNT_TYPE_NORMAL and player:getGroup():getId() > GROUP_TYPE_SENIORTUTOR) then
		return true
	end

	if (Container(item.uid) and not isInArray(SPECIAL_QUESTS, item.actionid) and item.uid > 65535) then
		return true
	end

	if position == fromPosition then
		if player:isPlayer() then
			local temple = creature:getTown():getTemplePosition()
			player:teleportTo(temple, false)
		else
			player:remove()
		end
	else
		creature:teleportTo(fromPosition, true)
	end

	return true
end

walkback:type("stepin")
walkback:id(2431, 2432, 2433, 2434, 2469, 2472, 2473, 2478, 2480, 2481, 2482, 21427, 21428, 21429, 21430, 21431, 21432, 21433, 21434)
walkback:register()
