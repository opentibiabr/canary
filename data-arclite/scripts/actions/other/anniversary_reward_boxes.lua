local config = {
	[39704] = { -- small reward box
		{id = 37533, count = 1}, -- birthday layer cake
		{id = 37530, count = 1}, -- bottle of champagne
		{id = 37531, count = 1}, -- candy floss
		{id = 37532, count = 1}, -- ice cream cone
		{id = 37461, count = 1}, -- balloon box
		{id = 37463, count = 1}, -- luminous box
		{id = 37467, count = 1}, -- carpet box
		{id = 37468, count = 1} -- special fx box
	},
	[39705] = { -- reward box
		{id = 37530, count = 2}, -- bottle of champagne
		{id = 37531, count = 2}, -- candy floss
		{id = 37532, count = 2}, -- ice cream cone
		{id = 37533, count = 2}, -- birthday layer cake
		{id = 37461, count = 2}, -- balloon box
		{id = 37463, count = 1}, -- luminous box
		{id = 37467, count = 2}, -- carpet box
		{id = 37468, count = 3}, -- special fx box
		{id = 37462, count = 2}, -- special carpet box
		{id = 37465, count = 2}, -- box full of presents
		{id = 37457, count = 1}, -- supernatural box
		{id = 37469, count = 2}, -- special balloon box
		{id = 37466, count = 1} -- embroidered box
	},
	[39706] = { -- box full of balloons
		{id = 39671, count = 1}, -- balloon no. 0
		{id = 39672, count = 1}, -- balloon no. 1
		{id = 39673, count = 1}, -- balloon no. 2
		{id = 39674, count = 1}, -- balloon no. 3
		{id = 39675, count = 1}, -- balloon no. 4
		{id = 39676, count = 1}, -- balloon no. 5
		{id = 39677, count = 1}, -- balloon no. 6
		{id = 39678, count = 1}, -- balloon no. 7
		{id = 39679, count = 1}, -- balloon no. 8
		{id = 39680, count = 1}, -- balloon no. 9
	},
	[39710] = { -- big reward box
		{id = 39693, count = 1}, -- 25 years backpack
		{id = 37530, count = 2}, -- bottle of champagne
		{id = 37531, count = 2}, -- candy floss
		{id = 37532, count = 2}, -- ice cream cone
		{id = 37533, count = 2}, -- birthday layer cake
		{id = 37461, count = 2}, -- balloon box
		{id = 37463, count = 1}, -- luminous box
		{id = 37467, count = 2}, -- carpet box
		{id = 37468, count = 3}, -- special fx box
		{id = 37462, count = 2}, -- special carpet box
		{id = 37465, count = 2}, -- box full of presents
		{id = 37457, count = 1}, -- supernatural box
		{id = 37469, count = 2}, -- special balloon box
		{id = 37466, count = 1} -- embroidered box
	}
}

local rewardBox = Action()
function rewardBox.onUse(player, item, fromPosition, itemEx, toPosition)
    local box = config[item:getId()]
	if not box or not player then
		return false
	end
    for i = 1, #box do
        if box[i] then
          player:addItem(box[i].id, box[i].count)
		  player:getPosition():sendMagicEffect(CONST_ME_PRISMATIC_SPARK)
    	end
    end
    item:remove()
    return true
end

for index, value in pairs(config) do
	rewardBox:id(index)
end
rewardBox:register()