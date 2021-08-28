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

-- Module shop
local shopModule = ShopModule:new()
npcHandler:addModule(shopModule)
-- Buyable item
shopModule:addBuyableItem({"almanac of magic"}, 10025, 600, 1)
-- Sellable item
shopModule:addSellableItem({"almanac of magic"}, 10025, 300, 1)

-- Function called by the callback "npcHandler:setCallback(CALLBACK_GREET, greetCallback)" in end of file
local function greetCallback(cid)
	npcHandler:setMessage(MESSAGE_GREET, "Hello |PLAYERNAME|, you need more info about {canary}?")
	return true
end

-- On creature say callback
local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "canary") then
		npcHandler:say({
			"The goal is for Canary to be an 'engine', that is, it will be \z
				a server with a 'clean' datapack, with as few things as possible, \z
				thus facilitating development and testing.",
			"See more on our {discord group}."
		}, cid, false, false, 3000)
	elseif msgcontains(msg, "discord group") then
		npcHandler:say("This the our discord group link: {https://discordapp.com/invite/3NxYnyV}", cid)
	end
	return true
end

-- Set to local function "greetCallback"
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
-- Set to local function "creatureSayCallback"
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

-- Bye message
npcHandler:setMessage(MESSAGE_FAREWELL, "Yeah, good bye and don't come again!")
-- Walkaway message
npcHandler:setMessage(MESSAGE_WALKAWAY, "You not have education?")

npcHandler:addModule(FocusModule:new())
