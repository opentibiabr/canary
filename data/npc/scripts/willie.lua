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
	{ text = "Ah, what the heck.Make sure you know what you want before you bug me." },
	{ text = "Buying and selling food!" },
	{ text = "Make sure you know what you want before you bug me." },
	{ text = "You, over there! Stop sniffing around my farm! Either trade with me or leave!" }
}
npcHandler:addModule(VoiceModule:new(voices))

-- NPC shop
local shopModule = ShopModule:new()
npcHandler:addModule(shopModule)
-- Buyable
-- Name, id, price, count/charges
shopModule:addBuyableItem({"bread"}, 2689, 3, 1)
shopModule:addBuyableItem({"cheese"}, 2696, 5, 1)
shopModule:addBuyableItem({"ham"}, 2671, 8, 1)
shopModule:addBuyableItem({"meat"}, 2666, 5, 1)
-- Sellable
shopModule:addSellableItem({"bread"}, 2689, 1, 1)
shopModule:addSellableItem({"cheese"}, 2696, 2, 1)
shopModule:addSellableItem({"ham"}, 2671, 4, 1)
shopModule:addSellableItem({"meat"}, 2666, 2, 1)
shopModule:addSellableItem({"cherry"}, 2679, 1, 1)
shopModule:addSellableItem({"egg"}, 2695, 1, 1)
shopModule:addSellableItem({"salmon"}, 2668, 2, 1)

-- Basic keywords
keywordHandler:addKeyword({"offer"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Haven't they taught you anything at school? Ask for a {trade} if you want to trade."
	}
)
keywordHandler:addAliasKeyword({"sell"})
keywordHandler:addAliasKeyword({"buy"})
keywordHandler:addAliasKeyword({"food"})

keywordHandler:addKeyword({"information"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Help yourself. Or ask the other {citizens}, I don't have time for that."
	}
)
keywordHandler:addAliasKeyword({"help"})
keywordHandler:addAliasKeyword({"hint"})

keywordHandler:addKeyword({"how", "are", "you"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Fine enough."
	}
)
keywordHandler:addKeyword({"name"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Willie."
	}
)
keywordHandler:addKeyword({"job"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I'm a farmer and a cook."
	}
)
keywordHandler:addKeyword({"cook"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I try out old and new {recipes}. You can sell all {food} to me."
	}
)
keywordHandler:addKeyword({"recipe"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I'd love to try a banana pie but I lack the {bananas}. If you get me one, I'll reward you."
	}
)
keywordHandler:addKeyword({"citizen"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Which one?"
	}
)
keywordHandler:addKeyword({"rookgaard"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "This island would be wonderful if there weren't a constant flood of newcomers."
	}
)
keywordHandler:addKeyword({"tibia"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "If I were you, I'd stay here."
	}
)
keywordHandler:addKeyword({"spell"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I know how to spell."
	}
)
keywordHandler:addKeyword({"magic"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I'm a magician in the kitchen."
	}
)
keywordHandler:addKeyword({"weapon"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I'm not in the weapon business, so stop disturbing me."
	}
)
keywordHandler:addKeyword({"king"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I'm glad that we don't see many officials here."
	}
)
keywordHandler:addKeyword({"god"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I'm a farmer, not a preacher."
	}
)
keywordHandler:addKeyword({"sewer"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "What about them? Do you live there?"
	}
)
keywordHandler:addKeyword({"dungeon"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I've got no time for your dungeon nonsense."
	}
)
keywordHandler:addKeyword({"rat"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "My cousin {Billy} cooks rat stew. Yuck! Can you imagine that?"
	}
)
keywordHandler:addKeyword({"monster"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Are you afraid of monsters? I bet even the sight of a {rat} would let your knees tremble. Hahaha."
	}
)
keywordHandler:addKeyword({"time"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Do I look like a clock?"
	}
)
keywordHandler:addKeyword({"god"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I'm a farmer, not a preacher."
	}
)

-- Names
keywordHandler:addKeyword({"al", "dee"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Can't stand him."
	}
)
keywordHandler:addKeyword({"amber"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Quite a babe."
	}
)
keywordHandler:addKeyword({"billy"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Don't ever mention his name again! He can't even {cook}!"
	}
)
keywordHandler:addKeyword({"cipfried"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Our little monkey."
	}
)
keywordHandler:addKeyword({"dallheim"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Uhm, fine guy I think."
	}
)
keywordHandler:addKeyword({"dixi"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Boring little girl."
	}
)
keywordHandler:addKeyword({"hyacinth"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Overrated."
	}
)
keywordHandler:addKeyword({"lee'delle"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "She thinks she owns this island with her underpriced offers."
	}
)
keywordHandler:addKeyword({"lily"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I don't like hippie girls."
	}
)
keywordHandler:addKeyword({"loui"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Leave me alone with that guy."
	}
)
keywordHandler:addKeyword({"norma"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "About time we got a bar here."
	}
)
keywordHandler:addKeyword({"obi"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "This old guy has only money on his mind."
	}
)
keywordHandler:addKeyword({"oracle"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Hopefully it gets you off this island soon so you can stop bugging me."
	}
)
keywordHandler:addKeyword({"paulie"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Uptight and correct in any situation."
	}
)
keywordHandler:addKeyword({"santiago"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "If he wants to sacrifice all his free time for beginners, fine with me. Then they don't disturb me."
	}
)
keywordHandler:addKeyword({"seymour"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "This joke of a man thinks he is sooo important."
	}
)
keywordHandler:addKeyword({"tom"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Decent guy."
	}
)
keywordHandler:addKeyword({"willie"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Yeah, so?"
	}
)
keywordHandler:addKeyword({"zerbrus"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Overrated."
	}
)
keywordHandler:addKeyword({"zirella"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Too old to be interesting for me."
	}
)

-- Studded Shield Quest
local bananaKeyword = keywordHandler:addKeyword({"banana"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Have you found a banana for me?"
	}
)
bananaKeyword:addChildKeyword({"yes"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "A banana! Great. Here, take this shield, I don't need it anyway.",
		reset = true
	},
		function(player)
			return player:getItemCount(2676) > 0
		end,
		function(player)
			player:removeItem(2676, 1)
			player:addItem(2526, 1)
		end
)
bananaKeyword:addChildKeyword({"yes"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Are you trying to mess with me?!",
		reset = true
	}
)
bananaKeyword:addChildKeyword({""}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Too bad.",
		reset = true
	}
)

npcHandler:setMessage(MESSAGE_WALKAWAY, "Yeah go away!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Yeah, bye |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Ya take a good look.")
npcHandler:setMessage(MESSAGE_GREET, "Hiho |PLAYERNAME|. I hope you're here to {trade}.")

npcHandler:addModule(FocusModule:new())
