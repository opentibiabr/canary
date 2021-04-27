local waterpos = {
	Position({x = 33282, y = 31036, z = 10}),
	Position({x = 33282, y = 31037, z = 10}),
	Position({x = 33283, y = 31037, z = 10}),
	Position({x = 33283, y = 31036, z = 10}),
	Position({x = 33283, y = 31038, z = 10}),
	Position({x = 33283, y = 31035, z = 10})
}

local function revertWater(position)
	local waterTile = Tile(position):getItemById(11030)
	if waterTile then
		waterTile:transform(11450)
	end
end

local wrathEmperorMiss2FirstContact = Action()
function wrathEmperorMiss2FirstContact.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	-- clay with the sacred earth
	if (item.itemid == 12285 and target.itemid == 12297) or (item.itemid == 12297 and target.itemid == 12285) then
		player:say("You carefully mix the clay with the sacred earth.", TALKTYPE_MONSTER_SAY)
		item:remove()
		target:remove()
		player:addItem(12300, 1)
	-- sacred clay
	elseif item.itemid == 12300 and target.itemid == 12287 then
		player:say("You carefully coat the inside of the wooden bowl with the sacred clay.", TALKTYPE_MONSTER_SAY)
		target:remove()
		item:transform(12303)
	-- sacred bowl of purification
	elseif item.itemid == 12303 and target.itemid == 11450 then
		player:say("Filling the corrupted water into the sacred bowl completly purifies the fluid.", TALKTYPE_MONSTER_SAY)
		item:transform(12289)
	-- bowl with sacred water
	elseif item.itemid == 12289 and target.itemid == 12301 then
		item:transform(12290)
		toPosition:sendMagicEffect(CONST_ME_POFF)
	-- sacred coal
	elseif item.itemid == 12290 and target.actionid == 8025 then
		player:say("As you give the coal into the pool the corrupted fluid begins to dissolve, leaving purified, refreshing water.", TALKTYPE_MONSTER_SAY)
		item:remove()
		if player:getStorageValue(Storage.WrathoftheEmperor.Questline) == 4 then
			player:setStorageValue(Storage.WrathoftheEmperor.Questline, 5)
			player:setStorageValue(Storage.WrathoftheEmperor.Mission02, 2) --Questlog, Wrath of the Emperor "Mission 02: First Contact"
		end
		for i = 1, 4 do
			waterpos[i]:sendMagicEffect(CONST_ME_GREEN_RINGS)
		end
		for i = 1, 6 do
			Tile(waterpos[i]):getItemById(11450):transform(11030)
			addEvent(revertWater, 60 * 1000, waterpos[i])
		end
	end
	return true
end

wrathEmperorMiss2FirstContact:id(12285,12289,12290,12297,12300,12303)
wrathEmperorMiss2FirstContact:register()