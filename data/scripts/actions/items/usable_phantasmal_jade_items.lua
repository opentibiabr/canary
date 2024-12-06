local config = {
	requiredItems = {
		[34072] = { key = "spectral-horseshoes", count = 4 },
		[34073] = { key = "spectral-saddle", count = 1 },
		[34074] = { key = "spectral-horse-tac", count = 1 },
	},

	mountId = 167,
}

local usablePhantasmalJadeItems = Action()

function usablePhantasmalJadeItems.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local itemInfo = config.requiredItems[item:getId()]
	if not itemInfo then
		return true
	end

	if player:hasMount(config.mountId) then
		return true
	end

	local currentCount = (player:kv():get(itemInfo.key) or 0) + 1
	player:kv():set(itemInfo.key, currentCount)
	player:getPosition():sendMagicEffect(CONST_ME_HOLYDAMAGE)
	item:remove(1)

	for _, info in pairs(config.requiredItems) do
		if (player:kv():get(info.key) or 0) < info.count then
			return true
		end
	end

	player:addMount(config.mountId)
	player:addAchievement("Natural Born Cowboy")
	player:addAchievement("You got Horse Power")
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Phantasmal jade is now yours!")
	return true
end

for itemId, _ in pairs(config.requiredItems) do
	usablePhantasmalJadeItems:id(itemId)
end

usablePhantasmalJadeItems:register()
