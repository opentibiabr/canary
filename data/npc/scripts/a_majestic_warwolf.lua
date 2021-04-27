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
	if Player(cid):getStorageValue(Storage.OutfitQuest.DruidHatAddon) < 9 then
		npcHandler:say('GRRRRRRRRRRRRR', cid)
		return false
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	local player = Player(cid)
	if isInArray({'addon', 'outfit'}, msg) then
		if player:getStorageValue(Storage.OutfitQuest.DruidHatAddon) == 9 then
			npcHandler:say('I can see in your eyes that you are a honest and friendly person, |PLAYERNAME|. You were patient enough to learn our language and I will grant you a special gift. Will you accept it?', cid)
			npcHandler.topic[cid] = 1
		end
	elseif msgcontains(msg, 'yes') and npcHandler.topic[cid] == 1 then
		player:setStorageValue(Storage.OutfitQuest.DruidHatAddon, 10)
		player:addOutfitAddon(148, 2)
		player:addOutfitAddon(144, 2)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
		npcHandler:say(player:getSex() == PLAYERSEX_FEMALE and 'From now on, you shall be known as |PLAYERNAME|, the wolf girl. You shall be fast and smart as Morgrar, the great white wolf. He shall guide your path.' or 'From now on, you shall be known as |PLAYERNAME|, the bear warrior. You shall be strong and proud as Angros, the great dark bear. He shall guide your path.', cid)
		npcHandler.topic[cid] = 0
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "Interesting. A human who can speak the language of wolves.")
npcHandler:setMessage(MESSAGE_FAREWELL, "YOOOOUHHOOOUU!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "YOOOOUHHOOOUU!")
npcHandler:addModule(FocusModule:new())
