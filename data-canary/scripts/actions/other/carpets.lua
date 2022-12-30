local carpetItems = {
	[22737] = 22736, [22736] = 22737,-- Rift carpet
	[23537] = 23536, [23536] = 23537,-- Void carpet
	[23431] = 23453, [23453] = 23431,-- Yalaharian carpet
	[23432] = 23454, [23454] = 23432,-- White fur carpet
	[23433] = 23455, [23455] = 23433,-- Bamboo mat carpet
	[23715] = 23707, [23707] = 23715,-- Crimson carpet
	[23710] = 23716, [23716] = 23710,-- Azure carpet
	[23711] = 23717, [23717] = 23711,-- Emerald carpet
	[23712] = 23718, [23718] = 23712,-- Light parquet carpet
	[23713] = 23719, [23719] = 23713,-- Dark parquet carpet
	[23714] = 23720, [23720] = 23714,-- Marble floor
	[24416] = 24424, [24424] = 24416,-- Flowery carpet
	[24417] = 24425, [24425] = 24417,-- Colourful Carpet
	[24418] = 24426, [24426] = 24418,-- Striped carpet
	[24419] = 24427, [24427] = 24419,-- Fur carpet
	[24420] = 24428, [24428] = 24420,-- Diamond carpet
	[24421] = 24429, [24429] = 24421,-- Patterned carpet
	[24422] = 24430, [24430] = 24422,-- Night sky carpet
	[24423] = 24431, [24431] = 24423,-- Star carpet
	[26114] = 26115, [26115] = 26114,-- Verdant carpet
	[26116] = 26117, [26117] = 26116,-- Shaggy carpet
	[26118] = 26119, [26119] = 26118,-- Mystic carpet
	[26120] = 26121, [26121] = 26120,-- Stone tile
	[26123] = 26122, [26122] = 26123,-- Wooden plank
	[26151] = 26150, [26150] = 26151,-- Wheat carpet
	[26152] = 26153, [26153] = 26152,-- Crested carpet
	[26154] = 26155, [26155] = 26154 -- Decorated carpet
}

local carpets = Action()

function carpets.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local carpet = carpetItems[item.itemid]
	if not carpet then
		return false
	end
	local tile = Tile(item:getPosition())
	local carpetStack = 0
	for _, carpetId in pairs(carpetItems) do
		carpetStack = carpetStack + tile:getItemCountById(carpetId)
	end
	if fromPosition.x == CONTAINER_POSITION then
		player:sendTextMessage(MESSAGE_FAILURE, "Put the item on the floor first.")
		return true
	elseif not tile or not tile:getHouse() then
		player:sendTextMessage(MESSAGE_FAILURE, "You may use this only inside a house.")
		return true
	elseif carpetStack > 1 then
		player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		return true
	end
	item:transform(carpet)
	return true
end

for index, value in pairs(carpetItems) do
	carpets:id(index)
end

carpets:register()
