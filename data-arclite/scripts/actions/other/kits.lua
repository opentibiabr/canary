local config = {
	[37562] = 37547, -- pile of presents kit
	[37563] = 37548, -- pile of three presents kit
	[37564] = 37549, -- green and blue presents kit
	[37565] = 37550, -- green and red presents kit
	[37566] = 37551, -- blue and red presents kit
	[37567] = 37552, -- blue present kit
	[37568] = 37553, -- red present kit
	[37569] = 37554, -- small blue present kit
	[37570] = 37555, -- yellow present kit
	[37571] = 37556, -- another yellow present kit
	[37717] = 37557, -- dragon pinata kit
	[39695] = 39694, -- lucky dragon kit
}

local decorationKits = Action()

function decorationKits.onUse(player, item, fromPosition, itemEx, toPosition)
	local kit = config[item.itemid]
	local fromPosition = item:getPosition()
	local tile = Tile(fromPosition)
	if not kit or not player then
		return false
	end
	if not fromPosition:getTile():getHouse() then
		player:sendTextMessage(MESSAGE_FAILURE, "You may construct this only inside a house.")
	else
		item:remove(1)
		fromPosition:getTile():addItem(kit)
		fromPosition:sendMagicEffect(CONST_ME_POFF)
	end
	return true
end

for index, value in pairs(config) do
	decorationKits:id(index)
end
decorationKits:register()