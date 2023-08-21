local liquidContainers = { 133, 2524, 2873, 2874, 2875, 2876, 2877, 2879, 2880, 2881, 2882, 2885, 2893, 2901, 2902, 2903 }
local millstones = { 1943, 1944, 1945, 1946 }
local oven = { 2535, 2537, 2539, 2541 }

local baking = Action()

function baking.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 3603 and table.contains(liquidContainers, target.itemid) then
		if target.type == 1 then
			if target.itemid == 133 then
				item:transform(item.itemid, item.type - 1)
				player:addItem(8195, 1)
				target:transform(2874, 0)
			else
				item:transform(item.itemid, item.type - 1)
				player:addItem(3604, 1)
				target:transform(target.itemid, 0)
			end
		elseif target.type == 9 then
			item:transform(item.itemid, item.type - 1)
			player:addItem(6276, 1)
			target:transform(target.itemid, 0)
		end
	-- flour
	-- water / holy water
	-- lump of holy water dough
	-- lump of dough
	-- milk
	-- lump of cake dough
	elseif item.itemid == 6276 and target.itemid == 6574 then -- lump of cake dough / bar of chocolate
		item:transform(item.itemid, item.type - 1)
		target:transform(target.itemid, target.type - 1)
		player:addItem(8018) -- lump of chocolate dough
	elseif item.itemid == 8195 and target.itemid == 8197 then -- bulb of garlic
		item:transform(item.itemid, item.type - 1)
		target:transform(target.itemid, target.type - 1)
		player:addItem(8196) -- lump of garlic dough
	elseif item.itemid == 8196 and target.itemid == 3464 then -- baking tray
		item:transform(item.itemid, item.type - 1)
		target:transform(8198) -- baking tray with garlic cookie dough on it
	elseif table.contains(oven, target.itemid) then
		if table.contains({ 6276, 8018 }, item.itemid) then
			player:addItem(item.itemid + 1, 1)
			item:transform(item.itemid, item.type - 1) -- bread
		-- cake / chocolate cake
		elseif item.itemid == 8196 then -- lump of garlic dough
			player:addItem(8194) -- garlic bread
			item:transform(item.itemid, item.type - 1)
		elseif item.itemid == 8198 then -- baking tray with garlic cookie dough on it
			player:addItem(8199, 12) -- garlic cookies
			item:transform(3464)
		else
			item:transform(item.itemid, item.type - 1)
			player:addItem(3600, 1)
		end
	elseif item.itemid == 5466 and target.itemid == 3605 then -- bunch of sugar cane, bunch of wheat
		item:transform(12802) -- sugar oat
		target:remove()
	elseif table.contains(millstones, target.itemid) then
		item:transform(item.itemid, item.type - 1)
		player:addItem(3603, 1) -- flour
	else
		return false
	end
	return true
end

baking:id(3603, 3604, 3605, 6276, 8018, 8195, 8196, 8198)
baking:register()
