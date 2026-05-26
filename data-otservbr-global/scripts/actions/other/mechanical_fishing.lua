local waterIds = { 622, 4597, 4598, 4599, 4600, 12561, 12563, 4601, 4602, 4609, 4610, 4611, 4612, 4613, 4614, 629, 630, 631, 632, 633, 634, 7236, 9582, 12560, 12561, 12562, 12563, 12558, 12559, 13988, 13989, 21414, 21312 }

local lootTrash = { 3119, 3123, 3264, 3409, 3578 }
local lootCommon = { 3035, 3051, 3052, 3580, 236, 237 }
local lootRare = { 3026, 3029, 3032, 7158, 7159 }
local lootVeryRare = { 281, 282, 9303 }
local lootVeryRare1 = { 281, 12557 }
local lootRare1 = { 3026, 12557 }
local lootCommon1 = { 3035, 237, 12557 }

local fishableWaterIds = {
	4597,
	4598,
	4599,
	4600,
	4601,
	4602,
	629,
	630,
	631,
	632,
	633,
	634,
	21312,
}

local nonFishableWaterIds = {
	4609,
	4610,
	4611,
	4612,
	4613,
	4614,
	4809,
	4810,
	4811,
	4812,
	4813,
	4814,
	21314,
}

local dirtyWaterFishable = { 12561, 12562, 12563 }
local dirtyWaterSpent = { 12558, 12559, 12560 }

local dirtyWaterTransform = {
	[12561] = 12558,
	[12562] = 12559,
	[12563] = 12560,
}

local SHIMMER_COOLDOWN_STORAGE = 20526
local SHIMMER_COUNT_STORAGE = 20527
local SHIMMER_COOLDOWN_SECONDS = 20 * 60 * 60

local transformToNonFishable = {
	[4597] = { to = 4609, decay = true },
	[4598] = { to = 4610, decay = true },
	[4599] = { to = 4611, decay = true },
	[4600] = { to = 4612, decay = true },
	[4601] = { to = 4613, decay = true },
	[4602] = { to = 4614, decay = true },
	[629] = { to = 4809, decay = true },
	[630] = { to = 4810, decay = true },
	[631] = { to = 4811, decay = true },
	[632] = { to = 4812, decay = true },
	[633] = { to = 4813, decay = true },
	[634] = { to = 4814, decay = true },
	[21312] = { to = 21314, decay = true },
}

local elementals = {
	chances = {
		{ from = 0, to = 500, itemId = 3026 }, -- white pearl
		{ from = 501, to = 801, itemId = 3029 }, -- small sapphire
		{ from = 802, to = 1002, itemId = 3032 }, -- small emerald
		{ from = 1003, to = 1053, itemId = 281 }, -- giant shimmering pearl (green)
		{ from = 1054, to = 1104, itemId = 282 }, -- giant shimmering pearl (brown)
		{ from = 1105, to = 1115, itemId = 9303 }, -- leviathan's amulet
	},
}

local useWorms = true

local YALAHAR_SEWERS = {
	fromX = 32736,
	fromY = 31142,
	toX = 32854,
	toY = 31260,
	z = 8,
}
local MECHANICAL_FISH_ID = 9307
local NAIL_ID = 953

local function isInYalaharSewers(position)
	return position.x >= YALAHAR_SEWERS.fromX and position.x <= YALAHAR_SEWERS.toX and position.y >= YALAHAR_SEWERS.fromY and position.y <= YALAHAR_SEWERS.toY and position.z == YALAHAR_SEWERS.z
end

local function refreeIceHole(position)
	local iceHole = Tile(position):getItemById(7237)
	if iceHole then
		iceHole:transform(7200)
	end
end

local function handleDirtyWaterFishing(player, target, toPosition)
	local targetId = target.itemid

	toPosition:sendMagicEffect(CONST_ME_LOSEENERGY)

	if player:getItemCount(3492) > 0 then
		player:addSkillTries(SKILL_FISHING, 1, true)
	end

	local successChance = math.min(math.max(10 + (player:getEffectiveSkillLevel(SKILL_FISHING) - 10) * 0.597, 10), 50)
	if math.random(100) > successChance then
		return true
	end

	if useWorms and not player:removeItem("worm", 1) then
		return true
	end

	local newId = dirtyWaterTransform[targetId]
	if newId then
		target:transform(newId)
		target:decay()
	end
	local dirtyWaterRoll = math.random(100)

	if dirtyWaterRoll <= 30 then
		if math.random(100) == 100 then
			local cooldownExpiry = player:getStorageValue(SHIMMER_COOLDOWN_STORAGE)
			if cooldownExpiry ~= -1 and os.time() < cooldownExpiry then
				player:addItem(3111, 1)
				return true
			end

			player:addItem(12557, 1)
			player:setStorageValue(SHIMMER_COOLDOWN_STORAGE, os.time() + SHIMMER_COOLDOWN_SECONDS)

			local currentCount = player:getStorageValue(SHIMMER_COUNT_STORAGE)
			if currentCount == -1 then
				currentCount = 0
			end
			currentCount = currentCount + 1
			player:setStorageValue(SHIMMER_COUNT_STORAGE, currentCount)

			if currentCount >= 50 and not player:hasAchievement("Biodegradable") then
				player:addAchievement("Biodegradable")
			end

			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A Shimmer Swimmer! It is said that this creature only appears once each day in the murkiest of waters!")
		else
			player:addItem(3111, 1)
		end
	end

	return true
