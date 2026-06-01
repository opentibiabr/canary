local internalNpcName = "Test Server"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}
local testConfig = {
	amountMoney = 100,
	amountTibiaCoin = 100000,
	maxTibiaCoins = 100000,
	minLevel = 1,
	maxLevel = 3000,
	resetLevel = 8,
	resetExperience = 4200,
	resetHealth = 185,
	resetMana = 185,
	defaultSkillLevel = 10,
}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1875,
	lookHead = 58,
	lookBody = 68,
	lookLegs = 109,
	lookFeet = 115,
	lookAddons = 3,
}

npcConfig.flags = {
	floorchange = false,
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
	npcHandler:onMove(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end

npcHandler:setMessage(MESSAGE_FAREWELL, "Please come back from time to time.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Please come back from time to time.")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

local function buildEquipmentShopFromItemsXml()
	local xmlPath = "data/items/items.xml"
	local file = io.open(xmlPath, "r")
	if not file then
		print(string.format("[Test Server NPC] Could not open %s", xmlPath))
		return {}
	end

	local xmlContent = file:read("*a")
	file:close()

	local validSlots = {
		head = true, -- helmet
		armor = true, -- armor
		legs = true, -- legs
		feet = true, -- boots
		ring = true, -- rings
		necklace = true, -- amulets
		hand = true, -- weapons (sword/axe/club/bow/crossbow/wand/rod)
		["two-handed"] = true, -- bows/crossbows and other 2h weapons defined by slotType
		shield = true, -- shields
		ammo = true, -- trinkets
	}

	local slotOrder = {
		head = 1,
		armor = 2,
		legs = 3,
		feet = 4,
		ring = 5,
		necklace = 6,
		hand = 7,
		["two-handed"] = 7,
		shield = 8,
		ammo = 9,
	}

	local entries = {}
	local seenNames = {}
	local excludedItems = {
		["crystal bolt"] = true,
	}

	for itemAttributes, itemBody in xmlContent:gmatch("<item%s+([^>]-)%s*>(.-)</item>") do
		-- Ignore self-closing tags (<item .../>) to avoid leaking the next item's body.
		if itemAttributes:sub(-1) == "/" then
			goto continue
		end

		local paddedAttributes = " " .. itemAttributes
		local itemId = paddedAttributes:match('%sid="(%d+)"')
		local itemName = paddedAttributes:match('%sname="([^"]+)"')
		if itemId and itemName then
			local hasStat = itemBody:find('key="armor"') or itemBody:find('key="attack"') or itemBody:find('key="defense"') or itemBody:find('key="fromDamage"') or itemBody:find('key="toDamage"')
			local hasWeaponData = itemBody:find('key="weaponType"') ~= nil
			if hasStat or hasWeaponData then
				local selectedSlot = nil
				for slot in itemBody:gmatch('<attribute%s+key="slot"%s+value="([^"]+)"[^>]*>') do
					if validSlots[slot] then
						selectedSlot = slot
						break
					end
				end

				if not selectedSlot then
					local slotType = itemBody:match('<attribute%s+key="slotType"%s+value="([^"]+)"[^>]*>')
					if validSlots[slotType] then
						selectedSlot = slotType
					end
				end

				local normalizedName = itemName:lower()
				if selectedSlot and not excludedItems[normalizedName] and not seenNames[normalizedName] then
					seenNames[normalizedName] = true
					entries[#entries + 1] = {
						itemName = itemName,
						clientId = tonumber(itemId),
						buy = 1,
						_slotOrder = slotOrder[selectedSlot] or 99,
						_isWeapon = hasWeaponData,
					}
				end
			end
		end

		::continue::
	end

	-- Mandatory test server items.
	local forcedItems = {
		{ itemName = "crystal coin", clientId = 3043, buy = 1, _slotOrder = 0 },
	}

	for _, forcedItem in ipairs(forcedItems) do
		local normalizedName = forcedItem.itemName:lower()
		if not seenNames[normalizedName] then
			seenNames[normalizedName] = true
			entries[#entries + 1] = forcedItem
		end
	end

	table.sort(entries, function(a, b)
		if a._slotOrder == b._slotOrder and a._isWeapon ~= b._isWeapon then
			return a._isWeapon
		end

		if a._slotOrder == b._slotOrder then
			return a.itemName < b.itemName
		end
		return a._slotOrder < b._slotOrder
	end)

	for index = 1, #entries do
		entries[index]._slotOrder = nil
		entries[index]._isWeapon = nil
	end

	return entries
end

local function buildOutfitIdsFromXml()
	local xmlPath = "data/XML/outfits.xml"
	local file = io.open(xmlPath, "r")
	if not file then
		print(string.format("[Test Server NPC] Could not open %s", xmlPath))
		return {}
	end

	local xmlContent = file:read("*a")
	file:close()

	local entries = {}
	local seen = {}
	for attributes in xmlContent:gmatch("<outfit%s+([^>]-)/>") do
		local paddedAttributes = " " .. attributes
		local enabled = paddedAttributes:match('%senabled="([^"]+)"')
		local lookType = tonumber(paddedAttributes:match('%slooktype="(%d+)"'))
		if lookType and enabled ~= "no" and not seen[lookType] then
			seen[lookType] = true
			entries[#entries + 1] = lookType
		end
	end

	table.sort(entries)
	return entries
end

local function buildMountIdsFromXml()
	local xmlPath = "data/XML/mounts.xml"
	local file = io.open(xmlPath, "r")
	if not file then
		print(string.format("[Test Server NPC] Could not open %s", xmlPath))
		return {}
	end

	local xmlContent = file:read("*a")
	file:close()

	local entries = {}
	local seen = {}
	for attributes in xmlContent:gmatch("<mount%s+([^>]-)/>") do
		local paddedAttributes = " " .. attributes
		local mountId = tonumber(paddedAttributes:match('%sid="(%d+)"'))
		if mountId and not seen[mountId] then
			seen[mountId] = true
			entries[#entries + 1] = mountId
		end
	end

	table.sort(entries)
	return entries
end

local outfitIds = buildOutfitIdsFromXml()
local mountIds = buildMountIdsFromXml()

local function messageHasKeyword(message, keyword)
	return message:lower():find(keyword:lower(), 1, true) ~= nil
end

local function getExperienceForLevel(level)
	if level <= 1 then
		return 0
	end

	local previousLevel = level - 1
	return ((50 * previousLevel * previousLevel * previousLevel) - (150 * previousLevel * previousLevel) + (400 * previousLevel)) / 3
end

local function setAllSkills(player, skillLevel, magicLevel)
	player:setMagicLevel(magicLevel)
	player:setSkillLevel(SKILL_FIST, skillLevel)
	player:setSkillLevel(SKILL_CLUB, skillLevel)
	player:setSkillLevel(SKILL_SWORD, skillLevel)
	player:setSkillLevel(SKILL_AXE, skillLevel)
	player:setSkillLevel(SKILL_DISTANCE, skillLevel)
	player:setSkillLevel(SKILL_SHIELD, skillLevel)
	player:setSkillLevel(SKILL_FISHING, skillLevel)
end

local function setSkillsByVocation(player)
	setAllSkills(player, testConfig.defaultSkillLevel, testConfig.defaultSkillLevel)

	local baseVocationId = player:getVocation():getBase():getId()
	if baseVocationId == VOCATION.BASE_ID.KNIGHT then
		player:setMagicLevel(15)
		player:setSkillLevel(SKILL_AXE, 100)
		player:setSkillLevel(SKILL_CLUB, 100)
		player:setSkillLevel(SKILL_SWORD, 100)
		player:setSkillLevel(SKILL_SHIELD, 100)
	elseif baseVocationId == VOCATION.BASE_ID.SORCERER or baseVocationId == VOCATION.BASE_ID.DRUID then
		player:setMagicLevel(100)
		player:setSkillLevel(SKILL_SHIELD, 100)
	elseif baseVocationId == VOCATION.BASE_ID.PALADIN then
		player:setMagicLevel(30)
		player:setSkillLevel(SKILL_DISTANCE, 100)
		player:setSkillLevel(SKILL_SHIELD, 100)
	elseif baseVocationId == VOCATION.BASE_ID.MONK then
		player:setMagicLevel(50)
		player:setSkillLevel(SKILL_FIST, 100)
		player:setSkillLevel(SKILL_AXE, 50)
		player:setSkillLevel(SKILL_CLUB, 50)
		player:setSkillLevel(SKILL_SWORD, 50)
		player:setSkillLevel(SKILL_SHIELD, 100)
	end
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	if not player then
		return false
	end

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if messageHasKeyword(message, "promot") then
		local vocation = player:getVocation()
		local promotedVocation = vocation and vocation:getPromotion()
		if not promotedVocation then
			npcHandler:say("Your vocation has no promotion.", npc, creature)
			return true
		end

		if player:getVocation():getId() == promotedVocation:getId() then
			npcHandler:say("You are already promoted.", npc, creature)
			return true
		end

		player:setVocation(promotedVocation)
		npcHandler:say("Congratulations! You are now promoted.", npc, creature)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
		return true
	end

	if messageHasKeyword(message, "remove tibia coin") then
		local currentCoins = player:getTransferableCoins()
		if currentCoins <= 0 then
			npcHandler:say("You do not have Tibia Coins to remove.", npc, creature)
			return true
		end

		local removeAmount = math.min(testConfig.amountTibiaCoin, currentCoins)
		player:removeTransferableCoins(removeAmount)
		npcHandler:say("Done, |PLAYERNAME|.", npc, creature)
		player:sendTextMessage(MESSAGE_STATUS, string.format("Removed %d Tibia Coins. Current balance: %d.", removeAmount, player:getTransferableCoins()))
		return true
	end

	if messageHasKeyword(message, "tibia coin") then
		local currentCoins = player:getTransferableCoins()
		if currentCoins >= testConfig.maxTibiaCoins then
			npcHandler:say(string.format("You already have the maximum of %d Tibia Coins.", testConfig.maxTibiaCoins), npc, creature)
			return true
		end

		local addAmount = math.min(testConfig.amountTibiaCoin, testConfig.maxTibiaCoins - currentCoins)
		player:addTransferableCoins(addAmount)
		npcHandler:say("Here you are, |PLAYERNAME|.", npc, creature)
		player:sendTextMessage(MESSAGE_STATUS, string.format("Added %d Tibia Coins. Current balance: %d.", addAmount, player:getTransferableCoins()))
		return true
	end

	if messageHasKeyword(message, "money") or messageHasKeyword(message, "gold") then
		player:addItem(3043, testConfig.amountMoney)
		npcHandler:say("Here you are, |PLAYERNAME|.", npc, creature)
		player:sendTextMessage(MESSAGE_STATUS, string.format("You received %d crystal coins.", testConfig.amountMoney))
		return true
	end

	if messageHasKeyword(message, "skill") then
		setSkillsByVocation(player)
		npcHandler:say("Here you are, |PLAYERNAME|.", npc, creature)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
		player:sendTextMessage(MESSAGE_STATUS, "Your skills were adjusted according to your vocation.")
		return true
	end

	local requestedLevel = message:match("[Ll][Ee][Vv][Ee][Ll]%s*(%d+)")
	if requestedLevel then
		local targetLevel = tonumber(requestedLevel)
		if not targetLevel or targetLevel < testConfig.minLevel or targetLevel > testConfig.maxLevel then
			npcHandler:say(string.format("Choose a level between %d and %d.", testConfig.minLevel, testConfig.maxLevel), npc, creature)
			return true
		end

		local targetExperience = getExperienceForLevel(targetLevel)
		local currentExperience = player:getExperience()
		if targetExperience > currentExperience then
			player:addExperience(targetExperience - currentExperience, true, true)
		elseif targetExperience < currentExperience then
			player:removeExperience(currentExperience - targetExperience)
		end

		npcHandler:say(string.format("Done, |PLAYERNAME|. You are now level %d.", targetLevel), npc, creature)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
		return true
	end

	local requestedExperience = message:match("[Ee][Xx][Pp]%s*(%d+)")
	if requestedExperience then
		local targetExperience = tonumber(requestedExperience)
		if not targetExperience or targetExperience < 0 then
			npcHandler:say("Choose a valid experience value.", npc, creature)
			return true
		end

		local currentExperience = player:getExperience()
		if targetExperience > currentExperience then
			player:addExperience(targetExperience - currentExperience, true, true)
		elseif targetExperience < currentExperience then
			player:removeExperience(currentExperience - targetExperience)
		end

		npcHandler:say(string.format("Done, |PLAYERNAME|. You now have %d experience.", targetExperience), npc, creature)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
		return true
	end

	if messageHasKeyword(message, "exp") or messageHasKeyword(message, "experience") then
		npcHandler:say(string.format("Use {level X} between %d and %d (example: {level 500}) or set raw experience with {exp X}.", testConfig.minLevel, testConfig.maxLevel), npc, creature)
		return true
	end

	if messageHasKeyword(message, "reset") then
		local resetExperience = testConfig.resetExperience
		local currentExperience = player:getExperience()
		if currentExperience > resetExperience then
			player:removeExperience(currentExperience - resetExperience)
		elseif currentExperience < resetExperience then
			player:addExperience(resetExperience - currentExperience, true, true)
		end

		setAllSkills(player, testConfig.defaultSkillLevel, testConfig.defaultSkillLevel)
		player:setMaxHealth(testConfig.resetHealth)
		player:setMaxMana(testConfig.resetMana)
		player:addHealth(testConfig.resetHealth)
		player:addMana(testConfig.resetMana)
		npcHandler:say(string.format("Character reset complete. Level %d, %d experience, health/mana %d/%d and skills %d.", testConfig.resetLevel, testConfig.resetExperience, testConfig.resetHealth, testConfig.resetMana, testConfig.defaultSkillLevel), npc, creature)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
		return true
	end

	if messageHasKeyword(message, "outfit") then
		if #outfitIds == 0 then
			npcHandler:say("I could not load outfits right now.", npc, creature)
			return true
		end

		local outfitsAdded = 0
		for _, outfitId in ipairs(outfitIds) do
			if not player:hasOutfit(outfitId, 3) then
				if not player:hasOutfit(outfitId, 0) then
					player:addOutfit(outfitId)
				end
				player:addOutfitAddon(outfitId, 1)
				player:addOutfitAddon(outfitId, 2)
				outfitsAdded = outfitsAdded + 1
			end
		end

		npcHandler:say("Here you are, |PLAYERNAME|.", npc, creature)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
		player:sendTextMessage(MESSAGE_STATUS, string.format("Added/updated %d outfits with full addons.", outfitsAdded))
		return true
	end

	if messageHasKeyword(message, "mount") then
		if #mountIds == 0 then
			npcHandler:say("I could not load mounts right now.", npc, creature)
			return true
		end

		local mountsAdded = 0
		for _, mountId in ipairs(mountIds) do
			if not player:hasMount(mountId) then
				player:addMount(mountId)
				mountsAdded = mountsAdded + 1
			end
		end

		npcHandler:say("Here you are, |PLAYERNAME|.", npc, creature)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
		player:sendTextMessage(MESSAGE_STATUS, string.format("Added %d new mounts.", mountsAdded))
		return true
	end

	if messageHasKeyword(message, "bless") then
		if not Tile(player:getPosition()):hasFlag(TILESTATE_PROTECTIONZONE) and (player:isPzLocked() or player:getCondition(CONDITION_INFIGHT, CONDITIONID_DEFAULT)) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You can't buy bless while in battle.")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			npcHandler:say("I cannot bless you during battle.", npc, creature)
			return true
		end

		local hasToF = not Blessings.Config.HasToF or player:hasBlessing(1)
		local donthavefilter = function(p, b)
			return not p:hasBlessing(b)
		end
		local missingBless = player:getBlessings(nil, donthavefilter)
		local missingBlessAmt = #missingBless + (hasToF and 0 or 1)

		if missingBlessAmt == 0 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are already blessed.")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return true
		end

		for _, v in ipairs(missingBless) do
			player:addBlessing(v.id, 1)
		end

		player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
		npcHandler:say("You have been blessed, |PLAYERNAME|.", npc, creature)
		player:sendTextMessage(MESSAGE_STATUS, string.format("You received the remaining %d blessings.", missingBlessAmt))
		return true
	end

	return true
end

npcConfig.shop = buildEquipmentShopFromItemsXml()
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "Welcome to Test Server. I can give {outfit}, {mount}, {bless}, {promotion}, {money}, {tibia coins}, {remove tibia coins}, {skill}, {reset}, and {exp}. Use {level X} from 1 to 3000 (example: {level 500}).")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Trade is open. You can also ask for {outfit}, {mount}, {bless}, {promotion}, {money}, {tibia coins}, {remove tibia coins}, {skill}, {reset}, and {exp}. Use {level X} from 1 to 3000.")
-- On buy npc shop message
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end
-- On sell npc shop message
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_TRADE, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end
-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType) end

npcType:register(npcConfig)
