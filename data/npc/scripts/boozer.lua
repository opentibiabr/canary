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
	if msgcontains(msg, "mission") then
		if player:getStorageValue(Storage.TibiaTales.ultimateBoozeQuest) == 2 and player:removeItem(7495, 1) then
			player:setStorageValue(Storage.TibiaTales.ultimateBoozeQuest, 3)
			npcHandler.topic[cid] = 0
			player:addItem(5710, 1)
			player:addItem(2152, 10)
			player:addExperience(100, true)
			npcHandler:say("Yessss! Now I only need to build my own small brewery, figure out the secret recipe, duplicate the dwarvish brew and BANG I'll be back in business! Here take this as a reward.", cid)
		elseif player:getStorageValue(Storage.TibiaTales.ultimateBoozeQuest) < 1 then
			npcHandler.topic[cid] = 1
			npcHandler:say("Shush!! I don't want everybody to know what I am up to. Listen, things are not going too well, I need a new attraction. Do you want to help me?", cid)
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 1 then
			player:setStorageValue(Storage.TibiaTales.DefaultStart, 1)
			player:setStorageValue(Storage.TibiaTales.ultimateBoozeQuest, 1)
			player:addItem(7496, 1)
			npcHandler:say("Good! Listen closely. Take this bottle and go to Kazordoon. I need a sample of their very special brown ale. You may find a cask in their brewery. Come back as soon as you got it.", cid)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
