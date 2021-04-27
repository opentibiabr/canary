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

local voices = { {text = 'Uhhhhhh....'} }
npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "seventh seal") then
		npcHandler:say("If you have passed the first six seals and entered the blue fires that lead to \z
				the chamber of the seal you might receive my {kiss} ... It will open the last seal. \z
				Do you think you are ready?", cid)
		npcHandler.topic[cid] = 1
	elseif msgcontains(msg, "kiss") and npcHandler.topic[cid] == 7 then
		if player:getStorageValue(Storage.Quest.TheQueenOfTheBanshees.LastSeal) < 1 then
			npcHandler:say("Are you prepared to receive my kiss, even though this will mean that your \z
					death as well as a part of your soul will forever belong to me, my dear?", cid)
			npcHandler.topic[cid] = 8
		else
			npcHandler:say("You have already received my kiss. You should know better then to ask for it.", cid)
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, "spectral dress") then
		if player:getStorageValue(Storage.ExplorerSociety.TheSpectralDress) == 48 and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 48 and player:getStorageValue(Storage.ExplorerSociety.BansheeDoor) < 1 then
			npcHandler:say("Your wish for a spectral dress is silly. \z
					Although I will grant you the permission to take one. \z
					My maidens left one in a box in a room, directly south of here.", cid)
			player:setStorageValue(Storage.ExplorerSociety.BansheeDoor, 1)
		end
	elseif msgcontains(msg, "addon") then
		if player:getStorageValue(Storage.OutfitQuest.WizardAddon) == 5 then
			npcHandler:say("Say... I have been longing for something for an eternity now... \z
					if you help me retrieve it, I will reward you. Do you consent to this arrangement?", cid)
			npcHandler.topic[cid] = 9
		end
	elseif msgcontains(msg, "orchid") or msgcontains(msg, "holy orchid") then
		if player:getStorageValue(Storage.OutfitQuest.WizardAddon) == 6 then
			npcHandler:say("Have you really brought me 50 holy orchids?", cid)
			npcHandler.topic[cid] = 11
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 1 then
			if player:getStorageValue(Storage.Quest.TheQueenOfTheBanshees.FourthSeal) == 1 then
				npcHandler:say("The Queen of the Banshee: Yessss, I can sense you have passed the seal of sacrifice. \z
						Have you passed any other seal yet?", cid)
				npcHandler.topic[cid] = 2
			else
				npcHandler:say("You have not passed the seal of sacrifice yet. Return to me when you are better prepared.", cid)
				npcHandler.topic[cid] = 0
			end
		elseif npcHandler.topic[cid] == 2 then
			if player:getStorageValue(Storage.Quest.TheQueenOfTheBanshees.FirstSeal) == 1 then
				npcHandler:say("The Queen of the Banshee: I sense you have passed the hidden seal as well. \z
						Have you passed any other seal yet?", cid)
				npcHandler.topic[cid] = 3
			else
				npcHandler:say("You have not found the hidden seal yet. Return when you are better prepared.", cid)
				npcHandler.topic[cid] = 0
			end
		elseif npcHandler.topic[cid] == 3 then
			if player:getStorageValue(Storage.Quest.TheQueenOfTheBanshees.SecondSeal) == 1 then
				npcHandler:say("The Queen of the Banshee: Oh yes, you have braved the plague seal. \z
						Have you passed any other seal yet?", cid)
				npcHandler.topic[cid] = 4
			else
				npcHandler:say("You have not faced the plagueseal yet. Return to me when you are better prepared.", cid)
				npcHandler.topic[cid] = 0
			end
		elseif npcHandler.topic[cid] == 4 then
			if player:getStorageValue(Storage.Quest.TheQueenOfTheBanshees.ThirdSeal) == 1 then
				npcHandler:say("The Queen of the Banshee: Ah, I can sense the power of the seal of \z
						demonrage burning in your heart. Have you passed any other seal yet?", cid)
				npcHandler.topic[cid] = 5
			else
				npcHandler:say("You are not filled with the fury of the imprisoned demon. Return when you are better prepared.", cid)
				npcHandler.topic[cid] = 0
			end
		elseif npcHandler.topic[cid] == 5 then
			if player:getStorageValue(Storage.Quest.TheQueenOfTheBanshees.FifthSeal) == 1 then
				npcHandler:say("The Queen of the Banshee: So, you have managed to pass the seal of the true path. \z
						Have you passed any other seal yet?", cid)
				npcHandler.topic[cid] = 6
			else
				npcHandler:say("You have not found your true path yet. Return when you are better prepared.", cid)
				npcHandler.topic[cid] = 0
			end
		elseif npcHandler.topic[cid] == 6 then
			if player:getStorageValue(Storage.Quest.TheQueenOfTheBanshees.SixthSeal) == 1 then
				npcHandler:say("The Queen of the Banshee: I see! You have mastered the seal of logic. \z
						You have made the sacrifice, you have seen the unseen, you possess fortitude, \z
						you have filled yourself with power and found your path. You may ask me for my {kiss} now.", cid)
				npcHandler.topic[cid] = 7
			else
				npcHandler:say("You have not found your true path yet. Return to meh when you are better prepared.", cid)
				npcHandler.topic[cid] = 0
			end
		elseif npcHandler.topic[cid] == 8 then
			if not player:isPzLocked() then
				npcHandler:say("So be it! Hmmmmmm...", cid)
				npcHandler.topic[cid] = 0
				player:teleportTo({x = 32202, y = 31812, z = 8})
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				player:setStorageValue(Storage.Quest.TheQueenOfTheBanshees.LastSeal, 1)
				player:setStorageValue(Storage.Quest.TheQueenOfTheBanshees.LastSealDoor, 1)
				player:setStorageValue(Storage.Quest.TheQueenOfTheBanshees.BansheeDoor, 1)
			else
				npcHandler:say("You have spilled too much blood recently and the dead are hungry for your soul. \z
						Perhaps return when you regained you inner balance.", cid)
				npcHandler.topic[cid] = 0
			end
		elseif npcHandler.topic[cid] == 9 then
			npcHandler:say({
				"Listen... there are no blooming flowers down here and the only smell present is that of death and decay. ...",
				"I wish that I could breathe the lovely smell of beautiful flowers just one more time, \z
						especially those which elves cultivate. ...",
				"Could you please bring me 50 holy orchids?"
			}, cid)
			npcHandler.topic[cid] = 10
		elseif npcHandler.topic[cid] == 10 then
			npcHandler:say("Thank you. I will wait for your return.", cid)
			player:setStorageValue(Storage.OutfitQuest.WizardAddon, 6)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 11 then
			if player:removeItem(5922, 50) then
				npcHandler:say("Thank you! You have no idea what that means to me. As promised,here is your reward... as a follower of Zathroth, I hope that you will like this accessory.", cid)
				player:setStorageValue(Storage.OutfitQuest.WizardAddon, 7)
				player:addOutfitAddon(145, 1)
				player:addOutfitAddon(149, 1)
				player:addAchievement('Warlock')
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("You need 50 holy orchid.", cid)
				npcHandler.topic[cid] = 0
			end
		end
	elseif msgcontains(msg, "no") then
		if npcHandler.topic[cid] >= 1 and npcHandler.topic[cid] <= 7 then
			npcHandler:say("Then try to be better prepared next time we meet.", cid)
		elseif npcHandler.topic[cid] == 8 then
			npcHandler:say("Perhaps it is the better choice for you, my dear.", cid)
		end
	end
	return true
end

keywordHandler:addKeyword({'stay'}, StdModule.say, 
	{
		npcHandler = npcHandler,
		text = "It's my curse to be the eternal {guardian} of this ancient {place}."
	}
)
keywordHandler:addKeyword({'guardian'}, StdModule.say, 
	{
		npcHandler = npcHandler,
		text = "I'm the {guardian} of the {SEVENTH} and final seal. The seal to open the last door before ... \z
			but perhaps it's better to see it with your own eyes."
	}
)
keywordHandler:addKeyword({'place'}, StdModule.say, 
	{
		npcHandler = npcHandler,
		text = "It served as a temple, a source of power and ... \z
			as a sender for an ancient {race} which lived a long time ago and has long been forgotten."
	}
)
keywordHandler:addKeyword({'race'}, StdModule.say, 
	{
		npcHandler = npcHandler,
		text = "The race that built this edifice came to this place from the stars. \z
			They ran from an enemy even more horrible than themselves. \z
			But they carried the {seed} of their own destruction in them."
	}
)
keywordHandler:addKeyword({'seed'}, StdModule.say, 
	{
		npcHandler = npcHandler,
		text = "This ancient race was annihilated by its own doings, that's all I know. \z
			Aeons have passed since then, but the sheer presence of this {complex} is still defiling and desecrating this area."
	}
)
keywordHandler:addKeyword({'complex'}, StdModule.say, 
	{
		npcHandler = npcHandler,
		text = "Its constructors were too strange for you or even me to understand. \z
			We don't know what this ... thing they built was supposed to be good for. \z
			I feel a constant twisting and binding of souls, though, that is probably only a side-effect."
	}
)
keywordHandler:addKeyword({'ghostlands'}, StdModule.say, 
	{
		npcHandler = npcHandler,
		text = "The place you know as the Ghostlands had a different name once ... \z
			and many names after. Too many to remember them all."
	}
)
keywordHandler:addKeyword({'banshee'}, StdModule.say, 
	{
		npcHandler = npcHandler,
		text = "They are my maidens. They give me comfort in my eternal watch over the last seal."
	}
)

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:setMessage(MESSAGE_GREET, "Be greeted, dear visitor. Come and {stay} ... a while.")
npcHandler:setMessage(MESSAGE_FAREWELL, "We will meet again, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Yes, flee from death. But know it shall be always one step behind you.")

npcHandler:addModule(FocusModule:new())