end

local function handleDesertFishing(player, target, toPosition)
	toPosition:sendMagicEffect(CONST_ME_LOSEENERGY)

	if player:getItemCount(3492) > 0 then
		player:addSkillTries(SKILL_FISHING, 1, true)
	end

	local successChance = math.min(math.max(10 + (player:getEffectiveSkillLevel(SKILL_FISHING) - 10) * 0.597, 10), 50)
	if math.random(100) > successChance then
		return true
	end

	if useWorms and not player:removeItem("worm", 1) then
		return true
	end

	target:transform(13988)
	target:decay()

	if math.random(100) == 1 then
		player:addItem(13992, 1)
		if not player:hasAchievement("Desert Fisher") then
			player:addAchievement("Desert Fisher")
		end
	end

	return true
end

local mechanicalFishing = Action()

function mechanicalFishing.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not table.contains(waterIds, target.itemid) then
		return false
	end

	local targetId = target.itemid

	if isInYalaharSewers(toPosition) and player:getItemCount(NAIL_ID) > 0 then
		if table.contains(nonFishableWaterIds, targetId) or table.contains(dirtyWaterSpent, targetId) then
			toPosition:sendMagicEffect(CONST_ME_LOSEENERGY)
			return true
		end

		toPosition:sendMagicEffect(CONST_ME_LOSEENERGY)

		player:addSkillTries(SKILL_FISHING, 1, true)

		local successChance = math.min(math.max(10 + (player:getEffectiveSkillLevel(SKILL_FISHING) - 10) * 0.597, 10), 50)
		if math.random(100) > successChance then
			return true
		end

		player:removeItem(NAIL_ID, 1)

		if transformToNonFishable[targetId] then
			local transformInfo = transformToNonFishable[targetId]
			target:transform(transformInfo.to)
			if transformInfo.decay then
				target:decay()
			end
		end

		player:addItem(MECHANICAL_FISH_ID, 1)
		return true
	end

	if table.contains(dirtyWaterSpent, targetId) then
		toPosition:sendMagicEffect(CONST_ME_LOSEENERGY)
		return true
	end

	if table.contains(dirtyWaterFishable, targetId) then
		return handleDirtyWaterFishing(player, target, toPosition)
	end

	if targetId == 13989 then
		return handleDesertFishing(player, target, toPosition)
	end

	if targetId == 13988 then
		toPosition:sendMagicEffect(CONST_ME_LOSEENERGY)
		return true
	end

	if table.contains(nonFishableWaterIds, targetId) then
		toPosition:sendMagicEffect(CONST_ME_LOSEENERGY)
		return true
	end

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
				player:say("There was just rubbish in it.", TALKTYPE_MONSTER_SAY)
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

	if useWorms and targetId == 21414 and player:removeItem("worm", 1) then
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

	if player:getItemCount(3492) > 0 and table.contains(fishableWaterIds, targetId) then
		player:addSkillTries(SKILL_FISHING, 1, true)
	end

	if math.random(100) <= math.min(math.max(10 + (player:getEffectiveSkillLevel(SKILL_FISHING) - 10) * 0.597, 10), 50) then
		if useWorms and not player:removeItem("worm", 1) then
			return true
		end

		if targetId == 7236 then
			target:transform(7237)
			local position = target:getPosition()
			addEvent(refreeIceHole, 1000 * 60 * 15, position)
			local rareChance = math.random(100)
			if rareChance == 1 then
				player:addItem(7158, 1)
				player:addAchievementProgress("Exquisite Taste", 250)
				return true
			elseif rareChance <= 4 then
				player:addItem(3580, 1)
				player:addAchievementProgress("Exquisite Taste", 250)
				return true
			elseif rareChance <= 10 then
				player:addItem(7159, 1)
				player:addAchievementProgress("Exquisite Taste", 250)
				return true
			end
		end

		if transformToNonFishable[targetId] then
			local transformInfo = transformToNonFishable[targetId]
			target:transform(transformInfo.to)
			if transformInfo.decay then
				target:decay()
			end
		end

		player:addItem(3578, 1)
		player:addAchievementProgress("Here, Fishy Fishy!", 250)
	end

	return true
end

mechanicalFishing:id(9306)
mechanicalFishing:allowFarUse(true)
mechanicalFishing:register()
