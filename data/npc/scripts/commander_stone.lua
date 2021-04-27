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

	if(msgcontains(msg, "mission")) then
		if player:getStorageValue(Storage.BigfootBurden.QuestLine) == 25 then
			npcHandler:say({"Two missions are available for your {rank}: crystal {keeper} and {spark} hunting. You can undertake each mission but you can turn in a specific mission only once each 20 hours. ...",
				"If you lose a mission item you can probably buy it from Gnomally."}, cid)
			npcHandler.topic[cid] = 0
		elseif player:getStorageValue(Storage.BigfootBurden.QuestLine) >= 26 then
			npcHandler:say({"For your {rank} there are four missions avaliable: crystal {keeper}, {spark} hunting, monster {extermination} and mushroom {digging}. By the way, you {rank} now allows you to take aditional missions from {Gnomeral} in {Gnomebase Alpha}. ... ", "If you lose a mission item you can probably buy it from Gnomally."}, cid)
			npcHandler.topic[cid] = 0
		end

	-- Crystal Kepper
	elseif msgcontains(msg, "keeper") then
		if player:getStorageValue(Storage.BigfootBurden.QuestLine) >= 25 then
			if player:getStorageValue(Storage.BigfootBurden.MissionCrystalKeeper) < 1 and player:getStorageValue(Storage.BigfootBurden.CrystalKeeperTimout) < os.time() then
				npcHandler:say("You will have to repair some damaged crystals. Go into the Crystal grounds and repair them, using this harmonic crystal. Repair five of them and return to me. ", cid)
				player:setStorageValue(Storage.BigfootBurden.MissionCrystalKeeper, 1)
				player:setStorageValue(Storage.BigfootBurden.RepairedCrystalCount, 0)
				player:addItem(18219, 1)   --- taking missions
			elseif player:getStorageValue(Storage.BigfootBurden.CrystalKeeperTimout) > os.time() then  -- trying to take mission while in cooldown
				npcHandler:say("Sorry, you will have to wait before you can undertake this mission again.", cid)
			elseif player:getStorageValue(Storage.BigfootBurden.MissionCrystalKeeper) > 0 then  -- reporting mission
				if player:getStorageValue(Storage.BigfootBurden.RepairedCrystalCount) >= 5 then -- can report missions
					player:removeItem(18219, 1)
					player:setStorageValue(Storage.BigfootBurden.Rank, player:getStorageValue(Storage.BigfootBurden.Rank) + 5)
					player:addItem(18422, 1)
					player:addItem(18215, 1)
					player:setStorageValue(Storage.BigfootBurden.MissionCrystalKeeper, 0)
					player:setStorageValue(Storage.BigfootBurden.CrystalKeeperTimout, os.time() + 20 * 60 * 60)
					player:setStorageValue(Storage.BigfootBurden.RepairedCrystalCount, -1)
					player:addAchievement('Crystal Keeper')
					player:checkGnomeRank()
					npcHandler:say("You did well. That will help us a lot. Take your {token} and this gnomish supply package as a reward. ", cid)
					npcHandler.topic[cid] = 0
				else   -- haven't finished
					if npcHandler.topic[cid] >= 1 then
						npcHandler:say("You are not done yet.", cid) -- is reporting
					else
						npcHandler:say("You already have accepted this mission. Don't forget to {report} to me when you are done.", cid) -- se nao tiver reportando
					end
					npcHandler.topic[cid] = 0
				end
			end
		else
			npcHandler:say("Sorry, you do have not have the required rank to undertake this mission.", cid)
		end
	-- Crystal Keeper

	-- Raiders of the Lost Spark
	elseif msgcontains(msg, "spark") then
		if player:getStorageValue(Storage.BigfootBurden.QuestLine) >= 25 then
			if player:getStorageValue(Storage.BigfootBurden.MissionRaidersOfTheLostSpark) < 1 and player:getStorageValue(Storage.BigfootBurden.RaidersOfTheLostSparkTimeout) < os.time() then
				npcHandler:say({"Take this extractor and drive it into a body of a slain crystal crusher. This will charge your own body with energy sparks. Charge it with seven sparks and return to me. ...",
					"Don't worry. The gnomes assured me you'd be save. That is if nothing strange or unusual occurs! "}, cid)
				player:setStorageValue(Storage.BigfootBurden.MissionRaidersOfTheLostSpark, 1)
				player:setStorageValue(Storage.BigfootBurden.ExtractedCount, 0)
				player:addItem(18213, 1)   --- taking missions
			elseif player:getStorageValue(Storage.BigfootBurden.RaidersOfTheLostSparkTimeout) > os.time() then  -- trying to take mission while in cooldown
				npcHandler:say("Sorry, you will have to wait before you can undertake this mission again.", cid)
			elseif player:getStorageValue(Storage.BigfootBurden.MissionRaidersOfTheLostSpark) > 0 then  -- reporting mission
				if player:getStorageValue(Storage.BigfootBurden.ExtractedCount) >= 7 then -- can report missions
					player:setStorageValue(Storage.BigfootBurden.Rank, player:getStorageValue(Storage.BigfootBurden.Rank) + 5)
					player:removeItem(18213, 1)
					player:addItem(18422, 1)
					player:addItem(18215, 1)
					player:setStorageValue(Storage.BigfootBurden.MissionRaidersOfTheLostSpark, 0)
					player:setStorageValue(Storage.BigfootBurden.ExtractedCount, -1)
					player:setStorageValue(Storage.BigfootBurden.RaidersOfTheLostSparkTimeout, os.time() + 20 * 60 * 60)
					player:addAchievement('Call Me Sparky')
					player:checkGnomeRank()
					npcHandler:say("You did well. That will help us a lot. Take your {token} and this gnomish supply package as a reward. ", cid)
					npcHandler.topic[cid] = 0
				else   -- haven't finished
					if npcHandler.topic[cid] >= 1 then
						npcHandler:say("You did not draw enough energy from Crystal Crushers or you have not asked for this task.", cid) -- is reporting
					else
						npcHandler:say("You already have accepted this mission. Don't forget to {report} to me when you are done.", cid) -- se nao tiver reportando
					end
					npcHandler.topic[cid] = 0
				end
			end
		else
			npcHandler:say("Sorry, you do have not have the required rank to undertake this mission.", cid)
		end
	-- Raiders of the Lost Spark

	-- Exterminators
	elseif msgcontains(msg, "extermination") then
		if player:getStorageValue(Storage.BigfootBurden.QuestLine) >= 26 then
			if player:getStorageValue(Storage.BigfootBurden.MissionExterminators) < 1 and player:getStorageValue(Storage.BigfootBurden.ExterminatorsTimeout) < os.time() then
				npcHandler:say("The wigglers have become a pest that threaten our resources and supplies. Kill 10 wigglers in the caves like the mushroon gardens or the truffles ground. {Report} back to me when you are done. ", cid)
				player:setStorageValue(Storage.BigfootBurden.MissionExterminators, 1)
				player:setStorageValue(Storage.BigfootBurden.ExterminatedCount, 0) --- taking missions
			elseif player:getStorageValue(Storage.BigfootBurden.ExterminatorsTimeout) > os.time() then  -- trying to take mission while in cooldown
				npcHandler:say("Sorry, you will have to wait before you can undertake this mission again.", cid)
			elseif player:getStorageValue(Storage.BigfootBurden.MissionExterminators) > 0 then  -- reporting mission
				if player:getStorageValue(Storage.BigfootBurden.ExterminatedCount) >= 10 then -- can report missions
					player:setStorageValue(Storage.BigfootBurden.Rank, player:getStorageValue(Storage.BigfootBurden.Rank) + 5)
					player:addItem(18422, 1)
					player:addItem(18215, 1)
					player:setStorageValue(Storage.BigfootBurden.MissionExterminators, 0)
					player:setStorageValue(Storage.BigfootBurden.ExterminatedCount, -1)
					player:setStorageValue(Storage.BigfootBurden.ExterminatorsTimeout, os.time() + 20 * 60 * 60)
					player:addAchievement('One Foot Vs. Many')
					player:checkGnomeRank()
					npcHandler:say("You did well. That will help us a lot. Take your {token} and this gnomish supply package as a reward. ", cid)
					npcHandler.topic[cid] = 0
				else   -- haven't finished
					if npcHandler.topic[cid] >= 1 then
						npcHandler:say("You are not done yet.", cid) -- is reporting
					else
						npcHandler:say("You already have accepted this mission. Don't forget to {report} to me when you are done.", cid) -- se nao tiver reportando
					end
					npcHandler.topic[cid] = 0
				end
			end
		else
			npcHandler:say("Sorry, you do have not have the required rank to undertake this mission.", cid)
		end
	-- Exterminators

	-- Mushroom Digger
	elseif msgcontains(msg, "digging") then
		if player:getStorageValue(Storage.BigfootBurden.QuestLine) >= 26 then
			if player:getStorageValue(Storage.BigfootBurden.MissionMushroomDigger) < 1 and player:getStorageValue(Storage.BigfootBurden.MushroomDiggerTimeout) < os.time() then
				npcHandler:say({
					"Take this little piggy here. It will one day become a great mushroom hunter for sure. For now it is depended on you and other pigs. ...",
					"Well, other pigs like it is one, I mean. I was of course not comparing you with a pig! Go to the truffles area and follow the truffle pigs there. If they dig up some truffles, let the little pig eat the mushrooms. ...",
					"You'll have to feed it three times. Then return it to me. ...",
					"Keep in mind that the pig has to be returned to his mother after a while. If you don't do this, the gnomes will call it back via teleport crystals."
				}, cid)
				player:setStorageValue(Storage.BigfootBurden.MissionMushroomDigger, 1)
				player:setStorageValue(Storage.BigfootBurden.MushroomCount, 0)
				player:addItem(18339, 1)   --- taking missions
			elseif player:getStorageValue(Storage.BigfootBurden.MushroomDiggerTimeout) > os.time() then  -- trying to take mission while in cooldown
				npcHandler:say("Sorry, you will have to wait before you can undertake this mission again.", cid)
			elseif player:getStorageValue(Storage.BigfootBurden.MissionMushroomDigger) > 0 then  -- reporting mission
				if player:getStorageValue(Storage.BigfootBurden.MushroomCount) >= 3 then -- can report missions
					player:removeItem(18339, 1)
					player:setStorageValue(Storage.BigfootBurden.Rank, player:getStorageValue(Storage.BigfootBurden.Rank) + 5)
					player:addItem(18422, 1)
					player:addItem(18215, 1)
					player:setStorageValue(Storage.BigfootBurden.MissionMushroomDigger, 0)
					player:setStorageValue(Storage.BigfootBurden.MushroomCount, -1)
					player:setStorageValue(Storage.BigfootBurden.MushroomDiggerTimeout, os.time() + 20 * 60 * 60)
					player:addAchievement('The Picky Pig')
					player:checkGnomeRank()
					npcHandler:say("You did well. That will help us a lot. Take your {token} and this gnomish supply package as a reward. ", cid)
					npcHandler.topic[cid] = 0
				else   -- haven't finished
					if npcHandler.topic[cid] >= 1 then
						npcHandler:say("You are not done yet.", cid) -- is reporting
					else
						npcHandler:say("You already have accepted this mission. Don't forget to {report} to me when you are done.", cid) -- se nao tiver reportando
					end
					npcHandler.topic[cid] = 0
				end
			end
		else
			npcHandler:say("Sorry, you do have not have the required rank to undertake this mission.", cid)
		end
	-- Mushroom Digger

	elseif(msgcontains(msg, "report")) then
		if player:getStorageValue(Storage.BigfootBurden.QuestLine) == 25 then
			npcHandler:say("Which mission do you want to report: crystal {keeper}, {spark} hunting?", cid)
			npcHandler.topic[cid] = 1
		elseif player:getStorageValue(Storage.BigfootBurden.QuestLine) >= 26 then
			npcHandler:say("Which mission do you want to report: crystal {keeper}, {spark} hunting, monster {extermination} or mushroom {digging}?", cid)
			npcHandler.topic[cid] = 2
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
