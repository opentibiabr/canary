local config = {
	requiredItems = {
		[44048] = { key = "spiritual-horseshoe", count = 4 },
	},
	mountId = 217,
}

local spiritualHorseshoe = Action()

function spiritualHorseshoe.onUse(player, item, fromPosition, target, toPosition, isHotkey)
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
	player:addAchievement("The Spirit of Purity")
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Spirit of Purity is now yours!")
	return true
end

for itemId, _ in pairs(config.requiredItems) do
	spiritualHorseshoe:id(itemId)
end

spiritualHorseshoe:register()
