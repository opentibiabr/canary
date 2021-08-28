-- Including the Advanced NPC System
dofile('data/npcxml/lib/npcsystem/npcsystem.lua')
dofile('data/npcxml/lib/npcsystem/customModules.lua')

isPlayerPremiumCallback = Player.isPremium

-- Function called with by the function "NpcOld:sayWithDelay"
local sayFunction = function(cid, text, type, e, pcid)
	local npc = NpcOld(cid)
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
	local message, keyword = message:lower(), keyword:lower()
	if message == keyword then
		return true
	end

	return message:find(keyword) and not message:find('(%w+)' .. keyword)
end

function NpcOld:sellItem(cid, itemId, amount, subType, ignoreCap, inBackpacks, backpack)
	local amount = amount or 1
	local subType = subType or 0
	local item = 0
	local player = Player(cid)

	if ItemType(itemId):isStackable() then
		local stuff
		if inBackpacks then
			stuff = Game.createItem(backpack, 1)
			item = stuff:addItem(itemId, math.min(100, amount))
		else
			stuff = Game.createItem(itemId, math.min(100, amount))
		end

		return player:addItemEx(stuff, ignoreCap) ~= RETURNVALUE_NOERROR and 0 or amount, 0
	end

	local a = 0
	if inBackpacks then
		local container, b = Game.createItem(backpack, 1), 1
		for i = 1, amount do
			local item = container:addItem(itemId, subType)
			if table.contains({(ItemType(backpack):getCapacity() * b), amount}, i) then
				if player:addItemEx(container, ignoreCap) ~= RETURNVALUE_NOERROR then
					b = b - 1
					break
				end

				a = i
				if amount > i then
					container = Game.createItem(backpack, 1)
					b = b + 1
				end
			end
		end
		return a, b
	end

	-- Normal method for non-stackable items
	for i = 1, amount do
		local item = Game.createItem(itemId, subType)
		if player:addItemEx(item, ignoreCap) ~= RETURNVALUE_NOERROR then
			break
		end
		a = i
	end
	return a, 0
end

function NpcOld:sayWithDelay(cid, text, messageType, delay, e, pcid)
	if Player(pcid):isPlayer() then
		e.done = false
		e.event = addEvent(sayFunction, delay < 1 and 1000 or delay, cid, text, messageType, e, pcid)
	end
end

function getCount(string)
	local b, e = string:find("%d+")
	return b and e and tonumber(string:sub(b, e)) or -1
end
