local itemInfos = {
	[29425] = {29429, 29425}, -- first index is the id of the item and the second the storage number for exhaustion purposes
	[29429] = {29425, 29425},
	[29423] = {29427, 29423},
	[29427] = {29423, 29423},
	[29428] = {29424, 29428},
	[29424] = {29428, 29428},
	[29430] = {29426, 29426},
	[29426] = {29430, 29426}
}

local storageValues = {}
local exhaustDelaySeconds = 1

local magicTree = Action()

function magicTree.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if(fromPosition.x == CONTAINER_POSITION) then
		return false
	end

	local house = player:getTile():getHouse()
	if not house then
		return false
	end

	local itemInfo = itemInfos[item:getId()]
	if not itemInfo then
		return false
	end

	if player:getStorageValue(itemInfo[2]) >= os.time() then
		return false
	end

	item:transform(itemInfo[1])
	player:setStorageValue(itemInfo[2], os.time() + exhaustDelaySeconds)
	return true
end

for index, value in pairs(itemInfos) do
	magicTree:id(index)
end

magicTree:register()
