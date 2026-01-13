local config = {
	requiredItems = {
		[36938] = { key = "fiery-horseshoe", count = 4 },
	},
	mountId = 184,
}

local fieryHorseshoe = Action()

function fieryHorseshoe.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local itemInfo = config.requiredItems[item:getId()]
	if not itemInfo then
		return true
	end

	if player:hasMount(config.mountId) then
		return true
	end

	local currentCount = (player:kv():get(itemInfo.key) or 0) + 1
	player:kv():set(itemInfo.key, currentCount)
	player:getPosition():sendMagicEffect(CONST_ME_FIREATTACK)
	item:remove(1)

	for _, info in pairs(config.requiredItems) do
		if (player:kv():get(info.key) or 0) < info.count then
			return true
		end
	end

	player:addMount(config.mountId)
	player:addAchievement("Hot on the Trail")
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Singeing Steed is now yours!")
	return true
end

for itemId, _ in pairs(config.requiredItems) do
	fieryHorseshoe:id(itemId)
end

fieryHorseshoe:register()
