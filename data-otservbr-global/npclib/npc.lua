-- Function called with by the function "Npc:sayWithDelay"
local sayFunction = function(npcId, text, type, eventDelay, playerId)
	local npc = Npc(npcId)
	if not npc then
		Spdlog.error("[local func = function(npcId, text, type, e, player)] - Npc not is valid")
		return false
	end

	npc:say(text, type, false, playerId, npc:getPosition())
	eventDelay.done = true
end

function MsgContains(message, keyword)
	local lowerMessage, lowerKeyword = message:lower(), keyword:lower()
	if lowerMessage == lowerKeyword then
		return true
	end

	return lowerMessage:find(lowerKeyword) and not lowerMessage:find('(%w+)' .. lowerKeyword)
end

function MsgFind(message, keyword)
	local lowerMessage, lowerKeyword = message:lower(), keyword:lower()
	if lowerMessage == lowerKeyword then
		return true
	end

	return string.find(lowerMessage, lowerKeyword)
		and string.find(lowerMessage, lowerKeyword.. '(%w+)')
		and string.find(lowerMessage, '(%w+)' .. lowerKeyword)
end

-- Npc talk
-- npc:talk({text, text2}) or npc:talk(text)
function Npc:talk(player, text)
	if type(text) == "table" then
		for i = 0, #text do
			self:sendMessage(player, text[i])
		end
	else
		self:sendMessage(player, text)
	end
end

-- Npc send message to player
-- npc:sendMessage(text)
function Npc:sendMessage(player, text)
	return self:say(string.format(text or "", player:getName()), TALKTYPE_PRIVATE_NP, true, player)
end

function Npc:sayWithDelay(npcId, text, messageType, delay, eventDelay, player)
	eventDelay.done = false
	eventDelay.event = addEvent(sayFunction, delay < 1 and 1000 or delay, npcId, text, messageType, eventDelay, player)
end

function SayEvent(npcId, playerId, messageDelayed, npcHandler, textType)
	local npc = Npc(npcId)
	if not npc then
		return Spdlog.error("[NpcHandler:say] - Npc parameter is missing, nil or not found")
	end

	local player = Player(playerId)
	if not player then
		return Spdlog.error("[NpcHandler:say] - Player parameter is missing, nil or not found")
	end

	local parseInfo = {
		[TAG_PLAYERNAME] = player:getName(),
		[TAG_TIME] = getFormattedWorldTime(),
		[TAG_BLESSCOST] = Blessings.getBlessingsCost(player:getLevel()),
		[TAG_PVPBLESSCOST] = Blessings.getPvpBlessingCost(player:getLevel())
	}
	npc:say(npcHandler:parseMessage(messageDelayed, parseInfo),
			textType or TALKTYPE_PRIVATE_NP, false, player, npc:getPosition())
end

function GetCount(string)
	local b, e = string:find("%d+")
	return b and e and tonumber(string:sub(b, e)) or -1
end
