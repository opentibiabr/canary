local setting = {
	[6506] = { { 6569, 15 }, { 3585, 5 }, { 3586, 10 }, { 3598, 20 }, { 3599, 10 }, 6500, 6501, 6489, 6503, 6387 }, -- red bundle
	[6507] = { { 6569, 15 }, { 3585, 5 }, { 3586, 10 }, { 3598, 20 }, { 3599, 10 }, 6500, 6501, 6489, 6505, 6387 }, -- blue bundle
	[6508] = { { 6569, 15 }, { 3585, 5 }, { 3586, 10 }, { 3598, 20 }, { 3599, 10 }, 6500, 6501, 6489, 6502, 6387 }, -- green bundle
}

local christmasBundle = Action()

function christmasBundle.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetItem = setting[item.itemid]
	if not targetItem then
		return true
	end

	local rewards = {}
	while #rewards < 7 do
		local randIndex = math.random(#targetItem)
		local gift = targetItem[randIndex]

		local count = 1
		if type(gift) == "table" then
			gift, count = unpack(gift)
		end

		rewards[#rewards + 1] = { gift, count }
		table.remove(targetItem, randIndex)
	end

	for _, reward in ipairs(rewards) do
		player:addItem(unpack(reward))
	end

	player:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
	item:remove(1)
	return true
end

for itemId in pairs(setting) do
	christmasBundle:id(itemId)
end

christmasBundle:register()
