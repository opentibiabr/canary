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

local shopModule = ShopModule:new()
npcHandler:addModule(shopModule)

shopModule:addBuyableItem({"almanac of magic"}, 10025, 600, 1)
shopModule:addSellableItem({"almanac of magic"}, 10025, 300, 1)

keywordHandler:addKeyword({'canary'}, StdModule.say, {npcHandler = npcHandler, text = "The goal is for Canary to be an 'engine', that is, it will be a server with a 'clean' datapack, with as few things as possible, thus facilitating development and testing. See more on our {discord group}"})
keywordHandler:addKeyword({'discord group'}, StdModule.say, {npcHandler = npcHandler, text = "This the our discord group link: https://discordapp.com/invite/3NxYnyV"})

npcHandler:setMessage(MESSAGE_GREET, "Hello |PLAYERNAME|, you need more info about {canary}?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Yeah, good bye and don't come again!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "You not have education?")
npcHandler:addModule(FocusModule:new())
