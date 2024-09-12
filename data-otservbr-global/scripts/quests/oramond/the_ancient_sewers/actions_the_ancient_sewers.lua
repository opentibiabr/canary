local config = {
	[21039] = { itemGerator = 21792, itemTransform = 21039 },
	[21040] = { itemGerator = 21792, itemTransform = 21040 },
}

local function revertItem(toPosition, getItemId, itemTransform)
	local tile = toPosition:getTile()
	if tile then
		local thing = tile:getItemById(getItemId)
		if thing then
			thing:transform(itemTransform)
		end
	end
end

local theAncientSewers = Action()

function theAncientSewers.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local gerator = config[item.itemid]
	if not gerator then
		return true
	end

	player:say((math.random(1, 100) < 50) and "<clong!> <clong!> There This piece fixed." or "<clong!> <clong!> <scrit scrit scrit>This should do it.", TALKTYPE_MONSTER_SAY)
	item:transform(gerator.itemGerator)
	addEvent(revertItem, 2 * 60 * 1000, toPosition, gerator.itemGerator, gerator.itemTransform)
	toPosition:sendMagicEffect(CONST_ME_BLOCKHIT)

	local currentMission = player:getStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission)
	if currentMission >= 1 and currentMission < 20 then
		player:setStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission, currentMission + 1)
	elseif currentMission == 20 then
		if player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission03) < 1 then
			player:setStorageValue(Storage.Quest.U10_50.DarkTrails.Mission03, 1)
		end

		player:setStorageValue(Storage.Quest.U10_50.OramondQuest.TheAncientSewers.Mission, 21)
	end
	return true
end

for itemId, info in pairs(config) do
	theAncientSewers:id(itemId)
end

theAncientSewers:register()
