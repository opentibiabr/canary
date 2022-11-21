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
	2130, 2130, 2982, 2524, 2030, 2029, 10182
}

local fruits = {
	3584, 3585, 3586, 3587, 3588, 3589, 3590, 3591, 3592, 3593, 3595, 3596, 5096, 8011, 8012, 8013
}

local lava = {
	Position(32808, 32336, 11),
	Position(32809, 32336, 11),
	Position(32810, 32336, 11),
	Position(32808, 32334, 11),
	Position(32807, 32334, 11),
	Position(32807, 32335, 11),
	Position(32807, 32336, 11),
	Position(32807, 32337, 11),
	Position(32806, 32337, 11),
	Position(32805, 32337, 11),
	Position(32805, 32338, 11),
	Position(32805, 32339, 11),
	Position(32806, 32339, 11),
	Position(32806, 32338, 11),
	Position(32807, 32338, 11),
	Position(32808, 32338, 11),
	Position(32808, 32337, 11),
	Position(32809, 32337, 11),
	Position(32810, 32337, 11),
	Position(32811, 32337, 11),
	Position(32811, 32338, 11),
	Position(32806, 32338, 11),
	Position(32810, 32338, 11),
	Position(32810, 32339, 11),
	Position(32809, 32339, 11),
	Position(32809, 32338, 11),
	Position(32811, 32336, 11),
	Position(32811, 32335, 11),
	Position(32810, 32335, 11),
	Position(32809, 32335, 11),
	Position(32808, 32335, 11),
	Position(32809, 32334, 11),
	Position(32809, 32333, 11),
	Position(32810, 32333, 11),
	Position(32811, 32333, 11),
	Position(32806, 32338, 11),
	Position(32810, 32334, 11),
	Position(32811, 32334, 11),
	Position(32812, 32334, 11),
	Position(32813, 32334, 11),
	Position(32814, 32334, 11),
	Position(32812, 32333, 11),
	Position(32810, 32334, 11),
	Position(32812, 32335, 11),
	Position(32813, 32335, 11),
	Position(32814, 32335, 11),
	Position(32814, 32333, 11),
	Position(32813, 32333, 11)
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
	[4995] = 4996,
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

-- Ferumbras ascendant ring reward
local function addFerumbrasAscendantReward(player, target, toPosition)
	local stonePos = Position(32648, 32134, 10)
	if (toPosition == stonePos) then
		local tile = Tile(stonePos)
		local stone = tile:getItemById(1772)
		if stone then
			stone:remove(1)
			toPosition:sendMagicEffect(CONST_ME_POFF)
			addEvent(function()
				Game.createItem(1772, 1, stonePos)
			end, 20000)
			return true
		end
	end

	if target.itemid == 10551 and target.actionid == 53803 then
		if player:getStorageValue(Storage.FerumbrasAscendant.Ring) >= 1 then
			return false
		end

		player:addItem(22170, 1)
		player:setStorageValue(Storage.FerumbrasAscendant.Ring, 1)
	end
end

function onDestroyItem(player, item, fromPosition, target, toPosition, isHotkey)
	if not target or target == nil or type(target) ~= "userdata" or not target:isItem() then
		return false
	end

	if target:hasAttribute(ITEM_ATTRIBUTE_UNIQUEID) or target:hasAttribute(ITEM_ATTRIBUTE_ACTIONID) then
		return false
	end

	if toPosition.x == CONTAINER_POSITION then
		player:sendCancelMessage(Game.getReturnMessage(RETURNVALUE_NOTPOSSIBLE))
		return true
	end

	local destroyId = cutItems[target.itemid] or ItemType(target.itemid):getDestroyId()
	if destroyId == 0 then
		if target.itemid ~= 25798 and target.itemid ~= 25800 then
			return false
		end
	end

	local watt = ItemType(item.itemid):getAttack()
	if math.random(1, 80) <= (watt and watt > 10 and watt or 10) then
		-- Against The Spider Cult (Spider Eggs)
		if target.itemid == 233 then
			local eggStorage = player:getStorageValue(Storage.TibiaTales.AgainstTheSpiderCult)
			if eggStorage >= 1 and eggStorage < 5 then
				player:setStorageValue(Storage.TibiaTales.AgainstTheSpiderCult, math.max(1, eggStorage) + 1)
			end

			Game.createMonster("Giant Spider", Position(33181, 31869, 12))
		end

		-- Move items outside the container
		if target:isContainer() then
			for i = target:getSize() - 1, 0, -1 do
				local containerItem = target:getItem(i)
				if containerItem then
					containerItem:moveTo(toPosition)
				end
			end
		end

		-- Being better than cipsoft
		if target:getFluidType() ~= 0 then
			local fluid = Game.createItem(2886, target:getFluidType(), toPosition)
			if fluid ~= nil then
				fluid:decay()
			end
		end

		target:remove(1)

		local itemDestroy = Game.createItem(destroyId, 1, toPosition)
		if itemDestroy ~= nil then
			itemDestroy:decay()
		end

		-- Energy barrier na threatned dreams quest (feyrist)
		if target.itemid == 25798 or target.itemid == 25800 then
			addEvent(Game.createItem, math.random(13000, 17000), target.itemid, 1, toPosition)
		end
	end

	toPosition:sendMagicEffect(CONST_ME_POFF)
	return true
end

function onUseRope(player, item, fromPosition, target, toPosition, isHotkey)
	if toPosition.x == CONTAINER_POSITION then
		return false
	end

	local tile = Tile(toPosition)
	if tile:isRopeSpot() then
		player:teleportTo(toPosition:moveUpstairs())
		if target.itemid == 7762 then
			if player:getStorageValue(Storage.RookgaardTutorialIsland.tutorialHintsStorage) < 22 then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
				"You have successfully used your rope to climb out of the hole. Congratulations! Now continue to the east.")
			end
		end
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
	addFerumbrasAscendantReward(player, target, toPosition)
	--Dawnport quest (Morris amulet task)
	local sandPosition = Position(32099, 31933, 7)
	if (toPosition == sandPosition) then
		local sandTile = Tile(sandPosition)
		local amuletId = sandTile:getItemById(19401)
		if amuletId then
			if player:getStorageValue(Storage.Quest.U10_55.Dawnport.TheLostAmulet) == 1 then
				local rand = math.random(100)
				if rand <= 10 then
					player:addItem(21379, 1)
					player:setStorageValue(Storage.Quest.U10_55.Dawnport.TheLostAmulet, 2)
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found an ancient amulet. Strange engravings cover it. Maybe Morris can make them out.")
				elseif rand <= 80 then
					player:addItem(21395, 1)
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You dig up sand and sea shells.")
				elseif rand > 95 then
					player:addItem(3976, math.random(1, 10))
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You dig up some worms. But you are confident that you'll find the amulet here, somewhere.")
				end
				toPosition:sendMagicEffect(CONST_ME_POFF)
			else
				return false
			end
		end
		return true
	end

	if table.contains(holes, target.itemid) then
		target:transform(target.itemid + 1)
		target:decay()
	elseif target.itemid == 1822 and target:getPosition() == Position(33222, 31100, 7) then
		player:teleportTo(Position(33223, 31100, 8))
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
	-- Rookgaard tutorial island
	elseif target.itemid == 351 and target.actionid == 8024 then
		player:addItem(11341, 1)
		player:say("You dig out a handful of earth from this sacred place.", TALKTYPE_MONSTER_SAY)
	elseif target.itemid == 7749 and player:getStorageValue(Storage.RookgaardTutorialIsland.tutorialHintsStorage) < 20 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
		"You dug a hole! Walk onto it as long as it is open to jump down into the forest cave."
		)
		player:setStorageValue(Storage.RookgaardTutorialIsland.tutorialHintsStorage, 19)
		Position(32070, 32266, 7):sendMagicEffect(CONST_ME_TUTORIALARROW)
		Position(32070, 32266, 7):sendMagicEffect(CONST_ME_TUTORIALSQUARE)
		target:transform(594)
		addEvent(revertItem, 30 * 1000, toPosition, 594, 7749)
	elseif target.actionid == 4654 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission49) == 1
	and player:getStorageValue(Storage.GravediggerOfDrefia.Mission50) < 1 then
		-- Gravedigger Quest
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You found a piece of the scroll. You pocket it quickly.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		player:addItem(18933, 1)
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission50, 1)
	elseif target.actionid == 4668 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission69) == 1
	and player:getStorageValue(Storage.GravediggerOfDrefia.Mission70) < 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A torn scroll piece emerges. Probably gnawed off by rats.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		player:addItem(18933, 1)
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission70, 1)
	elseif target.actionid == 50118 then
		local wagonItem = Tile(Position(32717, 31492, 11)):getItemById(7131)
		if wagonItem then
			if Tile(Position(32717, 31492, 11)):getItemById(7921) then
				return true
			end
			Game.createItem(7921, 1, wagonItem:getPosition()):setActionId(40023)
			toPosition:sendMagicEffect(CONST_ME_POFF)
		end
	elseif target.itemid == 7921 then
		local coalItem = Tile(Position(32699, 31492, 11)):getItemById(7921)
		if coalItem then
			coalItem:remove(1)
			toPosition:sendMagicEffect(CONST_ME_POFF)
			Tile(Position(32699, 31492, 11)):getItemById(7131):setActionId(40023)
			local crucibleItem = Tile(Position(32699, 31494, 11)):getItemById(7814)
			if crucibleItem then
				crucibleItem:setActionId(50119)
			end
		end
	elseif table.contains({8716, 17950, 15047, 16306, 16300}, target.itemid) then
		if player:getStorageValue(Storage.SwampDiggingTimeout) >= os.time() then
			toPosition:sendMagicEffect(CONST_ME_POFF)
			return false
		end

		local config = {
			{from = 1, to = 39, itemId = 3998},
			{from = 40, to = 79, itemId = 3028},
			{from = 80, to = 100, itemId = 17858}
		}

		local chance = math.random(100)
		for i = 1, #config do
			local randItem = config[i]
			if chance >= randItem.from and chance <= randItem.to then
				player:addItem(randItem.itemId, 1)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You dug up a " .. ItemType(randItem.itemId):getName() .. ".")
				player:setStorageValue(Storage.SwampDiggingTimeout, os.time() + 604800)
				toPosition:sendMagicEffect(CONST_ME_GREEN_RINGS)
				break
			end
		end
	elseif target.itemid == 103 and target.actionid == 4205 then
		if player:getStorageValue(Storage.TibiaTales.IntoTheBonePit) ~= 1 then
			return false
		end

		local remains = Game.createItem(3133, 1, toPosition)
		if remains then
			remains:setActionId(4206)
		end
		toPosition:sendMagicEffect(CONST_ME_HITAREA)
		addEvent(removeRemains, 60000, toPosition)
	elseif target.itemid == 5730 then
		if not player:removeItem(5090, 1) then
			return false
		end

		target:transform(5731)
		target:decay()
		toPosition:sendMagicEffect(CONST_ME_POFF)
	else
		return false
	end
	return true
