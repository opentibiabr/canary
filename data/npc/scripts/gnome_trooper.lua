local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local response = {
	[0] = "It's a pipe! What can be more relaxing for a gnome than to smoke his pipe after a day of duty at the front. At least it's a chance to do something really dangerous after all!",
	[1] = "Ah, a letter from home! Oh - I had no idea she felt that way! This is most interesting!",
	[2] = "It's a model of the gnomebase Alpha! For self-assembly! With toothpicks...! Yeeaah...! I guess.",
	[3] = "A medal of honour! At last they saw my true worth!"
}

if not DELIVERED_PARCELS then
	DELIVERED_PARCELS = {}
end

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

function greetCallback(cid)
	local player = Player(cid)
	if isInArray({-1, 4}, player:getStorageValue(SPIKE_LOWER_PARCEL_MAIN)) then
		return false
	end
	if isInArray(DELIVERED_PARCELS[player:getGuid()], Creature(getNpcCid()):getId()) then
		return false
	end
	return true
end

function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	local status = player:getStorageValue(SPIKE_LOWER_PARCEL_MAIN)

	if not DELIVERED_PARCELS[player:getGuid()] then
		DELIVERED_PARCELS[player:getGuid()] = {}
	end

	if msgcontains(msg, 'something') and not isInArray({-1, 4}, status) then
		if isInArray(DELIVERED_PARCELS[player:getGuid()], Creature(getNpcCid()):getId()) then
			return true
		end

		if not player:removeItem(21569, 1) then
			npcHandler:say("But you don't have it...", cid)
			return npcHandler:releaseFocus(cid)
		end

		npcHandler:say(response[player:getStorageValue(SPIKE_LOWER_PARCEL_MAIN)], cid)
		player:setStorageValue(SPIKE_LOWER_PARCEL_MAIN, status + 1)
		table.insert(DELIVERED_PARCELS[player:getGuid()], Creature(getNpcCid()):getId())
		npcHandler:releaseFocus(cid)
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
