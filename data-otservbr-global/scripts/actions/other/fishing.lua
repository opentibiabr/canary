local waterIds = {622, 4597, 4598, 4599, 4600, 12561, 12563, 4601, 4602, 4609, 4610, 4611, 4612, 4613, 4614, 629, 630, 631, 632, 633, 634, 7236, 9582, 13988, 13989, 12560, 21414}
local lootTrash = {3119, 3123, 3264, 3409, 3578}
local lootCommon = {3035, 3051, 3052, 3580, 236, 237}
local lootRare = {3026, 3029, 3032, 7158, 7159}
local lootVeryRare = {281, 282, 9303}
local lootVeryRare1 = {281, 12557}
local lootRare1 = {3026, 12557}
local lootCommon1 = {3035, 237, 12557}

local elementals = {
		chances = {
			{from = 0, to = 500, itemId = 3026}, -- white pearl
			{from = 501, to = 801, itemId = 3029}, -- small sapphire
			{from = 802, to = 1002, itemId = 3032}, -- small emerald
			{from = 1003, to = 1053, itemId = 281}, -- giant shimmering pearl (green)
			{from = 1054, to = 1104, itemId = 282}, -- giant shimmering pearl (brown)
			{from = 1105, to = 1115, itemId = 9303} -- leviathan's amulet
		}
}

local useWorms = true

local function refreeIceHole(position)
	local iceHole = Tile(position):getItemById(7237)
	if iceHole then
		iceHole:transform(7200)
	end
end

local fishing = Action()

function fishing.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not isInArray(waterIds, target.itemid) then
		return false
	end

	local targetId = target.itemid
	if targetId == 9582 then
		local owner = target:getAttribute(ITEM_ATTRIBUTE_CORPSEOWNER)
		if owner ~= 0 and owner ~= player.uid then
			player:sendTextMessage(MESSAGE_FAILURE, "You are not the owner.")
			return true
		end

		toPosition:sendMagicEffect(CONST_ME_WATERSPLASH)
		target:transform(target.itemid + 1)
		
		local chance = math.random(10000)
		for i = 1, #elementals.chances do
			local randomItem = elementals.chances[i]
			if chance >= randomItem.from and chance <= randomItem.to then
				player:addItem(randomItem.itemId, 1)
			end
			if chance > 1115 then
				player:say('There was just rubbish in it.', TALKTYPE_MONSTER_SAY)
				return true
			end
		end
	end

	if targetId == 12560 then
		toPosition:sendMagicEffect(CONST_ME_WATERSPLASH)
		local rareChance = math.random(100)
		if rareChance == 1 then
			player:addItem(lootVeryRare1[math.random(#lootVeryRare1)], 1)
	    elseif rareChance <= 3 then
			player:addItem(lootRare1[math.random(#lootRare1)], 1)
		elseif rareChance <= 10 then
			player:addItem(lootCommon1[math.random(#lootCommon1)], 1)
		else
			player:addItem(lootTrash[math.random(#lootTrash)], 1)
		end
		return true
	end

	if targetId ~= 7236 then
		toPosition:sendMagicEffect(CONST_ME_LOSEENERGY)
	end

	if targetId == 622 or targetId == 13989 then
		return true
	end

	if useWorms and player:removeItem("worm", 1) and targetId == 21414 then
		if player:getStorageValue(Storage.Quest.U10_55.Dawnport.TheDormKey) == 2 then
			if math.random(100) >= 97 then
				player:addItem(21402, 1)
				player:setStorageValue(Storage.Quest.U10_55.Dawnport.TheDormKey, 3)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "With a giant splash, you heave an enormous fish out of the water.")
				return true
			end
		elseif math.random(100) <= math.min(math.max(10 + (player:getEffectiveSkillLevel(SKILL_FISHING) - 10) * 0.597, 10), 50) then
			player:addItem(3578, 1)
		end
	end

	player:addSkillTries(SKILL_FISHING, 1, true)
	if math.random(100) <= math.min(math.max(10 + (player:getEffectiveSkillLevel(SKILL_FISHING) - 10) * 0.597, 10), 50) then
		if useWorms and not player:removeItem("worm", 1) then
			return true
		end

		if targetId == 13988 then
			target:transform(targetId + 1)
			target:decay()

			if math.random(100) >= 97 then
				player:addItem(13992, 1)
				return true
			end
		elseif targetId == 7236 then
			target:transform(7237)
			local position = target:getPosition()
			addEvent(refreeIceHole, 1000 * 60 * 15, position)
			local rareChance = math.random(100)
			if rareChance == 1 then
				player:addItem(7158, 1)
				return true
			elseif rareChance <= 4 then
				player:addItem(3580, 1)
				return true
			elseif rareChance <= 10 then
				player:addItem(7159, 1)
				return true
			end
		end
		player:addItem(3578, 1)
	end
	return true
end

fishing:id(3483)
fishing:allowFarUse(true)
fishing:register()
