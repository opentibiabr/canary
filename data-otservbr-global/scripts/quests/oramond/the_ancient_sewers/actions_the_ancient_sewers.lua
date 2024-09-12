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
	[21039] = { itemGerator = 21792, itemTransform = 21039 }, -- Gerator 1
	[21040] = { itemGerator = 21792, itemTransform = 21040 }, -- Gerator 2
}

local theAncientSewers = Action()

function theAncientSewers.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local gerator = config[item.itemid]
	if gerator then
		local chance = math.random(1, 100)
		if (chance >= 1) and (chance < 50) then
			player:say("<clong!> <clong!> There This piece fixed.", TALKTYPE_MONSTER_SAY)
		elseif (chance >= 50) and (chance < 100) then
			player:say("<clong!> <clong!> <scrit scrit scrit>This should do it.", TALKTYPE_MONSTER_SAY)
		end

		item:transform(gerator.itemGerator)
		addEvent(revertItem, 2 * 60 * 1000, toPosition, gerator.itemGerator, gerator.itemTransform)
		toPosition:sendMagicEffect(CONST_ME_BLOCKHIT)
		if player:getStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission) == 1 then
			player:setStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission, 2)
		elseif player:getStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission) == 2 then
			player:setStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission, 3)
		elseif player:getStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission) == 3 then
			player:setStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission, 4)
		elseif player:getStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission) == 4 then
			player:setStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission, 5)
		elseif player:getStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission) == 5 then
			player:setStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission, 6)
		elseif player:getStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission) == 6 then
			player:setStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission, 7)
		elseif player:getStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission) == 7 then
			player:setStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission, 8)
		elseif player:getStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission) == 8 then
			player:setStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission, 9)
		elseif player:getStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission) == 9 then
			player:setStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission, 10)
		elseif player:getStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission) == 10 then
			player:setStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission, 11)
		elseif player:getStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission) == 11 then
			player:setStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission, 12)
		elseif player:getStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission) == 12 then
			player:setStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission, 13)
		elseif player:getStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission) == 13 then
			player:setStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission, 14)
		elseif player:getStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission) == 14 then
			player:setStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission, 15)
		elseif player:getStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission) == 15 then
			player:setStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission, 16)
		elseif player:getStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission) == 16 then
			player:setStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission, 17)
		elseif player:getStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission) == 17 then
			player:setStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission, 18)
		elseif player:getStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission) == 18 then
			player:setStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission, 19)
		elseif player:getStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission) == 19 then
			player:setStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission, 20)
		elseif player:getStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission) == 20 then
			if player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission03) < 1 then
				player:setStorageValue(Storage.Quest.U10_50.DarkTrails.Mission03, 1)
			end
			player:setStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission, 21)
		end
	end
	return true
end

for itemId, info in pairs(config) do
	theAncientSewers:id(itemId)
end

theAncientSewers:register()
