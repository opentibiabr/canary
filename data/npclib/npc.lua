-- Including the Advanced NPC System
dofile('data/npclib/npc_system/npc_system.lua')
dofile('data/npclib/npc_system/custom_modules.lua')

isPlayerPremiumCallback = Player.isPremium

-- Function called with by the function "Npc:sayWithDelay"
local sayFunction = function(npc, text, type, e, pcid)
	local npc = Npc(npc)
	if not npc then
		Spdlog.error("[local func = function(cid, text, type, e, pcid)] - Creature not is valid")
		return
	end

	local player = Player(pcid)
	if player:isPlayer() then
		npc:say(text, type, false, pcid, npc:getPosition())
		e.done = true
	end
end

function msgcontains(message, keyword)
	local lowerMessage, lowerKeyword = message:lower(), keyword:lower()
	if lowerMessage == lowerKeyword then
		return true
	end

	return lowerMessage:find(lowerKeyword) and not lowerMessage:find('(%w+)' .. lowerKeyword)
end

function Npc:sellItem(cid, itemId, amount, subType, ignoreCap, inBackpacks, backpack)
	local localAmount = amount or 1
	local localSubType = subType or 0
	local item = 0
	local player = Player(cid)

	if ItemType(itemId):isStackable() then
		local stuff
		if inBackpacks then
			stuff = Game.createItem(backpack, 1)
			item = stuff:addItem(itemId, math.min(100, localAmount))
		else
			stuff = Game.createItem(itemId, math.min(100, localAmount))
		end

		return player:addItemEx(stuff, ignoreCap) ~= RETURNVALUE_NOERROR and 0 or localAmount, 0
	end

	local a = 0
	if inBackpacks then
		local container, b = Game.createItem(backpack, 1), 1
		for i = 1, localAmount do
			if table.contains({(ItemType(backpack):getCapacity() * b), localAmount}, i) then
				if player:addItemEx(container, ignoreCap) ~= RETURNVALUE_NOERROR then
					b = b - 1
					break
				end

				a = i
				if localAmount > i then
					container = Game.createItem(backpack, 1)
					b = b + 1
				end
			end
		end
		return a, b
	end

	-- Normal method for non-stackable items
	for i = 1, localAmount do
		local createItem = Game.createItem(itemId, localSubType)
		if player:addItemEx(createItem, ignoreCap) ~= RETURNVALUE_NOERROR then
			break
		end
		a = i
	end
	return a, 0
end

-- Npc talk
-- npc:talk({text, text2}) or npc:talk(text)
function Npc:talk(creature, text)
	if type(text) == "table" then
		for i = 0, #text do
			self:sendMessage(creature, text[i])
		end
	else
		self:sendMessage(creature, text)
	end
end

-- Npc send message to player
-- npc:sendMessage(text)
function Npc:sendMessage(creature, text)
	return self:say(string.format(text or "", creature:getName()), TALKTYPE_PRIVATE_NP, true, creature)
end

function Npc:sayWithDelay(npc, text, messageType, delay, e, pcid)
	if Player(pcid):isPlayer() then
		e.done = false
		e.event = addEvent(sayFunction, delay < 1 and 1000 or delay, npc, text, messageType, e, pcid)
	end
end

function getCount(string)
	local b, e = string:find("%d+")
	return b and e and tonumber(string:sub(b, e)) or -1
end
