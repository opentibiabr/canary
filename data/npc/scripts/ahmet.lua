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
	if msgcontains(msg, 'documents') then
		if player:getStorageValue(Storage.ThievesGuild.Mission04) == 2 then
			player:setStorageValue(Storage.ThievesGuild.Mission04, 3)
			npcHandler:say({
				'You need some forged documents? But I will only forge something for a friend. ...',
				'The nomads at the northern oasis killed someone dear to me. Go and kill at least one of them, then we talk about your document.'
			}, cid)
		elseif player:getStorageValue(Storage.ThievesGuild.Mission04) == 4 then
			npcHandler:say('The slayer of my enemies is my friend! For a mere 1000 gold I will create the documents you need. Are you interested?', cid)
			npcHandler.topic[cid] = 1
		end
	elseif msgcontains(msg, 'mission') or msgcontains(msg, 'quest') then
		if player:getStorageValue(Storage.QuestChests.StealFromThieves) < 1 then
			npcHandler:say({
				"What are you talking about?? I was robbed!!!! Someone catch those filthy thieves!!!!! GUARDS! ...",
				"<nothing happens>....<SIGH> Like usual, they hide at the slightest sign of trouble! YOU! Want to earn some quick money?"
			}, cid)
			npcHandler.topic[cid] = 2
		elseif player:getStorageValue(Storage.QuestChests.StealFromThieves) == 1 or player:getStorageValue(Storage.QuestChests.StealFromThieves) == 2 then
			npcHandler:say('Did you find my stuff?', cid)
			npcHandler.topic[cid] = 3
		end
	elseif msgcontains(msg, 'book') then
		npcHandler:say('I see: You want me to add an additional story to this book. A legend about how it brings ill luck to kill a white deer. I could do that, yes. It costs 5000 gold, however. Are you still interested?', cid)
		npcHandler.topic[cid] = 5
	elseif msgcontains(msg, 'yes') then
		if npcHandler.topic[cid] == 1 then
			if player:removeMoneyNpc(1000) then
				player:addItem(8694, 1)
				player:setStorageValue(Storage.ThievesGuild.Mission04, 5)
				npcHandler:say('And here they are! Now forget where you got them from.', cid)
			else
				npcHandler:say('You don\'t have enough money.', cid)
			end
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 2 then
			npcHandler:say({
				"Of course you do! Go hunt down the thieves and bring back the stuff they have stolen from me. ...",
				" I saw them running out of town and then to the north. Maybe they hide at the oasis."
			}, cid)
			npcHandler.topic[cid] = 0
			player:setStorageValue(Storage.QuestChests.StealFromThieves, 1)
		elseif npcHandler.topic[cid] == 3 then
			if player:removeItem(7587, 1) then
				npcHandler:say('GREAT! If you ever need a job as my personal security guard, let me know. Here is the reward I promised you.', cid)
				player:setStorageValue(Storage.QuestChests.StealFromThieves, 3)
				player:addItem(2148, 100)
				player:addItem(2789, 100)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say('Come back when you find my stuff.', cid)
				npcHandler.topic[cid] = 0
			end
		elseif npcHandler.topic[cid] == 5 then
			if (player:getStorageValue(Storage.ThreatenedDreams.TroubledMission01) == 2) then
				if ( (player:getItemCount(28596) >= 1) and (player:getMoney() > 5000) )then
					player:removeMoney(5000)
					npcHandler:say({
						"Well then. Here, take the book, I added the story. Oh, just a piece of advice: Not to inflame prejudice but poachers are of rather simple disposition. I doubt they are ardent readers. ...",
						"So if you want to make sure they read this anytime soon, perhaps don't hide the book in a shelf or chest. Make sure to place it somewhere where they will find it easily, like very obviously on a table or something."
					}, cid)
					player:setStorageValue(Storage.ThreatenedDreams.TroubledMission01, 3)
					npcHandler.topic[cid] = 0
				else
					npcHandler:say("You need 5000 gps and book with ancient legends.", cid)
				end
			else
				npcHandler:say("You have already completed this mission.", cid)
				npcHandler.topic[cid] = 0
			end
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
