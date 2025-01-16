local internalNpcName = "Taberna Coins Manager"
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
	{ text = "Visit our Game Store -> Taberna Shopp to check the offers" },
	{ text = "WE HAVE MOUNTS AND OUTFITS TO CHANGE !!" },
	--{ text = "Visit our site to check the offers: Library -> Taberna Coins" },
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

local OfferType = {
	ExerciseWeapon = 1,
	Doll = 2,
	House = 3,
	Utils = 4,
	Outfit = 5,
	Mount = 6,
}

--local listShopItems = {
--	["name"] = { id = x, count = 1, value = x, charges = x, type = OfferType.x },
--}
local listShopItems = {
	["exercise sword"] = { id = 28552, count = 1, value = 700, charges = 1500, type = OfferType.ExerciseWeapon },
	["exercise axe"] = { id = 28553, count = 1, value = 700, charges = 1500, type = OfferType.ExerciseWeapon },
	["exercise club"] = { id = 28554, count = 1, value = 700, charges = 1500, type = OfferType.ExerciseWeapon },
	["exercise bow"] = { id = 28555, count = 1, value = 700, charges = 1500, type = OfferType.ExerciseWeapon },
	["exercise rod"] = { id = 28556, count = 1, value = 700, charges = 1500, type = OfferType.ExerciseWeapon },
	["exercise wand"] = { id = 28557, count = 1, value = 700, charges = 1500, type = OfferType.ExerciseWeapon },

	["baby brain squid"] = { id = 32909, count = 1, value = 800, wrap = true, type = OfferType.House },
	["baby vulcongra"] = { id = 32908, count = 1, value = 800, wrap = true, type = OfferType.House },
	["cerberus champion puppy"] = { id = 31464, count = 1, value = 800, wrap = true, type = OfferType.House },
	["guzzlemaw grub"] = { id = 32907, count = 1, value = 800, wrap = true, type = OfferType.House },
	["jousting eagle baby"] = { id = 31462, count = 1, value = 800, wrap = true, type = OfferType.House },
	["demon doll"] = { id = 32918, count = 1, value = 400, wrap = true, type = OfferType.House },
	["ogre rowdy doll"] = { id = 32944, count = 1, value = 400, wrap = true, type = OfferType.House },
	["retching horror doll"] = { id = 32945, count = 1, value = 400, wrap = true, type = OfferType.House },
	["vexclaw doll"] = { id = 32943, count = 1, value = 400, wrap = true, type = OfferType.House },
	["draken doll"] = { id = 12044, count = 1, value = 150, wrap = true, type = OfferType.House },
	["bear doll"] = { id = 3001, count = 1, value = 150, wrap = true, type = OfferType.House },

	["gilded blessed shield"] = { id = 37165, count = 1, value = 1500, wrap = true, type = OfferType.House },
	["gilded crown"] = { id = 34332, count = 1, value = 1500, wrap = true, type = OfferType.House },
	["gilded horned helmet"] = { id = 38640, count = 1, value = 1500, wrap = true, type = OfferType.House },
	["gilded magic longsword"] = { id = 36995, count = 1, value = 1500, wrap = true, type = OfferType.House },
	["gilded warlord sword"] = { id = 39767, count = 1, value = 1500, wrap = true, type = OfferType.House },

	["sublime tournament accolade"] = { id = 31472, count = 1, value = 500, wrap = true, type = OfferType.House },
	["tournament accolade"] = { id = 31470, count = 1, value = 500, wrap = true, type = OfferType.House },

	["sublime tournament carpet"] = { id = 31467, count = 1, value = 100, wrap = true, type = OfferType.House },
	["tournament carpet"] = { id = 31466, count = 1, value = 100, wrap = true, type = OfferType.House },

	["carved table"] = { id = 32972, count = 1, value = 100, wrap = true, type = OfferType.House },
	["carved table centre"] = { id = 32974, count = 1, value = 100, wrap = true, type = OfferType.House },
	["carved table corner"] = { id = 32969, count = 1, value = 100, wrap = true, type = OfferType.House },

	["cozy couch"] = { id = 32948, count = 1, value = 100, wrap = true, type = OfferType.House },
	["cozy couch left end"] = { id = 32948, count = 1, value = 100, wrap = true, type = OfferType.House },
	["cozy couch right end"] = { id = 32956, count = 1, value = 100, wrap = true, type = OfferType.House },
	["cozy couch corner"] = { id = 32964, count = 1, value = 100, wrap = true, type = OfferType.House },

	["stamina refill"] = { id = 44740, count = 1, value = 400, type = OfferType.Utils },
	["zaoan chess box"] = { id = 18339, count = 1, value = 200, type = OfferType.Utils },
	["pannier backpack"] = { id = 19159, count = 1, value = 150, type = OfferType.Utils },
	["green light"] = { id = 21217, count = 1, value = 80, type = OfferType.Utils },
	["blood herb"] = { id = 3734, count = 3, value = 30, type = OfferType.Utils },

	["full dragon slayer"] = { id = { female = 1289, male = 1288 }, value = 5000, type = OfferType.Outfit },
	["full lion of war"] = { id = { female = 1207, male = 1206 }, value = 2000, type = OfferType.Outfit },
	["full veteran paladin"] = { id = { female = 1205, male = 1204 }, value = 2000, type = OfferType.Outfit },
	["full void master"] = { id = { female = 1203, male = 1202 }, value = 2000, type = OfferType.Outfit },

	["cerberus champion"] = { id = 146, value = 4000, type = OfferType.Mount },
	["jousting eagle"] = { id = 145, value = 1500, type = OfferType.Mount },
	["doom skull"] = { id = 219, value = 4000, type = OfferType.Mount },
	["foxmouse"] = { id = 218, value = 2500, type = OfferType.Mount },
	["corpsefire skull"] = { id = 221, value = 4000, type = OfferType.Mount },
	["spirit of purity"] = { id = 217, value = 4000, type = OfferType.Mount },
}

