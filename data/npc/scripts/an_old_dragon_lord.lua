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
function onCreatureSay(creature, type, msg)
	if not (msgcontains(msg, 'hi') or msgcontains(msg, 'hello')) then
		npcHandler:say('LEAVE THE DRAGONS\' CEMETERY AT ONCE!', creature.uid)
	end
	npcHandler:onCreatureSay(creature, type, msg)
end
function onThink()
	npcHandler:onThink()
end

local voices = { {text = 'AHHHH THE PAIN OF AGESSS! THE PAIN!'} }
npcHandler:addModule(VoiceModule:new(voices))

local function greetCallback(cid)
	local player = Player(cid)
	if player:getStorageValue(Storage.Dragonfetish) == 1 then
		npcHandler:say('LEAVE THE DRAGONS\' CEMETERY AT ONCE!', cid)
		return false
	end

	if not player:removeItem(2787, 1) then
		npcHandler:say('AHHHH THE PAIN OF AGESSS! I NEED MUSSSSHRROOOMSSS TO EASSSE MY PAIN! BRRRING ME MUSHRRROOOMSSS!', cid)
		return false
	end

	player:setStorageValue(Storage.Dragonfetish, 1)
	player:addItem(2319, 1)
	npcHandler:say('AHHH MUSHRRROOOMSSS! NOW MY PAIN WILL BE EASSSED FOR A WHILE! TAKE THISS AND LEAVE THE DRAGONSSS\' CEMETERY AT ONCE!', cid)
	return false
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:addModule(FocusModule:new())