end

function onUsePick(player, item, fromPosition, target, toPosition, isHotkey)
	local stonePos = Position(32648, 32134, 10)
	if (toPosition == stonePos) then
		local tile = Tile(stonePos)
		local stone = tile:getItemById(1772)
		if stone then
			stone:remove(1)
			toPosition:sendMagicEffect(CONST_ME_POFF)
			addEvent(function()
				Game.createItem(1772, 1, stonePos)
			end, 20000)
			return true
		end
	end

	-- The Rookie Guard Quest - Mission 09: Rock 'n Troll
	-- Path: data\scripts\actions\quests\the_rookie_guard\mission09_rock_troll.lua
	-- Damage tunnel pillars
	if player:getStorageValue(Storage.TheRookieGuard.Mission09) ~= -1 and target.itemid == 1600 then
		return onUsePickAtTunnelPillar(player, item, fromPosition, target, toPosition)
	end

	--Dawnport some cracks down
	local crackPosition = Position(32099, 31930, 7)
	if (toPosition == crackPosition) then
		local tile = Tile(crackPosition)
		local crack = tile:getItemById(6298)
		if crack then
			player:teleportTo({x = 32099, y = 31930, z = 8})
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end
	end

	if table.contains({354, 355}, target.itemid) and target.actionid == 101 then
		target:transform(394)
		target:decay()
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
	elseif target.itemid == 10310 then
		target:remove(1)
		toPosition:sendMagicEffect(CONST_ME_POFF)
		player:addItem(3035, 10)
	elseif target.itemid == 7200 then
		target:transform(7236)
		target:decay()
		toPosition:sendMagicEffect(CONST_ME_HITAREA)
	elseif target.itemid == 593 then
		target:transform(594)
		target:decay()
		toPosition:sendMagicEffect(CONST_ME_HITAREA)
	elseif target.itemid == 6298 and target.actionid > 0 then
		target:transform(615)
		target:decay()
		toPosition:sendMagicEffect(CONST_ME_HITAREA)
	elseif target.itemid == 21341 then
		target:transform(21342)
		target:decay()
		toPosition:sendMagicEffect(CONST_ME_HITAREA)
	elseif target.itemid == 606 then
		target:transform(615)
		target:decay()
		toPosition:sendMagicEffect(CONST_ME_HITAREA)
	elseif target.itemid == 608 then
		target:transform(609)
		target:decay()
		toPosition:sendMagicEffect(CONST_ME_HITAREA)
	elseif target.itemid == 867 then
		target:transform(868)
		target:decay()
		toPosition:sendMagicEffect(CONST_ME_HITAREA)
	elseif target.itemid == 7806 then
		-- Sea of light quest
		if player:getStorageValue(Storage.SeaOfLight.Questline) ~= 4 then
			return false
		end

		if toPosition == Position(33031, 31758, 8) then
			if math.random(100) <= 30 then
				if player:getStorageValue(Storage.SeaOfLight.Questline) == 4 then
					player:addItem(9697, 1)
					player:setStorageValue(Storage.SeaOfLight.Questline, player:getStorageValue(Storage.SeaOfLight.Questline) + 1)
					player:say("*crush*", TALKTYPE_MONSTER_SAY)
				end
			else
				player:getPosition():sendMagicEffect(CONST_ME_POFF)
			end
		end
	elseif target.itemid == 22075 then
		-- Grimvale quest
		if player:getStorageValue(Storage.Grimvale.SilverVein) < os.time() then
			local chance = math.random(1, 10)
			if chance >= 5 then
				player:sendTextMessage(
				MESSAGE_EVENT_ADVANCE,
				"Even after a thorough and frustrating \z
				search you could not find enough liquified silver in this vein to fill a flask."
				)
			elseif chance <= 4 then
				player:sendTextMessage(
				MESSAGE_EVENT_ADVANCE,
				"Carefully you gather some of the liquified \z
				silver from this vein in a small flask. You now feel strangely affected to the moon."
				)
				player:addItem(22058)
				target:transform(4464)
				addEvent(revertItem, 10 * 60 * 1000, toPosition, 4464, 22075)
			end
			player:setStorageValue(Storage.Grimvale.SilverVein, os.time() + 2 * 60)
		else
			player:sendTextMessage(
			MESSAGE_EVENT_ADVANCE,"You are still exhausted from earlier attempts. \z
				Getting liquid silver out of the mountain needs concentration and a steady hand.")
		end
	elseif target.itemid == 7185 then
		--The Ice Islands Quest, Nibelor 1: Breaking the Ice
		local missionProgress = player:getStorageValue(Storage.TheIceIslands.Mission02)
		local pickAmount = player:getStorageValue(Storage.TheIceIslands.PickAmount)
		if missionProgress < 1 or pickAmount >= 3 or player:getStorageValue(Storage.TheIceIslands.Questline) ~= 3 then
			return false
		end

		player:setStorageValue(Storage.TheIceIslands.PickAmount, math.max(0, pickAmount) + 1)
		-- Questlog The Ice Islands Quest, Nibelor 1: Breaking the Ice
		player:setStorageValue(Storage.TheIceIslands.Mission02, missionProgress + 1)

		if pickAmount >= 2 then
			player:setStorageValue(Storage.TheIceIslands.Questline, 4)
			-- Questlog The Ice Islands Quest, Nibelor 1: Breaking the Ice
			player:setStorageValue(Storage.TheIceIslands.Mission02, 4)
		end

		local crackItem = Tile(toPosition):getItemById(7185)
		if crackItem then
			crackItem:transform(7186)
			toPosition:sendMagicEffect(CONST_ME_POFF)
			addEvent(revertItem, 60 * 1000, toPosition, 7186, 7185)
		end
		local chakoyas = {"chakoya toolshaper", "chakoya tribewarden", "chakoya windcaller"}
		if toPosition == Position(32399, 31051, 7) then
			Game.createMonster(chakoyas[math.random(#chakoyas)], Position(32397, 31048, 7))
			Position(32397, 31048, 7):sendMagicEffect(CONST_ME_TELEPORT)
			Game.createMonster(chakoyas[math.random(#chakoyas)], Position(32399, 31048, 7))
			Position(32399, 31048, 7):sendMagicEffect(CONST_ME_TELEPORT)
		elseif toPosition == Position(32394, 31062, 7) then
			Game.createMonster(chakoyas[math.random(#chakoyas)], Position(32388, 31059, 7))
			Position(32388, 31059, 7):sendMagicEffect(CONST_ME_TELEPORT)
			Game.createMonster(chakoyas[math.random(#chakoyas)], Position(32390, 31062, 7))
			Position(32390, 31062, 7):sendMagicEffect(CONST_ME_TELEPORT)
			Game.createMonster(chakoyas[math.random(#chakoyas)], Position(32389, 31062, 7))
			Position(32389, 31062, 7):sendMagicEffect(CONST_ME_TELEPORT)
			Game.createMonster(chakoyas[math.random(#chakoyas)], Position(32387, 31064, 7))
			Position(32387, 31064, 7):sendMagicEffect(CONST_ME_TELEPORT)
		elseif toPosition == Position(32393, 31072, 7) then
			Game.createMonster(chakoyas[math.random(#chakoyas)], Position(32391, 31071, 7))
			Position(32391, 31071, 7):sendMagicEffect(CONST_ME_TELEPORT)
			Game.createMonster(chakoyas[math.random(#chakoyas)], Position(32390, 31069, 7))
			Position(32390, 31069, 7):sendMagicEffect(CONST_ME_TELEPORT)
			Game.createMonster(chakoyas[math.random(#chakoyas)], Position(32389, 31069, 7))
			Position(32389, 31069, 7):sendMagicEffect(CONST_ME_TELEPORT)
			Game.createMonster(chakoyas[math.random(#chakoyas)], Position(32388, 31074, 7))
			Position(32388, 31074, 7):sendMagicEffect(CONST_ME_TELEPORT)
			Game.createMonster(chakoyas[math.random(#chakoyas)], Position(32386, 31073, 7))
			Position(32386, 31073, 7):sendMagicEffect(CONST_ME_TELEPORT)
			Game.createMonster(chakoyas[math.random(#chakoyas)], Position(32387, 31072, 7))
			Position(32387, 31072, 7):sendMagicEffect(CONST_ME_TELEPORT)
		end
	elseif target.itemid == 1791 then
		-- The Pits of Inferno Quest
		if toPosition == Position(32808, 32334, 11) then
			for i = 1, #lava do
				Game.createItem(5815, 1, lava[i])
			end
			target:transform(3141)
			toPosition:sendMagicEffect(CONST_ME_SMOKE)
		elseif target.actionid == 50058 then
			-- naginata quest
			local stoneStorage = Game.getStorageValue(GlobalStorage.NaginataStone)
			if stoneStorage ~= 5 then
				Game.setStorageValue(GlobalStorage.NaginataStone, math.max(0, stoneStorage) + 1)
			elseif stoneStorage == 5 then
				target:remove(1)
				Game.setStorageValue(GlobalStorage.NaginataStone)
			end
			toPosition:sendMagicEffect(CONST_ME_POFF)
			doTargetCombatHealth(0, player, COMBAT_PHYSICALDAMAGE, -31, -39, CONST_ME_NONE)
		end
	elseif target.itemid == 355 and target.actionid == 101 then
		-- The Banshee Quest
		target:transform(394)
		target:decay()
		toPosition:sendMagicEffect(CONST_ME_POFF)
	elseif target.actionid == 50090 then
		-- The Hidden City of Beregar Quest
		if player:getStorageValue(Storage.hiddenCityOfBeregar.WayToBeregar) == 1 then
			player:teleportTo(Position(32566, 31338, 10))
		end
	elseif target.actionid == 40028 then
		if Tile(Position(32617, 31513, 9)):getItemById(1272)
		and Tile(Position(32617, 31514, 9)):getItemById(1624) then
			local rubbleItem = Tile(Position(32619, 31514, 9)):getItemById(5709)
			if rubbleItem then
				rubbleItem:remove(1)
			end
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
			"You can't remove this pile since it's currently holding up the tunnel.")
		end
	elseif target.actionid == 50127 then
		-- Pythius The Rotten (Firewalker Boots)
		if player:getStorageValue(Storage.QuestChests.FirewalkerBoots) == 1 then
			return false
		end
		target:remove(1)

		local stoneItem = Tile(toPosition):getItemById(1791)
		if stoneItem then
			stoneItem:remove(1)
		end

		iterateArea(function(position)
			local groundItem = Tile(position):getGround()
			if groundItem and groundItem.itemid == 21477 then
				groundItem:transform(5815)
			end
		end, Position(32550, 31373, 15), Position(32551, 31379, 15))

		iterateArea(function(position)
			position:sendMagicEffect(CONST_ME_POFF)
		end, Position(32551, 31374, 15), Position(32551, 31379, 15) )

		local portal = Game.createItem(1949, 1, Position(32551, 31376, 15))
		if portal then
			portal:setActionId(50126)
		end
	elseif target.actionid == 50091 then
		-- The Asure
		player:teleportTo(Position(32960, 32676, 4))
	elseif target.itemid == 11340 then
		-- Wrath of the emperor quest
		player:addItem(11339, 1)
		player:say("The cracked part of the table lets you cut out a large chunk of wood with your pick.",
			TALKTYPE_MONSTER_SAY )
	elseif target.itemid == 372 then
		target:transform(394)
		target:decay()
	elseif target.itemid == 2071 then
		-- Jack to the Future Quest
		if player:getStorageValue(Storage.TibiaTales.JackFutureQuest.Statue) ~= 1 then
			return false
		end

		if toPosition == Position(33277, 31754, 7) then
			if player:getStorageValue(Storage.TibiaTales.JackFutureQuest.Statue) == 1 then
				target:transform(2066)
				toPosition:sendMagicEffect(CONST_ME_POFF)
				player:addItem(10426, 1)
				player:setStorageValue(Storage.TibiaTales.JackFutureQuest.Statue, 2)
				player:setStorageValue(Storage.TibiaTales.JackFutureQuest.QuestLine, player:getStorageValue(Storage.TibiaTales.JackFutureQuest.QuestLine) + 1)
				addEvent(revertItem, 2 * 60 * 1000, {x = 33277, y = 31754, z = 7}, 2066, 2071)
			end
		end
	else
		return false
	end
	if (target ~= nil) and target:isItem() and (target:getId() == 20135) then
		--Lower Roshamuul
		if math.random(100) > 50 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Crushing the stone produces some fine gravel.")
			target:transform(20133)
			target:decay()
		else
			Game.createMonster("Frazzlemaw", toPosition)
			player:sendTextMessage(
			MESSAGE_EVENT_ADVANCE,
			"Crushing the stone yields nothing but slightly finer, yet still unusable rubber."
			)
			target:transform(20134)
			target:decay()
		end
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

function onUseCrowbar(player, item, fromPosition, target, toPosition, isHotkey)
	if not table.contains({3304, 9598}, item.itemid) then
		return false
	end

	if target.uid == 3071 then
		-- In service of yalahar quest
		if player:getStorageValue(Storage.InServiceofYalahar.SewerPipe01) < 1 then
			doSetMonsterOutfit(player, "skeleton", 3 * 1000)
			fromPosition:sendMagicEffect(CONST_ME_ENERGYHIT)
			player:setStorageValue(Storage.InServiceofYalahar.SewerPipe01, 1)
			-- StorageValue for Questlog "Mission 01: Something Rotten"
			player:setStorageValue(Storage.InServiceofYalahar.Mission01,
					player:getStorageValue(Storage.InServiceofYalahar.Mission01) + 1)
			local position = player:getPosition()
			for x = -1, 1 do
				for y = -1, 1 do
					position = position + Position(x, y, 0)
					position:sendMagicEffect(CONST_ME_YELLOWENERGY)
				end
			end
		end
	elseif target.uid == 3072 then
		if player:getStorageValue(Storage.InServiceofYalahar.SewerPipe02) < 1 then
			player:setStorageValue(Storage.InServiceofYalahar.SewerPipe02, 1)
			-- StorageValue for Questlog "Mission 01: Something Rotten"
			player:setStorageValue(Storage.InServiceofYalahar.Mission01,
					player:getStorageValue(Storage.InServiceofYalahar.Mission01) + 1)
			local position = player:getPosition()
			for x = -1, 1 do
				for y = -1, 1 do
					if math.random(2) == 2 then
						position = position + Position(x, y, 0)
						Game.createMonster("rat", position)
						position:sendMagicEffect(CONST_ME_TELEPORT)
					end
				end
			end
		end
	elseif target.uid == 3073 then
		if player:getStorageValue(Storage.InServiceofYalahar.SewerPipe03) < 1 then
			player:say("You have used the crowbar on a grate.", TALKTYPE_MONSTER_SAY)
			player:setStorageValue(Storage.InServiceofYalahar.SewerPipe03, 1)
			-- StorageValue for Questlog "Mission 01: Something Rotten"
			player:setStorageValue(Storage.InServiceofYalahar.Mission01,
					player:getStorageValue(Storage.InServiceofYalahar.Mission01) + 1)
		end
	elseif target.uid == 3074 then
		if player:getStorageValue(Storage.InServiceofYalahar.SewerPipe04) < 1 then
			doSetMonsterOutfit(player, "bog raider", 5 * 1000)
			player:say("You have used the crowbar on a knot.", TALKTYPE_MONSTER_SAY)
			player:setStorageValue(Storage.InServiceofYalahar.SewerPipe04, 1)
			-- StorageValue for Questlog "Mission 01: Something Rotten"
			player:setStorageValue(Storage.InServiceofYalahar.Mission01,
					player:getStorageValue(Storage.InServiceofYalahar.Mission01) + 1)
		end
	elseif target.actionid == 100 then
		if target.itemid == 3501 then
			-- Postman quest
			if player:getStorageValue(Storage.Postman.Mission02) == 1 then
				player:setStorageValue(Storage.Postman.Mission02, 2)
				toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
			end
		elseif target.itemid == 4848 then
			-- The ape city - mission 7
			local apeCityStorage = player:getStorageValue(Storage.TheApeCity.Casks)
			if apeCityStorage < 3 then
				player:setStorageValue(Storage.TheApeCity.Casks, math.max(0, apeCityStorage) + 1)
				target:transform(3134)
				toPosition:sendMagicEffect(CONST_ME_EXPLOSIONAREA)
				addEvent(revertCask, 3 * 60 * 1000, toPosition)
			end
		end
	elseif target.actionid == 12566 and player:getStorageValue(Storage.SecretService.TBIMission06) == 1 then
		-- Secret service quest
		local yellPosition = Position(32204, 31157, 8)
		-- Amazon lookType
		if player:getOutfit().lookType == 137 then
			player:setStorageValue(Storage.SecretService.TBIMission06, 2)
			Game.createMonster("barbarian skullhunter", yellPosition)
			player:say("Nooooo! What have you done??", TALKTYPE_MONSTER_SAY, false, 0, yellPosition)
			yellPosition.y = yellPosition.y - 1
			Game.createMonster("barbarian skullhunter", yellPosition)
		end
	else
		return false
	end
	return true
end

function onUseSpoon(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid == 390 then
		--The ice islands quest
		if player:getStorageValue(Storage.TheIceIslands.Questline) >= 21 then
			if player:getStorageValue(Storage.TheIceIslands.SulphurLava) < 1 then
				-- Fine sulphur
				player:addItem(7247, 1)
				player:setStorageValue(Storage.TheIceIslands.SulphurLava, 1)
				toPosition:sendMagicEffect(CONST_ME_YELLOW_RINGS)
				player:say("You retrive a fine sulphur from a lava hole.", TALKTYPE_MONSTER_SAY)
			end
		end
	elseif target.itemid == 3920 then
		--The ice islands quest
		if player:getStorageValue(Storage.TheIceIslands.Questline) >= 21 then
			if player:getStorageValue(Storage.TheIceIslands.SporesMushroom) < 1 then
				player:addItem(7251, 1)
				player:setStorageValue(Storage.TheIceIslands.SporesMushroom, 1)
				toPosition:sendMagicEffect(CONST_ME_MAGIC_GREEN)
				player:say("You retrive spores from a mushroom.", TALKTYPE_MONSTER_SAY)
			end
		end
	elseif target.itemid == 7743 or target.itemid == 390 then
		-- What a foolish quest - mission 8 (sulphur)
		if player:getStorageValue(Storage.WhatAFoolishQuest.Questline) ~= 21
				or player:getStorageValue(Storage.WhatAFoolishQuest.InflammableSulphur) == 1 then
			return false
		end

		player:setStorageValue(Storage.WhatAFoolishQuest.InflammableSulphur, 1)
		-- Easily inflammable sulphur
		player:addItem(124, 1)
		toPosition:sendMagicEffect(CONST_ME_YELLOW_RINGS)
	else
		return false
	end
	return true
end

function onUseScythe(player, item, fromPosition, target, toPosition, isHotkey)
	if not table.contains({3453, 9596}, item.itemid) then
		return false
	end

	if target.itemid == 5464 then
		target:transform(5463)
		target:decay()
		Game.createItem(5466, 1, toPosition)
	elseif target.itemid == 3653 then
		target:transform(3651)
		target:decay()
		Game.createItem(3605, 1, toPosition)
	-- The secret library
	elseif toPosition == Position(32177, 31925, 7) then
		player:teleportTo({x = 32515, y = 32535, z = 12})
	else
		return false
	end
	return onDestroyItem(player, item, fromPosition, target, toPosition, isHotkey)
end

function onUseKitchenKnife(player, item, fromPosition, target, toPosition, isHotkey)
	if not table.contains({3469, 9594, 9598}, item.itemid) then
		return false
	end

	-- The ice islands quest
	if target.itemid == 7261 then
		if player:getStorageValue(Storage.TheIceIslands.Questline) >= 21 then
			if player:getStorageValue(Storage.TheIceIslands.FrostbiteHerb) < 1 then
				player:addItem(7248, 1)
				player:setStorageValue(Storage.TheIceIslands.FrostbiteHerb, 1)
				toPosition:sendMagicEffect(CONST_ME_HITBYPOISON)
				player:say("You cut a leaf from a frostbite herb.", TALKTYPE_MONSTER_SAY)
			end
		end
	elseif target.itemid == 3647 then
		if player:getStorageValue(Storage.TheIceIslands.Questline) >= 21 then
			if player:getStorageValue(Storage.TheIceIslands.FlowerCactus) < 1 then
				player:addItem(7245, 1)
				player:setStorageValue(Storage.TheIceIslands.FlowerCactus, 1)
				target:transform(3637)
				addEvent(revertItem, 60 * 1000, toPosition, 3637, 3647)
				toPosition:sendMagicEffect(CONST_ME_MAGIC_GREEN)
				player:say("You cut a flower from a cactus.", TALKTYPE_MONSTER_SAY)
			end
		end
	elseif target.itemid == 3753 then
		if player:getStorageValue(Storage.TheIceIslands.Questline) >= 21 then
			if player:getStorageValue(Storage.TheIceIslands.FlowerBush) < 1 then
				player:addItem(7249, 1)
				player:setStorageValue(Storage.TheIceIslands.FlowerBush, 1)
				target:transform(3750)
				addEvent(revertItem, 60 * 1000, toPosition, 3750, 3753)
				toPosition:sendMagicEffect(CONST_ME_MAGIC_GREEN)
				player:say("You cut a flower from a bush.", TALKTYPE_MONSTER_SAY)
			end
		end
		-- What a foolish Quest (Mission 1)
	elseif target.actionid == 4200 then
		if toPosition.x == 32349 and toPosition.y == 32361 and toPosition.z == 7 then
			player:addItem(102, 1)
			player:say(
			"The stubborn flower has ruined your knife but at least you got it.",
			TALKTYPE_MONSTER_SAY, false, player, toPosition)
			item:remove(1)
		else
			player:say("This flower is too pathetic.", TALKTYPE_MONSTER_SAY, false, player, toPosition)
		end
		-- What a foolish quest (mission 5)
	elseif target.itemid == 114 then
		if player:getStorageValue(Storage.WhatAFoolishQuest.EmperorBeardShave) == 1 then
			player:say("God shave the emperor. Some fool already did it.", TALKTYPE_MONSTER_SAY)
			return true
		end

		player:setStorageValue(Storage.WhatAFoolishQuest.EmperorBeardShave, 1)
		player:say("This is probably the most foolish thing you've ever done!", TALKTYPE_MONSTER_SAY)
		player:addItem(113, 1)
		Game.createMonster("dwarf guard", Position(32656, 31853, 13))
		-- What a foolish quest (mission 8)
	elseif target.itemid == 3744 then
		if player:getStorageValue(Storage.WhatAFoolishQuest.Questline) ~= 22 or
		player:getStorageValue(Storage.WhatAFoolishQuest.SpecialLeaves) == 1 then
			return false
		end

		player:setStorageValue(Storage.WhatAFoolishQuest.SpecialLeaves, 1)
		player:addItem(3129, 1)
		toPosition:sendMagicEffect(CONST_ME_BLOCKHIT)
	elseif table.contains(fruits, target.itemid) and player:removeItem(6277, 1) then
		target:remove(1)
		player:addItem(6278, 1)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	else
		return false
	end
	return true
end

function onGrindItem(player, item, fromPosition, target, toPosition)
	if not(target.itemid == 21573) then
		return false
	end
	for index, value in pairs(Itemsgrinder) do
		if item.itemid == index then
			local topParent = item:getTopParent()
			if topParent.isItem and (not topParent:isItem() or topParent.itemid ~= 470) then
				local parent = item:getParent()
				if not parent:isTile() and (parent:addItem(value.item_id, 1) or topParent:addItem(value.item_id, 1)) then
					item:remove(1)
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You grind a " .. ItemType(index):getName() .. " into fine, " .. ItemType(value.item_id):getName() .. ".")
					doSendMagicEffect(target:getPosition(), value.effect)
					return true
				else
					Game.createItem(value.item_id, 1, item:getPosition())
				end
			else
				Game.createItem(value.item_id, 1, item:getPosition())
			end
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You grind a " .. ItemType(index):getName() .. " into fine, " .. ItemType(value.item_id):getName() .. ".")
			item:remove(1)
			doSendMagicEffect(target:getPosition(), value.effect)
			return
		end
	end
end