local offersByCategories = {
	["exercise weapons"] = "{exercise sword} (700), {exercise axe} (700), {exercise club} (700), {exercise bow} (700), {exercise rod} (700), {exercise wand} (700). Each one with 1500 charges.",
	["dolls"] = "{baby brain squid} (800), {baby vulcongra} (800), {cerberus champion puppy} (800), {guzzlemaw grub} (800), {jousting eagle baby} (800), {demon doll} (400), {ogre rowdy doll} (400), {retching horror doll} (400), {vexclaw doll} (400), {draken doll} (150), {bear doll} (150).",
	["house decorations"] = "\nGilded: {gilded blessed shield} (1500), {gilded crown} (1500), {gilded horned helmet} (1500), {gilded magic longsword} (1500), {gilded warlord sword} (1500).\n"
		.. "Accolade: {sublime tournament accolade} (500), {tournament accolade} (500).\n"
		.. "Carpet: {sublime tournament carpet} (100), {tournament carpet} (100).\n"
		.. "Table: {carved table} (100), {carved table centre} (100), {carved table corner} (100).\n"
		.. "Cozy: {cozy couch} (100), {cozy couch left end} (100), {cozy couch right end} (100), {cozy couch corner} (100).",
	["utils"] = "{stamina refill} (400), {zaoan chess box} (200), {pannier backpack} (150), {green light} (80), {blood herb} (30).",
	["outfits"] = "{full lion of war} (2000), {full veteran paladin} (2000), {full void master} (2000), {full dragon slayer} (5000).",
	["mounts"] = "{jousting eagle} (1500), {foxmouse} (2500), {doom skull} (4000), {corpsefire skull} (4000), {cerberus champion} (4000), {spirit of purity} (4000).",
}

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	local amountTournamentCoins = player:getTournamentCoins() or 0
	message = string.lower(message)
	if message == "help" or message == tournamentCoinName:lower() then
		npcHandler:say(string.format("In our game store -> Taberna Shop or website enter in {Library} -> {%s} or access https://tabernaot.com.br", tournamentCoinName), npc, creature)
		return true
	elseif message == "balance" then
		npcHandler:say(string.format("Your balance is %i %s%s!", amountTournamentCoins, tournamentCoinName:lower(), amountTournamentCoins > 1 and "s" or ""), npc, creature)
		return true
	elseif MsgContains(message, "categor") then
		npcHandler:say("You can see items by category: {Exercise Weapons}, {Dolls}, {House Decorations}, {Utils}, {Outfits} or {Mounts}.", npc, creature)
		npcHandler:setTopic(playerId, 1)
		return true
	end

	if (npcHandler:getTopic(playerId) == 2 or npcHandler:getTopic(playerId) == 0) and listShopItems[message] == nil then
		npcHandler:setTopic(playerId, 0)
		npcHandler:say("We can't find the item that you want, try again or access https://tabernaot.com.br", npc, creature)
		return true
	end

	if npcHandler:getTopic(playerId) == 1 then
		npcHandler:setTopic(playerId, 2)
		local text = offersByCategories[message]
		if text == nil then
			text = "We can't find the {category} that you want, try again or access https://tabernaot.com.br/"
			npcHandler:setTopic(playerId, 0)
		end
		npcHandler:say(text, npc, creature)
		return true
	end

	if (npcHandler:getTopic(playerId) == 2 or npcHandler:getTopic(playerId) == 0) and listShopItems[message] ~= nil then
		local selected = listShopItems[message]
		if amountTournamentCoins < selected.value then
			npcHandler:say(string.format("You don't have %i {%s}!", selected.value, tournamentCoinName), npc, creature)
			npcHandler:setTopic(playerId, 0)
			npcHandler:setTopic("selected", {})
			npcHandler:setTopic("outfit", {})
			npcHandler:setTopic("mount", {})
			return true
		end

		local descCharge = ""
		if selected.type == OfferType.ExerciseWeapon and selected.charges ~= nil then
			descCharge = " with " .. selected.charges .. " charges"
		end

		if selected.type == OfferType.Outfit then
			npcHandler:say(string.format("You want buy %s outfit for %i %s? {yes} or {no}", message, selected.value, tournamentCoinName:lower()), npc, creature)
			npcHandler:setTopic("outfit", message)
		elseif selected.type == OfferType.Mount then
			npcHandler:say(string.format("You want buy %s mount for %i %s? {yes} or {no}", message, selected.value, tournamentCoinName:lower()), npc, creature)
			npcHandler:setTopic("mount", message)
		else
			npcHandler:say(string.format("You want buy %ix %s%s for %i %s? {yes} or {no}", selected.count, message, descCharge, selected.value, tournamentCoinName:lower()), npc, creature)
		end

		npcHandler:setTopic(playerId, 3)
		npcHandler:setTopic("selected", selected)

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

			if selected.type == OfferType.Mount then
				if player:hasMount(selected.id) then
					npcHandler:say("You already own this mount.", npc, creature)
					return true
				end
				player:updateTournamentCoins(selected.value, "remove")
				player:addMount(selected.id)
				local mountName = npcHandler:getTopic("mount")
				local msg = string.format("You bought %s mount for %i {%s}!", mountName, selected.value, tournamentCoinName)
				player:getPosition():sendMagicEffect(CONST_ME_HOLYDAMAGE)
				npcHandler:say(msg, npc, creature)
				npcHandler:setTopic(playerId, 0)
				npcHandler:setTopic("selected", {})
				npcHandler:setTopic("mount", {})
			elseif selected.type == OfferType.Outfit then
				local female, male = selected.id.female, selected.id.male
				if player:hasOutfit(female) or player:hasOutfit(male) then
					npcHandler:say("You already own this outfit.", npc, creature)
					return true
				end
				player:updateTournamentCoins(selected.value, "remove")
				player:addOutfitAddon(female, 3)
				player:addOutfitAddon(male, 3)
				local outfitName = npcHandler:getTopic("outfit")
				local msg = string.format("You bought %s outfit for %i %s!", outfitName, selected.value, tournamentCoinName:lower())
				player:getPosition():sendMagicEffect(CONST_ME_HOLYDAMAGE)
				npcHandler:say(msg, npc, creature)
				npcHandler:setTopic(playerId, 0)
				npcHandler:setTopic("selected", {})
				npcHandler:setTopic("outfit", {})
			else
				local inbox = player:getSlotItem(CONST_SLOT_STORE_INBOX)
				local itemT = ItemType(selected.id)
				if amountTournamentCoins >= selected.value then
					if inbox and inbox:getEmptySlots() > 0 and player:getFreeCapacity() >= itemT:getCapacity() then
						player:updateTournamentCoins(selected.value, "remove")

						if selected.charges ~= nil and selected.charges > 0 then
							local addedItem = player:addItem(selected.id, selected.count, true)
							addedItem:setAttribute("charges", selected.charges)
						else
							selected.charges = 0
							if selected.wrap then
								local decoKit = inbox:addItem(ITEM_DECORATION_KIT, 1)
								if decoKit then
									decoKit:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "Unwrap it in your own house to create a <" .. itemT:getName() .. ">.")
									decoKit:setCustomAttribute("unWrapId", selected.id)
									decoKit:setAttribute(ITEM_ATTRIBUTE_STORE, systemTime())
									player:sendUpdateContainer(inbox)
								end
							else
								player:addItem(selected.id, selected.count)
							end
						end
						local descCharge = selected.charges > 0 and " with " .. selected.charges .. " charges" or ""
						local msg = string.format("You bought %ix %s%s for %i {%s} and received in your store inbox!", selected.count, itemT:getName(), descCharge, selected.value, tournamentCoinName)
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
