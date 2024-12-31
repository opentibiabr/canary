-- Function called with by the function "Npc:sayWithDelay"
local sayFunction = function(npcId, text, type, eventDelay, playerId)
	local npc = Npc(npcId)
	if not npc then
		logger.error("[sayFunction] - Npc not is valid")
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

	return lowerMessage:find(lowerKeyword) and not lowerMessage:find("(%w+)" .. lowerKeyword)
end

function MsgFind(message, keyword)
	local lowerMessage, lowerKeyword = message:lower(), keyword:lower()
	if lowerMessage == lowerKeyword then
		return true
	end

	return string.find(lowerMessage, lowerKeyword) and string.find(lowerMessage, lowerKeyword .. "(%w+)") and string.find(lowerMessage, "(%w+)" .. lowerKeyword)
end

function GetFormattedShopCategoryNames(itemsTable)
	local formattedCategoryNames = {}
	for categoryName, _ in pairs(itemsTable) do
		table.insert(formattedCategoryNames, "{" .. categoryName .. "}")
	end

	if #formattedCategoryNames > 1 then
		local lastCategory = table.remove(formattedCategoryNames)
		return table.concat(formattedCategoryNames, ", ") .. " and " .. lastCategory
	else
		return formattedCategoryNames[1] or ""
	end
end

function Npc:getRemainingShopCategories(selectedCategory, itemsTable)
	local remainingCategories = {}
	for categoryName, _ in pairs(itemsTable) do
		if categoryName ~= selectedCategory then
			table.insert(remainingCategories, "{" .. categoryName .. "}")
		end
	end
	return table.concat(remainingCategories, " or ")
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
		return logger.error("[{} NpcHandler:say] - Npc parameter for npc '{}' is missing, nil or not found", npc:getName(), npc:getName())
	end

	local player = Player(playerId)
	if not player then
		return logger.error("[{} NpcHandler:say] - Player parameter for npc '{}' is missing, nil or not found", npc:getName(), npc:getName())
	end

	local parseInfo = {
		[TAG_PLAYERNAME] = player:getName(),
		[TAG_TIME] = getFormattedWorldTime(),
		[TAG_BLESSCOST] = Blessings.getBlessingCost(player:getLevel(), false, (npc:getName() == "Kais" or npc:getName() == "Nomad") and true),
		[TAG_PVPBLESSCOST] = Blessings.getPvpBlessingCost(player:getLevel(), false),
	}
	npc:say(npcHandler:parseMessage(messageDelayed, parseInfo), textType or TALKTYPE_PRIVATE_NP, false, player, npc:getPosition())
end

function GetCount(string)
	local b, e = string:find("%d+")
	return b and e and tonumber(string:sub(b, e)) or -1
end
