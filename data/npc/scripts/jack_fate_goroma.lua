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
	if (msg) then
		msg = msg:lower()
	end

	if isInArray({"sail", "passage", "wreck", "liberty bay", "ship"}, msg) then
		if player:getStorageValue(Storage.TheShatteredIsles.AccessToGoroma) ~= 1 then
			if player:getStorageValue(Storage.TheShatteredIsles.Shipwrecked) < 1 then
				npcHandler:say('I\'d love to bring you back to Liberty Bay, but as you can see, my ship is ruined. I also hurt my leg and can barely move. Can you help me?', cid)
				npcHandler.topic[cid] = 1
			elseif player:getStorageValue(Storage.TheShatteredIsles.Shipwrecked) == 1 then
				npcHandler:say('Have you brought 30 pieces of wood so that I can repair the ship?', cid)
				npcHandler.topic[cid] = 3
			end
		else
			npcHandler:say('Do you want to travel back to Liberty Bay?', cid)
			npcHandler.topic[cid] = 4
		end
	elseif msgcontains(msg, 'yes') then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say({
				"Thank you. Luckily the damage my ship has taken looks more severe than it is, so I will only need a few wooden boards. ...",
				"I saw some lousy trolls running away with some parts of the ship. It might be a good idea to follow them and check if they have some more wood. ...",
				"We will need 30 pieces of wood, no more, no less. Did you understand everything?"
			}, cid)
			npcHandler.topic[cid] = 2
		elseif npcHandler.topic[cid] == 2 then
			npcHandler:say('Good! Please return once you have gathered 30 pieces of wood.', cid)
			player:setStorageValue(Storage.TheShatteredIsles.DefaultStart, 1)
			player:setStorageValue(Storage.TheShatteredIsles.Shipwrecked, 1)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 3 then
			if player:removeItem(5901, 30) then
				npcHandler:say("Excellent! Now we can leave this godforsaken place. Thank you for your help. Should you ever want to return to this island, ask me for a passage to Goroma.", cid)
				player:setStorageValue(Storage.TheShatteredIsles.Shipwrecked, 2)
				player:setStorageValue(Storage.TheShatteredIsles.AccessToGoroma, 1)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("You don't have enough...", cid)
			end
		elseif npcHandler.topic[cid] == 4 then
			player:teleportTo(Position(32285, 32892, 6), false)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			npcHandler:say('Set the sails!', cid)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			npcHandler.topic[cid] = 0
		end
	end
	return true
end

keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'My name is Jack Fate from the Royal Tibia Line.'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m the captain of this - well, wreck. Argh.'})
keywordHandler:addKeyword({'captain'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m the captain of this - well, wreck. Argh'})
keywordHandler:addKeyword({'goroma'}, StdModule.say, {npcHandler = npcHandler, text = 'This is where we are... the volcano island Goroma. There are many rumours about this place.'})

npcHandler:setMessage(MESSAGE_GREET, "Hello, Sir |PLAYERNAME|. Where can I {sail} you today?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye then.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
