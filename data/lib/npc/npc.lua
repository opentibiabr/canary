-- add npc interaction lib
dofile('data/lib/npc/npc_utils.lua')
dofile('data/lib/npc/npc_interaction/load.lua')

-- Checks whether a message is being sent to npc
-- msgContains(message, keyword)
function msgContains(message, keyword)
	local message, keyword = message:lower(), keyword:lower()
	if message == keyword then
		return true
	end

	return message:find(keyword) and not message:find('(%w+)' .. keyword)
end

function Npc:decoratedTalkToCreature(creature, text)
    if type(text) == "table" then
        for i = 0, #text do
            self:sendMessage(creature, text[i])
        end
    else
        self:sendMessage(creature, text)
    end
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

function Npc:processOnSay(message, player, npcInteractions)
    if not player then
        return false
    end

    if not self:isInTalkRange(player:getPosition()) then
        return false
    end

    for _, npcInteraction in pairs(npcInteractions) do
        if npcInteraction:execute(message, player, self) then return true end
    end

    return false
end

function Npc:doSellItem(cid, itemId, amount, subType, ignoreCap, inBackpacks, backpack)
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

    for i = 1, amount do -- normal method for non-stackable items
        local item = Game.createItem(itemId, subType)
        if player:addItemEx(item, ignoreCap) ~= RETURNVALUE_NOERROR then
            break
        end
        a = i
    end
    return a, 0
end