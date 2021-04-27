local function revertItem(toPosition, getItemId, itemTransform)
	local tile = toPosition:getTile()
	if tile then
		local thing = tile:getItemById(getItemId)
		if thing then
			thing:transform(itemTransform)
		end
	end
end

local config = {
	[23410] = {itemGerator = 24161, itemTransform = 23410}, -- Gerator 1
	[23411] = {itemGerator = 24161, itemTransform = 23411} -- Gerator 2
}

local theAncientSewers = Action()

function theAncientSewers.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local gerator = config[item.itemid]
	if gerator then
		local chance = math.random(1, 100)
		if((chance >= 1) and (chance < 50)) then
			player:say("<clong!> <clong!> There This piece fixed.", TALKTYPE_ORANGE_1)
		elseif((chance >= 50) and (chance < 100)) then
			player:say("<clong!> <clong!> <scrit scrit scrit>This should do it.", TALKTYPE_ORANGE_1)
		end

		item:transform(gerator.itemGerator)
		addEvent(revertItem, 2 * 60 * 1000, toPosition, gerator.itemGerator, gerator.itemTransform)
		toPosition:sendMagicEffect(CONST_ME_BLOCKHIT)
		if player:getStorageValue(Storage.Oramond.MissionAbandonedSewer) <= 0 then
			player:setStorageValue(Storage.Oramond.MissionAbandonedSewer,1)
			player:setStorageValue(Storage.Oramond.MissionToTakeRoots1)
		elseif player:getStorageValue(Storage.Oramond.MissionAbandonedSewer) == 1 then
			player:setStorageValue(Storage.Oramond.MissionAbandonedSewer,2)
		elseif player:getStorageValue(Storage.Oramond.MissionAbandonedSewer) == 2 then
			player:setStorageValue(Storage.Oramond.MissionAbandonedSewer,3)
		elseif player:getStorageValue(Storage.Oramond.MissionAbandonedSewer) == 3 then
			player:setStorageValue(Storage.Oramond.MissionAbandonedSewer,4)
		elseif player:getStorageValue(Storage.Oramond.MissionAbandonedSewer) == 4 then
			player:setStorageValue(Storage.Oramond.MissionAbandonedSewer,5)
		elseif player:getStorageValue(Storage.Oramond.MissionAbandonedSewer) == 5 then
			player:setStorageValue(Storage.Oramond.MissionAbandonedSewer,6)
		elseif player:getStorageValue(Storage.Oramond.MissionAbandonedSewer) == 6 then
			player:setStorageValue(Storage.Oramond.MissionAbandonedSewer,7)
		elseif player:getStorageValue(Storage.Oramond.MissionAbandonedSewer) == 7 then
			player:setStorageValue(Storage.Oramond.MissionAbandonedSewer,8)
		elseif player:getStorageValue(Storage.Oramond.MissionAbandonedSewer) == 8 then
			player:setStorageValue(Storage.Oramond.MissionAbandonedSewer,9)
		elseif player:getStorageValue(Storage.Oramond.MissionAbandonedSewer) == 9 then
			player:setStorageValue(Storage.Oramond.MissionAbandonedSewer,10)
		elseif player:getStorageValue(Storage.Oramond.MissionAbandonedSewer) == 10 then
			player:setStorageValue(Storage.Oramond.MissionAbandonedSewer,11)
		elseif player:getStorageValue(Storage.Oramond.MissionAbandonedSewer) == 11 then
			player:setStorageValue(Storage.Oramond.MissionAbandonedSewer,12)
		elseif player:getStorageValue(Storage.Oramond.MissionAbandonedSewer) == 12 then
			player:setStorageValue(Storage.Oramond.MissionAbandonedSewer,13)
		elseif player:getStorageValue(Storage.Oramond.MissionAbandonedSewer) == 13 then
			player:setStorageValue(Storage.Oramond.MissionAbandonedSewer,14)
		elseif player:getStorageValue(Storage.Oramond.MissionAbandonedSewer) == 14 then
			player:setStorageValue(Storage.Oramond.MissionAbandonedSewer,15)
		elseif player:getStorageValue(Storage.Oramond.MissionAbandonedSewer) == 15 then
			player:setStorageValue(Storage.Oramond.MissionAbandonedSewer,16)
		elseif player:getStorageValue(Storage.Oramond.MissionAbandonedSewer) == 16 then
			player:setStorageValue(Storage.Oramond.MissionAbandonedSewer,17)
		elseif player:getStorageValue(Storage.Oramond.MissionAbandonedSewer) == 17 then
			player:setStorageValue(Storage.Oramond.MissionAbandonedSewer,18)
		elseif player:getStorageValue(Storage.Oramond.MissionAbandonedSewer) == 18 then
			player:setStorageValue(Storage.Oramond.MissionAbandonedSewer,19)
		elseif player:getStorageValue(Storage.Oramond.MissionAbandonedSewer) == 19 then
			if player:getStorageValue(Storage.DarkTrails.Mission03) < 1 then
				player:setStorageValue(Storage.DarkTrails.Mission03,1)
			end
			player:setStorageValue(Storage.Oramond.MissionAbandonedSewer, 20)
		end
	end
	return true
end

theAncientSewers:id(23410, 23411)
theAncientSewers:register()
