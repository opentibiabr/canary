-- Advanced NPC System by Jiddo

if NpcHandler == nil then
	-- Constant talkdelay behaviors.
	TALKDELAY_NONE = 0 -- No talkdelay. Npc will reply immedeatly.
	TALKDELAY_ONTHINK = 1 -- Talkdelay handled through the onThink callback function. (Default)
	TALKDELAY_EVENT = 2 -- Not yet implemented

	-- Currently applied talkdelay behavior. TALKDELAY_ONTHINK is default.
	NPCHANDLER_TALKDELAY = TALKDELAY_ONTHINK

	-- Constant indexes for defining default messages.
	MESSAGE_GREET = 1 -- When the player greets the npc.
	MESSAGE_FAREWELL = 2 -- When the player unGreets the npc.
	MESSAGE_BUY = 3 -- When the npc asks the player if he wants to buy something.
	-- EMPTY = 4
	-- EMPTY = 5
	-- EMPTY = 6
	-- EMPTY = 7
	-- EMPTY = 8
	MESSAGE_MISSINGMONEY = 9 -- When the player does not have enough money.
	MESSAGE_NEEDMONEY = 10 -- Same as above, used for shop window.
	MESSAGE_MISSINGITEM = 11 -- When the player is trying to sell an item he does not have.
	MESSAGE_NEEDITEM = 12 -- Same as above, used for shop window.
	MESSAGE_NEEDSPACE = 13 -- When the player don't have any space to buy an item
	MESSAGE_NEEDMORESPACE = 14 -- When the player has some space to buy an item, but not enough space
	-- EMPTY = 15
	MESSAGE_WALKAWAY = 16 -- When the player walks out of the talkRadius of the npc.
	MESSAGE_DECLINE	 = 17 -- When the player says no to something.
	MESSAGE_SENDTRADE = 18 -- When the npc sends the trade window to the player
	MESSAGE_NOSHOP = 19 -- When the npc's shop is requested but he doesn't have any
	MESSAGE_ONCLOSESHOP = 20 -- When the player closes the npc's shop window
	MESSAGE_ALREADYFOCUSED = 21 -- When the player already has the player of this npc.
	MESSAGE_WALKAWAY_MALE = 22 -- When a male player walks out of the talkRadius of the npc.
	MESSAGE_WALKAWAY_FEMALE = 23 -- When a female player walks out of the talkRadius of the npc.

	-- Constant indexes for callback functions. These are also used for module callback ids.
	CALLBACK_ON_APPEAR = 1
	CALLBACK_ON_DISAPPEAR = 2
	CALLBACK_ON_SAY = 3
	CALLBACK_ON_THINK = 4
	CALLBACK_GREET = 5
	CALLBACK_FAREWELL = 6
	CALLBACK_MESSAGE_DEFAULT = 7
	CALLBACK_PLAYER_END_TRADE = 8
	CALLBACK_CLOSE_CHANNEL = 9
	CALLBACK_ON_MOVE = 10
	CALLBACK_SET_INTERACTION = 18
	CALLBACK_REMOVE_INTERACTION = 19
	CALLBACK_ON_TRADE_REQUEST = 20

	-- Addidional module callback ids
	CALLBACK_MODULE_INIT = 12
	CALLBACK_MODULE_RESET = 13

	-- Constant strings defining the keywords to replace in the default messages.
	TAG_PLAYERNAME = "|PLAYERNAME|"
	TAG_ITEMCOUNT = "|ITEMCOUNT|"
	TAG_TOTALCOST = "|TOTALCOST|"
	TAG_ITEMNAME = "|ITEMNAME|"
	TAG_TIME = "|TIME|"
	TAG_BLESSCOST = "|BLESSCOST|"
	TAG_PVPBLESSCOST = "|PVPBLESSCOST|"
	TAG_TRAVELCOST = "|TRAVELCOST|"

	NpcHandler = {
		keywordHandler = nil,
		talkStart = nil,
		talkDelay = 1000, -- Delay from each messages
		talkDelayTimeForOutgoingMessages = 1, -- Seconds to delay outgoing messages
		callbackFunctions = nil,
		modules = nil,
		npcName = nil,
		eventSay = nil,
		eventDelayedSay = nil,
		topic = nil,
		messages = {
			-- These are the default replies of all npcs. They can/should be changed individually for each npc.
			-- Leave empty for no send message
			[MESSAGE_GREET] = "Greetings, |PLAYERNAME|.",
			[MESSAGE_FAREWELL] = "Good bye, |PLAYERNAME|.",
			[MESSAGE_BUY] = "Do you want to buy |ITEMCOUNT| |ITEMNAME| for |TOTALCOST| gold coins?",
			[MESSAGE_MISSINGMONEY] = "You don't have enough money.",
			[MESSAGE_NEEDMONEY] = "You don't have enough money.",
			[MESSAGE_MISSINGITEM] = "You don't have so many.",
			[MESSAGE_NEEDITEM] = "You do not have this object.",
			[MESSAGE_NEEDSPACE] = "There is not enought room.",
			[MESSAGE_NEEDMORESPACE] = "You do not have enough capacity for all items.",
			[MESSAGE_WALKAWAY] = "Good bye.",
			[MESSAGE_DECLINE] = "Then not.",
			[MESSAGE_SENDTRADE] = "Of course, just browse through my wares.",
			[MESSAGE_NOSHOP] = "Sorry, I'm not offering anything.",
			[MESSAGE_ONCLOSESHOP] = "Thank you, come back whenever you're in need of something else.",
			[MESSAGE_ALREADYFOCUSED] = "|PLAYERNAME|, I am already talking to you.",
			[MESSAGE_WALKAWAY_MALE] = "",
			[MESSAGE_WALKAWAY_FEMALE] = ""
		}
	}

	-- Creates a new NpcHandler with an empty callbackFunction stack.
	function NpcHandler:new(keywordHandler)
		local obj = {}
		obj.callbackFunctions = {}
		obj.modules = {}
		obj.npcName = ""
		obj.eventSay = {}
		obj.eventDelayedSay = {}
		obj.topic = {}
		obj.talkStart = {}
		obj.keywordHandler = keywordHandler
		obj.messages = {}

		setmetatable(obj.messages, self.messages)
		self.messages.__index = self.messages

		setmetatable(obj, self)
		self.__index = self
		return obj
	end

	-- NpcHandler get and set obj
	-- Get keyword handler of this npc handler
	function NpcHandler:getKeywordHandler()
		return self.keywordHandler
	end

	-- Attackes a new keyword handler to this npc handler
	function NpcHandler:setKeywordHandler(newHandler)
		self.keywordHandler = newHandler
	end

	-- local playerId = player:getId()
	-- npcHandler:getEventDelayedSay(playerId)
	function NpcHandler:getEventDelayedSay(playerId)
		return self.eventDelayedSay[playerId]
	end

	-- npcHandler:setEventDelayedSay(playerId, nil)
	function NpcHandler:setEventDelayedSay(playerId, newEventDelayedSay)
		self.eventDelayedSay[playerId] = newEventDelayedSay
	end

	-- npcHandler:getEventSay(playerId)
	function NpcHandler:getEventSay(playerId)
		return self.eventSay[playerId]
	end

	-- npcHandler:setEventSay(playerId, nil)
	function NpcHandler:setEventSay(playerId, newEventSay)
		self.eventSay[playerId] = newEventSay
	end

	-- npcHandler:getTalkStart(playerId)
	function NpcHandler:getTalkStart(playerId)
		return self.talkStart[playerId]
	end

	-- npcHandler:setTalkStart(playerId, nil)
	function NpcHandler:setTalkStart(playerId, newTalkStart)
		self.talkStart[playerId] = newTalkStart
	end

	-- npcHandler:getTopic(playerId) == topicId
	function NpcHandler:getTopic(playerId)
		return self.topic[playerId]
	end

	-- npcHandler:setTopic(playerId, nil)
	function NpcHandler:setTopic(playerId, newTopic)
		self.topic[playerId] = newTopic
	end

	-- Npc handler interaction functions
	-- It will check if the npc is interacting with the player
	function NpcHandler:checkInteraction(npc, player)
		return npc:isInteractingWithPlayer(player)
	end

	-- If the player is not interacting with the npc, it set the npc's interaction with the player
	-- It clean the eventDelayedSay and turn npc to the player
	function NpcHandler:updateInteraction(npc, player)
		local playerId = player:getId()
		if not self:checkInteraction(npc, player) then
			npc:setPlayerInteraction(player, 0)
			return true
		end
		if self:getEventDelayedSay(playerId) then
			self:cancelNPCTalk(self:getEventDelayedSay(playerId))
		end
		return npc:turnToCreature(player, true)
	end

	-- This function is used to set an interaction between the npc and the player
	-- Also set the default (0) topic and call "updateInteraction"
	function NpcHandler:setInteraction(npc, player)
		local playerId = player:getId()
		if self:checkInteraction(npc, player) then
			return false
		end

		self:setTopic(playerId, 0)
		local callback = self:getCallback(CALLBACK_SET_INTERACTION)
		if callback == nil or callback(npc, player) then
			self:processModuleCallback(CALLBACK_SET_INTERACTION, npc, player)
		end
		self:updateInteraction(npc, player)
		return true
	end

	-- This function removes the npc interaction with the player and clear the objects
	-- Also close the shop (if is opened) and clear eventDelayedSay
	function NpcHandler:removeInteraction(npc, player)
		local playerId = player:getId()
		if Player(player) == nil then
			return Spdlog.error("[NpcHandler:removeInteraction] - Player is missing or nil")
		end

		if self:getEventDelayedSay(playerId) then
			self:cancelNPCTalk(self:getEventDelayedSay(playerId))
		end

		self:setEventDelayedSay(playerId, nil)
		self:setEventSay(playerId, nil)
		self:setTalkStart(playerId, nil)
		self:setTopic(playerId, nil)

		local callback = self:getCallback(CALLBACK_REMOVE_INTERACTION)
		if callback == nil or callback(npc, player) then
			self:processModuleCallback(CALLBACK_REMOVE_INTERACTION, npc, player)
		end

		-- If it is an npc that has a shop and the shop is open, it will be closed
		if npc:isMerchant() then
			npc:closeShopWindow(player)
		end
		npc:removePlayerInteraction(player)
	end

	-- Returns the callback function with the specified id or nil if no such callback function exists
	function NpcHandler:getCallback(id)
		local ret = nil
		if self.callbackFunctions ~= nil then
			ret = self.callbackFunctions[id]
		end
		return ret
	end

	-- Changes the callback function for the given id to callback
	function NpcHandler:setCallback(id, callback)
		if self.callbackFunctions ~= nil then
			self.callbackFunctions[id] = callback
		end
	end

	-- Adds a module to this npc handler and inits it
	-- Variables "greetCallback, farewellCallback and tradeCallback" are boolean value, true by default
	function NpcHandler:addModule(module, initNpcName, greetCallback, farewellCallback, tradeCallback)
		if self.modules ~= nil then
			self.modules[#self.modules + 1] = module
			self.npcName = initNpcName
			if greetCallback == nil then
				Spdlog.warn("[NpcHandler:addModule] - Greet callback is missing for npc with name: ".. initNpcName ..", setting to true")
				greetCallback = true
			end
			if farewellCallback == nil then
				Spdlog.warn("[NpcHandler:addModule] - Farewell callback is missing for npc with name: ".. initNpcName ..", setting to true")
				farewellCallback = true
			end
			if tradeCallback == nil then
				Spdlog.warn("[NpcHandler:addModule] - Trade callback is missing for npc with name: ".. initNpcName ..", setting to true")
				tradeCallback = true
			end
			module:init(self, greetCallback, farewellCallback, tradeCallback)
		end
	end

	-- Calls the callback function represented by id for all modules added to this npc handler with the given arguments
	function NpcHandler:processModuleCallback(id, ...)
		local ret = true
		for _, module in pairs(self.modules) do
			local tmpRet = true
			if id == CALLBACK_ON_APPEAR and module.callbackOnAppear ~= nil then
				tmpRet = module:callbackOnAppear(...)
			elseif id == CALLBACK_ON_DISAPPEAR and module.callbackOnCreatureDisappear ~= nil then
				tmpRet = module:callbackOnCreatureDisappear(...)
			elseif id == CALLBACK_ON_SAY and module.callbackOnCreatureSay ~= nil then
				tmpRet = module:callbackOnCreatureSay(...)
			elseif id == CALLBACK_PLAYER_END_TRADE and module.callbackOnPlayerEndTrade ~= nil then
				tmpRet = module:callbackOnPlayerEndTrade(...)
			elseif id == CALLBACK_CLOSE_CHANNEL and module.callbackOnCloseChannel ~= nil then
				tmpRet = module:callbackOnCloseChannel(...)
			elseif id == CALLBACK_ON_TRADE_REQUEST and module.callbackOnTradeRequest ~= nil then
				tmpRet = module:callbackOnTradeRequest(...)
			elseif id == CALLBACK_SET_INTERACTION and module.callbackOnAddFocus ~= nil then
				tmpRet = module:callbackOnAddFocus(...)
			elseif id == CALLBACK_REMOVE_INTERACTION and module.callbackOnReleaseFocus ~= nil then
				tmpRet = module:callbackOnReleaseFocus(...)
			elseif id == CALLBACK_ON_THINK and module.callbackOnThink ~= nil then
				tmpRet = module:callbackOnThink(...)
			elseif id == CALLBACK_ON_MOVE and module.callbackOnMove ~= nil then
				tmpRet = module:callbackOnMove(...)
			elseif id == CALLBACK_GREET and module.callbackOnGreet ~= nil then
				tmpRet = module:callbackOnGreet(...)
			elseif id == CALLBACK_FAREWELL and module.callbackOnFarewell ~= nil then
				tmpRet = module:callbackOnFarewell(...)
			elseif id == CALLBACK_MESSAGE_DEFAULT and module.callbackOnMessageDefault ~= nil then
				tmpRet = module:callbackOnMessageDefault(...)
			elseif id == CALLBACK_MODULE_RESET and module.callbackOnModuleReset ~= nil then
				tmpRet = module:callbackOnModuleReset(...)
			end
			if not tmpRet then
				ret = false
				break
			end
		end
		return ret
	end

	-- Returns the message represented by id
	function NpcHandler:getMessage(id)
		local ret = nil
		if self.messages ~= nil then
			ret = self.messages[id]
		end
		return ret
	end

	-- Changes the default response message with the specified id to newMessage
	function NpcHandler:setMessage(id, newMessage, delay)
		if self.messages ~= nil then
			self.messages[id] = newMessage
			if delay ~= nil and delay > 1 then
				self.talkDelay = delay
			end
		end
	end

	-- Translates all message tags found in msg using parseInfo
	function NpcHandler:parseMessage(msg, parseInfo)
		local ret = msg
		if type(ret) == 'string' then
			for search, replace in pairs(parseInfo) do
				ret = string.gsub(ret, search, replace)
			end
		else
			for i = 1, #ret do
				for search, replace in pairs(parseInfo) do
					ret[i] = string.gsub(ret[i], search, replace)
				end
			end
		end
		return ret
	end

	-- Undoes the action of talking to the player, thus resetting the direct interaction with the npc and the player
	function NpcHandler:unGreet(npc, player)
		if not self:checkInteraction(npc, player) then
			return false
		end

		local callback = self:getCallback(CALLBACK_FAREWELL)
		if callback == nil or callback(player) then
			if self:processModuleCallback(CALLBACK_FAREWELL) then
				local msg = self:getMessage(MESSAGE_FAREWELL)
				local playerName = player:getName() or -1
				local parseInfo = { [TAG_PLAYERNAME] = playerName }
				self:resetNpc(player)
				msg = self:parseMessage(msg, parseInfo)
				self:say(msg, npc, player)
				self:removeInteraction(npc, player)
			end
		end
	end

	-- Greets the player, thus initiating the direct interaction between the npc and the player
	function NpcHandler:greet(npc, player, message)
		if self:checkInteraction(npc, player) then
			return
		end

		local callback = self:getCallback(CALLBACK_GREET)
		if callback == nil or callback(npc, player, message) then
			if self:processModuleCallback(CALLBACK_GREET, npc, player) then
				local msg = self:getMessage(MESSAGE_GREET)
				local playerName = player:getName() or -1
				local parseInfo = { [TAG_PLAYERNAME] = playerName }
				msg = self:parseMessage(msg, parseInfo)
				self:say(msg, npc, player)
			end
		end
		self:setInteraction(npc, player)
	end

	-- Handles onAppear events. If you with to handle this yourself, please use the CALLBACK_ON_APPEAR callback.
	function NpcHandler:onAppear(npc, player)
		local callback = self:getCallback(CALLBACK_ON_APPEAR)
		if callback == nil or callback(npc, player) then
			if self:processModuleCallback(CALLBACK_ON_APPEAR, npc, player) then
				return callback
			end
		end
	end

	-- Handles onDisappear events. If you with to handle this yourself, please use the CALLBACK_ON_DISAPPEAR callback.
	function NpcHandler:onDisappear(npc, player)
		local callback = self:getCallback(CALLBACK_ON_DISAPPEAR)
		if callback == nil or callback(npc, player) then
			if self:processModuleCallback(CALLBACK_ON_DISAPPEAR, npc, player) then
				self:onWalkAway(npc, player)
			end
		end
	end

	-- Handles onSay events. If you with to handle this yourself, please use the CALLBACK_ON_SAY callback.
	function NpcHandler:onSay(npc, player, msgtype, msg)
		local playerId = player:getId()
		local callback = self:getCallback(CALLBACK_ON_SAY)
		if callback == nil or callback(npc, player, msgtype, msg) then
			if self:processModuleCallback(CALLBACK_ON_SAY, npc, player, msgtype, msg) then
				if not self:isInRange(npc, player) then
					return false
				end

				if self.keywordHandler ~= nil then
					if self:checkInteraction(npc, player)
					and msgtype == TALKTYPE_PRIVATE_PN
					or not self:checkInteraction(npc, player) then
						local ret = self.keywordHandler:processMessage(npc, player, msg)
						if not ret then
							callback = self:getCallback(CALLBACK_MESSAGE_DEFAULT)
							if callback ~= nil and callback(npc, player, msgtype, msg) then
								self:setTalkStart(playerId, os.time())
							end
						else
							self:setTalkStart(playerId, os.time())
						end
					end
				end
			end
		end
	end

	-- Handles onCloseChannel events. If you wish to handle this yourself, use the CALLBACK_CLOSE_CHANNEL callback.
	function NpcHandler:onCloseChannel(npc, player)
		local callback = self:getCallback(CALLBACK_CLOSE_CHANNEL)
		if callback == nil or callback(npc, player) then
			if self:processModuleCallback(CALLBACK_CLOSE_CHANNEL, player) then
				self:onWalkAway(npc, player)
			end
		end
	end

	-- Handles tradeRequest events. If you wish to handle this yourself, use the CALLBACK_ON_TRADE_REQUEST callback.
	function NpcHandler:tradeRequest(npc, player, message)
		local callback = self:getCallback(CALLBACK_ON_TRADE_REQUEST)
		if callback == nil or callback(npc, player, message) then
			if self:processModuleCallback(CALLBACK_ON_TRADE_REQUEST, npc, player) then
				local parseInfo = { [TAG_PLAYERNAME] = Player(player):getName() }
				local msg = self:parseMessage(self:getMessage(MESSAGE_SENDTRADE), parseInfo)

				-- If is npc shop, send shop window and parse default message (if not have callback on the npc)
				if npc:isMerchant() then
					npc:openShopWindow(player)
					self:say(msg, npc, player)
				end
				return true
			end
		end
	end

	-- Callback for requesting a trade window with the NPC.
	function NpcHandler:onTradeRequest(npc, player, message)
		if self:checkInteraction(npc, player) then
			self:tradeRequest(npc, player, message)
			return true
		end
	end

	-- Handles onThink events. If you wish to handle this yourself, please use the CALLBACK_ON_THINK callback.
	function NpcHandler:onThink(npc, interval)
		local callback = self:getCallback(CALLBACK_ON_THINK)
		if callback == nil or callback(npc, interval) then
			if self:processModuleCallback(CALLBACK_ON_THINK, npc, interval) then
				return true
			end
		end
	end

	-- Handles onMove events. If you wish to handle this yourself, please use the CALLBACK_ON_MOVE callback.
	function NpcHandler:onMove(npc, player, fromPosition, toPosition)
		local callback = self:getCallback(CALLBACK_ON_MOVE)
		if callback == nil or callback(npc, player, fromPosition, toPosition) then
			if self:processModuleCallback(CALLBACK_ON_MOVE, npc, player, fromPosition, toPosition) then
				if self:checkInteraction(npc, player) then
					if not self:isInRange(npc, player) then
						self:onWalkAway(npc, player)
					else
						self:updateInteraction(npc, player)
					end
				end
			end
		end
	end

	-- Tries to greet the player with the given player.
	function NpcHandler:onGreet(npc, player, message)
		if npc:isInTalkRange(Player(player):getPosition()) then
			if not self:checkInteraction(npc, player) then
				self:greet(npc, player, message)
				return true
			end
		end
	end

	-- Simply calls the underlying unGreet function.
	function NpcHandler:onFarewell(npc, player)
		if self:checkInteraction(npc, player) then
			self:unGreet(npc, player)
			return true
		end
	end

	-- Should be called on this npc's player if the distance to player is greater then talkRadius.
	function NpcHandler:onWalkAway(npc, player)
		if not self:checkInteraction(npc, player) then
			return false
		end

		local callback = self:getCallback(CALLBACK_ON_DISAPPEAR)
		if callback == nil or callback() then
			if self:processModuleCallback(CALLBACK_ON_DISAPPEAR, npc, player) then
				local msg = self:getMessage(MESSAGE_WALKAWAY)
				local playerName = player and player:getName() or -1
				local playerSex = player and player:getSex() or 0

				local parseInfo = { [TAG_PLAYERNAME] = playerName }
				local message = self:parseMessage(msg, parseInfo)

				local msg_male = self:getMessage(MESSAGE_WALKAWAY_MALE)
				local message_male = self:parseMessage(msg_male, parseInfo)
				local msg_female = self:getMessage(MESSAGE_WALKAWAY_FEMALE)
				local message_female = self:parseMessage(msg_female, parseInfo)
				if message_female ~= message_male then
					if playerSex == PLAYERSEX_FEMALE then
						npc:sayWithDelay(npc:getId(), message_female, TALKTYPE_SAY, self.talkDelay, self.eventDelayedSay)
					else
						npc:sayWithDelay(npc:getId(), message_male, TALKTYPE_SAY, self.talkDelay, self.eventDelayedSay)
					end
				elseif message ~= "" then
					npc:sayWithDelay(npc:getId(), message, TALKTYPE_SAY, self.talkDelay, self.eventDelayedSay)
				end
				self:resetNpc(player)
				self:removeInteraction(npc, player)
			end
		end
	end

	-- Returns true if player is within the talk range of the npc
	function NpcHandler:isInRange(npc, player)
		return npc:isInTalkRange(player:getPosition())
	end

	-- Resets the npc into its initial state (in regard of the keywordhandler).
	--	All modules are also receiving a reset call through their callbackOnModuleReset function.
	function NpcHandler:resetNpc(player)
		if self:processModuleCallback(CALLBACK_MODULE_RESET) then
			self.keywordHandler:reset(player)
		end
	end

	function NpcHandler:cancelNPCTalk(events)
		for aux = 1, #events do
			stopEvent(events[aux].event)
		end
		events = nil
	end

	function NpcHandler:doNPCTalkALot(msgs, delay, npc, player)
		local playerId = player:getId()
		if self:getEventDelayedSay(playerId) then
			self:cancelNPCTalk(self:getEventDelayedSay(playerId))
		end

		local playerUniqueId = player.uid
		if not playerUniqueId then
			return Spdlog.error("[NpcHandler:doNPCTalkALot] - playerUniqueId is wrong or unsafe.")
		end

		local npcUniqueId = npc.uid
		if not npcUniqueId then
			return Spdlog.error("[NpcHandler:doNPCTalkALot] - npcUniqueId is wrong or unsafe.")
		end

		self.eventDelayedSay[playerId] = {}
		local ret = {}
		for messagesTable, messageString in pairs(msgs) do
			self.eventDelayedSay[playerId][messagesTable] = {}
			if delay ~= nil and delay > 1 then
				self.talkDelay = delay
			end
			-- The "self.talkDelayTimeForOutgoingMessages * 1000" = Interval for sending subsequent messages from the first
			npc:sayWithDelay(npcUniqueId, msgs[messagesTable], TALKTYPE_PRIVATE_NP, ((messagesTable-1) * self.talkDelay + self.talkDelayTimeForOutgoingMessages * 1000),
                             self.eventDelayedSay[playerId][messagesTable], playerUniqueId)
			ret[#ret + 1] = self.eventDelayedSay[playerId][messagesTable]
		end
		return(ret)
	end

	-- Makes the npc represented by this instance of NpcHandler say something.
	-- This implements the currently set type of talkdelay.
	-- The "delay" variable sets the delay for the interval between messages
	function NpcHandler:say(message, npc, player, delay, textType)
		local playerId = player:getId()
		if type(message) == "table" then
			return self:doNPCTalkALot(message, delay, npc, player)
		end

		if self:getEventDelayedSay(playerId) then
			self:cancelNPCTalk(self:getEventDelayedSay(playerId))
		end

		stopEvent(self.eventSay[playerId])
		self.eventSay[playerId] = addEvent(SayEvent, self.talkDelayTimeForOutgoingMessages * 1000, npc:getId(), player:getId(), message, self, textType)
	end

	-- sendMessages(msg, messagesTable, npc, player, useDelay(true or false), delay)
	-- If not have useDelay = true and delay, then send npc:talk(), this function not have delay of one message to other
	function NpcHandler:sendMessages(message, messageTable, npc, player, useDelay, delay)
		for index, value in pairs(messageTable) do
			if MsgFind(message, index) then
				if useDelay and useDelay == true then
					self:say(value, npc, player, delay or 1000)
				else
					npc:talk(Player(player), value)
				end
				return true
			end
		end
	end
end
