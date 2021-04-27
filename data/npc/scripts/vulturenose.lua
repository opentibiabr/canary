local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)
	npcHandler:onCreatureAppear(cid)
end
function onCreatureDisappear(cid)
	npcHandler:onCreatureDisappear(cid)
end
function onCreatureSay(cid, type, msg)
	npcHandler:onCreatureSay(cid, type, msg)
end
function onThink()
	npcHandler:onThink()
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if msgcontains(msg, 'enter') then
		if player:getStorageValue(Storage.TheShatteredIsles.RaysMission3) == 1
		and player:getStorageValue(Storage.TheShatteredIsles.YavernDoor) < 0 then
			local headItem = player:getSlotItem(CONST_SLOT_HEAD)
			local armorItem = player:getSlotItem(CONST_SLOT_ARMOR)
			local legsItem = player:getSlotItem(CONST_SLOT_LEGS)
			local feetItem = player:getSlotItem(CONST_SLOT_FEET)
			if headItem and headItem.itemid == 6096 and armorItem and armorItem.itemid == 6095
			and legsItem and legsItem.itemid == 5918 and feetItem and feetItem.itemid == 5462 then
				npcHandler:say('Hey, I rarely see a dashing pirate like you! Get in, matey!', cid)
				player:setStorageValue(Storage.TheShatteredIsles.YavernDoor, 1)
			else
				npcHandler:say("YOU WILL NOT PASS! Erm ... \
				I mean you don't look like a true pirate to me. You won't get in.", cid)
			end
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
