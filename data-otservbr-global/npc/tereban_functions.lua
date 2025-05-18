local topic = {}

local storages = {
	Storage.Quest.U8_6.AFathersBurden.Sinew,
	Storage.Quest.U8_6.AFathersBurden.Wood,
	Storage.Quest.U8_6.AFathersBurden.Cloth,
	Storage.Quest.U8_6.AFathersBurden.Silk,
	Storage.Quest.U8_6.AFathersBurden.Crystal,
	Storage.Quest.U8_6.AFathersBurden.Root,
	Storage.Quest.U8_6.AFathersBurden.Iron,
	Storage.Quest.U8_6.AFathersBurden.Scale,
}

TerebanConfig = {
	["strong sinew"] = {
		storage = Storage.Quest.U8_6.AFathersBurden.Sinew,
		messages = {
			deliever = "Do you have the required sinew?",
			success = "Ah, not only did you bring some sinew to me, you also made the world a safer place by killing Heoni.",
			failure = "Sorry, you must be wrong. Perhaps Heoni was out to hunt when you were looking for it. Search in the mountains of Edron. I put my trust in your abilities.",
			no = "Perhaps Heoni was out to hunt when you were looking for it. Search in the mountains of Edron. I put my trust in your abilities.",
			done = "Your bravery earned us this excellent sinew.",
		},
		itemId = 11548, -- Strong sinew
	},
	["exquisite wood"] = {
		storage = Storage.Quest.U8_6.AFathersBurden.Wood,
		messages = {
			deliever = "Could you find the wood we were talking about?",
			success = "Thank you. I feel somewhat embarrassed to put you into such a danger for some birthday present but I am sure you can handle it.",
			failure = { "Sorry, you must be wrong. The wood that I need should be in one of the barbarian camps. ...", "It seems logical to search the most northern camp first, it is closest to the place where the tree was cut. Please hurry, there is still so much to do before the birthday." },
			no = "The wood that I need should be in one of the barbarian camps. It seems logical to search the most northern camp first, it is closest to the place where the tree was cut. Please hurry, there is still so much to do before the birthday.",
			done = "The wood you have found is just what we needed.",
		},
		itemId = 11547, -- Exquisite wood
	},
	["spectral cloth"] = {
		storage = Storage.Quest.U8_6.AFathersBurden.Cloth,
		messages = {
			deliever = "Could you find the cloth I am looking for?",
			success = "It looks a bit scary but I guess sorcerers might even find that appealing. Thank you very much.",
			failure = "Sorry, you must be wrong. You will find it somewhere in the crypts under the Isle of the Kings. You will probably have to look for hidden caves when you don't find it at an obvious place. Perhaps you even need a shovel or a pick.",
			no = "Don't forget, you will find it somewhere in the crypts under the Isle of the Kings. You will probably have to look for hidden caves when you don't find it at an obvious place. Perhaps you even need a shovel or a pick.",
			done = "Thanks to your efforts we have a suitable piece of spectral cloth.",
		},
		itemId = 11546, -- Spectral cloth
	},
	["exquisite silk"] = {
		storage = Storage.Quest.U8_6.AFathersBurden.Silk,
		messages = {
			deliever = "So you've found the silk that I need?",
			success = "Great. I better don't think about how big a spider has to be to produce such strands of silk.",
			failure = "Sorry, you must be wrong. Search the spider caves of the continent Zao for the silk. They have to be somewhere in the east of Zao's southern part. My sources claim there you will find the silk that we need.",
			no = "Then search the spider caves of the continent Zao for the silk. They have to be somewhere in the east of Zao's southern part. My sources claim there you will find the silk that we need.",
			done = "The silk you have brought me is exquisite indeed.",
		},
		itemId = 11545, -- Exquisite silk
	},
	["magic crystal"] = {
		storage = Storage.Quest.U8_6.AFathersBurden.Crystal,
		messages = {
			deliever = "Did you find the required crystal?",
			success = "Oh look at the colours and sparkles. This crystal is truly remarkable, thank you.",
			failure = { "Sorry, you must be wrong. It is probably not easy to find the crystal that we need in such a huge desert which may contain several tombs, but please don't give up. ...", "According to my sources the tomb we are looking for is east of Ankrahmun. You probably need a shovel to enter it. We still have some time and I am convinced you will find it." },
			no = { "It is probably not easy to find the crystal that we need in such a huge desert which may contain several tombs, but please don't give up. ...", "According to my sources the tomb we are looking for is east of Ankrahmun. You probably need a shovel to enter it. We still have some time and I am convinced you will find it." },
			done = "The crystal you have found is absolutely flawless. You did a great job indeed.",
		},
		itemId = 11552, -- Magical crystal
	},
	["mystic root"] = {
		storage = Storage.Quest.U8_6.AFathersBurden.Root,
		messages = {
			deliever = "Could you find the root which we are looking for?",
			success = "You are admirably determined in fulfilling your task. I will make sure that my sons appreciate what you did for their presents.",
			failure = "Sorry, you must be wrong. The best advice I can give you is to look underground beneath the city for a suitable root.",
			no = "The best advice I can give you is to look underground beneath the city for a suitable root.",
			done = "It is even recognisable for me that the root you gave me is filled with magic.",
		},
		itemId = 11551, -- Mystic root
	},
	["old iron"] = {
		storage = Storage.Quest.U8_6.AFathersBurden.Iron,
		messages = {
			deliever = "Have you found the iron that we need for the present?",
			success = "I wish there'd an easier way to get that iron but those dwarfs are so stubborn. However, now we got what we need.",
			failure = "Sorry, you must be wrong. I know it's not easy to find this iron but there has to be some in the deposits beneath the old Kazordoon mines. I doubt that it can be found in the newer mines outside of Kazordoon.",
			no = "I know it's not easy to find this iron but there has to be some in the deposits beneath the old Kazordoon mines. I doubt it that it can be found in the newer mines outside of Kazordoon.",
			done = "The iron that you've found will make an ideal base for a shield.",
		},
		itemId = 11549, -- Old iron
	},
	["flexible dragon scale"] = {
		storage = Storage.Quest.U8_6.AFathersBurden.Scale,
		messages = {
			deliever = "Could you get Glitterscale's scales yet?",
			success = "These scales must have belonged to a fearsome beast. I envy you for your bravery.",
			failure = "Sorry, you must be wrong. Oh please, search for Glitterscale. It should not be too hard to find it in those caves north of Thais.",
			no = "Oh please, search for Glitterscale. It should not be too hard to find it in those caves north of Thais.",
			done = "Only someone as daring as you could slay the beast to get the necessary scales.",
		},
		itemId = 11550, -- Flexibe dragon scale
	},
}
local ThreatenedDreams = Storage.Quest.U11_40.ThreatenedDreams

