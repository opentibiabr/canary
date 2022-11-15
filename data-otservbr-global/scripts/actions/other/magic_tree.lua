local itemInfos = {
	[26189] = {26193, 29425}, -- first index is the id of the item and the second the storage number for exhaustion purposes
	[26193] = {26189, 29425},
	[26187] = {26191, 29423},
	[26191] = {26187, 29423},
	[26192] = {26188, 29428},
	[26188] = {26192, 29428},
	[26194] = {26190, 29426},
	[26190] = {26194, 29426}
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
