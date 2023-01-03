local storeItemID = {
	-- registered item ids here are not tradable with players
	-- these items can be set to moveable at items.xml
	-- 500 charges exercise weapons
	28552, -- exercise sword
	28553, -- exercise axe
	28554, -- exercise club
	28555, -- exercise bow
	28556, -- exercise rod
	28557, -- exercise wand

	-- 50 charges exercise weapons
	28540, -- training sword
	28541, -- training axe
	28542, -- training club
	28543, -- training bow
	28544, -- training wand
	28545, -- training club

	-- magic gold and magic converter (activated/deactivated)
	28525, -- magic gold converter
	28526, -- magic gold converter
	23722, -- gold converter
	25719, -- gold converter

	-- foods
	29408, -- roasted wyvern wings
	29409, -- carrot pie
	29410, -- tropical marinated tiger
	29411, -- delicatessen salad
	29412, -- chilli con carniphila
	29413, -- svargrond salmon filet
	29414, -- carrion casserole
	29415, -- consecrated beef
	29416 -- overcooked noodles
}

local ec = EventCallback

function ec.onTradeRequest(player, target, item)
	-- No trade items with actionID = 100
	if item:getActionId() == NOT_MOVEABLE_ACTION then
		return false
	end

	if table.contains(storeItemID, item:getId()) then
		return false
	end
	return true
end

ec:register(--[[0]])
