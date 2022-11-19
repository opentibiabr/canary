local setting = {
	-- Blue present
	[6570] = {
		{3598, 10},
		{6393, 3},
		2995,
		6569,
		6572,
		6574,
		6575,
		6576,
		6577,
		6578,
		6279
	},
	-- Red present
	[6571] = {
		{3035, 10},
		{3035, 10},
		{3035, 10},
		{2995, 3},
		{6392, 2},
		{6574, 2},
		{6576, 2},
		{6578, 2},
		2993,
		3036,
		3079,
		3386,
		3420,
		5944,
		6566,
		6568
	}
}

local surpriseBag = Action()

function surpriseBag.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local count = 1
	local targetItem = setting[item.itemid]
	if not targetItem then
		return true
	end

	local gift = targetItem[math.random(#targetItem)]
	if type(gift) == "table" then
		gift = gift[1]
		count = gift[2]
	end

	player:addItem(gift, count)
	item:remove(1)
	fromPosition:sendMagicEffect(CONST_ME_GIFT_WRAPS)
	return true
end

for index, value in pairs(setting) do
	surpriseBag:id(index)
end

surpriseBag:register()