function ClearTerebanMessages(npc, creature)
	local player = Player(creature)
	local playerId = player:getId()
	topic[playerId] = nil
end

function ParseTerebanSay(npc, creature, message, npcHandler)
	local player = Player(creature)
	local playerId = player:getId()
	if npcHandler:getTopic(playerId) == 0 then
		if MsgContains(message, "cloak") then
			if player:getStorageValue(ThreatenedDreams.Mission01[1]) == 12 then
				npcHandler:say({
					"I met this troll when he was hanging around near the town. He carried something I would consider rather uncharacteristic for a troll: a stunningly beautiful cloak entirely made of white feathers. I was curious and asked him if he would sell it. ...",
					"He seemed to be more interested in some of my coins and a piece of meat than in this unusual garment. Therefore, we made a trade: He got some meat and coins and I got the cloak. ...",
					"I had a clue that it was a magical item but nobody in Edron knew something about it. As I have a very lettered friend in Darashia I took a magical carpet flight to visit him and ask him about the cloak. ...",
					"But then something very annoying happened: During the flight the wind blew so strongly that it tattered the cloak. Feather after feather was blown off the carpet but I didn't realise it. ...",
					"When I reached Darashia there was no cloak just a handful of feathers. *sighs* I'm not sure whether it makes sense to search for these feathers. There was a small wind gust when we were still above Edron. ...",
					"But the actual storm began when we were in the air above the Darama. The feathers are now scattered all over the desert I guess. Rather futile to look out for them but if you really want to try: ...",
					"The magic carpet made a beeline from Edron to Darashia. You should search along this line on the ground. Good luck!",
				}, npc, creature)
				player:setStorageValue(ThreatenedDreams.Mission01[1], 13)
				player:setStorageValue(ThreatenedDreams.Mission01.FeathersCount, 0) -- Start Mission 'Tattered Swan Feathers'
			else
				npcHandler:say("You are not on that mission.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif MsgContains(message, "mission") then
			if player:getStorageValue(Storage.Quest.U8_6.AFathersBurden.Status) == 1 then
				if player:getStorageValue(Storage.Quest.U8_6.AFathersBurden.Progress) ~= 8 then
					npcHandler:say("Well, I need the parts of a sorcerer's robe, a paladin's bow, a knight's shield, and a druid's rod. If you cannot find one of them, ask me about it and I might provide you with some minor hints.", npc, creature)
					return true
				end

				player:setStorageValue(Storage.Quest.U8_6.AFathersBurden.Status, 2)
				player:addItem(oldCape, 1)
				player:addExperience(8000, true)
				npcHandler:say({
					"I'm so glad I finally have all the parts for the presents. Your reward is my eternal gratitude. Well, that and some gold of course. ...",
					"Take this sachet over there, I wrapped the coins into this old cape I had still lying around here from a barter with a stranger, it is of no use for me anyway. Farewell and thank you once again.",
				}, npc, creature)
			elseif player:getStorageValue(Storage.Quest.U8_6.AFathersBurden.Status) == 2 then
				npcHandler:say("Thank you for your help!", npc, creature)
				return true
			else
				npcHandler:say({
					"I have four sons which are very dear to me. Though they were born on the same day and even in the same hour, they took quite different paths in life. ...",
					"Each of them chose a different vocation, one will become a knight, one a sorcerer, one a druid, and the other a paladin. In a few weeks they will reach adulthood and I am holding a birthday party for them. ...",
					"It should become a day to remember and so I want to give them something special as a present. I searched the land for the finest craftsmen so they could create suitable presents for my sons. ...",
					"But something of fine craftsmanship will just not cut it. So I asked them what they would need to create something special. They all came up with lists of rare and expensive items necessary for the task ahead. ...",
					"I spent a small fortune to buy most of the materials but in the end the key components are that rare that they cannot be simply bought somewhere. ...",
					"As far as I understood it, the places where you can get these items are quite dangerous and so it would take some adventurer to get them. ...",
					"That would be your mission if you are interested. Uhm, so are you interested?",
				}, npc, creature)
				npcHandler:setTopic(playerId, 1)
			end
		elseif TerebanConfig[message:lower()] then
			local targetMessage = TerebanConfig[message:lower()]
			if player:getStorageValue(targetMessage.storage) == 2 then
				npcHandler:say(targetMessage.messages.done, npc, creature)
				return true
			end

			npcHandler:say(targetMessage.messages.deliever, npc, creature)
			npcHandler:setTopic(playerId, 2)
			topic[playerId] = targetMessage
		end
	elseif npcHandler:getTopic(playerId) == 1 then
		if MsgContains(message, "yes") then
			npcHandler:say("I am relieved someone as capable as you will handle the task. Well, I need the parts of a sorcerer's robe, a paladin's bow, a knight's shield, and a druid's wand.", npc, creature)
			player:setStorageValue(Storage.Quest.U8_6.AFathersBurden.QuestLog, 1)
			player:setStorageValue(Storage.Quest.U8_6.AFathersBurden.Progress, 0)
			player:setStorageValue(Storage.Quest.U8_6.AFathersBurden.Status, 1)
			for i = 1, #storages do
				player:setStorageValue(storages[i], 1)
			end
		elseif MsgContains(message, "no") then
			npcHandler:say("Oh my. I really hope you will change your mind.", npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	elseif npcHandler:getTopic(playerId) == 2 then
		local targetMessage = topic[playerId]
		if MsgContains(message, "yes") then
			if not player:removeItem(targetMessage.itemId, 1) then
				npcHandler:say(targetMessage.messages.failure, npc, creature)
				return true
			end

			player:setStorageValue(targetMessage.storage, 2)
			player:setStorageValue(Storage.Quest.U8_6.AFathersBurden.Progress, player:getStorageValue(Storage.Quest.U8_6.AFathersBurden.Progress) + 1)
			player:addExperience(2500, true)
			npcHandler:say(targetMessage.messages.success, npc, creature)
		elseif MsgContains(message, "no") then
			npcHandler:say(targetMessage.messages.no, npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	end
end
