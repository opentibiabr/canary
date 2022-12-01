local internalNpcName = "A Sleeping Dragon"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookTypeEx = 168
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

local function greetCallback(npc, creature)
	local playerId = creature:getId()
	if Player(creature):getStorageValue(Storage.WrathoftheEmperor.Questline) == 27 then
		npcHandler:setMessage(MESSAGE_GREET, "ZzzzZzzZz...chrrr...")
	else
		npcHandler:setMessage(MESSAGE_GREET, "Greetings, {wayfarer}.")
	end
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if player:getStorageValue(Storage.WrathoftheEmperor.Questline) == 27 then
		if(message == "SOLOSARASATIQUARIUM") and player:getStorageValue(Storage.WrathoftheEmperor.InterdimensionalPotion) == 1 then
			npcHandler:say({
				"Dragon dreams are golden. ...",
				"A broad darkness surrounds you as if a heavy curtain is closing before your eyes. After what seems like minutes of floating through emptiness, you get the feeling as if a hole opens in the dark before you. ...",
				"The hole grows larger, you cannot close your eyes. An unimaginable black. Deeper and darker than any nothingness you could possibly imagine drags you into it. ...",
				"You feel as if you cannot breathe anymore. The very second you let loose of your consciousness, you sense all heaviness around you lifted. ...",
				"You dive into an ocean of emerald light. Feeling like born anew the colour around you is almost overwhelming. Countless objects of all shapes and sizes are dashing past you. Racing against each other, millions are clashing in the distance. ..",
				"The loudness of the gargantuan spectacle around you bursts your hearing, yet you absorb all the sounds around you. ...",
				"As several large obstacles move aside directly in front of you, an intense bright centre leaps into your view. Though you cannot perceive how fast you are, your pace seems too slow. ...",
				"Ever decelerating, you ultimately approach a middle in this chaos of tones of green. ...",
				"As you come closer to it, yellowish shades of orange embrace you, softer shapes emerge and you almost forget the mayhem before. In warm comfort you see what lies in the heart of it all. ...",
				"A majestic dragon in his sleep is surrounded by what seems the warmth and energy of a thousand suns. The tranquillity of its sight makes you smile gently. ...",
				"You feel a perfect mixture of joy, compassion and sudden peacefulness. Bright xanthous impressions of topaz, orange and white welcome you at the final halt of your journey. ...",
				"Dragon dreams are golden. ...",
				"You find yourself inside the dragon's dream. You can {look} around or {go} into a specific direction. You can also {take} or {use} an object. Enter {help} to display this information at any time."
			}, npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif(message:lower() == "help" and npcHandler:getTopic(playerId) > 0 and npcHandler:getTopic(playerId) < 34) then
			npcHandler:say("You find yourself inside the dragon's dream. You can {look} around or {go} into a specific direction. You can also {take} or {use} an object. Enter {help} to display this information at any time.", npc, creature)
		elseif(message:lower() == "west" and npcHandler:getTopic(playerId) == 1) then
			npcHandler:say("Advancing to the west, you recognise an increase of onyx on the ground.", npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif(message:lower() == "take attachment" and npcHandler:getTopic(playerId) == 2) then
			npcHandler:say("You carefully lift the onyx attachment from its socket. It is lighter than you expected.", npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif(message:lower() == "east" and npcHandler:getTopic(playerId) == 3) then
			npcHandler:say("You return to the plateau in the east.", npc, creature)
			npcHandler:setTopic(playerId, 4)
		elseif(message:lower() == "south" and npcHandler:getTopic(playerId) == 4) then
			npcHandler:say("You wander to the south, passing large obelisks of emerald to your left and sprawling trees of topaz to your right. ", npc, creature)
			npcHandler:setTopic(playerId, 5)
		elseif(message:lower() == "take stand" and npcHandler:getTopic(playerId) == 5) then
			npcHandler:say("As you rip the solid stand out of its socket and take it with you, the large gate opens with a deafening rumble. ", npc, creature)
			npcHandler:setTopic(playerId, 6)
		elseif(message:lower() == "east" and npcHandler:getTopic(playerId) == 6) then
			npcHandler:say("You gasp at the size of the large open gate as you walk through to head further to the east.", npc, creature)
			npcHandler:setTopic(playerId, 7)
		elseif(message:lower() == "take model" and npcHandler:getTopic(playerId) == 7) then
			npcHandler:say("You reach for a small solitary arrangement of combined small houses and put it in your pocket.", npc, creature)
			npcHandler:setTopic(playerId, 8)
		elseif(message:lower() == "take emeralds" and npcHandler:getTopic(playerId) == 8) then
			npcHandler:say("You take an emerald from the pile. ", npc, creature)
			npcHandler:setTopic(playerId, 9)
		elseif(message:lower() == "west" and npcHandler:getTopic(playerId) == 9) then
			npcHandler:say("You return through the semi-translucent gate to the west. ", npc, creature)
			npcHandler:setTopic(playerId, 10)
		elseif(message:lower() == "north" and npcHandler:getTopic(playerId) == 10) then
			npcHandler:say("You head back north to the plateau. ", npc, creature)
			npcHandler:setTopic(playerId, 11)
		elseif(message:lower() == "east" and npcHandler:getTopic(playerId) == 11) then
			npcHandler:say("You travel east across several large emerald bluffs and edges. All sorts of gems are scattered alongside your path. ", npc, creature)
			npcHandler:setTopic(playerId, 12)
		elseif(message:lower() == "take rubies" and npcHandler:getTopic(playerId) == 12) then
			npcHandler:say("You take a rather large ruby out of a pile before you. ", npc, creature)
			npcHandler:setTopic(playerId, 13)
		elseif(message:lower() == "north" and npcHandler:getTopic(playerId) == 13) then
			npcHandler:say("You head north passing countless stones in the crimson sea of stones beneath your feet.", npc, creature)
			npcHandler:setTopic(playerId, 14)
		elseif(message:lower() == "use attachment" and npcHandler:getTopic(playerId) == 14) then
			npcHandler:say({
				"Avoiding the bright light, you carefully put the attachment on top of the strange socket. ...",
				"As your eyes adjust to the sudden reduction of brightness, you see the giant wings of the gate before you move to the side. You can also make out something shiny on the ground."
			}, npc, creature)
			npcHandler:setTopic(playerId, 15)
		elseif(message:lower() == "take mirror" and npcHandler:getTopic(playerId) == 15) then
			npcHandler:say("You pick the mirror from the ground.", npc, creature)
			npcHandler:setTopic(playerId, 16)
		elseif(message:lower() == "north" and npcHandler:getTopic(playerId) == 16) then
			npcHandler:say({
				"Your path to the north is open. You pass the gigantic gate wings to your left and right as you advance. After about an hour of travel you hear a slight rustling in the distance. You head further into that direction. ...",
				"The rustling gets louder until you come to a small dune. Behind it you find the source of the noise."
			}, npc, creature)
			npcHandler:setTopic(playerId, 17)
		elseif(message:lower() == "use model" and npcHandler:getTopic(playerId) == 17) then
			npcHandler:say({
				"You lunge out and throw the model far into the water. As nothing happens, you turn your back to the ocean. ...",
				"The very moment you walk down the dune to head back south, rays of light burst over your head in a shock wave that makes you tumble down the rest of the hill. ...",
				"You can also hear a deep loud scraping for several minutes somewhere far in the west."
			}, npc, creature)
			npcHandler:setTopic(playerId, 18)
		elseif(message:lower() == "south" and npcHandler:getTopic(playerId) == 18) then
			npcHandler:say("You travel all the way back down the dune and through the gate to the south. ", npc, creature)
			npcHandler:setTopic(playerId, 19)
		elseif(message:lower() == "south" and npcHandler:getTopic(playerId) == 19) then
			npcHandler:say("You return to the crimson sea of rubies in the south. ", npc, creature)
			npcHandler:setTopic(playerId, 20)
		elseif(message:lower() == "west" and npcHandler:getTopic(playerId) == 20) then
			npcHandler:say("You travel back to the plateau in the west. ", npc, creature)
			npcHandler:setTopic(playerId, 21)
		elseif(message:lower() == "west" and npcHandler:getTopic(playerId) == 21) then
			npcHandler:say("Advancing to the west, you recognise an increase of onyx on the ground. ", npc, creature)
			npcHandler:setTopic(playerId, 22)
		elseif(message:lower() == "north" and npcHandler:getTopic(playerId) == 22) then
			npcHandler:say("You continue travelling the barren sea of gemstones to the north. ", npc, creature)
			npcHandler:setTopic(playerId, 23)
		elseif(message:lower() == "west" and npcHandler:getTopic(playerId) == 23) then
			npcHandler:say("You leave the massive open gate behind you and go to the west. ", npc, creature)
			npcHandler:setTopic(playerId, 24)
		elseif(message:lower() == "bastesh" and npcHandler:getTopic(playerId) == 24) then
			npcHandler:say("This huge statue of Bastesh is made from onyx, and thrones on a large plateau which can be reached by a sprawling stairway. She holds a large {sapphire} in her hands. ", npc, creature)
			npcHandler:setTopic(playerId, 25)
		elseif(message:lower() == "take sapphire" and npcHandler:getTopic(playerId) == 25) then
			npcHandler:say("You carefully remove the sapphire from Bastesh's grasp. ", npc, creature)
			npcHandler:setTopic(playerId, 26)
		elseif(message:lower() == "east" and npcHandler:getTopic(playerId) == 26) then
			npcHandler:say("You head back to the east and to the plateau. ", npc, creature)
			npcHandler:setTopic(playerId, 27)
		elseif(message:lower() == "south" and npcHandler:getTopic(playerId) == 27) then
			npcHandler:say("You head back south to the site with the onyx lookout. ", npc, creature)
			npcHandler:setTopic(playerId, 28)
		elseif(message:lower() == "east" and npcHandler:getTopic(playerId) == 28) then
			npcHandler:say("You return to the plateau in the east. ", npc, creature)
			npcHandler:setTopic(playerId, 29)
		elseif(message:lower() == "use stand" and npcHandler:getTopic(playerId) == 29) then
			npcHandler:say("You put the stand into a small recess you find near the middle of the plateau. ", npc, creature)
			npcHandler:setTopic(playerId, 30)
		elseif(message:lower() == "use ruby" and npcHandler:getTopic(playerId) == 30) then
			npcHandler:say("As the ruby slips into the notch, the strong red of the stone intensifies a thousandfold. You fear to hurt your eyes and turn away immediately. The ray seems to be directed to the centre of the plateau with astounding precision. ", npc, creature)
			npcHandler:setTopic(playerId, 31)
		elseif(message:lower() == "use sapphire" and npcHandler:getTopic(playerId) == 31) then
			npcHandler:say("As the sapphire slips into the notch, the deep blue of the stone intensifies a thousandfold. You fear to hurt your eyes and turn away immediately. The ray seems to be directed to the centre of the plateau with astounding precision. ", npc, creature)
			npcHandler:setTopic(playerId, 32)
		elseif(message:lower() == "use emerald" and npcHandler:getTopic(playerId) == 32) then
			npcHandler:say("As the emerald slips into the notch, the vibrant green of the stone intensifies a thousandfold. You fear to hurt your eyes and turn away immediately. The ray seems to be directed to the centre of the plateau with astounding precision. ", npc, creature)
			npcHandler:setTopic(playerId, 33)
		elseif(message:lower() == "use mirror" and npcHandler:getTopic(playerId) == 33) then
			npcHandler:say({
				"With your eyes covered and avoiding direct sight of the rays, you put the mirror into the stand. ...",
				"Instinctively you run to a larger emerald bluff near the raise to find cover. Mere seconds after you claimed the sturdy shelter, a deep dark humming starts to swirl through the air. ...",
				"Seconds pass as the hum gets louder. The noise is maddening, drowning all other sounds around you. As you cover your ears in pain, the humming explodes into a deafening growl. ...",
				"You raise your head above the edge of the emerald to catch a glimpse of what's happening. ...",
				"The hand seems to have grown into a fist. In the distance you can now see a blurry scheme of a creature too large for your eyes to get a sharper view of its head. ...",
				"Blending the rays, the mirror directs pure white light directly towards the part where you assume the face of the creature. ...",
				"The growl transforms into a scream, everything around you seems to compress. As you press yourself tightly against the bluff, everything falls silent and in a split second, the dark being dissolves into bursts of blackness. You wake."
			}, npc, creature)
			player:addAchievement('Wayfarer')
			player:setStorageValue(Storage.WrathoftheEmperor.Questline, 28)
			player:setStorageValue(Storage.WrathoftheEmperor.Mission09, 2) --Questlog, Wrath of the Emperor "Mission 09: The Sleeping Dragon"
			npcHandler:setTopic(playerId, 0)
	end
	elseif player:getStorageValue(Storage.WrathoftheEmperor.Questline) == 28 then
		if(MsgContains(message, "wayfarer")) then
			npcHandler:say("I call you the wayfarer. You travelled through my dreams. You ultimately freed my mind. My mind accepted you and so will I.", npc, creature)
		elseif MsgContains(message, "mission") then
			npcHandler:say({
				"Aaaah... free at last. Hmmm. ...",
				"I assume you need to get through the gate to reach the evildoer. I can help you if you trust me, wayfarer. I will share a part of my mind with you which should enable you to step through the gate. ...",
				"This procedure may be exhausting. Are you prepared to receive my key?"
			}, npc, creature)
			npcHandler:setTopic(playerId, 41)
		elseif(MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 41) then
			npcHandler:say({
				"SAETHELON TORILUN GARNUM. ...",
				"SLEEP. ...",
				"GAIN. ...",
				"RISE. ...",
				"The transfer was successful. ...",
				"You are now prepared to enter the realm of the evildoer. I am grateful for your help, wayfarer. Should you seek my council, use this charm I cede to you. For my spirit will guide you wherever you are. May you enjoy a sheltered future, you shall prevail."
			}, npc, creature)
			player:setStorageValue(Storage.WrathoftheEmperor.Questline, 29)
			player:setStorageValue(Storage.WrathoftheEmperor.Mission10, 1) --Questlog, Wrath of the Emperor "Mission 10: A Message of Freedom"
			player:addItem(10343, 1)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
