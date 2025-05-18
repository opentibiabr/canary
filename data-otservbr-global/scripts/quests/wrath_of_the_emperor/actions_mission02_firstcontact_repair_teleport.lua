local waterpos = {
	Position({ x = 33282, y = 31036, z = 10 }),
	Position({ x = 33282, y = 31037, z = 10 }),
	Position({ x = 33283, y = 31037, z = 10 }),
	Position({ x = 33283, y = 31036, z = 10 }),
	Position({ x = 33283, y = 31038, z = 10 }),
	Position({ x = 33283, y = 31035, z = 10 }),
}

local function revertWater(position)
	local waterTile = Tile(position):getItemById(10113)
	if waterTile then
		waterTile:transform(10494)
	end
end

local wrathEmperorMiss2FirstContact = Action()
function wrathEmperorMiss2FirstContact.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	-- clay with the sacred earth
	if (item.itemid == 11329 and target.itemid == 11341) or (item.itemid == 11341 and target.itemid == 11329) then
		player:say("You carefully mix the clay with the sacred earth.", TALKTYPE_MONSTER_SAY)
		item:remove()
		target:remove()
		player:addItem(11344, 1)
		-- sacred clay
	elseif item.itemid == 11344 and target.itemid == 11331 then
		player:say("You carefully coat the inside of the wooden bowl with the sacred clay.", TALKTYPE_MONSTER_SAY)
		target:remove()
		item:transform(11347)
		-- sacred bowl of purification
	elseif item.itemid == 11347 and target.itemid == 10494 then
		player:say("Filling the corrupted water into the sacred bowl completly purifies the fluid.", TALKTYPE_MONSTER_SAY)
		item:transform(11333)
		-- bowl with sacred water
	elseif item.itemid == 11333 and target.itemid == 11345 then
		item:transform(11334)
		toPosition:sendMagicEffect(CONST_ME_POFF)
		-- sacred coal
	elseif item.itemid == 11334 and target.actionid == 8025 then
		player:say("As you give the coal into the pool the corrupted fluid begins to dissolve, leaving purified, refreshing water.", TALKTYPE_MONSTER_SAY)
		item:remove()
		if player:getStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.Questline) == 4 then
			player:setStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.Questline, 5)
			player:setStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.Mission02, 2) --Questlog, Wrath of the Emperor "Mission 02: First Contact"
		end
		for i = 1, 4 do
			waterpos[i]:sendMagicEffect(CONST_ME_GREEN_RINGS)
		end
		for i = 1, 6 do
			Tile(waterpos[i]):getItemById(10494):transform(10113)
			addEvent(revertWater, 60 * 1000, waterpos[i])
		end
	end
	return true
end

wrathEmperorMiss2FirstContact:id(11329, 11333, 11334, 11341, 11344, 11347)
wrathEmperorMiss2FirstContact:register()
