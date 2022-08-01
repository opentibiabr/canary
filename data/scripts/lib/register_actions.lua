local holeId = {
	294, 369, 370, 385, 394, 411, 412, 413, 432, 433, 435, 8709, 594, 595, 615, 609, 610, 615, 1156, 482, 483, 868, 874, 4824, 7768, 433, 432, 413, 7767, 411, 370, 369, 7737, 7755, 7768, 7767, 7515, 7516, 7517, 7518, 7519, 7520, 7521, 7522, 7762, 8144, 8690, 8709, 12203, 12961, 17239, 19220, 23364
}

local Itemsgrinder = {
	[675] = {item_id = 30004, effect = CONST_ME_BLUE_FIREWORKS}, -- Sapphire dust
	[16122] = {item_id = 21507, effect = CONST_ME_GREENSMOKE} -- Pinch of crystal dust
	}

local holes = {
	593, 606, 608, 867, 21341
}

local JUNGLE_GRASS = {
	3696, 3702, 17153
}
local WILD_GROWTH = {
	2130, 2982, 2524, 2030, 2029, 10182
}

local fruits = {
	3584, 3585, 3586, 3587, 3588, 3589, 3590, 3591, 3592, 3593, 3595, 3596, 5096, 8011, 8012, 8013
}

local function revertItem(position, itemId, transformId)
	local item = Tile(position):getItemById(itemId)
	if item then
		item:transform(transformId)
	end
end

local function removeRemains(toPosition)
	local item = Tile(toPosition):getItemById(3133)
	if item then
		item:remove()
	end
end

local function revertCask(position)
	local caskItem = Tile(position):getItemById(3134)
	if caskItem then
		caskItem:transform(4848)
		position:sendMagicEffect(CONST_ME_MAGIC_GREEN)
	end
end

local cutItems = {
	[2291] = 3146,
	[2292] = 3146,
	[2293] = 3145,
	[2294] = 3145,
	[2295] = 3145,
	[2296] = 3145,
	[2314] = 3136,
	[2315] = 3136,
	[2316] = 3136,
	[2319] = 3136,
	[2358] = 3138,
	[2359] = 3138,
	[2360] = 3138,
	[2361] = 3138,
	[2366] = 3137,
	[2367] = 3137,
	[2368] = 3137,
	[2369] = 3137,
	[2374] = 3137,
	[2375] = 3137,
	[2376] = 3137,
	[2377] = 3137,
	[2378] = 3137,
	[2379] = 3137,
	[2380] = 3137,
	[2381] = 3137,
	[2382] = 3138,
	[2384] = 3137,
	[2385] = 3138,
	[2431] = 3136,
	[2432] = 3136,
	[2433] = 3136,
	[2441] = 3137,
	[2442] = 3137,
	[2443] = 3137,
	[2444] = 3137,
	[2445] = 3139,
	[2446] = 3139,
	[2447] = 3139,
	[2448] = 3139,
	[2449] = 3139,
	[2450] = 3139,
	[2452] = 3139,
	[2524] = 3135,
	[2904] = 3137,
	[4995] = 3137,
	[2997] = 3139,
	[2998] = 3139,
	[2999] = 3139,
	[3000] = 3139,
	[6123] = 3139,
	[2959] = 3139,
	[2960] = 3139,
	[2961] = 3139,
	[2962] = 3139,
	[2963] = 3139,
	[2964] = 3139,
	[2974] = 3135,
	[2975] = 3135,
	[2976] = 3135,
	[2979] = 3135,
	[2980] = 3135,
	[2982] = 3135,
	[2987] = 3135,
	[2986] = 3135,
	[3465] = 3142,
	[3484] = 3143,
	[3485] = 3143,
	[3486] = 3143,
	[2346] = 6266,
	[2347] = 6266,
	[2348] = 3137,
	[2349] = 3137,
	[2350] = 3137,
	[2351] = 3137,
	[2352] = 3140,
	[2353] = 6266,
	[2418] = 3137,
	[2419] = 3137,
	[2420] = 3137,
	[2421] = 3137,
	[2422] = 3137,
	[2423] = 3137,
	[2424] = 3137,
	[2425] = 3137,
	[2426] = 3140,
	[2465] = 3140,
	[2466] = 3140,
	[2467] = 3140,
	[2468] = 3140,
	[6355] = 3142,
	[6356] = 3142,
	[6357] = 3142,
	[6358] = 3142,
	[6359] = 3142,
	[6360] = 3142,
	[6362] = 3142,
	[6367] = 3135,
	[6368] = 3135,
	[6369] = 3135,
	[6370] = 3135,
	[2469] = 3135,
	[2471] = 3136,
	[2472] = 3135,
	[2473] = 3140,
	[2480] = 3135,
	[2481] = 3135,
	[2482] = 2483,
	[2483] = 3139,
	[2484] = 3139,
	[2485] = 3139,
	[2486] = 3139,
	[2519] = 3136,
	[2523] = 3135,
	[6085] = 3139,
	[116] = 3136,
	[117] = 3136,
	[118] = 3136,
	[119] = 3135,
	[404] = 3136,
	[405] = 3136,
	[6109] = 3139,
	[6110] = 3139,
	[6111] = 3139,
	[6112] = 3139,
	[182] = 188,
	[183] = 189,
	[233] = 234,
	[25798] = 0,
	[25800] = 0
}

