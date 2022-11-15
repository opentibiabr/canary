local config = {
	[37457] = { -- supernatural box
		37572, 37573, 37574, 37575, 37576
	},
	[37461] = { -- balloon box
		37471, 37472, 37496, 37497, 37498, 37499, 37500, 37501, 37513, 37514, 37515, 37516, 37517, 37518
	},
	[37462] = { -- special carpet box
		37354, 37357, 37358, 37360, 37362, 37364
	},
	[37463] = { -- luminous box
		37543, 37544, 37545
	},
	[37465] = { -- box full of presents
		37562, 37563, 37564, 37565, 37566, 37567, 37568, 37569, 37570, 37571
	},
	[37466] = { -- embroidered box
		37540, 37541, 37542
	},
	[37467] = { -- carpet box
		37366, 37374, 37375, 37376, 37377, 37378, 37379, 37380, 37382, 37390, 37391, 37392, 37393, 37394, 37395, 37396
	},
	[37468] = { -- special fx box
		37448, 37450, 37451, 37452, 37453, 37454, 37455, 37456, 37458, 37459, 37460
	},
	[37469] = { -- special balloon box
		37502, 37503, 37504, 37505, 37506, 37507, 37508, 37509, 37510, 37511, 37512
	},
	[37614] = { -- box full of decoration
		37463, 37466, 37496, 37717
	}
}

local specialBox = Action()

function specialBox.onUse(player, item, fromPosition, itemEx, toPosition)
	local box = config[item.itemid]
	if not box or not player then
		return false
	end
	local gift = box[math.random(1, #box)]
	for index, value in pairs(config) do
		Item(item.uid):remove(1)
		if fromPosition.x == CONTAINER_POSITION then
			player:getPosition():sendMagicEffect(CONST_ME_PRISMATIC_SPARK)
			player:addItem(gift)
		else
			fromPosition:sendMagicEffect(CONST_ME_PRISMATIC_SPARK)
			fromPosition:getTile():addItem(gift)
		end
		return true
	end
end

for index, value in pairs(config) do
	specialBox:id(index)
end
specialBox:register()