function ParseAlesarSay(npc, creature, message, npcHandler)
	local player = Player(creature)
	local playerId = player:getId()

	local missionProgress = player:getStorageValue(Storage.DjinnWar.EfreetFaction.Mission02)
	if MsgContains(message, "mission") then
		if player:getStorageValue(Storage.DjinnWar.EfreetFaction.Mission01) == 3 then
			if missionProgress < 1 then
				npcHandler:say({
					"So Baa'leal thinks you are up to do a mission for us? ...",
					"I think he is getting old, entrusting human scum such as you are with an important mission like that. ...",
					"Personally, I don't understand why you haven't been slaughtered right at the gates. ...",
					"Anyway. Are you prepared to embark on a dangerous mission for us?"
				}, npc, creature)
				npcHandler:setTopic(playerId, 1)

			elseif isInArray({1, 2}, missionProgress) then
				npcHandler:say("Did you find the tear of Daraman?", npc, creature)
				npcHandler:setTopic(playerId, 2)
			else
				npcHandler:say("Don't forget to talk to Malor concerning your next mission.", npc, creature)
			end
		end

	elseif npcHandler:getTopic(playerId) == 1 then
		if MsgContains(message, "yes") then
			npcHandler:say({
				"All right then, human. Have you ever heard of the {'Tears of Daraman'}? ...",
				"They are precious gemstones made of some unknown blue mineral and possess enormous magical power. ...",
				"If you want to learn more about these gemstones don't forget to visit our library. ...",
				"Anyway, one of them is enough to create thousands of our mighty djinn blades. ...",
				"Unfortunately my last gemstone broke and therefore I'm not able to create new blades anymore. ...",
				"To my knowledge there is only one place where you can find these gemstones - I know for a fact that the Marid have at least one of them. ...",
				"Well... to cut a long story short, your mission is to sneak into Ashta'daramai and to steal it. ...",
				"Needless to say, the Marid won't be too eager to part with it. Try not to get killed until you have delivered the stone to me."
			}, npc, creature)
			player:setStorageValue(Storage.DjinnWar.EfreetFaction.Mission02, 1)
			player:setStorageValue(Storage.DjinnWar.EfreetFaction.DoorToMaridTerritory, 1)

		elseif MsgContains(message, "no") then
			npcHandler:say("Then not.", npc, creature)
		end
		npcHandler:setTopic(playerId, 0)

	elseif npcHandler:getTopic(playerId) == 2 then
		if MsgContains(message, "yes") then
			if player:getItemCount(3233) == 0 or missionProgress ~= 2 then
				npcHandler:say("As I expected. You haven't got the stone. Shall I explain your mission again?", npc, creature)
				npcHandler:setTopic(playerId, 1)
			else
				npcHandler:say({
					"So you have made it? You have really managed to steal a Tear of Daraman? ...",
					"Amazing how you humans are just impossible to get rid of. Incidentally, you have this character trait in common with many insects and with other vermin. ...",
					"Nevermind. I hate to say it, but it you have done us a favour, human. That gemstone will serve us well. ...",
					"Baa'leal, wants you to talk to Malor concerning some new mission. ...",
					"Looks like you have managed to extended your life expectancy - for just a bit longer."
				}, npc, creature)
				player:removeItem(3233, 1)
				player:setStorageValue(Storage.DjinnWar.EfreetFaction.Mission02, 3)
				npcHandler:setTopic(playerId, 0)
			end

		elseif MsgContains(message, "no") then
			npcHandler:say("As I expected. You haven't got the stone. Shall I explain your mission again?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	end
end