function onUseSickle(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid == 5463 then
		target:transform(5462)
		target:decay()
		Game.createItem(5466, 1, toPosition)
		return true
	end
end

function onUseRope(player, item, fromPosition, target, toPosition, isHotkey)
	if toPosition.x == CONTAINER_POSITION then
		return false
	end

	local tile = Tile(toPosition)
	if tile:isRopeSpot() then
		player:teleportTo(toPosition:moveUpstairs())
	elseif table.contains(holeId, target.itemid) then
		toPosition.z = toPosition.z + 1
		tile = Tile(toPosition)
		if tile then
			local thing = tile:getTopVisibleThing()
			if thing:isItem() and thing:getType():isMovable() then
				return thing:moveTo(toPosition:moveUpstairs())
			elseif thing:isCreature() and thing:isPlayer() then
				return thing:teleportTo(toPosition:moveUpstairs())
			end
		end

		player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
	else
		return false
	end
	return true
end

function onUseShovel(player, item, fromPosition, target, toPosition, isHotkey)
	if table.contains(holes, target.itemid) then
		target:transform(target.itemid + 1)
		target:decay()
	elseif table.contains({231, 231}, target.itemid) then
		local rand = math.random(100)
		if target.actionid == 100 and rand <= 20 then
			target:transform(615)
			target:decay()
		elseif rand == 1 then
			Game.createItem(3042, 1, toPosition)
		elseif rand > 95 then
			Game.createMonster("Scarab", toPosition)
		end
		toPosition:sendMagicEffect(CONST_ME_POFF)
	end
	return true
end

function onUsePick(player, item, fromPosition, target, toPosition, isHotkey)
	if table.contains({354, 355}, target.itemid) then
		target:transform(394)
		target:decay()
		toPosition:sendMagicEffect(CONST_ME_POFF)
	elseif target.itemid == 10310 then
		-- shiny stone refining
		local chance = math.random(1, 100)
		if chance == 1 then
			player:addItem(3043, 1) -- 1% chance of getting crystal coin
		elseif chance <= 6 then
			player:addItem(3031, 1) -- 5% chance of getting gold coin
		elseif chance <= 51 then
			player:addItem(3035, 1) -- 45% chance of getting platinum coin
		else
			player:addItem(3028, 1) -- 49% chance of getting small diamond
		end
		target:getPosition():sendMagicEffect(CONST_ME_BLOCKHIT)
		target:remove(1)
		return true
	end
	return true
end

function onUseMachete(player, item, fromPosition, target, toPosition, isHotkey)
	if table.contains(JUNGLE_GRASS, target.itemid) then
		target:transform(target.itemid == 17153 and 17151 or target.itemid - 1)
		target:decay()
		return true
	end

	if table.contains(WILD_GROWTH, target.itemid) then
		toPosition:sendMagicEffect(CONST_ME_POFF)
		target:remove()
		return true
	end
	return onDestroyItem(player, item, fromPosition, target, toPosition, isHotkey)
end

function onUseScythe(player, item, fromPosition, target, toPosition, isHotkey)
	if not table.contains({3453, 9596}, item.itemid) then -- TOOLGEAR ISN'T WORKING IDK WHY
		return false
	end
	-- Burning Sugar Cane
	if target.itemid == 5464 then
		target:transform(5463)
		target:decay()
		Game.createItem(5466, 1, toPosition)
	-- Wheat
	elseif target.itemid == 3653 then
		target:transform(3651)
		target:decay()
		Game.createItem(3605, 1, toPosition)
	else
		return false
	end
	return onDestroyItem(player, item, fromPosition, target, toPosition, isHotkey)
end