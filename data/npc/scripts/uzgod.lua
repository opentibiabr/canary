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
	if(not npcHandler:isFocused(cid)) then
		return false
	end
	local player = Player(cid)
	if(msgcontains(msg, "piece of draconian steel")) then
		npcHandler:say("You bringing me draconian steel and obsidian lance in exchange for obsidian knife?", cid)
		npcHandler.topic[cid] = 15
	elseif(msgcontains(msg, "yes") and npcHandler.topic[cid] == 15) then
		if player:getItemCount(5889) >= 1 and player:getItemCount(2425) >= 1 then
			if player:removeItem(5889, 1) and player:removeItem(2425, 1) then
				npcHandler:say("Here you have it.", cid)
				player:addItem(5908, 1)
				npcHandler.topic[cid] = 0
			end
		else
			npcHandler:say("You don\'t have these items.", cid)
			npcHandler.topic[cid] = 0
		end
	end

	if(msgcontains(msg, "pickaxe")) then
		if player:getStorageValue(Storage.ExplorerSociety.JoiningTheExplorers) == 1 and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 1 then
			npcHandler:say("True dwarven pickaxes having to be maded by true weaponsmith! You wanting to get pickaxe for explorer society?", cid)
			npcHandler.topic[cid] = 1
		end
	elseif(msgcontains(msg, "crimson sword")) then
		if player:getStorageValue(Storage.TravellingTrader.Mission05) == 1 then
			npcHandler:say("Me don't sell crimson sword.", cid)
			npcHandler.topic[cid] = 5
		end
	elseif(msgcontains(msg, "forge")) then
		if(npcHandler.topic[cid] == 5) then
			npcHandler:say("You telling me to forge one?! Especially for you? You making fun of me?", cid)
			npcHandler.topic[cid] = 6
		end
	elseif(msgcontains(msg, "brooch")) then
		if player:getStorageValue(Storage.ExplorerSociety.JoiningTheExplorers) == 2 and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 2 then
			npcHandler:say("You got me brooch?", cid)
			npcHandler.topic[cid] = 3
		end
	elseif(msgcontains(msg, "yes")) then
		if(npcHandler.topic[cid] == 1) then
			npcHandler:say("Me order book quite full is. But telling you what: You getting me something me lost and Uzgod seeing that your pickaxe comes first. Jawoll! You interested?", cid)
			npcHandler.topic[cid] = 2
		elseif(npcHandler.topic[cid] == 2) then
			npcHandler:say("Good good. You listening: Me was stolen valuable heirloom. Brooch from my family. Good thing is criminal was caught. Bad thing is, criminal now in dwarven prison of dwacatra is and must have taken brooch with him ...", cid)
			npcHandler:say("To get into dwacatra you having to get several keys. Each key opening way to other key until you get key to dwarven prison ...", cid)
			npcHandler:say("Last key should be in the generals quarter near armory. Only General might have key to enter there too. But me not knowing how to enter Generals private room at barracks. You looking on your own ...", cid)
			npcHandler:say("When got key, then you going down to dwarven prison and getting me that brooch. Tell me that you got brooch when having it.", cid)
			npcHandler.topic[cid] = 0
			player:setStorageValue(Storage.ExplorerSociety.JoiningTheExplorers, 2)
			player:setStorageValue(Storage.ExplorerSociety.DwacatraDoor, 1)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 2)
		elseif(npcHandler.topic[cid] == 3) then
			if player:removeItem(4845, 1) then -----
				npcHandler:say("Thanking you for brooch. Me guessing you now want your pickaxe?", cid)
				npcHandler.topic[cid] = 4
			end
		elseif(npcHandler.topic[cid] == 4) then
			npcHandler:say("Here you have it.", cid)
			player:addItem(4874, 1) -----
			player:setStorageValue(Storage.ExplorerSociety.JoiningTheExplorers, 3)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 3)
			npcHandler.topic[cid] = 0
		elseif(npcHandler.topic[cid] == 9) then
			if player:getMoney() + player:getBankBalance() >= 250 and player:getItemCount(5880) >= 3 then
				if player:removeMoneyNpc(250) and player:removeItem(5880, 3) then
					npcHandler:say("Ah, that's how me like me customers. Ok, me do this... <pling pling> ... another fine swing of the hammer here and there... <ploing>... here you have it!", cid)
					player:addItem(7385, 1)
					player:setStorageValue(Storage.TravellingTrader.Mission05, 2)
					npcHandler.topic[cid] = 0
				end
			end
		end
	elseif(msgcontains(msg, "no")) then
		if(npcHandler.topic[cid] == 6) then
			npcHandler:say("Well. Thinking about it, me a smith, so why not. 1000 gold for your personal crimson sword. Ok?", cid)
			npcHandler.topic[cid] = 7
		elseif(npcHandler.topic[cid] == 7) then
			npcHandler:say("Too expensive?! You think me work is cheap? Well, if you want cheap, I can make cheap. Hrmpf. I make cheap sword for 300 gold. Ok?", cid)
			npcHandler.topic[cid] = 8
		elseif(npcHandler.topic[cid] == 8) then
			npcHandler:say("Cheap but good quality? Impossible. Unless... you bring material. Three iron ores, 250 gold. Okay?", cid)
			npcHandler.topic[cid] = 9
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
