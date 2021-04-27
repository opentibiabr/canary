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

local voices = {
	{text = "Don't forget to always have a rope with you! Buy one here, only the best quality!"},
	{text = "Don't complain to ME when you fell down a hole without a rope to get you out! You can buy one here now!"},
	{text = "Everything an adventurer needs!"},
	{text = "A rope is the adventurer's best friend!"},
	{text = "Fresh meat! Durable provisions! Ropes and shovels!"},
	{text = "Feeling like a bit of treasure-seeking? \z
		Buy a shovel or a pick and investigate likely-looking stone piles and cracks!"}
}

npcHandler:addModule(VoiceModule:new(voices))

-- NPC shop
local shopModule = ShopModule:new()
npcHandler:addModule(shopModule)
-- Buyable
-- Name, id, price, count/charges
shopModule:addBuyableItem({"backpack"}, 1988, 10, 1)
shopModule:addBuyableItem({"bag"}, 1987, 4, 1)
shopModule:addBuyableItem({"bread"}, 2689, 3, 1)
shopModule:addBuyableItem({"carrot"}, 2684, 1, 1)
shopModule:addBuyableItem({"cheese"}, 2696, 5, 1)
shopModule:addBuyableItem({"cherry"}, 2679, 1, 1)
shopModule:addBuyableItem({"egg"}, 2695, 1, 1)
shopModule:addBuyableItem({"fishing rod"}, 2580, 150, 1)
shopModule:addBuyableItem({"ham"}, 2671, 8, 1)
shopModule:addBuyableItem({"machete"}, 2420, 6, 1)
shopModule:addBuyableItem({"meat"}, 2666, 5, 1)
shopModule:addBuyableItem({"pick"}, 2553, 15, 1)
shopModule:addBuyableItem({"rope"}, 2120, 50, 1)
shopModule:addBuyableItem({"salmon"}, 2668, 2, 1)
shopModule:addBuyableItem({"scroll"}, 1949, 5, 1)
shopModule:addBuyableItem({"shovel"}, 2554, 10, 1)
shopModule:addBuyableItem({"torch"}, 2050, 2, 1)
shopModule:addBuyableItem({"worm"}, 3976, 1, 1)
-- Sellable
shopModule:addSellableItem({"cheese"}, 2696, 2, 1)
shopModule:addSellableItem({"fishing rod"}, 2580, 30, 1)
shopModule:addSellableItem({"meat"}, 2666, 2, 1)
shopModule:addSellableItem({"rope"}, 2120, 8, 1)
shopModule:addSellableItem({"shovel"}, 2554, 2, 1)

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if msgcontains(msg, "job") then
		npcHandler:say(
			{
				"I was a carpenter, back on Main. Wanted my own little shop. Didn't sit with the old man. \z
					So I shipped to somewhere else. Terrible storm.",
				"Woke up on this island. Had to eat squirrels before the adventurers found me and took me in. End of story."
			},
		cid, false, true, 10)
		npcHandler.topic[cid] = 0
	elseif msgcontains(msg, "rope") then
		npcHandler:say(
			{
				"Only the best quality, I assure you. A rope in need is a friend indeed! Imagine you stumble into a rat \z
					hole without a rope - heh, your bones will be gnawed clean before someone finds ya!",
				"Now, about that rope - ask me for equipment to see my wares. <winks>"
			},
		cid, false, true, 10)
		npcHandler.topic[cid] = 0
	end
	return true
end

keywordHandler:addKeyword({'name'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Richard. Just Richard. Lost my surname with my past in that storm. <winks>"
	}
)
keywordHandler:addKeyword({'dawnport'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "This lovely island here. Once I didn't have to live off squirrels, it became quite enjoyable. \z
			Nasty things though live underground, so take care where you tread and ALWAYS have a rope with you!"
	}
)
keywordHandler:addKeyword({'rookgaard'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "<shrugs> Never been, mate. Heard it's kinda cute, though."
	}
)
keywordHandler:addKeyword({'coltrayne'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "You know, I really don't want to poke into someone else's private life. \z
			Suffice it to say that everyone has chapters of his life he doesn't want to mention. \z
			Judging by Coltrayne's looks, we're looking at a trilogy here."
	}
)
keywordHandler:addKeyword({'inigo'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Old Inigo was the one who found me, actually, and brought me to the outpost. \z
			I was half starved by then. He taught me how to make better traps and how to fish... I owe much to Inigo."
	}
)
keywordHandler:addKeyword({'garamond'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Can you believe how old he is? He won't say it, \z
			but I wouldn't be surprised if he had been around for loooooong time."
	}
)
keywordHandler:addKeyword({'squirrel'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Don't talk to ME about squirrels! <shudders> Had to live off them the first days, \z
			when they were the only thing to go into my self-made acorn traps. Nasty."
	}
)
keywordHandler:addKeyword({'mr morris'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Don't know what to make of him. Great researcher in all Dawnport matters, though. \z
			Always has a quest or two where he needs help, if you're looking for adventuring work."
	}
)
keywordHandler:addKeyword({'oressa'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Quiet little lady, her. Knows her way around the isle, looking for herbs and stuff \z
			but mostly spends her time in the temple, helping younglings like you choose a vocation."
	}
)
keywordHandler:addKeyword({'plunderpurse'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "You know, on the day that ol' pirate decides to make off with all that gold in the bank, \z
			I'm gonna come with him. Should be much more fun landing on a strange island with some gold \z
			to spend on booze and babes! <winks>"
	}
)
keywordHandler:addKeyword({'hamish'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Tries to act tough, but he's quite a witty and decent bloke who wouldn't hurt a fly. \z
			We enjoy a good laugh together in the evenings."
	}
)

npcHandler:setMessage(MESSAGE_GREET, "Hello there, mate. Here for a {trade}? My stock's just been refilled.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Of course, just browse through my wares. \z
	You can also have a look at food or {equipment} only.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Have fun!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
