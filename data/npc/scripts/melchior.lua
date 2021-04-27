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
	npcHandler:setMessage(MESSAGE_GREET, Player(cid):getSex() == PLAYERSEX_FEMALE and 'Welcome, |PLAYERNAME|! The lovely sound of your voice shines like a beam of light through my solitary darkness!' or 'Greetings, |PLAYERNAME|. I do not see your face, but I can read a thousand things in your voice!')
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if msgcontains(msg, 'greeting') then
		if player:getStorageValue(Storage.DjinnWar.Faction.Greeting) ~= 0 then
			npcHandler:say({
				'The djinns have an ancient code of honour. This code includes a special concept of hospitality. Anybody who utters the word of greeting must not be attacked even if he is an enemy. Well, at least that is what the code says. ...',
				'I have found out, though, that this does not work at all times. There is no point to say the word of greeting to an enraged djinn. ...',
				'I can tell you the word of greeting if you\'re interested. It is {DJANNI\'HAH}. Remember this word well, stranger. It might save your life one day. ...',
				'And keep in mind that you must choose sides in this conflict. You can only follow the Efreet or the Marid - once you have made your choice there is no way back. I know from experience that djinn do not tolerate double-crossing.'
			}, cid)

			if player:getStorageValue(Storage.Factions) ~= 1 then
				player:setStorageValue(Storage.Factions, 1)
			end
			player:setStorageValue(Storage.DjinnWar.Faction.Greeting, 1)
		end
	end

	return true
end

npcHandler:setMessage(MESSAGE_FAREWELL, 'Farewell, stranger. May Uman the Wise guide your steps in this treacherous land.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Farewell, stranger. May Uman the Wise guide your steps in this treacherous land.')

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
