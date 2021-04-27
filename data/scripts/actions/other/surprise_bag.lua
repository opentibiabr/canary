local config = {
	[6570] = { -- bluePresent
		{2687, 10}, {6394, 3}, 6280, 6574, 6578, 6575, 6577, 6569, 6576, 6572, 2114, 15439, 16014
	},
	[6571] = { -- redPresent
		6574, 2195, 6394, 6576, 6578, 2114, 15439, 2153, 5944, 2492, 2520, 2156, 5080, 2112, 2498, 2173, 5791
	},
	[9108] = { -- surpriseBag
		{2148, 10}, 7487, 2114, 8072, 7735, 8110, 6574, 6394, 7377, 2667, 9693
	},
	[16094] = { -- surpriseBag
		{10559, 15},{2670, 15}, 5917, 2385, 11219, 2238, 5928, 5926, 5927, 6095, 5918, 6097, 6098, 5462, 5091
	},
	[16102] = { -- surpriseBag
		{6569, 10}, {6541, 10}, {6542, 10}, {6543, 10}, {6544, 10}, {6545, 10}, 6574, 4850, 6570, 6571, 11400
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

surpriseBag:id(6570, 6571, 9108, 16094, 16102)
surpriseBag:register()
