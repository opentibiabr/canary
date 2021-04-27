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
		if player:getStorageValue(Storage.toOutfoxAFoxQuest) < 1 then
			npcHandler:say({
				"Funny that you are asking me for a mission! There is indeed something you can do for me. Ever heard about The Horned Fox? Anyway, yesterday his gang has stolen my mining helmet during a raid. ...",
				"It belonged to my father and before that to my grandfather. That helmet is at least 600 years old! I need it back. Are you willing to help me?"
			}, cid)
			npcHandler.topic[cid] = 1

		elseif player:getStorageValue(Storage.toOutfoxAFoxQuest) == 1 then
			if player:removeItem(7497, 1) then
				player:setStorageValue(Storage.toOutfoxAFoxQuest, 2)
				player:addItem(7939, 1)
				npcHandler:say("I always said it to the others 'This brave fellow will bring me my mining helmet back' and here you are with it!! Here take my spare helmet, I don't need it anymore!", cid)
			else
				npcHandler:say("We presume the hideout of The Horned Fox is somewhere in the south-west near the coast, good luck finding my mining helmet!", cid)
			end
			npcHandler.topic[cid] = 0
			else npcHandler:say("Hum... what, {task}?", cid)
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 1 then
			player:setStorageValue(Storage.toOutfoxAFoxQuest, 1)
			npcHandler:say("I knew you have the guts for that task! We presume the hideout of The Horned Fox somewhere in the south-west near the coast. Good luck!", cid)
			npcHandler.topic[cid] = 0

			elseif npcHandler.topic[cid] == 2 then
			npcHandler:say("Hussah! Let's bring war to those hoof-legged, dirt-necked, bull-headed minotaurs!! Come back to me when you are done with your mission.", cid)
			player:setStorageValue(JOIN_STOR, 1)
			player:setStorageValue(Storage.KillingInTheNameOf.BudrikMinos, 1)
			player:setStorageValue(Storage.KillingInTheNameOf.BudrikMinosCount, 0)
			npcHandler.topic[cid] = 0


			else npcHandler:say("Zzz...", cid)

		end
		elseif msgcontains(msg, "task") then
		-- AQUI
		if player:getStorageValue(Storage.KillingInTheNameOf.BudrikMinos) <= 0 then
			npcHandler:say({
				"I am so angry I could spit grit! That damn Horned Fox and his attacks! Let's show those bull-heads that they have messed with the wrong people....",
				"I want you to kill {5000 minotaurs} - no matter where - for me and all the dwarfs of Kazordoon! Are you willing to do that?"
			}, cid)
			npcHandler.topic[cid] = 2
		elseif player:getStorageValue(Storage.KillingInTheNameOf.BudrikMinos) == 1 then
			if player:getStorageValue(Storage.KillingInTheNameOf.BudrikMinosCount) >= 5000 then
				npcHandler:say({
					"By all that is holy! You are a truly great warrior! With much patience! I have just found out the location the hideout of {The Horned Fox}! I have marked the spot on your map so you can find it. Go there and slay him!! Good luck!"
				}, cid)
				player:setStorageValue(17522, 1)
				player:setStorageValue(Storage.KillingInTheNameOf.BudrikMinos, 2)
			else
				npcHandler:say("Come back when you have slain {5000 minotaurs!}", cid)
			end
		elseif player:getStorageValue(Storage.KillingInTheNameOf.BudrikMinos) == 2 then
			npcHandler:say({
				"It was very decent of you to help me, and I am thankful, really I am, but now I have to get back to my duties as a foreman."
			}, cid)
			player:setStorageValue(Storage.KillingInTheNameOf.BudrikMinos, 3)
		elseif player:getStorageValue(Storage.KillingInTheNameOf.BudrikMinos) == 3 then
			npcHandler:say("You already done this task.", cid)
			npcHandler.topic[cid] = 0
			else npcHandler:say("You need to do the {To Outfox a Fox Quest} before.", cid)
		end
		-- AQUI

		-- YES AQUI

	elseif msgcontains(msg, "no") then
		if npcHandler.topic[cid] > 1 then
			npcHandler:say("Then no.", cid)
			npcHandler.topic[cid] = 0
		end
	end
		-- YES AQUI

	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "Bye, bye.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Bye, bye.")
npcHandler:setMessage(MESSAGE_GREET, "Hiho, hiho |PLAYERNAME|.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
