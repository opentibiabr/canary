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

local voices = {
	{text = "Great spirit potions as well as health and mana potions in different sizes!"},
	{text = "If you need alchemical fluids like slime and blood, get them here."}
}

npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	local player = Player(cid)
	if isInArray({"vial", "ticket", "bonus", "deposit"}, msg) then
		if player:getStorageValue(Storage.OutfitQuest.MageSummoner.AddonBelt) < 1 then
			npcHandler:say(
				"You have " ..
				player:getStorageValue(38412) ..
				" credits. We have a special offer right now for depositing vials. Are you interested in hearing it?",
			cid)
			npcHandler.topic[cid] = 1
		elseif player:getStorageValue(Storage.OutfitQuest.MageSummoner.AddonBelt) >= 1 then
			npcHandler:say("Would you like to get a lottery ticket instead of the deposit for your vials?", cid)
			npcHandler.topic[cid] = 3
		end
	elseif msgcontains(msg, "prize") then
		npcHandler:say("Are you here to claim a prize?", cid)
		npcHandler.topic[cid] = 4
	elseif msgcontains(msg, "fafnar fire") then
		if player:getStorageValue(Storage.TheShatteredIsles.RaysMission1) == 1 then
			npcHandler:say("Pssht, not that loud. So they have sent you to get... the stuff?", cid)
			npcHandler.topic[cid] = 5
		end
	elseif msgcontains(msg, "your continued existence is payment enough") then
		if npcHandler.topic[cid] == 6 then
			if player:getStorageValue(Storage.TheShatteredIsles.RaysMission1) == 1 then
				npcHandler:say(
					"What?? How dare you?! I am a sorcerer of the most reknown academy on the face of this world. \
					Do you think some lousy pirates could scare me? Get lost! Now! \
					I will have no further dealings with the likes of you!",
				cid)
				player:setStorageValue(Storage.TheShatteredIsles.RaysMission1, 2)
				npcHandler.topic[cid] = 0
			end
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say(
				{
					"The Edron academy has introduced a bonus system. Each time you deposit 100 vials without \
					claiming the money for it, you will receive a lottery ticket. ...",
					"Some of these lottery tickets will grant you a special potion belt accessory, \
					if you bring the ticket to me. ...",
					"If you join the bonus system now, I will ask you each time you are bringing back 100 or \
					more vials to me whether you claim your deposit or rather want a lottery ticket. ...",
					"Of course, you can leave or join the bonus system at any time by just asking me for the 'bonus'. ...",
					"Would you like to join the bonus system now?"
				},
			cid)
			npcHandler.topic[cid] = 2
		elseif npcHandler.topic[cid] == 2 then
			npcHandler:say(
				"Great! I've signed you up for our bonus system. From now on, \
				you will have the chance to win the potion belt addon!",
			cid)
			player:setStorageValue(Storage.OutfitQuest.MageSummoner.AddonBelt, 1)
			player:setStorageValue(Storage.OutfitQuest.DefaultStart, 1) --this for default start of Outfit and Addon Quests
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 3 then
			if player:getStorageValue(38412) >= 100
			or player:removeItem(7634, 100)
			or player:removeItem(7635, 100)
			or player:removeItem(7636, 100) then
				npcHandler:say(
					"Alright, thank you very much! Here is your lottery ticket, good luck. \
					Would you like to deposit more vials that way?",
				cid)
				player:setStorageValue(38412, player:getStorageValue(38412) - 100)
				player:addItem(5957, 1)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say(
					"Sorry, but you don't have 100 empty flasks or vials of the SAME kind and thus don't qualify for the lottery. \
					Would you like to deposit the vials you have as usual and receive 5 gold per vial?",
				cid)
				npcHandler.topic[cid] = 0
			end
		elseif npcHandler.topic[cid] == 4 then
			if player:getStorageValue(Storage.OutfitQuest.MageSummoner.AddonBelt) == 1 and player:removeItem(5958, 1) then
				npcHandler:say("Congratulations! Here, from now on you can wear our lovely potion belt as accessory.", cid)
				player:setStorageValue(Storage.OutfitQuest.MageSummoner.AddonBelt, 2)
				player:addOutfitAddon(138, 1)
				player:addOutfitAddon(133, 1)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			else
				npcHandler:say("Sorry, but you don't have your lottery ticket with you.", cid)
			end
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 5 then
			if player:getStorageValue(Storage.TheShatteredIsles.RaysMission1) == 1 then
				npcHandler:say(
					"Finally. You have no idea how difficult it is to keep something secret here. \
					And you brought me all the crystal coins I demanded?",
				cid)
				npcHandler.topic[cid] = 6
			end
		end
		return true
	end
end

keywordHandler:addKeyword(
	{"shop"},
	StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I sell potions and fluids. If you'd like to see my offers, ask me for a {trade}."
	}
)

npcHandler:setMessage(MESSAGE_GREET, "Hello |PLAYERNAME|, welcome to the fluid and potion {shop} of Edron.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye, |PLAYERNAME|, please come back soon.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye, |PLAYERNAME|, please come back soon.")
npcHandler:setMessage(
	MESSAGE_SENDTRADE,
	"Of course, just browse through my wares. By the way, if you'd like to join our bonus \
	system for depositing flasks and vial, you have to tell me about that {deposit}."
)

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
