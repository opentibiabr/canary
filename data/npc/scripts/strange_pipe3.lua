
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

-- Don't forget npcHandler = npcHandler in the parameters. It is required for all StdModule functions!
keywordHandler:addKeyword({'importance'}, StdModule.say, {npcHandler = npcHandler, text = 'I can\'t reveal much to you right now as time is of the essence. I can tell you though that the glooth plant and the whole town are in danger and we have to act to stop a {madman} and his schemes.'})
keywordHandler:addKeyword({'laboratory'}, StdModule.say, {npcHandler = npcHandler, text = 'I defeated him there in the past. It has been abandoned for many {years}, but I suspected him to return from the dead eventually, as he has done so often before.'})
keywordHandler:addKeyword({'plan'}, StdModule.say, {npcHandler = npcHandler, text = 'The creature is powerful but not very clever. It seems it can be easily {enraged} and then it would likely let slip all caution and would relentlessly attack without regard for its safety.'})
keywordHandler:addKeyword({'years'}, StdModule.say, {npcHandler = npcHandler, text = 'I used the time to prepare. You\'ll find my talking tubes all the {way} to his lair, and I can provide you with vital information about the things ahead.'})

local function greetCallback(cid)
	local player = Player(cid)
	player:setStorageValue(Storage.HeroRathleton.AccessTeleport3, 1)
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if msgcontains(msg, "madman") then
		npcHandler:say({
			"He is an old enemy of the city and I've battled him often in the past. ...",
			"Now he has returned for vengeance, he reclaimed an old abandoned underground {laboratory} and he has acquired new powerful {allies}."
		}, cid)
	end
	if msgcontains(msg, 'allies') then
		npcHandler:say({
			"His allies are an enigma even to me. It seems they belong to some unknown race that lives deep under the earth. ...",
			"They seem to have supplied him with resources and workforce and a powerful {guardian} to prevent anyone from entering the passages to his lair."
		}, cid)
	end
	if msgcontains(msg, 'guardian') then
		npcHandler:say({
			"It's a fearsome subterranean beast like nothing I've ever encountered. It is dangerous and almost unbeatable because its main body is hidden beneath the ground ...",
			"And it has an endless supply of tentacles. But not all is lost, as I have devised a {plan} to battle the beast."
		}, cid)
	end
	if msgcontains(msg, 'enraged') then
		npcHandler:say({
			"While it's buried, it only uses his tentacles to attack. If one is destroyed it will simply use another set of tentacles and its supply seems endless. ...",
			"If you manage though to kill all the tentacles it is using within a few heartbeats, it will become confused by its momentary helplessness and will probably attack with its main body. ...",
			"That is when you have a chance to destroy it. Pass through its chamber and look for another of my tubes to contact me. Please hurry! End of communication."
		}, cid)
	end
	if msgcontains(msg, 'way') then
		npcHandler:say({
			"You will have to leave the plant through the eastern door on the lowest level. I have arranged for it to be 'accidentally' open. ...",
			"As in the past, our enemy still uses a series of machines to open the way to the next section of his lair. You have to turn them all on to proceed. ...",
			"They will only work for a certain amount of time though, so you will have to hurry or some of the machines will turn inactive again."
		}, cid)
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
