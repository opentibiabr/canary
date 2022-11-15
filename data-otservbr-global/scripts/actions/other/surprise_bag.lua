local config = {
	[6570] = { -- bluePresent
		{3598, 10}, {6393, 3}, 6279, 6574, 6578, 6575, 6577, 6569, 6576, 6572, 2995, 14027, 14681
	},
	[6571] = { -- redPresent
		6574, 3079, 6393, 6576, 6578, 2995, 14027, 3036, 5944, 3386, 3420, 3039, 5080, 2993, 3392, 3057, 5791
	},
	[8853] = { -- surpriseBag
		{3031, 10}, 123, 2995, 2397, 651, 3218, 6574, 6393, 7377, 3578, 8778
	},
	[14751] = { -- surpriseBag
		{9642, 15},{3581, 15}, 5917, 3273, 10302, 3123, 5928, 5926, 5927, 6095, 5918, 6097, 6098, 5461, 5090
	},
	[14759] = { -- surpriseBag
		{6569, 10}, {6541, 10}, {6542, 10}, {6543, 10}, {6544, 10}, {6545, 10}, 6574, 4839, 6570, 6571, 3215
	}
}

local surpriseBag = Action()

function surpriseBag.onUse(cid, item, fromPosition, itemEx, toPosition)
	local present = config[item.itemid]
	if not present then
		return false
	end

	local count = 1
	local gift = present[math.random(1, #present)]
	if type(gift) == "table" then
		count = gift[2]
		gift = gift[1]
	end

	Player(cid):addItem(gift, count)
	Item(item.uid):remove(1)
	fromPosition:sendMagicEffect(CONST_ME_GIFT_WRAPS)
	return true
end

surpriseBag:id(6570, 6571, 8853, 14751, 14759)
surpriseBag:register()
