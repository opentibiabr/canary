local promotionScrolls = {
	[43946] = {storageKey = "wheel.abridged", points = 3, name = "abridged promotion scroll"},
	[43947] = {storageKey = "wheel.basic", points = 5, name = "basic promotion scroll"},
	[43948] = {storageKey = "wheel.revised", points = 9, name = "revised promotion scroll"},
	[43949] = {storageKey = "wheel.extended", points = 13, name = "extended promotion scroll"},
	[43950] = {storageKey = "wheel.advanced", points = 20, name = "advanced promotion scroll"},
}

local scroll = Action()

function scroll.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getLevel() < 51 then
		player:sendTextMessage(MESSAGE_INFO_DESCR, "Only a hero of level 51 or above can decipher this scroll.")
		return true
	end

	local scrollData = promotionScrolls[item:getId()]
	if player:getStorageValueByName(scrollData.storageKey) == 1 then
		player:sendTextMessage(MESSAGE_INFO_DESCR, "You have already deciphered this scroll.")
		return true
	end

	player:setStorageValueByName(scrollData.storageKey, 1)
	player:sendTextMessage(MESSAGE_INFO_DESCR, "You have gained " .. scrollData.points .. " promotion points for the Wheel of Destiny by deciphering the " .. scrollData.name .. ".")
	item:remove(1)

	return true
end

for id in pairs(promotionScrolls) do
	scroll:id(id)
end

scroll:register()
