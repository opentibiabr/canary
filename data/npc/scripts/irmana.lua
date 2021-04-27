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

function creatureSayCallback(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

	local player = Player(cid)
	if (msgcontains(msg, "fur")) then
		if (player:getStorageValue(Storage.ThreatenedDreams.TroubledMission01) == 8) then
			npcHandler:say({
				"A wolf whelp fur? Well, some months ago a hunter came here - a rather scruffy, smelly guy. I would have thrown him out instantly, but he had to offer some fine pelts. One of them was the fur of a very young wolf. ...",
				"I was not delighted that he obviously killed such a young animal. When I confronted him, he said he wanted to raise it as a companion but it unfortunately died. A sad story. In the end, I bought some of his pelts, among them the whelp fur. ...",
				"You can have it if this is important for you. I would sell it for 1000 gold. Are you interested?"
			}, cid)
			npcHandler.topic[cid] = 8
		else
			npcHandler:say("You are not on that mission.", cid)
			npcHandler.topic[cid] = 0
		end
	elseif(msgcontains(msg, "addon")) then
		if(getPlayerStorageValue(cid, Storage.Irmana1) < 1) then
			npcHandler:say("Currently we are offering accessories for the nobleman - and, of course, noblewoman - outfit. Would you like to hear more about our offer?", cid)
			npcHandler.topic[cid] = 1
		elseif getPlayerStorageValue(cid, Storage.Irmana2) < 1 then
			npcHandler:say("Currently we are offering accessories for the nobleman - and, of course, noblewoman - outfit. Would you like to hear more about our offer?", cid)
			npcHandler.topic[cid] = 1
		else
			npcHandler:say("You have already bought the two addons.", cid)
		end
	elseif(msgcontains(msg, "yes")) then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say("Especially for you, mylady, we are offering a pretty {hat} and a beautiful {dress} like the ones I wear. Which one are you interested in?", cid)
			npcHandler.topic[cid] = 2
		elseif npcHandler.topic[cid] == 3 then
			if(doPlayerRemoveMoney(cid, 150000) and getPlayerStorageValue(cid, Storage.Irmana1) < 1) then
				npcHandler:say("Congratulations! Here is your brand-new accessory, I hope you like it. Please visit us again! ", cid)
				npcHandler.topic[cid] = 0
				player:addOutfitAddon(140, 2)
				player:addOutfitAddon(132, 2)
				setPlayerStorageValue(cid, Storage.Irmana1, 1)
				if player:getStorageValue(Storage.Irmana1) == 1 and player:getStorageValue(Storage.Irmana2) == 1 then
					player:addAchievement(226) -- Achievement Aristocrat
				end
			end
		elseif npcHandler.topic[cid] == 4 then
			if(doPlayerRemoveMoney(cid, 150000) and getPlayerStorageValue(cid, Storage.Irmana2) < 1) then
				npcHandler:say("Congratulations! Here is your brand-new accessory, I hope you like it. Please visit us again! ", cid)
				npcHandler.topic[cid] = 0
				player:addOutfitAddon(140, 1)
				player:addOutfitAddon(132, 1)
				setPlayerStorageValue(cid, Storage.Irmana2, 1)
				if player:getStorageValue(Storage.Irmana1) == 1 and player:getStorageValue(Storage.Irmana2) == 1 then
					player:addAchievement(226) -- Achievement Aristocrat
				end
			end
		elseif npcHandler.topic[cid] == 5 then
			 if getPlayerItemCount(cid,2655) >= 1 then
					doPlayerRemoveItem(cid,2655,1)
				npcHandler:say("A {Red Robe}! Great. Here, take this red piece of cloth, I don\'t need it anyway.", cid)
				doPlayerAddItem(cid,5911,1)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say('Are you trying to mess with me?!', cid)
			end
		elseif npcHandler.topic[cid] == 6 then
				 if getPlayerItemCount(cid,2663) >= 1 then
				doPlayerRemoveItem(cid,2663,1)
				npcHandler:say("A {Mystic Turban}! Great. Here, take this blue piece of cloth, I don\'t need it anyway.", cid)
				doPlayerAddItem(cid,5912,1)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say('Are you trying to mess with me?!', cid)
			end
		elseif npcHandler.topic[cid] == 7 then
				 if getPlayerItemCount(cid,2652) >= 150 then
				doPlayerRemoveItem(cid,2652,150)
				npcHandler:say("A 150 {Green Tunic}! Great. Here, take this green piece of cloth, I don\'t need it anyway.", cid)
				doPlayerAddItem(cid,5910,1)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say('Are you trying to mess with me?!', cid)
			end
		elseif npcHandler.topic[cid] == 8 then
			if player:getMoney() >= 1000 then
				player:removeMoney(1000)
				player:addItem(28599, 1) -- Fur of a Wolf Whelp
				npcHandler:say("Alright. Here is the fur.", cid)
				player:setStorageValue(Storage.ThreatenedDreams.TroubledMission01, 9)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say('Are you trying to mess with me?!', cid)
			end
		end
	elseif(msgcontains(msg, "hat") or msgcontains(msg, "accessory")) and (npcHandler.topic[cid] == 2 and getPlayerStorageValue(cid, Storage.Irmana1) < 1) then
		selfSay("This accessory requires a small fee of 150000 gold pieces. Of course, we do not want to put you at any risk to be attacked while carrying this huge amount of money. ...", cid)
		selfSay("This is why we have established our brand-new instalment sale. You can choose to either pay the price at once, or if you want to be safe, by instalments of 10000 gold pieces. ...", cid)
		selfSay("I also have to inform you that once you started paying for one of the accessories, you have to finish the payment first before you can start paying for the other one, of course. ...", cid)
		npcHandler:say("Are you interested in purchasing this accessory?", cid)
		npcHandler.topic[cid] = 3
	elseif(msgcontains(msg, "dress") or msgcontains(msg, "coat")) and (npcHandler.topic[cid] == 2 and getPlayerStorageValue(cid, Storage.Irmana2) < 1) then
		selfSay("This accessory requires a small fee of 150000 gold pieces. Of course, we do not want to put you at any risk to be attacked while carrying this huge amount of money. ...", cid)
		selfSay("This is why we have established our brand-new instalment sale. You can choose to either pay the price at once, or if you want to be safe, by instalments of 10000 gold pieces. ...", cid)
		selfSay("I also have to inform you that once you started paying for one of the accessories, you have to finish the payment first before you can start paying for the other one, of course. ...", cid)
		npcHandler:say("Are you interested in purchasing this accessory?", cid)
		npcHandler.topic[cid] = 4
	elseif(msgcontains(msg, "red robe")) then
		npcHandler:say("Have you found a {Red Robe} for me?", cid)
		npcHandler.topic[cid] = 5
	elseif(msgcontains(msg, "mystic turban")) then
		npcHandler:say("Have you found a {Mystic Turban} for me?", cid)
		npcHandler.topic[cid] = 6
	elseif(msgcontains(msg, "green tunic")) then
		npcHandler:say("Have you found {150 Green Tunic} for me?", cid)
		npcHandler.topic[cid] = 7
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
