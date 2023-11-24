local internalNpcName = "Jeronimo"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 150
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 132,
	lookHead = 57,
	lookBody = 59,
	lookLegs = 3,
	lookFeet = 1,
	lookAddons = 3,
}

npcConfig.flags = {
	floorchange = false,
}

local tournamentCoinName = configManager.getString(configKeys.TOURNAMENT_COINS_NAME)

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Change your " .. tournamentCoinName .. " for Items here!" },
	{ text = "Visit our Game Store -> Tournament Shopp to check the offers" },
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

-- ID, Count, Price, Wrappable, Charges
local eventShopItems = {
	["exercise sword"] = { 28552, 1, 25, false, 500 },
	["exercise axe"] = { 28553, 1, 25, false, 500 },
	["exercise club"] = { 28554, 1, 25, false, 500 },
	["exercise bow"] = { 28555, 1, 25, false, 500 },
	["exercise rod"] = { 28556, 1, 25, false, 500 },
	["exercise wand"] = { 28557, 1, 25, false, 500 },

	["baby brain squid"] = { 32909, 1, 800, true },
	["baby vulcongra"] = { 32908, 1, 800, true },
	["cerberus champion puppy"] = { 31464, 1, 800, true },
	["guzzlemaw grub"] = { 32907, 1, 800, true },
	["jousting eagle baby"] = { 31462, 1, 800, true },
	["demon doll"] = { 32918, 1, 400, true },
	["ogre rowdy doll"] = { 32944, 1, 400, true },
	["retching horror doll"] = { 32945, 1, 400, true },
	["vexclaw doll"] = { 32943, 1, 400, true },

	["gilded blessed shield"] = { 37165, 1, 1500, true },
	["gilded crown"] = { 34332, 1, 1500, true },
	["gilded horned helmet"] = { 38640, 1, 1500, true },
	["gilded magic longsword"] = { 36995, 1, 1500, true },
	["gilded warlord sword"] = { 39767, 1, 1500, true },

	["sublime tournament accolade"] = { 31472, 1, 500, true },
	["tournament accolade"] = { 31470, 1, 500, true },

	["sublime tournament carpet"] = { 31467, 1, 100, true },
	["tournament carpet"] = { 31466, 1, 100, true },

	["carved table"] = { 32972, 1, 100, true },
	["carved table centre"] = { 32974, 1, 100, true },
	["carved table corner"] = { 32969, 1, 100, true },

	["cozy couch"] = { 32948, 1, 100, true },
	["cozy couch left end"] = { 32948, 1, 100, true },
	["cozy couch right end"] = { 32956, 1, 100, true },
	["cozy couch corner"] = { 32964, 1, 100, true },

	["zaoan chess box"] = { 18339, 1, 200, false },
	["pannier backpack"] = { 19159, 1, 150, false },
	["green light"] = { 21217, 1, 80, false },
	["blood herb"] = { 3734, 3, 30, false },

	["cerberus champion"] = { 146, 1, 1250, false, 9999999 },
	["jousting eagle"] = { 145, 1, 1250, false, 9999999 },

	["full dragon slayer"] = { 1289, 1288, 5000, false, 8888888 },
	["full lion of war"] = { 1207, 1206, 1750, false, 8888888 },
	["full veteran paladin"] = { 1205, 1204, 750, false, 8888888 },
	["full void master"] = { 1203, 1202, 750, false, 8888888 },
}

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	local amountTournamentCoins = player:getTournamentCoins()
	message = string.lower(message)
	if message == "help" or message == tournamentCoinName:lower() then
		npcHandler:say("In our game store -> Tournament Shop", npc, creature)
		return true
	elseif message == "balance" then
		npcHandler:say(string.format("Your balance is %i %s%s!", amountTournamentCoins, tournamentCoinName:lower(), amountTournamentCoins > 1 and "s" or ""), npc, creature)
		return true
	elseif MsgContains(message, "categor") then
		npcHandler:say("You can see items by category: {Exercise Weapons}, {Dolls}, {House Decorations}, {Utils}, {Outfits} or {Mounts}.", npc, creature)
		npcHandler:setTopic(playerId, 1)
		return true
	end

	if (npcHandler:getTopic(playerId) == 2 or npcHandler:getTopic(playerId) == 0) and eventShopItems[message] == nil then
		npcHandler:setTopic(playerId, 0)
		npcHandler:say("We can't find the item that you want, try again or access https://thorfinn.com.br/?thorfinncoins", npc, creature)
		return true
	end

	if npcHandler:getTopic(playerId) == 1 then
		npcHandler:setTopic(playerId, 2)
		local text = "We can't find the {category} that you want, try again or access https://thorfinn.com.br/?thorfinncoins"
		if message == "exercise weapons" then
			text = "{exercise sword} (25), {exercise axe} (25), {exercise club} (25), {exercise bow} (25), {exercise rod} (25), {exercise wand} (25). Each one with 500 charges"
		elseif message == "dolls" then
			text = "{baby brain squid} (800), {baby vulcongra} (800), {cerberus champion puppy} (800), {guzzlemaw grub} (800), {jousting eagle baby} (800), {demon doll} (400), {ogre rowdy doll} (400), {retching horror doll} (400), {vexclaw doll} (400)."
		elseif message == "house decorations" then
			text = "\nGilded: {gilded blessed shield} (1500), {gilded crown} (1500), {gilded horned helmet} (1500), {gilded magic longsword} (1500), {gilded warlord sword} (1500).\n"
				.. "Accolade: {sublime tournament accolade} (500), {tournament accolade} (500).\n"
				.. "Carpet: {sublime tournament carpet} (100), {tournament carpet} (100).\n"
				.. "Table: {carved table} (100), {carved table centre} (100), {carved table corner} (100).\n"
				.. "Cozy: {cozy couch} (100), {cozy couch left end} (100), {cozy couch right end} (100), {cozy couch corner} (100)."
		elseif message == "utils" then
			text = "{stamina extension} (300), {zaoan chess box} (200), {pannier backpack} (150), {green light} (80), {blood herb} (30)."
		elseif message == "mounts" then
			text = "{jousting eagle} (1500), {foxmouse} (2500), {doom skull} (4000), {corpsefire skull} (4000), {cerberus champion} (4000), {spirit of purity} (4000)."
		elseif message == "outfits" then
			text = "{full lion of war} (2000), {full veteran paladin} (2000), {full void master} (2000), {full dragon slayer} (5000)."
		end
		npcHandler:say(text, npc, creature)
		return true
	end

	if (npcHandler:getTopic(playerId) == 2 or npcHandler:getTopic(playerId) == 0) and eventShopItems[message] ~= nil then
		local selected = eventShopItems[message]
		local itemCount, itemPrice, itemCharge = selected[2], selected[3], selected[5] or 0
		local descCharge = ""
		if itemCharge > 0 and (itemCharge ~= 9999999 and itemCharge ~= 8888888) then
			descCharge = " with " .. itemCharge .. " charges"
		end

		if amountTournamentCoins > 0 and amountTournamentCoins >= itemPrice then
			if itemCharge == 9999999 then
				npcHandler:say(string.format("You want buy %s mount for %i %s? {yes} or {no}", message, itemPrice, tournamentCoinName:lower()), npc, creature)
				npcHandler:setTopic("mount", message)
			elseif itemCharge == 8888888 then
				npcHandler:say(string.format("You want buy %s outfit for %i %s? {yes} or {no}", message, itemPrice, tournamentCoinName:lower()), npc, creature)
				npcHandler:setTopic("outfit", message)
			else
				npcHandler:say(string.format("You want buy %ix %s%s for %i %s? {yes} or {no}", itemCount, message, descCharge, itemPrice, tournamentCoinName:lower()), npc, creature)
			end
			npcHandler:setTopic(playerId, 3)
			npcHandler:setTopic("selected", selected)
		else
			npcHandler:say(string.format("You don't have %i {%s}!", itemPrice, tournamentCoinName), npc, creature)
			npcHandler:setTopic(playerId, 0)
			npcHandler:setTopic("selected", {})
			npcHandler:setTopic("outfit", {})
			npcHandler:setTopic("mount", {})
		end
		return true
	end

	if npcHandler:getTopic(playerId) == 3 then
		if message ~= "yes" then
			npcHandler:say("So... what you want?", npc, creature)
			npcHandler:setTopic(playerId, 0)
			npcHandler:setTopic("selected", {})
			return true
		else
			local selected = npcHandler:getTopic("selected")
			if not selected or selected == nil then
				npcHandler:setTopic(playerId, 0)
				npcHandler:setTopic("selected", {})
				logger.error("[jeronimo]: item not selected")
				return true
			end

			local itemId, itemCount, itemPrice, isWrappable, itemCharge = selected[1], selected[2], selected[3], selected[4] or false, selected[5] or 0

			if itemCharge == 9999999 then
				if player:hasMount(itemId) then
					npcHandler:say("You already own this mount.", npc, creature)
					return true
				end
				player:updateTournamentCoins(itemPrice, "remove")
				player:addMount(itemId)
				local mountName = npcHandler:getTopic("mount")
				local msg = string.format("You bought %s mount for %i {%s}!", mountName, itemPrice, tournamentCoinName)
				player:getPosition():sendMagicEffect(CONST_ME_HOLYDAMAGE)
				npcHandler:say(msg, npc, creature)
				npcHandler:setTopic(playerId, 0)
				npcHandler:setTopic("selected", {})
				npcHandler:setTopic("mount", {})
			elseif itemCharge == 8888888 then
				local female, male = itemCount, itemId
				if player:hasOutfit(female) or player:hasOutfit(male) then
					npcHandler:say("You already own this outfit.", npc, creature)
					return true
				end
				player:updateTournamentCoins(itemPrice, "remove")
				player:addOutfitAddon(female, 3)
				player:addOutfitAddon(male, 3)
				local outfitName = npcHandler:getTopic("outfit")
				local msg = string.format("You bought %s outfit for %i {%s}!", outfitName, itemPrice, tournamentCoinName)
				player:getPosition():sendMagicEffect(CONST_ME_HOLYDAMAGE)
				npcHandler:say(msg, npc, creature)
				npcHandler:setTopic(playerId, 0)
				npcHandler:setTopic("selected", {})
				npcHandler:setTopic("outfit", {})
			else
				local inbox = player:getSlotItem(CONST_SLOT_STORE_INBOX)
				local itemT = ItemType(itemId)
				if amountTournamentCoins >= itemPrice then
					if inbox and inbox:getEmptySlots() > 0 and player:getFreeCapacity() >= itemT:getCapacity() then
						player:updateTournamentCoins(itemPrice, "remove")

						if itemCharge > 0 then
							local addedItem = player:addItem(itemId, itemCount, true)
							addedItem:setAttribute("charges", itemCharge)
						else
							if isWrappable then
								local decoKit = inbox:addItem(ITEM_DECORATION_KIT, 1)
								if decoKit then
									decoKit:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "Unwrap it in your own house to create a <" .. itemT:getName() .. ">.")
									decoKit:setCustomAttribute("unWrapId", itemId)
									decoKit:setAttribute(ITEM_ATTRIBUTE_STORE, systemTime())
									player:sendUpdateContainer(inbox)
								end
							else
								player:addItem(itemId, itemCount)
							end
						end
						local descCharge = itemCharge > 0 and " with " .. itemCharge .. " charges" or ""
						local msg = string.format("You bought %ix %s%s for %i {%s} and received in your store inbox!", itemCount, itemT:getName(), descCharge, itemPrice, tournamentCoinName)
						player:getPosition():sendMagicEffect(CONST_ME_HOLYDAMAGE)
						npcHandler:say(msg, npc, creature)
						npcHandler:setTopic(playerId, 0)
						npcHandler:setTopic("selected", {})
					else
						npcHandler:say("You need to have capacity and empty slots to receive.", npc, creature)
					end
				else
					npcHandler:say(string.format("You don't have enough {%s}.", tournamentCoinName), npc, creature)
				end
			end
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Welcome |PLAYERNAME|! You can see my offers by {categories} or if you want to change your " .. tournamentCoinName:lower() .. " to items, just say the item name! If you want help, say {help}! Or do you want know your {balance}?")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)
npcType:register(npcConfig)
