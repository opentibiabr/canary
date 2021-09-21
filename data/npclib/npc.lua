isPlayerPremiumCallback = Player.isPremium

-- Function called with by the function "Npc:sayWithDelay"
local sayFunction = function(npc, text, type, e, player)
	local npc = Npc(npc)
	if not npc then
		Spdlog.error("[local func = function(npc, text, type, e, player)] - Npc not is valid")
		return
	end

	npc:say(text, type, false, player, npc:getPosition())
	e.done = true
end

function msgcontains(message, keyword)
	local lowerMessage, lowerKeyword = message:lower(), keyword:lower()
	if lowerMessage == lowerKeyword then
		return true
	end

	return string.find(lowerMessage, lowerKeyword) and string.find(lowerMessage, lowerKeyword.. '(%w+)') and string.find(lowerMessage, '(%w+)' .. lowerKeyword)
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

function Npc:sayWithDelay(npc, text, messageType, delay, e, player)
	e.done = false
	e.event = addEvent(sayFunction, delay < 1 and 1000 or delay, npc, text, messageType, e, player)
end

function getCount(string)
	local b, e = string:find("%d+")
	return b and e and tonumber(string:sub(b, e)) or -1
end
