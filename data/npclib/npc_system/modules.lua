-- Advanced NPC System by Jiddo

if Modules == nil then
	-- default words for greeting and ungreeting the npc. Should be a table containing all such words.
	FOCUS_GREETWORDS = {"hi", "hello"}
	FOCUS_FAREWELLWORDS = {"bye", "farewell"}

	-- The words for requesting trade window.
	SHOP_TRADEREQUEST = {"trade"}

	-- The word for accepting/declining an offer. CAN ONLY CONTAIN ONE FIELD! Should be a table with a single string value.
	SHOP_YESWORD = {"yes"}
	SHOP_NOWORD = {"no"}

	-- Pattern used to get the amount of an item a player wants to buy/sell.
	PATTERN_COUNT = "%d+"

	Modules = {
		parseableModules = {}
	}

	StdModule = {}

	-- These callback function must be called with parameters.npcHandler = npcHandler in the parameters table or they will not work correctly.
	-- Notice: The members of StdModule have not yet been tested. If you find any bugs, please report them to me.
	-- Usage:
		-- keywordHandler:addKeyword({"offer"}, StdModule.say, {npcHandler = npcHandler, text = "I sell many powerful melee weapons."})
	function StdModule.say(cid, message, keywords, parameters, node)
		local npcHandler = parameters.npcHandler
		if npcHandler == nil then
			error("StdModule.say called without any npcHandler instance.")
		end

		if parameters.onlyFocus == true and parameters.onlyUnfocus == true then
			error("StdModule.say conflicting parameters 'onlyFocus' and 'onlyUnfocus' both true")
		end

		local onlyFocus = (parameters.onlyFocus == nil or parameters.onlyFocus == true)
		if not npcHandler:isFocused(cid) and onlyFocus then
			return false
		end

		if npcHandler:isFocused(cid) and parameters.onlyUnfocus == true then
			return false
		end

		local player = Player(cid)
		local cost, costMessage = parameters.cost, '%d gold'
		if cost and cost > 0 then
			if parameters.discount then
				cost = cost - StdModule.travelDiscount(player, parameters.discount)
			end

			costMessage = cost > 0 and string.format(costMessage, cost) or 'free'
		else
			costMessage = 'free'
		end

		local parseInfo = {[TAG_PLAYERNAME] = player:getName(), [TAG_TIME] = getFormattedWorldTime(), [TAG_BLESSCOST] = Blessings.getBlessingsCost(player:getLevel()), [TAG_PVPBLESSCOST] = Blessings.getPvpBlessingCost(player:getLevel()), [TAG_TRAVELCOST] = costMessage}
		if parameters.text then
			npcHandler:say(npcHandler:parseMessage(parameters.text, parseInfo), cid, parameters.publicize and true)
		end

		if parameters.ungreet then
			npcHandler:resetNpc(cid)
			npcHandler:releaseFocus(cid)
		elseif parameters.reset then
			local parseInfo = {[TAG_PLAYERNAME] = Player(cid):getName()}
			npcHandler:say(npcHandler:parseMessage(parameters.text or parameters.message, parseInfo), cid, parameters.publicize and true)
			if parameters.reset then
				npcHandler:resetNpc(cid)
			elseif parameters.moveup then
				npcHandler.keywordHandler:moveUp(cid, parameters.moveup)
			end
		end

		return true
	end

	--Usage:
		-- local node1 = keywordHandler:addKeyword({"promot"}, StdModule.say, {npcHandler = npcHandler, text = "I can promote you for 20000 gold coins. Do you want me to promote you?"})
		-- node1:addChildKeyword({"yes"}, StdModule.promotePlayer, {npcHandler = npcHandler, cost = 20000, level = 20}, text = "Congratulations! You are now promoted.")
		-- node1:addChildKeyword({"no"}, StdModule.say, {npcHandler = npcHandler, text = "Allright then. Come back when you are ready."}, reset = true)
	function StdModule.promotePlayer(cid, message, keywords, parameters, node)
		local npcHandler = parameters.npcHandler
		if npcHandler == nil then
			error("StdModule.promotePlayer called without any npcHandler instance.")
		end

		if not npcHandler:isFocused(cid) then
			return false
		end

		local player = Player(cid)
		if player:isPremium() or not parameters.premium then
			local promotion = player:getVocation():getPromotion()
			if player:getStorageValue(STORAGEVALUE_PROMOTION) == 1 then
				npcHandler:say("You are already promoted!", cid)
			elseif player:getLevel() < parameters.level then
				npcHandler:say("I am sorry, but I can only promote you once you have reached level " .. parameters.level .. ".", cid)
			elseif not player:removeMoneyBank(parameters.cost) then
				npcHandler:say("You do not have enough money!", cid)
			else
				npcHandler:say(parameters.text, cid)
				player:setVocation(promotion)
				player:setStorageValue(STORAGEVALUE_PROMOTION, 1)
			end
		else
			npcHandler:say("You need a premium account in order to get promoted.", cid)
		end
		npcHandler:resetNpc(cid)
		return true
	end

	function StdModule.learnSpell(cid, message, keywords, parameters, node)
		local npcHandler = parameters.npcHandler
		if npcHandler == nil then
			error("StdModule.learnSpell called without any npcHandler instance.")
		end

		if not npcHandler:isFocused(cid) then
			return false
		end

		local player = Player(cid)
		if player:isPremium() or not parameters.premium then
			if player:hasLearnedSpell(parameters.spellName) then
				npcHandler:say("You already know this spell.", cid)
			elseif not player:canLearnSpell(parameters.spellName) then
				npcHandler:say("You cannot learn this spell.", cid)
			elseif not player:removeMoneyBank(parameters.price) then
				npcHandler:say("You do not have enough money, this spell costs " .. parameters.price .. " gold.", cid)
			else
				npcHandler:say("You have learned " .. parameters.spellName .. ".", cid)
				player:learnSpell(parameters.spellName)
			end
		else
			npcHandler:say("You need a premium account in order to buy " .. parameters.spellName .. ".", cid)
		end

		npcHandler:resetNpc(cid)
		return true
	end

	function StdModule.bless(cid, message, keywords, parameters, node)
		local npcHandler = parameters.npcHandler
		if npcHandler == nil then
			error("StdModule.bless called without any npcHandler instance.")
		end

		if not npcHandler:isFocused(cid) or Game.getWorldType() == WORLD_TYPE_PVP_ENFORCED then
			return false
		end

		local player = Player(cid)
		local parseInfo = {[TAG_BLESSCOST] = Blessings.getBlessingsCost(player:getLevel()), [TAG_PVPBLESSCOST] = Blessings.getPvpBlessingCost(player:getLevel())}
		if player:hasBlessing(parameters.bless) then
			npcHandler:say("You already possess this blessing.", cid)
		elseif parameters.bless == 3 and player:getStorageValue(Storage.KawillBlessing) ~= 1 then
			npcHandler:say("You need the blessing of the great geomancer first.", cid)
		elseif parameters.bless == 1 and #player:getBlessings() == 0 and not player:getItemById(2173, true) then
			npcHandler:say("You don't have any of the other blessings nor an amulet of loss, so it wouldn't make sense to bestow this protection on you now. Remember that it can only protect you from the loss of those!", cid)
		elseif not player:removeMoneyBank(type(parameters.cost) == "string" and npcHandler:parseMessage(parameters.cost, parseInfo) or parameters.cost) then
			npcHandler:say("Oh. You do not have enough money.", cid)
		else
			npcHandler:say(parameters.text or "You have been blessed by one of the seven gods!", cid)
			if parameters.bless == 3 then
				player:setStorageValue(Storage.KawillBlessing, 0)
			end
			player:addBlessing(parameters.bless, 1)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
		end

		npcHandler:resetNpc(cid)
		return true
	end

	function StdModule.travel(cid, message, keywords, parameters, node)
		local npcHandler = parameters.npcHandler
		if npcHandler == nil then
			error("StdModule.travel called without any npcHandler instance.")
		end

		if not npcHandler:isFocused(cid) then
			return false
		end

		local player = Player(cid)
		local cost = parameters.cost
		if cost and cost > 0 then
			if parameters.discount then
				cost = cost - StdModule.travelDiscount(player, parameters.discount)

				if cost < 0 then
					cost = 0
				end
			end
		else
			cost = 0
		end

		if parameters.premium and not player:isPremium() then
			npcHandler:say("I'm sorry, but you need a premium account in order to travel onboard our ships.", cid)
		elseif parameters.level and player:getLevel() < parameters.level then
			npcHandler:say("You must reach level " .. parameters.level .. " before I can let you go there.", cid)
		elseif player:isPzLocked() then
			npcHandler:say("First get rid of those blood stains! You are not going to ruin my vehicle!", cid)
		elseif not player:removeMoneyBank(cost) then
			npcHandler:say("You don't have enough money.", cid)
		elseif os.time() < player:getStorageValue(Storage.NpcExhaust) then
			npcHandler:say('Sorry, but you need to wait three seconds before travel again.', cid)
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
		else
			npcHandler:releaseFocus(cid)
			npcHandler:say(parameters.text or "Set the sails!", cid)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)

			local destination = parameters.destination
			if type(destination) == 'function' then
				destination = destination(player)
			end

			player:teleportTo(destination)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)

			setPlayerStorageValue(cid, StorageNpcExhaust, 3 + os.time())
			player:teleportTo(destination)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)

			-- What a foolish Quest - Mission 3
			if player:getStorageValue(Storage.WhatAFoolish.PieBoxTimer) > os.time() then
				if destination ~= Position(32660, 31957, 15) then -- kazordoon steamboat
					player:setStorageValue(Storage.WhatAFoolish.PieBoxTimer, 1)
				end
			end
		end

		npcHandler:resetNpc(cid)
		return true
	end

	FocusModule = {
		npcHandler = nil,
		greetWords = nil,
		farewellWords = nil,
		greetCallback = nil,
		farewellCallback = nil
	}

	-- Creates a new instance of FocusModule without an associated NpcHandler.
	function FocusModule:new()
		local obj = {}
		setmetatable(obj, self)
		self.__index = self
		return obj
	end

	-- Inits the module and associates handler to it.
	function FocusModule:init(handler)
		self.npcHandler = handler
		for i, word in pairs(FOCUS_GREETWORDS) do
			local obj = {}
			obj[#obj + 1] = word
			obj.callback = FOCUS_GREETWORDS.callback or FocusModule.messageMatcher
			handler.keywordHandler:addKeyword(obj, FocusModule.onGreet, {module = self})
		end

		for i, word in pairs(FOCUS_FAREWELLWORDS) do
			local obj = {}
			obj[#obj + 1] = word
			obj.callback = FOCUS_FAREWELLWORDS.callback or FocusModule.messageMatcher
			handler.keywordHandler:addKeyword(obj, FocusModule.onFarewell, {module = self})
		end

		return true
	end

	-- Set custom greeting messages
	function FocusModule:addGreetMessage(message)
		if not self.greetWords then
			self.greetWords = {}
		end


		if type(message) == 'string' then
			table.insert(self.greetWords, message)
		else
			for i = 1, #message do
				table.insert(self.greetWords, message[i])
			end
		end
	end

	-- Set custom farewell messages
	function FocusModule:addFarewellMessage(message)
		if not self.farewellWords then
			self.farewellWords = {}
		end

		if type(message) == 'string' then
			table.insert(self.farewellWords, message)
		else
			for i = 1, #message do
				table.insert(self.farewellWords, message[i])
			end
		end
	end

	-- Set custom greeting callback
	function FocusModule:setGreetCallback(callback)
		self.greetCallback = callback
	end

	-- Set custom farewell callback
	function FocusModule:setFarewellCallback(callback)
		self.farewellCallback = callback
	end

	-- Greeting callback function.
	function FocusModule.onGreet(npc, cid, message, keywords, parameters)
		parameters.module.npcHandler:onGreet(npc, cid, message)
		return true
	end

	-- UnGreeting callback function.
	function FocusModule.onFarewell(npc, cid, message, keywords, parameters)
		if parameters.module.npcHandler:isFocused(cid) then
			parameters.module.npcHandler:onFarewell(npc, cid)
			return true
		else
			return false
		end
	end

	-- Custom message matching callback function for greeting messages.
	function FocusModule.messageMatcher(keywords, message)
		for i, word in pairs(keywords) do
			if type(word) == "string" then
				if string.find(message, word) and not string.find(message, "[%w+]" .. word) and not string.find(message, word .. "[%w+]") then
					return true
				end
			end
		end
		return false
	end

	KeywordModule = {
		npcHandler = nil
	}
	-- Add it to the parseable module list.
	Modules.parseableModules["module_keywords"] = KeywordModule

	function KeywordModule:new()
		local obj = {}
		setmetatable(obj, self)
		self.__index = self
		return obj
	end

	function KeywordModule:init(handler)
		self.npcHandler = handler
		return true
	end

	function KeywordModule:parseKeywords(data)
		for keys in string.gmatch(data, "[^;]+") do
			local i = 1

			local keywords = {}
			for temp in string.gmatch(keys, "[^,]+") do
				keywords[#keywords + 1] = temp
				i = i + 1
			end
		end
	end

	function KeywordModule:addKeyword(keywords, reply)
		self.npcHandler.keywordHandler:addKeyword(keywords, StdModule.say, {npcHandler = self.npcHandler, onlyFocus = true, text = reply, reset = true})
	end

	TravelModule = {
		npcHandler = nil,
		destinations = nil,
		yesNode = nil,
		noNode = nil,
	}

	-- Add it to the parseable module list.
	Modules.parseableModules["module_travel"] = TravelModule

	function TravelModule:new()
		local obj = {}
		setmetatable(obj, self)
		self.__index = self
		return obj
	end

	function TravelModule:init(handler)
		self.npcHandler = handler
		self.yesNode = KeywordNode:new(SHOP_YESWORD, TravelModule.onConfirm, {module = self})
		self.noNode = KeywordNode:new(SHOP_NOWORD, TravelModule.onDecline, {module = self})
		self.destinations = {}
		return true
	end

	function TravelModule:parseDestinations(data)
		for destination in string.gmatch(data, "[^;]+") do
			local i = 1

			local name = nil
			local x = nil
			local y = nil
			local z = nil
			local cost = nil
			local premium = false

			for temp in string.gmatch(destination, "[^,]+") do
				if i == 1 then
					name = temp
				elseif i == 2 then
					x = tonumber(temp)
				elseif i == 3 then
					y = tonumber(temp)
				elseif i == 4 then
					z = tonumber(temp)
				elseif i == 5 then
					cost = tonumber(temp)
				elseif i == 6 then
					premium = temp == "true"
				else
					Spdlog.warn(string.format("[TravelModule:parseDestinations] - %s] NpcSystem: Unknown parameter found in travel destination parameter. temp[%d], destination[%s]",
						NpcOld():getName(), temp, destination))
				end
				i = i + 1
			end

			if name and x and y and z and cost then
				self:addDestination(name, {x=x, y=y, z=z}, cost, premium)
			else
				Spdlog.warn("[TravelModule:parseDestinations] - " .. NpcOld():getName() .. "] NpcSystem: Parameter(s) missing for travel destination:", name, x, y, z, cost, premium)
			end
		end
	end

	function TravelModule:addDestination(name, position, price, premium)
		self.destinations[#self.destinations + 1] = name

		local parameters = {
			cost = price,
			destination = position,
			premium = premium,
			module = self
		}
		local keywords = {}
		keywords[#keywords + 1] = name

		local keywords2 = {}
		keywords2[#keywords2 + 1] = "bring me to " .. name
		local node = self.npcHandler.keywordHandler:addKeyword(keywords, TravelModule.travel, parameters)
		self.npcHandler.keywordHandler:addKeyword(keywords2, TravelModule.bringMeTo, parameters)
		node:addChildKeywordNode(self.yesNode)
		node:addChildKeywordNode(self.noNode)

		if npcs_loaded_travel[getNpcCid()] == nil then
			npcs_loaded_travel[getNpcCid()] = getNpcCid()
			self.npcHandler.keywordHandler:addKeyword({'yes'}, TravelModule.onConfirm, {module = self})
			self.npcHandler.keywordHandler:addKeyword({'no'}, TravelModule.onDecline, {module = self})
		end
	end

	function TravelModule.travel(cid, message, keywords, parameters, node)
		local module = parameters.module
		if not module.npcHandler:isFocused(cid) then
			return false
		end

		local npcHandler = module.npcHandler

		shop_destination[cid] = parameters.destination
		shop_cost[cid] = parameters.cost
		shop_premium[cid] = parameters.premium
		shop_npcuid[cid] = getNpcCid()

		local cost = parameters.cost
		local destination = parameters.destination
		local premium = parameters.premium

		module.npcHandler:say("Do you want to travel to " .. keywords[1] .. " for " .. cost .. " gold coins?", cid)
		return true
	end

	function TravelModule.onConfirm(cid, message, keywords, parameters, node)
		local module = parameters.module
		if not module.npcHandler:isFocused(cid) then
			return false
		end

		if shop_npcuid[cid] ~= NpcOld().uid then
			return false
		end

		local npcHandler = module.npcHandler

		local cost = shop_cost[cid]
		local destination = Position(shop_destination[cid])

		local player = Player(cid)
		if player:isPremium() or not shop_premium[cid] then
			if not player:removeMoneyBank(cost) then
				npcHandler:say("You do not have enough money!", cid)
			elseif player:isPzLocked(cid) then
				npcHandler:say("Get out of there with this blood.", cid)
			else
				npcHandler:say("It was a pleasure doing business with you.", cid)
				npcHandler:releaseFocus(cid)

				local position = player:getPosition()
				player:teleportTo(destination)

				position:sendMagicEffect(CONST_ME_TELEPORT)
				destination:sendMagicEffect(CONST_ME_TELEPORT)
			end
		else
			npcHandler:say("I can only allow premium players to travel there.", cid)
		end

		npcHandler:resetNpc(cid)
		return true
	end

	-- onDecline keyword callback function. Generally called when the player sais "no" after wanting to buy an item.
	function TravelModule.onDecline(cid, message, keywords, parameters, node)
		local module = parameters.module
		if not module.npcHandler:isFocused(cid) or shop_npcuid[cid] ~= getNpcCid() then
			return false
		end
		local parentParameters = node:getParent():getParameters()
		local parseInfo = { [TAG_PLAYERNAME] = Player(cid):getName() }
		local msg = module.npcHandler:parseMessage(module.npcHandler:getMessage(MESSAGE_DECLINE), parseInfo)
		module.npcHandler:say(msg, cid)
		module.npcHandler:resetNpc(cid)
		return true
	end

	function TravelModule.bringMeTo(cid, message, keywords, parameters, node)
		local module = parameters.module
		if not module.npcHandler:isFocused(cid) then
			return false
		end

		local cost = parameters.cost
		local destination = Position(parameters.destination)

		local player = Player(cid)
		if player:isPremium() or not parameters.premium then
			if player:removeMoneyBank(cost) then
				local position = player:getPosition()
				player:teleportTo(destination)

				position:sendMagicEffect(CONST_ME_TELEPORT)
				destination:sendMagicEffect(CONST_ME_TELEPORT)
			end
		end
		return true
	end

	function TravelModule.listDestinations(cid, message, keywords, parameters, node)
		local module = parameters.module
		if not module.npcHandler:isFocused(cid) then
			return false
		end

		local msg = "I can bring you to "
		--local i = 1
		local maxn = #module.destinations
		for i, destination in pairs(module.destinations) do
			msg = msg .. destination
			if i == maxn - 1 then
				msg = msg .. " and "
			elseif i == maxn then
				msg = msg .. "."
			else
				msg = msg .. ", "
			end
			i = i + 1
		end

		module.npcHandler:say(msg, cid)
		module.npcHandler:resetNpc(cid)
		return true
	end
end
