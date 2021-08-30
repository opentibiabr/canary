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
	MESSAGE_ALREADYFOCUSED = 21 -- When the player already has the focus of this npc.
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
		talkRadius = 3,
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

	-- Function used to change the focus of this npc.
	function NpcHandler:addFocus(npc, newFocus)
		if self:isFocused(newFocus) then
			return
		end

		self.focuses[#self.focuses + 1] = newFocus
		self.topic[newFocus] = 0
		local callback = self:getCallback(CALLBACK_ONADDFOCUS)
		if callback == nil or callback(newFocus) then
			self:processModuleCallback(CALLBACK_ONADDFOCUS, newFocus)
		end
		npc:turnToCreature(newFocus)
		self:updateFocus(npc, newFocus)
	end

	-- Function used to verify if npc is focused to certain player
	function NpcHandler:isFocused(focus)
		for _, v in pairs(self.focuses) do
			if v == focus then
				return true
			end
		end
		return false
	end

	-- This function should be called on each onThink and makes sure the npc faces the player it is talking to.
	--	Should also be called whenever a new player is focused.
	function NpcHandler:updateFocus(npc, creature)
		for _, focus in pairs(self.focuses) do
			if focus ~= nil then
				npc:setPlayerInteraction(focus)
				return
			end
			npc:removePlayerInteraction(focus)
		end
	end

	-- Used when the npc should un-focus the player.
	function NpcHandler:releaseFocus(npc, focus)
		if self.eventDelayedSay[focus] then
			self:cancelNPCTalk(self.eventDelayedSay[focus])
		end

		if not self:isFocused(focus) then
			return
		end

		local pos = nil
		for k, v in pairs(self.focuses) do
			if v == focus then
				pos = k
			end
		end

		self.focuses[pos] = nil

		self.eventSay[focus] = nil
		self.eventDelayedSay[focus] = nil
		self.talkStart[focus] = nil
		self.topic[focus] = nil

		local callback = self:getCallback(CALLBACK_ONRELEASEFOCUS)
		if callback == nil or callback(focus) then
			self:processModuleCallback(CALLBACK_ONRELEASEFOCUS, focus)
		end

		if Player(focus) ~= nil then
			npc:closeShopWindow(focus) --Even if it can not exist, we need to prevent it.
			npc:removePlayerInteraction(focus)
			self:updateFocus(npc, focus)
		end
	end

	-- Returns the callback function with the specified id or nil if no such callback function exists.
	function NpcHandler:getCallback(id)
		local ret = nil
		if self.callbackFunctions ~= nil then
			ret = self.callbackFunctions[id]
		end
		return ret
	end

	-- Changes the callback function for the given id to callback.
	function NpcHandler:setCallback(id, callback)
		if self.callbackFunctions ~= nil then
			self.callbackFunctions[id] = callback
		end
	end

	-- Adds a module to this npchandler and inits it.
	function NpcHandler:addModule(module)
		if self.modules ~= nil then
			self.modules[#self.modules + 1] = module
			module:init(self)
		end
	end

	-- Calls the callback function represented by id for all modules added to this npchandler with the given arguments.
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

	-- Returns the message represented by id.
	function NpcHandler:getMessage(id)
		local ret = nil
		if self.messages ~= nil then
			ret = self.messages[id]
		end
		return ret
	end

	-- Changes the default response message with the specified id to newMessage.
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

	-- Makes sure the npc un-focuses the currently focused player
	function NpcHandler:unGreet(npc, cid)
		if not self:isFocused(cid) then
			return
		end

		local callback = self:getCallback(CALLBACK_FAREWELL)
		if callback == nil or callback(cid) then
			if self:processModuleCallback(CALLBACK_FAREWELL) then
				local msg = self:getMessage(MESSAGE_FAREWELL)
				local player = Player(cid)
				local playerName = player and player:getName() or -1
				local parseInfo = { [TAG_PLAYERNAME] = playerName }
				self:resetNpc(cid)
				msg = self:parseMessage(msg, parseInfo)
				self:say(msg, npc, cid, true)
				self:releaseFocus(npc, cid)
			end
		end
	end

	-- Greets a new player.
	function NpcHandler:greet(npc, cid, message)
		if cid ~= 0 then
			local callback = self:getCallback(CALLBACK_GREET)
			if callback == nil or callback(npc, cid, message) then
				if self:processModuleCallback(CALLBACK_GREET, npc, cid) then
					local msg = self:getMessage(MESSAGE_GREET)
					local player = Player(cid)
					local playerName = player and player:getName() or -1
					local parseInfo = { [TAG_PLAYERNAME] = playerName }
					msg = self:parseMessage(msg, parseInfo)
					self:say(msg, npc, cid, true)
				else
					return false
				end
			else
				return false
			end
		end
		self:addFocus(npc, cid)
	end

	-- Handles onCreatureAppear events. If you with to handle this yourself, please use the CALLBACK_CREATURE_APPEAR callback.
	function NpcHandler:onCreatureAppear(npc, creature)
		local cid = creature.uid
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
		if callback == nil or callback(cid) then
			if self:processModuleCallback(CALLBACK_CREATURE_APPEAR, cid) then
				--
			end
		end
	end

	-- Handles onCreatureDisappear events. If you with to handle this yourself, please use the CALLBACK_CREATURE_DISAPPEAR callback.
	function NpcHandler:onCreatureDisappear(npc, creature)
		local cid = creature.uid
		if npc:getId() == cid then
			return
		end

		local callback = self:getCallback(CALLBACK_CREATURE_DISAPPEAR)
		if callback == nil or callback(cid) then
			if self:processModuleCallback(CALLBACK_CREATURE_DISAPPEAR, cid) then
				if self:isFocused(cid) then
					self:unGreet(cid)
				end
			end
		end
	end

	-- Handles onCreatureSay events. If you with to handle this yourself, please use the CALLBACK_CREATURE_SAY callback.
	function NpcHandler:onCreatureSay(npc, creature, msgtype, msg)
		local cid = creature.uid
		local player = Player(creature)
		local callback = self:getCallback(CALLBACK_CREATURE_SAY)
		if callback == nil or callback(npc, cid, msgtype, msg) then
			if self:processModuleCallback(CALLBACK_CREATURE_SAY, npc, cid, msgtype, msg) then
				if not npc:isInTalkRange(player:getPosition()) then
					return false
				end

				if self.keywordHandler ~= nil then
					if self:isFocused(cid) and msgtype == TALKTYPE_PRIVATE_PN or not self:isFocused(cid) then
						local ret = self.keywordHandler:processMessage(npc, cid, msg)
						if not ret then
							local callback = self:getCallback(CALLBACK_MESSAGE_DEFAULT)
							if callback ~= nil and callback(npc, cid, msgtype, msg) then
								self.talkStart[cid] = os.time()
							end
						else
							self.talkStart[cid] = os.time()
						end
					end
				end
			end
		end
	end

	-- Handles onPlayerCloseChannel events. If you wish to handle this yourself, use the CALLBACK_PLAYER_CLOSECHANNEL callback.
	function NpcHandler:onPlayerCloseChannel(creature)
		local cid = creature.uid
		local callback = self:getCallback(CALLBACK_PLAYER_CLOSECHANNEL)
		if callback == nil or callback(cid) then
			if self:processModuleCallback(CALLBACK_PLAYER_CLOSECHANNEL, cid, msgtype, msg) then
				if self:isFocused(cid) then
					self:unGreet(cid)
				end
			end
		end
	end

	-- Handles onTradeRequest events. If you wish to handle this yourself, use the CALLBACK_ONTRADEREQUEST callback.
	function NpcHandler:onTradeRequest(npc, cid)
		local callback = self:getCallback(CALLBACK_ONTRADEREQUEST)
		if callback == nil or callback(cid) then
			if self:processModuleCallback(CALLBACK_ONTRADEREQUEST, npc, cid) then
				return true
			end
		end
		return false
	end

	-- Handles onThink events. If you wish to handle this yourself, please use the CALLBACK_ONTHINK callback.
	function NpcHandler:onThink(npc, interval)
		local callback = self:getCallback(CALLBACK_ONTHINK)
		if callback == nil or callback() then
			if self:processModuleCallback(CALLBACK_ONTHINK) then
				for _, focus in pairs(self.focuses) do
					if focus ~= nil then
						if not npc:isInTalkRange(Player(focus):getPosition()) then
							self:onWalkAway(npc, focus)
						elseif self.talkStart[focus] ~= nil and (os.time() - self.talkStart[focus]) > self.idleTime then
							self:unGreet(focus)
						else
							self:updateFocus(npc, focus)
						end
					end
				end
			end
		end
	end

	-- Tries to greet the player with the given cid.
	function NpcHandler:onGreet(npc, cid, message)
		if not self:isFocused(cid) then
			self:greet(npc, cid, message)
			return
		end
	end

	-- Simply calls the underlying unGreet function.
	function NpcHandler:onFarewell(npc, cid)
		self:unGreet(npc, cid)
	end

	-- Should be called on this npc's focus if the distance to focus is greater then talkRadius.
	function NpcHandler:onWalkAway(npc, cid)
		if self:isFocused(cid) then
			local callback = self:getCallback(CALLBACK_CREATURE_DISAPPEAR)
			if callback == nil or callback() then
				if self:processModuleCallback(CALLBACK_CREATURE_DISAPPEAR, cid) then
					local msg = self:getMessage(MESSAGE_WALKAWAY)
					local player = Player(cid)
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
							self:say(message_female, npc, cid)
						else
							self:say(message_male, npc, cid)
						end
					elseif message ~= "" then
						self:say(message, npc, cid)
					end
					self:resetNpc(cid)
					self:releaseFocus(npc, cid)
				end
			end
		end
	end

	-- Resets the npc into its initial state (in regard of the keywordhandler).
	--	All modules are also receiving a reset call through their callbackOnModuleReset function.
	function NpcHandler:resetNpc(cid)
		if self:processModuleCallback(CALLBACK_MODULE_RESET) then
			self.keywordHandler:reset(cid)
		end
	end

	function NpcHandler:cancelNPCTalk(events)
		for aux = 1, #events do
			stopEvent(events[aux].event)
		end
		events = nil
	end

	function NpcHandler:doNPCTalkALot(msgs, delay, npc, pcid)
		if self.eventDelayedSay[pcid] then
			self:cancelNPCTalk(self.eventDelayedSay[pcid])
		end

		self.eventDelayedSay[pcid] = {}
		local ret = {}
		for aux = 1, #msgs do
			self.eventDelayedSay[pcid][aux] = {}
			npc:sayWithDelay(npc:getId(), msgs[aux], TALKTYPE_PRIVATE_NP, ((aux-1) * (delay or 4000)), self.eventDelayedSay[pcid][aux], pcid)
			ret[#ret + 1] = self.eventDelayedSay[pcid][aux]
		end
		return(ret)
	end

	-- Makes the npc represented by this instance of NpcHandler say something.
	--	This implements the currently set type of talkdelay.
	function NpcHandler:say(message, npc, focus, useDelay, delay)
		if type(message) == "table" then
			return self:doNPCTalkALot(message, delay, npc, focus)
		end

		if self.eventDelayedSay[focus] then
			self:cancelNPCTalk(self.eventDelayedSay[focus])
		end

		stopEvent(self.eventSay[focus])
		self.eventSay[focus] = addEvent(function(npcId, message, focusId)
			if not Npc(npc) then
				return Spdlog.error("[NpcHandler:say] - Npc parameter is missing or wrong")
			end

			if not Player(focus) then
				return Spdlog.error("[NpcHandler:say] - Player parameter is missing or wrong")
			end
			
			npcId = npc:getId()
			if npcId == nil then
				Spdlog.error("[NpcHandler:say] - Npc not found or is nil")
				return
			end
	
			focusId = Player(focus):getId()
			if npcId == nil then
				Spdlog.error("[NpcHandler:say] - Player id not found or is nil")
				return
			end

			local player = Player(focusId)
			if player then
				local parseInfo = {[TAG_PLAYERNAME] = player:getName(), [TAG_TIME] = getFormattedWorldTime(), [TAG_BLESSCOST] = Blessings.getBlessingsCost(player:getLevel()), [TAG_PVPBLESSCOST] = Blessings.getPvpBlessingCost(player:getLevel())}
				npc:say(self:parseMessage(message, parseInfo), TALKTYPE_PRIVATE_NP, false, player, npc:getPosition())
			end
		end, self.talkDelayTime * 1000, npc:getId(), message, focusId)
	end

	-- sendMessages(msg, messagesTable, npc, creature, useDelay(true or false), delay)
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
