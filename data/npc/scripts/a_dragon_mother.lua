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

local function greetCallback(cid)
	local player = Player(cid)
	if player:getStorageValue(Storage.ForgottenKnowledge.BabyDragon) < 1 then
		npcHandler:setMessage(MESSAGE_GREET, "Greetings humans! Consider yourselfs lucky, I'm in need of {help}.")
		npcHandler.topic[cid] = 1
		return true
	elseif player:getStorageValue(Storage.ForgottenKnowledge.AccessMachine) == 1 then
		npcHandler:setMessage(MESSAGE_GREET, 'Grrr.')
		return true
	elseif player:getStorageValue(Storage.ForgottenKnowledge.HorrorKilled) >= 1 then
		npcHandler:setMessage(MESSAGE_GREET, 'You have done me a favour and the knowledge you are seeking shall be yours. I melted the ice for you, you can pass now.')
		player:setStorageValue(Storage.ForgottenKnowledge.AccessMachine, 1)
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if msgcontains(msg, "help") then
		npcHandler:say({
			"I'm aware what you are looking for. Usually I would rather devour you, but due to unfortunate circumstances, I need your {assistance}.",
		}, cid)
		npcHandler.topic[cid] = 2
	elseif msgcontains(msg, "assistance") then
		if npcHandler.topic[cid] == 2 then
			npcHandler:say({
				"Wretched creatures of ice have stolen my egg that was close to hatching. ...",
				" Since I'm to huge to enter those lower Tunnels I have to ask you to take care of my {egg}. Will you do this?"
			}, cid)
			npcHandler.topic[cid] = 3
		end
	end

	if msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 3 then
			npcHandler:say({
				"So return to the upper tunnels where cultists and ice golems dwell. Somewhere in these tunnels you will find a small prison haunted by a ghost. South of this prison cell there is a tunnel that will lead you eastwards. ...",
				"Follow the tunnel until you reach a small cave. Step down and down until you see a blue energy field. It will lead you to my egg. It is sealed so that not everyone may enter the room. But you have the permission now."
			}, cid)
			player:setStorageValue(Storage.ForgottenKnowledge.BabyDragon, 1)
			npcHandler.topic[cid] = 4
		end
	elseif msgcontains(msg, "no") then
			if npcHandler.topic[cid] == 3 then
			npcHandler:say({
				"Grrr."
			}, cid)
			npcHandler.topic[cid] = 1
		end
	end

	if msgcontains(msg, "egg") then
			if npcHandler.topic[cid] == 4 then
			npcHandler:say({
				"As I told you, fiendish ice creatures dragged my egg into the lower caves. ...",
				" Without enough heat the egg will die soon. Venture there and save my hatchling and the knowledge you seeek shall be yours!"
			}, cid)
			player:setStorageValue(Storage.ForgottenKnowledge.BabyDragon, 1)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
