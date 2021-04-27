local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

local spike_items = {
	[21564] = {250, 4, SPIKE_MIDDLE_MUSHROOM_MAIN},
	[21555] = {150, 3, SPIKE_UPPER_TRACK_MAIN},
	[21569] = {100, 4, SPIKE_LOWER_PARCEL_MAIN},
	[21557] = {250, 1, SPIKE_MIDDLE_CHARGE_MAIN},
	[21553] = {150, 4, SPIKE_UPPER_MOUND_MAIN},
	[21556] = {500, 1, SPIKE_LOWER_LAVA_MAIN},
	[21554] = {150, 7, SPIKE_UPPER_PACIFIER_MAIN}
}

local onBuy = function(cid, item, subType, amount, ignoreCap, inBackpacks)
	if not doPlayerRemoveMoney(cid, spike_items[item][1] * amount) then
		selfSay("You don't have enough money.", cid)
	else
		doPlayerAddItem(cid, item, amount)
		selfSay("Here you are!", cid)
	end
	return true
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

function creatureSayCallback(cid, type, msg)

	if not npcHandler:isFocused(cid) then
		return false
	end

	local player, canBuy, shopWindow = Player(cid), false, {}

	for itemid, data in pairs(spike_items) do
		if not isInArray({-1, data[2]}, player:getStorageValue(data[3])) then
			canBuy = true
			table.insert(shopWindow, {id = itemid, subType = 0, buy = data[1], sell = 0, name = ItemType(itemid):getName()})
		end
	end

	if msgcontains(msg, 'trade') then
		if canBuy then
			openShopWindow(cid, shopWindow, onBuy, onSell)
			return npcHandler:say("Here you are.", cid)
		else
			return npcHandler:say("Sorry, there's nothing for you right now.", cid)
		end
		return true
	end

	if msgcontains(msg, 'job') then
		npcHandler:say("I'm responsible for resupplying foolish adventurers with equipment that they may have lost. If you're one of them, just ask me about a {trade}. ", cid)
	end

	if msgcontains(msg, 'gnome') then
		npcHandler:say("What could I say about gnomes that anyone would not know? I mean, we're interesting if not fascinating, after all.", cid)
	end

	if msgcontains(msg, 'spike') then
		npcHandler:say({"I came here as a crystal farmer and know the Spike all the way back to when it was a little baby crystal. I admit I feel a little fatherly pride in how big and healthy it has become.","When most other crystal experts left for new assignments, I decided to stay and help here a bit."}, cid)
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
