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

keywordHandler:addKeyword({'hi'}, StdModule.say, {npcHandler = npcHandler, onlyUnfocus = true})
keywordHandler:addKeyword({'hello'}, StdModule.say, {npcHandler = npcHandler, onlyUnfocus = true})

function creatureSayCallback(cid, type, msg)
	if(not(npcHandler:isFocused(cid))) then
		return false
	end

	local player = Player(cid)	
	if (msgcontains(msg, "nokmir")) then
		if player:getStorageValue(Storage.HiddenCityOfBeregar.JusticeForAll) == 1 then
			npcHandler:say("I always liked him and I still can't believe that he really stole that ring.", cid)
			npcHandler.topic[cid] = 1
		elseif player:getStorageValue(Storage.HiddenCityOfBeregar.JusticeForAll) == 4 and player:removeItem(14348, 1) then
			npcHandler:say("Interesting. The fact that you have the ring means that Nokmir can't have stolen it. Combined with the information Grombur gave you, the case appears in a completely different light. ...", cid)
			npcHandler:say("Let there be justice for all. Nokmir is innocent and acquitted from all charges! And Rerun... I want him in prison for this malicious act!", cid)
			player:setStorageValue(Storage.HiddenCityOfBeregar.JusticeForAll, 5)
		end	
	elseif (msgcontains(msg, "grombur")) then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say("He's very ambitious and always volunteers for the long shifts.", cid)
			player:setStorageValue(Storage.HiddenCityOfBeregar.JusticeForAll, 2)
			npcHandler.topic[cid] = 0
		end	
	elseif (msgcontains(msg, "mission")) then
		if player:getStorageValue(Storage.HiddenCityOfBeregar.RoyalRescue) < 1 and player:getStorageValue(Storage.HiddenCityOfBeregar.JusticeForAll) > 4 then
			npcHandler:say("As you have proven yourself trustworthy I\'m going to assign you a special mission. Are you interested?", cid)
			npcHandler.topic[cid] = 2
		elseif player:getStorageValue(Storage.HiddenCityOfBeregar.RoyalRescue) == 5 then
			npcHandler:say("My son was captured by trolls? Doesn\'t sound like him, but if you say so. Now you want a reward, huh? ...", cid)
			npcHandler.topic[cid] = 3
		end	
	elseif (msgcontains(msg, "yes")) then
		if npcHandler.topic[cid] == 2 then
			npcHandler:say("Splendid! My son Rehon set off on an expedition to the deeper mines. He and a group of dwarfs were to search for new veins of crystal. Unfortunately they have been missing for 2 weeks now. ...", cid)
			npcHandler:say("Find my son and if he's alive bring him back. You will find a reactivated ore wagon tunnel at the entrance of the great citadel which leades to the deeper mines. If you encounter problems within the tunnel go ask Xorlosh, he can help you.", cid)
			player:setStorageValue(Storage.HiddenCityOfBeregar.RoyalRescue, 1)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 3 then	
			npcHandler:say("Look at these dwarven legs. They were forged years ago by a dwarf who was rather tall for our kind. I want you to have them. Thank you for rescuing my son |PLAYERNAME|.", cid)
			player:addItem(2504, 1)
			player:setStorageValue(Storage.HiddenCityOfBeregar.RoyalRescue, 6)
			npcHandler.topic[cid] = 0
		end	
	elseif (msgcontains(msg, "no")) then
		if npcHandler.topic[cid] == 1 or npcHandler.topic[cid] == 2 then
			npcHandler:say("Alright then, come back when you are ready.", cid)
			npcHandler.topic[cid] = 0
		end	
	end 
	return true
end

local node1 = keywordHandler:addKeyword({'promot'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'I can promote you for 20000 gold coins. Do you want me to promote you?'})
node1:addChildKeyword({'yes'}, StdModule.promotePlayer, {npcHandler = npcHandler, cost = 20000, level = 20, promotion = 1, text = 'Congratulations! You are now promoted.'})
node1:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Alright then, come back when you are ready.', reset = true})

-- Greeting message
keywordHandler:addGreetKeyword({"hail emperor"}, {npcHandler = npcHandler, text = "May fire and earth bless you, stranger. What leads you to Beregar, the dwarven city?"})
keywordHandler:addGreetKeyword({"salutations emperor"}, {npcHandler = npcHandler, text = "May fire and earth bless you, stranger. What leads you to Beregar, the dwarven city?"})

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)

npcHandler:addModule(FocusModule:new())