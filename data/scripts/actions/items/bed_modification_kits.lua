local setting = {
	[831] = { { 734, 735 }, { 736, 737 } }, -- green kit
	[832] = { { 742, 743 }, { 744, 745 } }, -- yellow kit
	[833] = { { 738, 739 }, { 740, 741 } }, -- red kit
	[834] = { { 2487, 2488 }, { 2493, 2494 } }, -- removal kit
	[17972] = { { 17917, 17918 }, { 17919, 17920 } }, -- canopy kit
}

local function internalBedTransform(item, targetItem, toPosition, itemArray)
	targetItem:transform(itemArray[1])
	targetItem:getPosition():sendMagicEffect(CONST_ME_POFF)

	Tile(toPosition):getItemByType(ITEM_TYPE_BED):transform(itemArray[2])
	toPosition:sendMagicEffect(CONST_ME_POFF)

	item:remove()
end

local bedModificationKits = Action()

function bedModificationKits.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local newBed = setting[item:getId()]
	if not newBed or not target or not target:isItem() then
		return false
	end

	local tile = Tile(toPosition)
	if not tile or not tile:getHouse() then
		return false
	end

	local targetItemId = target:getId()
	if targetItemId == newBed[1][1] or targetItemId == newBed[2][1] then
		player:sendTextMessage(MESSAGE_FAILURE, "You already have this value modification.")
		return true
	end

	for _, value in pairs(setting) do
		if value[1][1] == targetItemId or table.contains({ 2491, 5501, 15506 }, targetItemId) then
			toPosition:sendMagicEffect(CONST_ME_POFF)
			toPosition.y = toPosition.y + 1
			internalBedTransform(item, target, toPosition, newBed[1])
			break
		elseif value[2][1] == targetItemId or table.contains({ 2489, 5499, 15508 }, targetItemId) then
			toPosition:sendMagicEffect(CONST_ME_POFF)
			toPosition.x = toPosition.x + 1
			internalBedTransform(item, target, toPosition, newBed[2])
			break
		end
	end
	return true
end

for id in pairs(setting) do
	bedModificationKits:id(id)
end

bedModificationKits:register()
