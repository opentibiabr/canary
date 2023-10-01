local internalNpcName = "Ghost Of A Priest"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 355
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

	if MsgContains(message, "mission") or MsgContains(message, "sceptre") then
		if player:getStorageValue(Storage.WrathoftheEmperor.Questline) == 10 then
			if player:getPosition().z == 12 and player:getStorageValue(Storage.WrathoftheEmperor.GhostOfAPriest01) < 1 and npcHandler:getTopic(playerId) ~= 1 then
				npcHandler:say({
					"Although we are willing to hand this item to you, there is something you have to understand: There is no such thing as 'the' sceptre. ...",
					"Those sceptres are created for special purposes each time anew. Therefore you will have to create one on your own. It will be your {mission} to find us three keepers and to get the three parts of the holy sceptre. ...",
					"Then go to the holy altar and create a new one."
				}, npc, creature)
				npcHandler:setTopic(playerId, 1)
			elseif npcHandler:getTopic(playerId) == 1 then
				npcHandler:say({
					"Even though we are spirits, we can't create anything out of thin air. You will have to donate some precious metal which we can drain for energy and substance. ...",
					"The equivalent of 5000 gold will do. Are you willing to make such a donation?"
				}, npc, creature)
				npcHandler:setTopic(playerId, 2)
			elseif player:getPosition().z == 13 and player:getStorageValue(Storage.WrathoftheEmperor.GhostOfAPriest02) < 1 then
				npcHandler:say({
					"Even though we are spirits, we can't create anything out of thin air. You will have to donate some precious metal which we can drain for energy and substance. ...",
					"The equivalent of 5000 gold will do. Are you willing to make such a donation?"
				}, npc, creature)
				npcHandler:setTopic(playerId, 3)
			elseif player:getPosition().z == 14 and player:getStorageValue(Storage.WrathoftheEmperor.GhostOfAPriest03) < 1 then
				npcHandler:say({
					"Even though we are spirits, we can't create anything out of thin air. You will have to donate some precious metal which we can drain for energy and substance. ...",
					"The equivalent of 5000 gold will do. Are you willing to make such a donation?"
				}, npc, creature)
				npcHandler:setTopic(playerId, 4)
			end
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 2 then
			if player:getMoney() + player:getBankBalance() >= 5000 then
				player:setStorageValue(Storage.WrathoftheEmperor.GhostOfAPriest01, 1)
				player:removeMoneyBank(5000)
				player:addItem(11368, 1)
				npcHandler:say("So be it! Here is my part of the sceptre. Combine it with the other parts on the altar of the Great Snake in the depths of this temple.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 3 then
			if player:getMoney() + player:getBankBalance() >= 5000 then
				player:setStorageValue(Storage.WrathoftheEmperor.GhostOfAPriest02, 1)
				player:removeMoneyBank(5000)
				player:addItem(11369, 1)
				npcHandler:say("So be it! Here is my part of the sceptre. Combine it with the other parts on the altar of the Great Snake in the depths of this temple.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 4 then
			if player:getMoney() + player:getBankBalance() >= 5000 then
				player:setStorageValue(Storage.WrathoftheEmperor.GhostOfAPriest03, 1)
				player:removeMoneyBank(5000)
				player:addItem(11370, 1)
				npcHandler:say("So be it! Here is my part of the sceptre. Combine it with the other parts on the altar of the Great Snake in the depths of this temple.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		end
	elseif MsgContains(message, "no") and npcHandler:getTopic(playerId) then
		npcHandler:say("No deal then.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	end
	return true
end
--Basic
keywordHandler:addKeyword({"mortal"}, StdModule.say, {npcHandler = npcHandler, text = "We are the {guardians}. We are all what is left from the glory of the past."})
keywordHandler:addKeyword({"guardians"}, StdModule.say, {npcHandler = npcHandler, text = "We are the keepers of this old temple and the guardians of its sacred {secrets}."})
keywordHandler:addKeyword({"secrets"}, StdModule.say, {npcHandler = npcHandler, text = "We are keepers of the {lore} of the Great {Snake} and we guard some of its {relics}."})
keywordHandler:addKeyword({"lore"}, StdModule.say, {npcHandler = npcHandler, text = "The lore of the Great {Snake} is contorted like a snake. Although we feel you are touched by the snake's essence, you are not ready yet to receive the blessing of the deeper wisdom."})
keywordHandler:addKeyword({"relics"}, StdModule.say, {npcHandler = npcHandler, text = "Once the powerful relics of the Great {Snake} were abundant. Most got lost to the ravages of time and our enemies. What is {left} is all the more precious."})
keywordHandler:addKeyword({"left"}, StdModule.say, {npcHandler = npcHandler, text = {
"Some of the relics are still left in this world. They are insignia of the snake god's power. We know that you came for one of those insignia. ...",
"The Great {Snake} approves that you acquire its holy {sceptre}. We will not question the wisdom of the god to hand this relic to one of the false-born."}})
keywordHandler:addKeyword({"job"}, StdModule.say, {npcHandler = npcHandler, text = "We are the guardians. We are all what is left from the glory of the past."})
keywordHandler:addKeyword({"banuta"}, StdModule.say, {npcHandler = npcHandler, text = "What you call Banuta was once a centre of our civilisation and culture. We gave those {apes} so much, but they wanted more. In the end, the Great {Snake} used them as a tool to teach our people a painful but necessary lesson."})
keywordHandler:addKeyword({"apes"}, StdModule.say, {npcHandler = npcHandler, text = "In their vanity our descendants thought they could use those false-born as servants. They paid a terrible price. Their downfall might only be temporary though if we can {redeem} our race in the eyes of the snake god."})
keywordHandler:addKeyword({"redeem"}, StdModule.say, {npcHandler = npcHandler, text = {
"We have failed our god and paid a high price. But all tragedies and obstacles are just a test of the Great Snake. We will have to prove we are worthy to be its first true-born. ...",
"Only in the face of seemingly impossible odds, we can prove what we are capable of. If we overcome all obstacles, the favour of the Great {Snake} will return to us. ...",
"The god has cast us down only to elevate us to new heights if we are worthy."}})
keywordHandler:addKeyword({"dragon"}, StdModule.say, {npcHandler = npcHandler, text = "Dragons are one of the greatest creations of the Great {Snake}. Yet, they are still distanced from the Great {Snake} and susceptible for {corruption} and the lies of the egg stealers."})
keywordHandler:addKeyword({"corruption"}, StdModule.say, {npcHandler = npcHandler, text = "There are many forms of corruption in this world. All of it is the work of the egg stealers who spread their taint. The creation hatched by the Great {Snake} was perfect without even the option of corruption."})
keywordHandler:addKeyword({"zalamon"}, StdModule.say, {npcHandler = npcHandler, text = {
"We understand what he is and what he has become. We were not aware there were others like us left in the world. ...",
"Perhaps there is still a chance our race can redeem itself in the eyes of the Great {Snake}."}})
keywordHandler:addKeyword({"snake"}, StdModule.say, {npcHandler = npcHandler, text = {
"The father and mother of everything. Its first egg hatched the world. Its second egg hatched life itself. The lizard people were of its third litter. ...",
"Of the third litter but the first true-born, we became its keepers. As its first true children, we inherited the earth but it was taken from us by the {egg stealers}."}})
keywordHandler:addAliasKeyword({"gods"})
keywordHandler:addKeyword({"egg stealers"}, StdModule.say, {npcHandler = npcHandler, text = "Creatures from beyond. Greedy and traitorous, they stole parts of the world and of life for themselves. They corrupted the world by their deceptions and stole our {birthright}."})
keywordHandler:addKeyword({"birthright"}, StdModule.say, {npcHandler = npcHandler, text = {
"We were the rulers of the world. We overlooked the world in the name of the Great {Snake}. The egg stealers and their creatures stole it from our claws. ...",
"We have failed the Great {Snake} and our {decline} is its punishment."}})
keywordHandler:addKeyword({"decline"}, StdModule.say, {npcHandler = npcHandler, text = "We were overthrown by those of who we vainly thought we could use for our advantage, even though we knew about the foulness of the false-born."})
keywordHandler:addKeyword({"false born"}, StdModule.say, {npcHandler = npcHandler, text = "Everything that lacks scales is no true litter of the Great Snake. They are the corrupted kin of the egg stealers."})
keywordHandler:addKeyword({"name"}, StdModule.say, {npcHandler = npcHandler, text = "Such concepts are of little consequence for the dead."})
keywordHandler:addKeyword({"serpent spawn"}, StdModule.say, {npcHandler = npcHandler, text = "They are a manifestation of the snake god's power. They are its avatars in some way."})
keywordHandler:addKeyword({"lizard"}, StdModule.say, {npcHandler = npcHandler, text = "We are the true-born. We are the children of the snake. But as children we have yet much to learn. One day we might take our rightful place in creation, but only if we prove {worthy}."})
keywordHandler:addKeyword({"worthy"}, StdModule.say, {npcHandler = npcHandler, text = {
"The Great Snake deserves that we try to use the best of our abilities and capabilities to serve it. Our existence is a test in this world corrupted by the egg stealers. ...",
"Only when we overcome all obstacles cast into our way, we will become worthy to serve the Great Snake in all eternity."}})
keywordHandler:addKeyword({"creatures"}, StdModule.say, {npcHandler = npcHandler, text = "They are the false-born. They hatched from foul eggs - poisoned by the egg stealers. They are numerous and like a plague for the world."})
keywordHandler:addKeyword({"temple"}, StdModule.say, {npcHandler = npcHandler, text = "This was once the centre of power of our religion. From here we ruled Tiquanda in the name of the snake god."})
keywordHandler:addKeyword({"zao"}, StdModule.say, {npcHandler = npcHandler, text = "We were not aware of another civilisation that was left. Only recently the awareness of the Great Snake touched us in our slumber and we learnt through visions of its other children."})
keywordHandler:addKeyword({"left"}, StdModule.say, {npcHandler = npcHandler, text = {
"Some of the relics are still left in this world. They are insignia of the snake god's power. We know that you came for one of those insignia. ...",
"The Great Snake approves that you acquire its holy sceptre. We will not question the wisdom of the god to hand this relic to one of the false-born."}})
keywordHandler:addKeyword({"slumber"}, StdModule.say, {npcHandler = npcHandler, text = {
"We were once the heigh priests of the Great Snake. We willingly left our mortal existence behind to become bound to this temple. ...",
"In this state we can serve the Great Snake in a more suitable way. You have to understand that it is an honour and a privilege, not a sacrifice."}})
npcHandler:setMessage(MESSAGE_FAREWELL, "Bye.")
npcHandler:setMessage(MESSAGE_GREET, "Greetings {mortal}.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
