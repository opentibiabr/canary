local internalNpcName = "Budrik"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 160,
	lookHead = 94,
	lookBody = 95,
	lookLegs = 58,
	lookFeet = 114
}

npcConfig.flags = {
	floorchange = false
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
	npcHandler:onMove(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end


	if isInArray({"mission", "quest"}, message:lower()) then
		if player:getStorageValue(Storage.toOutfoxAFoxQuest) < 1 then
			npcHandler:say({
				"Funny that you are asking me for a mission! There is indeed something you can do for me. Ever heard about The Horned Fox? Anyway, yesterday his gang has stolen my mining helmet during a raid. ...",
				"It belonged to my father and before that to my grandfather. That helmet is at least 600 years old! I need it back. Are you willing to help me?"
			}, npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif player:getStorageValue(Storage.toOutfoxAFoxQuest) == 1 then
			if player:removeItem(139, 1) then
				player:setStorageValue(Storage.toOutfoxAFoxQuest, 2)
				player:addItem(875, 1)
				npcHandler:say("As I was just saying to the others, 'this brave fellow will bring me my mining helmet back' and here you are with it!! Here take my spare helmet, I don't need it anymore!", npc, creature)
			else
				npcHandler:say("We presume the hideout of The Horned Fox is somewhere in the south-west near the coast, good luck finding my mining helmet!", npc, creature)
			end
		elseif player:getStorageValue(Storage.toOutfoxAFoxQuest) == 2 and player:getLevel() <= 40 and player:getStorageValue(Storage.KillingInTheNameOf.BudrikMinos) < 0 then
			npcHandler:say({
				"I am so angry I could spit grit! That damn {Horned Fox} and his attacks! Let's show those bull-heads that they have messed with the wrong people....",
				"I want you to kill 5000 minotaurs - no matter where - for me and all the dwarfs of Kazordoon! Are you willing to do that?"}, npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif player:getStorageValue(Storage.KillingInTheNameOf.BudrikMinos) == 0 then
			if player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.MinotaurCount) >= 5000 then
				npcHandler:say({
					"By all that is holy! You are a truly great warrior! With much patience! I have just found out the location the hideout of The Horned Fox! I have marked the spot on your map so you can find it. Go there and slay him!! ...",
					"BUT, you will have only this ONE chance to catch him! Good luck!"}, npc, creature)
				player:setStorageValue(Storage.KillingInTheNameOf.BudrikMinos, 1)
				player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.FoxCount, 0)
			else
				npcHandler:say("Come back when you have slain {5000 minotaurs!}", npc, creature)
			end
		elseif player:getStorageValue(Storage.KillingInTheNameOf.BudrikMinos) == 2 and player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.FoxCount) == 1 then
			npcHandler:say("It was very decent of you to help me, and I am thankful, really I am, but now I have to get back to my duties as a foreman.", npc, creature)
		elseif player:getLevel() > 40 and player:getStorageValue(Storage.KillingInTheNameOf.BudrikMinos) < 0 then
			npcHandler:say("Well, I could need help with that damn Horned Fox and his gang, but I guess since you are rather experienced, killing minotaurs would bore you to death. I'll wait for someone else. But thanks!", npc, creature)
		else
			npcHandler:say("Hum... what, {task}?", npc, creature)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("I knew you have the guts for that task! We presume the hideout of The Horned Fox somewhere in the south-west near the coast. Good luck!", npc, creature)
			npcHandler:setTopic(playerId, 0)
			player:setStorageValue(Storage.toOutfoxAFoxQuest, 1)
		elseif npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("Hussah! Let's bring war to those hoof-legged, dirt-necked, bull-headed minotaurs!! Come back to me when you are done with your {mission}.", npc, creature)
			player:setStorageValue(JOIN_STOR, 1)
			player:setStorageValue(Storage.KillingInTheNameOf.BudrikMinos, 0)
			player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.MinotaurCount, 0)
			player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.MinotaurCount, 0)
			player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.MinotaurGuardCount, 0)
			player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.MinotaurMageCount, 0)
			player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.MinotaurArcherCount, 0)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("Zzz...", npc, creature)
		end
	elseif MsgContains(message, "no") then
		if npcHandler:getTopic(playerId) > 1 then
			npcHandler:say("Then no.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

-- Basic
keywordHandler:addKeyword({"disturb"}, StdModule.say, {npcHandler = npcHandler, text = "I'm the foreman of this {mine}."})
keywordHandler:addAliasKeyword({"job"})
keywordHandler:addAliasKeyword({"shop"})
keywordHandler:addKeyword({"dwarfs"}, StdModule.say, {npcHandler = npcHandler, text = "We understand the ways of the earth like nobody else."})
keywordHandler:addKeyword({"help"}, StdModule.say, {npcHandler = npcHandler, text = "I'm a miner, not your mother. Go ask someone else."})
keywordHandler:addKeyword({"hideout"}, StdModule.say, {npcHandler = npcHandler, text = "The hideout of the Horned Fox is probably a dangerous if not lethal place for inexperienced adventurers. It is the source of all the {trouble} around here."})
keywordHandler:addKeyword({"horned fox"}, StdModule.say, {npcHandler = npcHandler, text = "He is a minotaur who was kicked out of Mintwallin. He must have some kind of {hideout} nearby."})
keywordHandler:addKeyword({"mine"}, StdModule.say, {npcHandler = npcHandler, text = "This is not an amusement park! Leave the miners and their drilling-worms alone and get out! We've already got enough {trouble} without you."})
keywordHandler:addAliasKeyword({"dungeon"})
keywordHandler:addKeyword({"monster"}, StdModule.say, {npcHandler = npcHandler, text = "We occasionally come across nasty beasts in the deepest mines."})
keywordHandler:addKeyword({"name"}, StdModule.say, {npcHandler = npcHandler, text = "My name is Budrik Deepdigger, Son of Earth, from the Molten Rock."})
keywordHandler:addKeyword({"time"}, StdModule.say, {npcHandler = npcHandler, text = {"Precisely "..getFormattedWorldTime()..", young one."}})
keywordHandler:addKeyword({"trouble"}, StdModule.say, {npcHandler = npcHandler, text = "The {Horned Fox} is leading his bandits in sneak attacks and raids on us."})
keywordHandler:addKeyword({"shearton softbeard"}, StdModule.say, {npcHandler = npcHandler, text = {
"Yes, I remember him well. It was a tragedy. An earthquake led to a cave-in and many of our brave miners died. ...",
"Their ghosts still haunt the Grothmok tunnel in which they died, so we had to seal it off."}})
keywordHandler:addKeyword({"grothmok"}, StdModule.say, {npcHandler = npcHandler, text = "You may enter the tunnel."})
keywordHandler:addKeyword({"deeper mines"}, StdModule.say, {npcHandler = npcHandler, text = "This is no funhouse. Leave the miners and their drilling-worms alone and get out! We have already enough trouble without you."})
npcHandler:setMessage(MESSAGE_WALKAWAY, "Bye, bye.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Bye, bye.")
npcHandler:setMessage(MESSAGE_GREET, "Hiho, hiho |PLAYERNAME|. Why do you {disturb} me?")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
