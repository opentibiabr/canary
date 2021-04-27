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

local config = {
	towns = {
		["venore"] = TOWNS_LIST.VENORE,
		["thais"] = TOWNS_LIST.THAIS,
		["kazordoon"] = TOWNS_LIST.KAZORDOON,
		["carlin"] = TOWNS_LIST.CARLAIN,
		["ab'dendriel"] = TOWNS_LIST.AB_DENDRIEL,
		["liberty bay"] = TOWNS_LIST.LIBERTY_BAY,
		["port hope"] = TOWNS_LIST.PORT_HOPE,
		["ankrahmun"] = TOWNS_LIST.ANKRAHMUN,
		["darashia"] = TOWNS_LIST.DARASHIA,
		["edron"] = TOWNS_LIST.EDRON
	},
}

local function greetCallback(cid)
	local player = Player(cid)
	if player:getStorageValue(Storage.AdventurersGuild.CharosTrav) > 6 then
		npcHandler:say("Sorry, you have traveled a lot.", cid)
		npcHandler:resetNpc(cid)
		return false
	else
		npcHandler:setMessage(MESSAGE_GREET, "Hello young friend! I can attune you to a city of your choice. \z
		If you step to the teleporter here you will not appear in the city you came from as usual, \z
		but the city of your choice. Is it what you wish?")
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if npcHandler.topic[cid] == 0 then
		if msgcontains(msg, "yes") then
			npcHandler:say("Fine. You have ".. -player:getStorageValue(Storage.AdventurersGuild.CharosTrav)+7 .." \z
			attunements left. What is the new city of your choice? Thais, Carlin, Ab'Dendriel, Kazordoon, Venore, \z
			Ankrahmun, Edron, Darashia, Liberty Bay or Port Hope?", cid)
			npcHandler.topic[cid] = 1
		end
	elseif npcHandler.topic[cid] == 1 then
		local cityTable = config.towns[msg:lower()]
		if cityTable then
			player:setStorageValue(Storage.AdventurersGuild.CharosTrav,
			player:getStorageValue(Storage.AdventurersGuild.CharosTrav)+1)
			player:setStorageValue(Storage.AdventurersGuild.Stone, cityTable)
			npcHandler:say("Goodbye traveler!", cid)
		else
			npcHandler:say("Sorry, I don't know about this place.", cid)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
