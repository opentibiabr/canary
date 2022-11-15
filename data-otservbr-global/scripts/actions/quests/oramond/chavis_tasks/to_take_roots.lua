local function revertRoot(position, itemId, transformId)
	local item = Tile(position):getItemById(itemId)
	if item then
		item:transform(transformId)
	end
end

local toTakeRoots = Action()
function toTakeRoots.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local rand = math.random(1, 100)
	if item.itemid == 21104 then
		if rand <= 50 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You successfully harvest some juicy roots.')
			player:addItem(21291, 1)
			item:transform(item.itemid + 2)
			addEvent(revertRoot, 120000, toPosition, 21106, 21104)
			toPosition:sendMagicEffect(CONST_ME_GREEN_RINGS)
			if player:getStorageValue(Storage.Oramond.QuestLine) <= 0 then
				player:setStorageValue(Storage.Oramond.QuestLine, 1)
			end
			if player:getStorageValue(Storage.Oramond.MissionToTakeRoots) <= 0 then
				player:setStorageValue(Storage.Oramond.MissionToTakeRoots, 1)
			end
			player:setStorageValue(Storage.Oramond.HarvestedRootCount,
				player:getStorageValue(Storage.Oramond.HarvestedRootCount) > 0
				and player:getStorageValue(Storage.Oramond.HarvestedRootCount) + 1 or 1)
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Your harvesting attempt destroyed more of the juicy roots than you could salvage.')
			item:transform(item.itemid + 2)
			addEvent(revertRoot, 120000, toPosition, 21106, 21104)
			toPosition:sendMagicEffect(CONST_ME_GREEN_RINGS)
		end
	elseif item.itemid == 21105 then
		if rand <= 50 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You successfully harvest some juicy roots.')
			player:addItem(21291, 1)
			item:transform(item.itemid + 2)
			addEvent(revertRoot, 120000, toPosition, 21107, 21105)
			toPosition:sendMagicEffect(CONST_ME_GREEN_RINGS)
			if player:getStorageValue(Storage.Oramond.QuestLine) <= 0 then
				player:setStorageValue(Storage.Oramond.QuestLine, 1)
			end
			if player:getStorageValue(Storage.Oramond.MissionToTakeRoots) <= 0 then
				player:setStorageValue(Storage.Oramond.MissionToTakeRoots, 1)
			end
			player:setStorageValue(Storage.Oramond.HarvestedRootCount,
				player:getStorageValue(Storage.Oramond.HarvestedRootCount) > 0
				and player:getStorageValue(Storage.Oramond.HarvestedRootCount) + 1 or 1)
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Your harvesting attempt destroyed more of the juicy roots than you could salvage.')
			item:transform(item.itemid + 2)
			addEvent(revertRoot, 120000, toPosition, 21107, 21105)
			toPosition:sendMagicEffect(CONST_ME_GREEN_RINGS)
		end
	elseif item.itemid == 21106 or item.itemid == 21107 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'This root has already been harvested, nothing to gain here.')
	end
	return true
end

toTakeRoots:id(21104, 21105, 21106, 21107)
toTakeRoots:register()
