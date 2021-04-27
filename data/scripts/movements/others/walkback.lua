local SPECIAL_QUESTS = {2215, 2216, 10544, 12374, 12513, 26300, 27300, 28300}

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
walkback:id(1714, 1715, 1716, 1717, 1738, 1740, 1741, 1746, 1747, 1748, 1749, 23798, 23799, 23800, 23801, 23802, 23803, 23804, 23805)
walkback:register()
