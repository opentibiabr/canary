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

	if msgcontains(msg, "again") then
		player:setStorageValue(Storage.BigfootBurden.QuestLine, 19)
	end

	if msgcontains(msg, "shooting") then
		if player:getStorageValue(Storage.BigfootBurden.QuestLine) == 11 then
			npcHandler:say({
				"To the left you see our shooting range. Grab a cannon and shoot at the targets. You need five hits to succeed. ...",
				"Shoot at the villain targets that will pop up. DON'T shoot innocent civilians since this will reset your score and you have to start all over. Report to me afterwards."
			}, cid)
			player:setStorageValue(Storage.BigfootBurden.QuestLine, 13) -- tirar do questlog
			player:setStorageValue(Storage.BigfootBurden.Shooting, 0)
		elseif player:getStorageValue(Storage.BigfootBurden.QuestLine) == 13 then
			npcHandler:say("Shoot at the villain targets that will pop up. DON'T shoot innocent civilians since this will reset your score and you have to start all over. {Report} to me afterwards.", cid)
		end
	elseif msgcontains(msg, "report") then
		if player:getStorageValue(Storage.BigfootBurden.QuestLine) == 14 then
			npcHandler:say("You are showing some promise! Now continue with the recruitment and talk to Gnomewart to the south for your endurance test!", cid)
			player:setStorageValue(Storage.BigfootBurden.Shooting, player:getStorageValue(Storage.BigfootBurden.Shooting) + 1)
			player:setStorageValue(Storage.BigfootBurden.QuestLine, 15)
		elseif player:getStorageValue(Storage.BigfootBurden.QuestLine) == 13 then
			npcHandler:say("Sorry you are not done yet.", cid)
		elseif player:getStorageValue(Storage.BigfootBurden.QuestLine) <= 12 then
			npcHandler:say("You have nothing to report at all.", cid)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
