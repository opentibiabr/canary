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
	{ text = 'I can inform you about the status of this world, if you\'re interested.' },
	{ text = 'Hello, is this your first visit to Venore? I can show you around a little.' },
	{ text = 'Talk to me if you need directions.' },
	{ text = 'Need some help finding your way through Venore? Let me assist you.' },
	{ text = 'Free escort to the depot for newcomers!' }
}

npcHandler:addModule(VoiceModule:new(voices))

local configMarks = {
	{mark = "shops1", position = Position(32976, 32083, 6), markId = MAPMARK_BAG, description = "Magic Bazar"},
	{mark = "depot", position = Position(32919, 32071, 6), markId = MAPMARK_LOCK, description = "Depot"},
	{mark = "temple", position = Position(32958, 32078, 6), markId = MAPMARK_TEMPLE, description = "Temple"},
	{mark = "shop2", position = Position(32908, 32123, 6), markId = MAPMARK_TEMPLE, description = "Armors and Weapons"},
	{mark = "bank", position = Position(33011, 32053, 6), markId = MAPMARK_TEMPLE, description = "Bank"},
	{mark = "shop3", position = Position(32976, 32045, 6), markId = MAPMARK_TEMPLE, description = "Foods and Plants"}
}

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	local player = Player(cid)
	if isInArray({"map", "marks"}, msg) then
		npcHandler:say("Would you like me to mark locations like - for example - the depot, bank and shops on your map?", cid)
		npcHandler.topic[cid] = 1
	elseif msgcontains(msg, "yes") and npcHandler.topic[cid] == 1 then
		npcHandler:say("Here you go.", cid)
		local mark
		for i = 1, #configMarks do
			mark = configMarks[i]
			player:addMapMark(mark.position, mark.markId, mark.description)
		end
		npcHandler.topic[cid] = 0
	elseif msgcontains(msg, "no") and npcHandler.topic[cid] >= 1 then
		npcHandler:say("Well, nothing wrong about exploring the town on your own. Let me know if you need something!", cid)
		npcHandler.topic[cid] = 0
	end
	return true
end

keywordHandler:addKeyword({'information'}, StdModule.say, {npcHandler = npcHandler, text = 'Currently, I can tell you all about the town, its temple, the bank, shops - well, warehouses - spell trainers and the depot, as well as about the adventurer\'s guild, hunting grounds, quests and the world status.'})
keywordHandler:addKeyword({'temple'}, StdModule.say, {npcHandler = npcHandler, text = 'The temple is pretty much in the middle of Venore. If you go south from this harbour, you can\'t miss it.'})
keywordHandler:addKeyword({'bank'}, StdModule.say, {npcHandler = npcHandler, text = 'The bank as well as jewel stores can be found in the House of Wealth, in the north-eastern part of Venore. I can mark it on your map if you want.'})
keywordHandler:addKeyword({'shops'}, StdModule.say, {npcHandler = npcHandler, text = 'You can buy almost everything here! Visit one of our warehouses for weapons, armors, magical equipment, spells, gems, tools, furniture and everything else you can imagine.'})
keywordHandler:addKeyword({'depot'}, StdModule.say, {npcHandler = npcHandler, text = 'The depot is a place where you can safely store your belongings. You are also protected against attacks there. I escort newcomers there.'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I will help you find your way in the buzzing city of Venore. I can mark important locations on your map and give you some information about the town and the world status.'})
keywordHandler:addKeyword({'town'}, StdModule.say, {npcHandler = npcHandler, text = 'This trading city has been built directly over a swamp and basically stands on stone pillars. We have many large warehouses here. To speak of \'shops\' would be an understatement.'})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m Elena, sweetheart. I love your name, |PLAYERNAME|.'})

npcHandler:setMessage(MESSAGE_GREET, "Welcome to Venore, |PLAYERNAME| Would you like some information and a map guide?")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye and enjoy your stay in Venore, |PLAYERNAME|.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
