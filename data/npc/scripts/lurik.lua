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
	local player = Player(cid)
	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "mission") then
		if player:getStorageValue(Storage.ExplorerSociety.TheAstralPortals) == 56 and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 56 then
			npcHandler:say("Ah, you've just come in time. An experienced explorer is just what we need here! Would you like to go on a mission for us?", cid)
			npcHandler.topic[cid] = 1
		elseif player:getStorageValue(Storage.ExplorerSociety.TheIslandofDragons) == 58 and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 58 then
			if player:removeItem(7314, 1) then
				npcHandler:say({
					"A frozen dragon lord? This is just the information we needed! And you even brought a scale from it! Take these 5000 gold pieces as a reward. ...",
					"As you did such a great job, I might have another mission for you later."
				}, cid)
				player:addItem(2152, 50)
				player:setStorageValue(Storage.ExplorerSociety.TheIslandofDragons, 59)
				player:setStorageValue(Storage.ExplorerSociety.QuestLine, 59)
			else
				npcHandler:say("You're not done yet...", cid)
			end
		elseif player:getStorageValue(Storage.ExplorerSociety.TheIslandofDragons) == 59 and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 59 then
			npcHandler:say({
				"Ah, yes, the mission. Let me tell you about something called ice music. ...",
				"There is a cave on Hrodmir, north of the southernmost barbarian camp Krimhorn. ...",
				"In this cave, there are a waterfall and a lot of stalagmites. ...",
				"When the wind blows into this cave and hits the stalagmites, it is supposed to create a sound similar to a soft song. ...",
				"Please take this resonance crystal and use it on the stalagmites in the cave to record the sound of the wind."
			}, cid)
			player:setStorageValue(Storage.ExplorerSociety.TheIceMusic, 60)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 60)
			player:addItem(7242, 1)
		elseif player:getStorageValue(Storage.ExplorerSociety.TheIceMusic) == 61 and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 61 and player:removeItem(7315, 1) then
			npcHandler:say({
				"Ah! You did it! I can't wait to hear the sound... but I will do that in a silent moment. ...",
				"You helped as much in our research here. As a reward, you may use our astral portal in the upper room from now on. ...",
				"For just one orichalcum pearl, you can travel between Liberty Bay and Svargrond. Thank you again!"
			}, cid)
			npcHandler.topic[cid] = 0
			player:setStorageValue(Storage.ExplorerSociety.TheIceMusic, 62)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 62)
			player:setStorageValue(Storage.ExplorerSociety.IceMusicDoor, 1)
		elseif player:getStorageValue(Storage.TheIceIslands.Questline) == 32 then
			npcHandler:say({
				"You are the one who became an honorary barbarian! The one who made friends with the grim local musher and helped the shamans of Nibelor! The one they call old bearhugg ... erm ... I mean indeed I might have a mission for someone like you ...",
				"We are trying to find out what is happening in the raider camps. Through our connection to the shamans we could get a covered contact in their majorcamp far to the south. We equipped our contact with a memory crystal so he could report all he knew ...",
				"We need you to recover this crystal. Travel to the southern camp of the raiders and find our contact man there. Get the memory crystal and bring ithere. The society and the shamans will then decide our next steps. Do you think you can do this?"
			}, cid)
			npcHandler.topic[cid] = 2
		elseif player:getStorageValue(Storage.TheIceIslands.Questline) == 33 then
			npcHandler:say("Have you retrieved the memory crystal?", cid)
			npcHandler.topic[cid] = 3
		elseif player:getStorageValue(Storage.TheIceIslands.Questline) == 34 and player:getStorageValue(Storage.TheIceIslands.MemoryCrystal) > os.time() then
			npcHandler:say("Give me some more time!", cid)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.TheIceIslands.Questline) == 34 and player:getStorageValue(Storage.TheIceIslands.MemoryCrystal) < os.time() then
			npcHandler:say({
				"The information was quite useful. What worries me most are not the raiders but those that have driven them from the old mines...",
				"We need to investigate the mines. Most entrances collapsed due to the lack of maintenance but there should be some possibilities to get in ...",
				"In case you find a door, Ill tell you the old trick of the Carlin mining company to open it <whisper> <whisper>. Find some hint or someone who is willing to talk about what is going on there."
			}, cid)
			npcHandler.topic[cid] = 0
			player:setStorageValue(Storage.TheIceIslands.Questline, 35)
			player:setStorageValue(Storage.TheIceIslands.Mission09, 1) -- Questlog The Ice Islands Quest, Formorgar Mines 1: The Mission
		end
	elseif msgcontains(msg, "yes") then
		-- ISLAND OF DRAGONS
		if npcHandler.topic[cid] == 1 then
			npcHandler:say({
				"Now we're talking! Maybe you've already heard of the island Okolnir south of Hrodmir. ...",
				"Okolnir is the home of a new and fierce dragon race, the so-called frost dragons. However, we have no idea where they originate from. ...",
				"Rumours say that dragon lords, that roamed on this isle, were somehow turned into frost dragons when the great frost covered Okolnir. ...",
				"Travel to Okolnir and try to find a proof for the existence of dragon lords there in the old times. I think old Buddel might be able to bring you there."
			}, cid)
			npcHandler.topic[cid] = 0
			player:setStorageValue(Storage.ExplorerSociety.TheIslandofDragons, 57)
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 57)
		-- ISLAND OF DRAGONS
		elseif npcHandler.topic[cid] == 2 then
			npcHandler:say("Excellent. Just report about your mission when you got the memory crystal.", cid)
			player:setStorageValue(Storage.TheIceIslands.Questline, 33)
			player:setStorageValue(Storage.TheIceIslands.Mission08, 2) -- Questlog The Ice Islands Quest, The Contact
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 3 then
			if player:removeItem(7281, 1) then
				npcHandler:say("Ah, great. Please give me some time to evaluate the information. Then talk to me again about your mission. ", cid)
				player:setStorageValue(Storage.TheIceIslands.Questline, 34)
				player:setStorageValue(Storage.TheIceIslands.Mission08, 4) -- Questlog The Ice Islands Quest, The Contact
				player:setStorageValue(Storage.TheIceIslands.MemoryCrystal, os.time() + 5 * 60)
				npcHandler.topic[cid] = 0
			end
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
