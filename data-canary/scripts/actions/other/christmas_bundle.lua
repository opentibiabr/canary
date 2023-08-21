local setting = {
	-- [christmas bundle item id] = {{reward item id, count}, ...}
	[6506] = { -- red bundle
	{ 6569, 15 }, { 3585, 5 }, { 3586, 10 }, { 3598, 20 }, { 3599, 10 }, 6500, 6501, 6489, 6503, 6387 }, -- candy -- red apple -- orange -- cookie -- candy cane -- gingerbreadman -- christmas wreath -- christmas branch -- red christmas garland -- christmas card
	[6507] = { -- blue bundle
	{ 6569, 15 }, { 3585, 5 }, { 3586, 10 }, { 3598, 20 }, { 3599, 10 }, 6500, 6501, 6489, 6505, 6387 }, -- candy -- red apple -- orange -- cookie -- candy cane -- gingerbreadman -- christmas wreath -- christmas branch -- blue christmas garland -- christmas card
	[6508] = { -- green bundle
	{ 6569, 15 }, { 3585, 5 }, { 3586, 10 }, { 3598, 20 }, { 3599, 10 }, 6500, 6501, 6489, 6502, 6387 } -- candy -- red apple -- orange -- cookie -- candy cane -- gingerbreadman -- christmas wreath -- christmas branch -- christmas garland -- christmas card
}

local christmasBundle = Action()

function christmasBundle.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetItem = setting[item.itemid]
	if not targetItem then
		return true
	end

	local rewards = {}
	while #rewards < 7 do
		local count = 1
		local rand = math.random(#targetItem)
		local gift = targetItem[rand]
		if type(gift) == "table" then
			gift, count = unpack(gift)
		end
		rewards[#rewards + 1] = { gift, count }
		table.remove(targetItem, rand)
	end

	for i = 1, #rewards do
		player:addItem(unpack(rewards[i]))
	end
	item:remove(1)
	player:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
	return true
end

for index, value in pairs(setting) do
	christmasBundle:id(index)
end

christmasBundle:register()
