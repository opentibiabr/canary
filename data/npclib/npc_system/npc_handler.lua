-- Advanced NPC System by Jiddo

if NpcHandler == nil then
	local duration = 1
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
	MESSAGE_IDLETIMEOUT = 15 -- When the player has been idle for longer then idleTime allows.
	MESSAGE_WALKAWAY = 16 -- When the player walks out of the talkRadius of the npc.
	MESSAGE_DECLINE	 = 17 -- When the player says no to something.
	MESSAGE_SENDTRADE = 18 -- When the npc sends the trade window to the player
	MESSAGE_NOSHOP = 19 -- When the npc's shop is requested but he doesn't have any
	MESSAGE_ONCLOSESHOP = 20 -- When the player closes the npc's shop window
	MESSAGE_ALREADYFOCUSED = 21 -- When the player already interacting with this npc.
	MESSAGE_WALKAWAY_MALE = 22 -- When a male player walks out of the talkRadius of the npc.
	MESSAGE_WALKAWAY_FEMALE = 23 -- When a female player walks out of the talkRadius of the npc.

	-- Constant indexes for callback functions. These are also used for module callback ids.
	CALLBACK_CREATURE_APPEAR = 1
	CALLBACK_CREATURE_DISAPPEAR = 2
	CALLBACK_CREATURE_SAY = 3
	CALLBACK_ONTHINK = 4
	CALLBACK_GREET = 5
	CALLBACK_FAREWELL = 6
	CALLBACK_MESSAGE_DEFAULT = 7
	CALLBACK_PLAYER_ENDTRADE = 8
	CALLBACK_PLAYER_CLOSECHANNEL = 9
	CALLBACK_ONMOVE = 10
	CALLBACK_ONADDFOCUS = 18
	CALLBACK_ONRELEASEFOCUS = 19
	CALLBACK_ONTRADEREQUEST = 20

	-- Addidional module callback ids
	CALLBACK_MODULE_INIT	 = 12
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
		focuses = nil,
		talkStart = nil,
		idleTime = 120,
		talkDelayTime = 1, -- Seconds to delay outgoing messages.
		talkDelay = nil,
		callbackFunctions = nil,
		modules = nil,
		eventSay = nil,
		eventDelayedSay = nil,
		topic = nil,
		messages = {
			-- These are the default replies of all npcs. They can/should be changed individually for each npc.
			-- Leave empty for no send message
			[MESSAGE_GREET] = "Greetings, |PLAYERNAME|.",
			[MESSAGE_FAREWELL] = "Good bye, |PLAYERNAME|.",
			[MESSAGE_BUY] = "Do you want to buy |ITEMCOUNT| |ITEMNAME| for |TOTALCOST| gold coins?",
			--[EMPTY] = "EMPTY",
			--[EMPTY] = "EMPTY",
			--[EMPTY] = "EMPTY",
			--[EMPTY] = "EMPTY",
			[MESSAGE_MISSINGMONEY] = "You don't have enough money.",
			[MESSAGE_NEEDMONEY] = "You don't have enough money.",
			[MESSAGE_MISSINGITEM] = "You don't have so many.",
			[MESSAGE_NEEDITEM] = "You do not have this object.",
			[MESSAGE_NEEDSPACE] = "There is not enought room.",
			[MESSAGE_NEEDMORESPACE] = "You do not have enough capacity for all items.",
			[MESSAGE_IDLETIMEOUT] = "Good bye.",
			[MESSAGE_WALKAWAY] = "",
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
		obj.eventSay = {}
		obj.eventDelayedSay = {}
		obj.topic = {}
		obj.focuses = {}
		obj.talkStart = {}
		obj.talkDelay = {}
		obj.keywordHandler = keywordHandler
		obj.messages = {}

		setmetatable(obj.messages, self.messages)
		self.messages.__index = self.messages

		setmetatable(obj, self)
		self.__index = self
		return obj
	end

	-- Re-defines the maximum idle time allowed for a player when talking to this npc.
	function NpcHandler:setMaxIdleTime(newTime)
		self.idleTime = newTime
	end

	-- Attackes a new keyword handler to this npchandler
	function NpcHandler:setKeywordHandler(newHandler)
		self.keywordHandler = newHandler
	end

	-- It will check the player's interaction, return the topic the player is on and also check if the npc is interacting with the player
	function NpcHandler:checkInteraction(npc, player)
		if self.topic then
			npc:isPlayerInteractingOnTopic(player, self.topic)
		end

		return npc:isInteractingWithPlayer(player)
	end

	-- If the player is not interacting with the npc, it set the npc's interaction with the player
	function NpcHandler:updateInteraction(npc, player)
		if not self:checkInteraction(npc, player) then
			npc:setPlayerInteraction(player, 0)
			return true
		end
		return npc:turnToCreature(player)
	end

	-- This function is used to set an interaction between the npc and the player
	-- The "self.focuses" is used to store the player the npc is interacting with, to be used as a callback in the "NpcHandler:onThink", for allowing the player used within the function
	function NpcHandler:setInteraction(npc, player)
		if self:checkInteraction(npc, player) then
			return false
		end

		self.focuses[#self.focuses + 1] = player
		self.topic[player] = 0
		local callback = self:getCallback(CALLBACK_ONADDFOCUS)
		if callback == nil or callback(player) then
			self:processModuleCallback(CALLBACK_ONADDFOCUS, player)
		end
		self:updateInteraction(npc, player)
		return true
	end

	-- This function removes the npc interaction with the player
	function NpcHandler:removeInteraction(npc, player)
		if self.eventDelayedSay[player] then
			self:cancelNPCTalk(self.eventDelayedSay[player])
		end

		if Player(player) == nil then
			return Spdlog.error("[NpcHandler:removeInteraction] - Player is missing or nil")
		end

		self.focuses[player] = nil
		self.eventSay[player] = nil
		self.eventDelayedSay[player] = nil
		self.talkStart[player] = nil
		self.topic[player] = nil

		local callback = self:getCallback(CALLBACK_ONRELEASEFOCUS)
		if callback == nil or callback(player) then
			self:processModuleCallback(CALLBACK_ONRELEASEFOCUS, player)
		end

		npc:closeShopWindow(player) --Even if it can not exist, we need to prevent it.
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

	-- Adds a module to this npchandler and inits it
	function NpcHandler:addModule(module)
		if self.modules ~= nil then
			self.modules[#self.modules + 1] = module
			module:init(self)
		end
	end

	-- Calls the callback function represented by id for all modules added to this npchandler with the given arguments
	function NpcHandler:processModuleCallback(id, ...)
		local ret = true
		for _, module in pairs(self.modules) do
			local tmpRet = true
			if id == CALLBACK_CREATURE_APPEAR and module.callbackOnCreatureAppear ~= nil then
				tmpRet = module:callbackOnCreatureAppear(...)
			elseif id == CALLBACK_CREATURE_DISAPPEAR and module.callbackOnCreatureDisappear ~= nil then
				tmpRet = module:callbackOnCreatureDisappear(...)
			elseif id == CALLBACK_CREATURE_SAY and module.callbackOnCreatureSay ~= nil then
				tmpRet = module:callbackOnCreatureSay(...)
			elseif id == CALLBACK_PLAYER_ENDTRADE and module.callbackOnPlayerEndTrade ~= nil then
				tmpRet = module:callbackOnPlayerEndTrade(...)
			elseif id == CALLBACK_PLAYER_CLOSECHANNEL and module.callbackOnPlayerCloseChannel ~= nil then
				tmpRet = module:callbackOnPlayerCloseChannel(...)
			elseif id == CALLBACK_ONTRADEREQUEST and module.callbackOnTradeRequest ~= nil then
				tmpRet = module:callbackOnTradeRequest(...)
			elseif id == CALLBACK_ONADDFOCUS and module.callbackOnAddFocus ~= nil then
				tmpRet = module:callbackOnAddFocus(...)
			elseif id == CALLBACK_ONRELEASEFOCUS and module.callbackOnReleaseFocus ~= nil then
				tmpRet = module:callbackOnReleaseFocus(...)
			elseif id == CALLBACK_ONTHINK and module.callbackOnThink ~= nil then
				tmpRet = module:callbackOnThink(...)
			elseif id == CALLBACK_ONMOVE and module.callbackOnMove ~= nil then
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
	function NpcHandler:setMessage(id, newMessage)
		if self.messages ~= nil then
			self.messages[id] = newMessage
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
				self:say(msg, npc, player, true)
				self:removeInteraction(npc, player)
			end
		end
	end

	-- Greets the player, thus initiating the direct interaction between the npc and the player
	function NpcHandler:greet(npc, player, message)
		if player ~= 0 then
			local callback = self:getCallback(CALLBACK_GREET)
			if callback == nil or callback(npc, player, message) then
				if self:processModuleCallback(CALLBACK_GREET, npc, player) then
					local msg = self:getMessage(MESSAGE_GREET)
					local playerName = player:getName() or -1
					local parseInfo = { [TAG_PLAYERNAME] = playerName }
					msg = self:parseMessage(msg, parseInfo)
					self:say(msg, npc, player, true)
				else
					return false
				end
			else
				return false
			end
		end
		self:setInteraction(npc, player)
	end

	-- Handles onCreatureAppear events. If you with to handle this yourself, please use the CALLBACK_CREATURE_APPEAR callback.
	function NpcHandler:onCreatureAppear(npc, player)
		if npc then
			local speechBubble = npc:getSpeechBubble()
			if speechBubble == 3 then
				npc:setSpeechBubble(4)
			else
				npc:setSpeechBubble(2)
			end
		else
			if self:getMessage(MESSAGE_GREET) and npc:getSpeechBubble() < 1 then
				npc:setSpeechBubble(1)
			end
		end

		local callback = self:getCallback(CALLBACK_CREATURE_APPEAR)
		if callback == nil or callback(player) then
			if self:processModuleCallback(CALLBACK_CREATURE_APPEAR, player) then
				--
			end
		end
	end

	-- Handles onCreatureDisappear events. If you with to handle this yourself, please use the CALLBACK_CREATURE_DISAPPEAR callback.
	function NpcHandler:onCreatureDisappear(npc, player)
		if npc:getId() == player then
			return
		end

		local callback = self:getCallback(CALLBACK_CREATURE_DISAPPEAR)
		if callback == nil or callback(npc, player) then
			if self:processModuleCallback(CALLBACK_CREATURE_DISAPPEAR, npc, player) then
				self:unGreet(npc, player)
			end
		end
	end

	-- Handles onCreatureSay events. If you with to handle this yourself, please use the CALLBACK_CREATURE_SAY callback.
	function NpcHandler:onCreatureSay(npc, player, msgtype, msg)
		local callback = self:getCallback(CALLBACK_CREATURE_SAY)
		if callback == nil or callback(npc, player, msgtype, msg) then
			if self:processModuleCallback(CALLBACK_CREATURE_SAY, npc, player, msgtype, msg) then
				if not self:isInRange(npc, player) then
					return
				end

				if self.keywordHandler ~= nil then
					if self:checkInteraction(npc, player) and msgtype == TALKTYPE_PRIVATE_PN or not self:checkInteraction(npc, player) then
						local ret = self.keywordHandler:processMessage(npc, player, msg)
						if not ret then
							local callback = self:getCallback(CALLBACK_MESSAGE_DEFAULT)
							if callback ~= nil and callback(npc, player, msgtype, msg) then
								self.talkStart[player] = os.time()
							end
						else
							self.talkStart[player] = os.time()
						end
					end
				end
			end
		end
	end

	-- Handles onPlayerCloseChannel events. If you wish to handle this yourself, use the CALLBACK_PLAYER_CLOSECHANNEL callback.
	function NpcHandler:onPlayerCloseChannel(npc, player)
		local callback = self:getCallback(CALLBACK_PLAYER_CLOSECHANNEL)
		if callback == nil or callback(npc, player) then
			if self:processModuleCallback(CALLBACK_PLAYER_CLOSECHANNEL, player, msgtype, msg) then
				self:unGreet(npc, player)
			end
		end
	end

	-- Handles tradeRequest events. If you wish to handle this yourself, use the CALLBACK_ONTRADEREQUEST callback.
	function NpcHandler:tradeRequest(npc, player, message)
		local callback = self:getCallback(CALLBACK_ONTRADEREQUEST)
		if callback == nil or callback(npc, player, message) then
			if self:processModuleCallback(CALLBACK_ONTRADEREQUEST, npc, player) then				
				local parseInfo = { [TAG_PLAYERNAME] = Player(player):getName() }
				local msg = self:parseMessage(self:getMessage(MESSAGE_SENDTRADE), parseInfo)

				-- If is npc shop, send shop window and parse default message (if not have callback on the npc)
				if npc:isMerchant() then
					npc:openShopWindow(player)
					self:say(msg, npc, player)
				end
				return true
			else
				return false
			end
		else
			return false
		end
		return false
	end

	-- Callback for requesting a trade window with the NPC.
	function NpcHandler:onTradeRequest(npc, player, message)
		if self:checkInteraction(npc, player) then
			self:tradeRequest(npc, player, message)
		end
		return true
	end

	-- Handles onThink events. If you wish to handle this yourself, please use the CALLBACK_ONTHINK callback.
	function NpcHandler:onThink(npc, interval)
		local callback = self:getCallback(CALLBACK_ONTHINK)
		if callback == nil or callback() then
			if self:processModuleCallback(CALLBACK_ONTHINK) then
				for _, player in pairs(self.focuses) do
					if player ~= nil then
						if self.talkStart[player] ~= nil and (os.time() - self.talkStart[player]) > self.idleTime then
							self:unGreet(npc, player)
						end
					end
				end
			end
		end
	end

	-- Handles onMove events. If you wish to handle this yourself, please use the CALLBACK_ONMOVE callback.
	function NpcHandler:onMove(npc, player, fromPosition, toPosition)
		local callback = self:getCallback(CALLBACK_ONMOVE)
		if callback == nil or callback() then
			if self:processModuleCallback(CALLBACK_ONMOVE) then
				if npc:isInteractingWithPlayer(player) then
					if not self:isInRange(npc, player) then
						self:onWalkAway(npc, player)
					else
						npc:turnToCreature(player)
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
		self:unGreet(npc, player)
	end

	-- Should be called on this npc's player if the distance to player is greater then talkRadius.
	function NpcHandler:onWalkAway(npc, player)
		local callback = self:getCallback(CALLBACK_CREATURE_DISAPPEAR)
		if callback == nil or callback() then
			if self:processModuleCallback(CALLBACK_CREATURE_DISAPPEAR, npc, player) then
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
						self:say(message_female, npc, player)
					else
						self:say(message_male, npc, player)
					end
				elseif message ~= "" then
					self:say(message, npc, player)
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
		if self.eventDelayedSay[player] then
			self:cancelNPCTalk(self.eventDelayedSay[player])
		end

		local playerId = player.uid
		if not playerId then
			return Spdlog.error("[NpcHandler:doNPCTalkALot] - Player is unsafe.")
		end

		self.eventDelayedSay[player] = {}
		local ret = {}
		for aux = 1, #msgs do
			self.eventDelayedSay[player][aux] = {}
			npc:sayWithDelay(npc:getId(), msgs[aux], TALKTYPE_PRIVATE_NP, ((aux-1) * (delay or 4000)), self.eventDelayedSay[player][aux], playerId)
			ret[#ret + 1] = self.eventDelayedSay[player][aux]
		end
		return(ret)
	end

	-- Makes the npc represented by this instance of NpcHandler say something.
	--	This implements the currently set type of talkdelay.
	function NpcHandler:say(message, npc, player, delay)
		if type(message) == "table" then
			return self:doNPCTalkALot(message, delay, npc, player)
		end

		if self.eventDelayedSay[player] then
			self:cancelNPCTalk(self.eventDelayedSay[player])
		end

		stopEvent(self.eventSay[player])
		self.eventSay[player] = addEvent(function(npcId, message, focusId)
			if not Npc(npc) then
				return Spdlog.error("[NpcHandler:say] - Npc parameter is missing or wrong")
			end
			
			npcId = npc:getId()
			if npcId == nil then
				Spdlog.error("[NpcHandler:say] - Npc not found or is nil")
				return
			end
	
			focusId = Player(player):getId()
			if npcId == nil then
				Spdlog.error("[NpcHandler:say] - Player id not found or is nil")
				return
			end

			local player = Player(focusId)
			if player then
				local parseInfo = {[TAG_PLAYERNAME] = player:getName(), [TAG_TIME] = getFormattedWorldTime(), [TAG_BLESSCOST] = Blessings.getBlessingsCost(player:getLevel()), [TAG_PVPBLESSCOST] = Blessings.getPvpBlessingCost(player:getLevel())}
				npc:say(self:parseMessage(message, parseInfo), TALKTYPE_PRIVATE_NP, false, player, npc:getPosition())
			end
		end, self.talkDelayTime * 1000, npcId, message, focusId)
	end

	-- sendMessages(msg, messagesTable, npc, player, useDelay(true or false), delay)
	-- If not have useDelay = true and delay, then send npc:talk(), this function not have delay of one message to other
	function NpcHandler:sendMessages(message, messageTable, npc, player, useDelay, delay)
		for index, value in pairs(messageTable) do
			if msgcontains(message, index) then
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
