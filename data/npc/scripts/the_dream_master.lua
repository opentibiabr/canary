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
	if msgcontains(msg, "join") then
		if player:getStorageValue(Storage.OutfitQuest.BrotherhoodOutfit) < 1 and player:getStorageValue(Storage.OutfitQuest.NightmareOutfit) < 1 then
			npcHandler:say({
				"The Nightmare Knights are almost extinct now, and as far as I know I am the only teacher that is left. But you might beright and its time to accept new disciples ...",
				"After all you have passed the Dream Challenge to reach this place, which used to be the process of initiation in the past...",
				"So I ask you: do you wish to become a member of the ancient order of the Nightmare Knights, |PLAYERNAME|?"
			}, cid)
			npcHandler.topic[cid] = 1
		end
	elseif msgcontains(msg, "advancement") then
		if player:getStorageValue(Storage.OutfitQuest.NightmareOutfit) == 1 then
			npcHandler:say("So you want to advance to a {Initiate} rank? Did you bring 500 demonic essences with you?", cid)
			npcHandler.topic[cid] = 3
		elseif player:getStorageValue(Storage.OutfitQuest.NightmareOutfit) == 2 then
			npcHandler:say("So you want to advance to a {Dreamer} rank? Did you bring 1000 demonic essences with you?", cid)
			npcHandler.topic[cid] = 4
		elseif player:getStorageValue(Storage.OutfitQuest.NightmareOutfit) == 3 then
			npcHandler:say("So you want to advance to a {Lord Protector} rank? Did you bring 1500 demonic essences with you?", cid)
			npcHandler.topic[cid] = 5
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say("Please know that your decision is irrevocable. You will abandon the opportunity to join any order whose doctrine is incontrast to our own ...", cid)
			npcHandler:say("Do you still want to join our order?", cid)
			npcHandler.topic[cid] = 2
		elseif npcHandler.topic[cid] == 2 then
			npcHandler:say({
				"So I welcome you as the latest member of the order of the Nightmare Knights. You entered this place as a stranger, butyou will leave this place as a friend ...",
				"You can always ask me about your current rank and about the privileges the ranks grant to those who hold them."
			}, cid)
			player:setStorageValue(Storage.OutfitQuest.NightmareOutfit, 1)
			player:addAchievement('Nightmare Knight')
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 3 then
			if player:removeItem(6500, 500) then
				player:addItem(7845, 1)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				player:setStorageValue(Storage.OutfitQuest.NightmareOutfit, 2)
				npcHandler:say("You advanced to {Initiate} rank! You are now able to use teleports of second floor of Knightwatch Tower.", cid)
			else
				npcHandler:say("Come back when you gather all essences.", cid)
			end
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 4 then
			if player:removeItem(6500, 1000) then
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				player:setStorageValue(Storage.OutfitQuest.NightmareOutfit, 3)
				player:addItem(7846, 1)
				player:addItem(6391, 1)
				player:addAchievement('Nightmare Walker')
				npcHandler:say("You advanced to {Dreamer} rank!", cid)
			else
				npcHandler:say("Come back when you gather all essences.", cid)
			end
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 5 then
			if player:removeItem(6500, 1500) then
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				player:setStorageValue(Storage.OutfitQuest.NightmareOutfit, 4)
				player:setStorageValue(Storage.OutfitQuest.NightmareDoor, 1)
				player:setStorageValue(Storage.KnightwatchTowerDoor, 1)
				player:addAchievement('Lord Protector')
				npcHandler:say("You advanced to {Lord Protector} rank! You are now able to use teleports of fourth floor of Knightwatch Tower and to create addon scrolls.", cid)
			else
				npcHandler:say("Come back when you gather all essences.", cid)
			end
			npcHandler.topic[cid] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
