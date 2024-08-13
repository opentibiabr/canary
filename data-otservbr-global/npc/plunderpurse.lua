local internalNpcName = "Plunderpurse"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 151,
	lookHead = 114,
	lookBody = 131,
	lookLegs = 0,
	lookFeet = 20,
	lookAddons = 1,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Waste not, want not!" },
	{ text = "Don't burden yourself with too much cash - store it here!" },
	{ text = "Don't take the money and run - deposit it and walk instead!" },
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

local count = {}
local function greetCallback(npc, creature)
	local playerId = creature:getId()
	count[playerId] = nil
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	--Help
	if MsgContains(message, "bank account") then
		npcHandler:say({
			"Every Adventurer has one. \z
					The big advantage is that you can access your money in every branch of the World Bank! ...",
			"Would you like to know more about the {basic} functions of your bank account, the {advanced} functions, \z
					or are you already bored, perhaps?",
		}, npc, creature, 10)
		npcHandler:setTopic(playerId, 0)
		return true
		--Balance
	elseif MsgContains(message, "balance") then
		npcHandler:setTopic(playerId, 0)
		if player:getBankBalance() >= 100000000 then
			npcHandler:say("I think you must be one of the richest inhabitants in the world! \z
				Your account balance is " .. player:getBankBalance() .. " gold.", npc, creature)
			return true
		elseif player:getBankBalance() >= 10000000 then
			npcHandler:say("You have made ten millions and it still grows! Your account balance is \z
				" .. player:getBankBalance() .. " gold.", npc, creature)
			return true
		elseif player:getBankBalance() >= 1000000 then
			npcHandler:say("Wow, you have reached the magic number of a million gp!!! \z
				Your account balance is " .. player:getBankBalance() .. " gold!", npc, creature)
			return true
		elseif player:getBankBalance() >= 100000 then
			npcHandler:say("You certainly have made a pretty penny. Your account balance is \z
				" .. player:getBankBalance() .. " gold.", npc, creature)
			return true
		else
			npcHandler:say("Your account balance is " .. player:getBankBalance() .. " gold.", npc, creature)
			return true
		end
		--Deposit
	elseif MsgContains(message, "deposit") then
		count[playerId] = player:getMoney()
		if count[playerId] < 1 then
			npcHandler:say("You do not have enough gold.", npc, creature)
			npcHandler:setTopic(playerId, 0)
			return false
		elseif not isValidMoney(count[playerId]) then
			npcHandler:say("Sorry, but you can't deposit that much.", npc, creature)
			npcHandler:setTopic(playerId, 0)
			return false
		end
		if MsgContains(message, "all") then
			count[playerId] = player:getMoney()
			npcHandler:say("Would you really like to deposit " .. count[playerId] .. " gold?", npc, creature)
			npcHandler:setTopic(playerId, 2)
			return true
		else
			if string.match(message, "%d+") then
				count[playerId] = getMoneyCount(message)
				if count[playerId] < 1 then
					npcHandler:say("You do not have enough gold.", npc, creature)
					npcHandler:setTopic(playerId, 0)
					return false
				end
				npcHandler:say("Would you really like to deposit " .. count[playerId] .. " gold?", npc, creature)
				npcHandler:setTopic(playerId, 2)
				return true
			else
				npcHandler:say("Please tell me how much gold it is you would like to deposit.", npc, creature)
				npcHandler:setTopic(playerId, 1)
				return true
			end
		end
	elseif npcHandler:getTopic(playerId) == 1 then
		count[playerId] = getMoneyCount(message)
		if isValidMoney(count[playerId]) then
			npcHandler:say("Would you really like to deposit " .. count[playerId] .. " gold?", npc, creature)
			npcHandler:setTopic(playerId, 2)
			return true
		else
			npcHandler:say("You do not have enough gold.", npc, creature)
			npcHandler:setTopic(playerId, 0)
			return true
		end
	elseif npcHandler:getTopic(playerId) == 2 then
		if MsgContains(message, "yes") then
			if count[playerId] > 1500 or player:getBankBalance() >= 1500 then
				npcHandler:say("Sorry, but you can't deposit that much.", npc, creature)
				npcHandler:setTopic(playerId, 0)
				return false
			end
			if player:depositMoney(count[playerId]) then
				npcHandler:say("Alright, we have added the amount of " .. count[playerId] .. " gold to your {balance}. \z
				You can {withdraw} your money anytime you want to.", npc, creature)
			else
				npcHandler:say("You do not have enough gold.", npc, creature)
			end
		elseif MsgContains(message, "no") then
			npcHandler:say("As you wish. Is there something else I can do for you?", npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
		return true
		--Withdraw
	elseif MsgContains(message, "withdraw") then
		if string.match(message, "%d+") then
			count[playerId] = getMoneyCount(message)
			if isValidMoney(count[playerId]) then
				npcHandler:say("Are you sure you wish to withdraw " .. count[playerId] .. " gold from your bank account?", npc, creature)
				npcHandler:setTopic(playerId, 7)
			else
				npcHandler:say("There is not enough gold on your account.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
			return true
		else
			npcHandler:say("Please tell me how much gold you would like to withdraw.", npc, creature)
			npcHandler:setTopic(playerId, 6)
			return true
		end
	elseif npcHandler:getTopic(playerId) == 6 then
		count[playerId] = getMoneyCount(message)
		if isValidMoney(count[playerId]) then
			npcHandler:say("Are you sure you wish to withdraw " .. count[playerId] .. " gold from your bank account?", npc, creature)
			npcHandler:setTopic(playerId, 7)
		else
			npcHandler:say("There is not enough gold on your account.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
		return true
	elseif npcHandler:getTopic(playerId) == 7 then
		if MsgContains(message, "yes") then
			if player:getFreeCapacity() >= getMoneyWeight(count[playerId]) then
				if not player:withdrawMoney(count[playerId]) then
					npcHandler:say("There is not enough gold on your account.", npc, creature)
				else
					npcHandler:say("Here you are, " .. count[playerId] .. " gold. \z
						Please let me know if there is something else I can do for you.", npc, creature)
				end
			else
				npcHandler:say(
					"Whoah, hold on, you have no room in your inventory to carry all those coins. \z
					I don't want you to drop it on the floor, maybe come back with a cart!",
					npc,
					creature
				)
			end
			npcHandler:setTopic(playerId, 0)
		elseif MsgContains(message, "no") then
			npcHandler:say("The customer is king! Come back anytime you want to if you wish to {withdraw} your money.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
		return true
		--Money exchange
	elseif MsgContains(message, "change gold") then
		npcHandler:say("How many platinum coins would you like to get?", npc, creature)
		npcHandler:setTopic(playerId, 14)
	elseif npcHandler:getTopic(playerId) == 14 then
		if getMoneyCount(message) < 1 then
			npcHandler:say("Sorry, you do not have enough gold coins.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			count[playerId] = getMoneyCount(message)
			npcHandler:say("So you would like me to change " .. count[playerId] * 100 .. " of your gold \z
				coins into " .. count[playerId] .. " platinum coins?", npc, creature)
			npcHandler:setTopic(playerId, 15)
		end
	elseif npcHandler:getTopic(playerId) == 15 then
		if MsgContains(message, "yes") then
			if player:removeItem(3031, count[playerId] * 100) then
				player:addItem(3035, count[playerId])
				npcHandler:say("Here you are.", npc, creature)
			else
				npcHandler:say("Sorry, you do not have enough gold coins.", npc, creature)
			end
		else
			npcHandler:say("Well, can I help you with something else?", npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "change platinum") then
		npcHandler:say("Would you like to change your platinum coins into gold or crystal?", npc, creature)
		npcHandler:setTopic(playerId, 16)
	elseif npcHandler:getTopic(playerId) == 16 then
		if MsgContains(message, "gold") then
			npcHandler:say("How many platinum coins would you like to change into gold?", npc, creature)
			npcHandler:setTopic(playerId, 17)
		elseif MsgContains(message, "crystal") then
			npcHandler:say("How many crystal coins would you like to get?", npc, creature)
			npcHandler:setTopic(playerId, 19)
		else
			npcHandler:say("Well, can I help you with something else?", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif npcHandler:getTopic(playerId) == 17 then
		if getMoneyCount(message) < 1 then
			npcHandler:say("Sorry, you do not have enough platinum coins.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			count[playerId] = getMoneyCount(message)
			npcHandler:say("So you would like me to change " .. count[playerId] .. " of your platinum \z
				coins into " .. count[playerId] * 100 .. " gold coins for you?", npc, creature)
			npcHandler:setTopic(playerId, 18)
		end
	elseif npcHandler:getTopic(playerId) == 18 then
		if MsgContains(message, "yes") then
			if player:removeItem(3035, count[playerId]) then
				player:addItem(3031, count[playerId] * 100)
				npcHandler:say("Here you are.", npc, creature)
			else
				npcHandler:say("Sorry, you do not have enough platinum coins.", npc, creature)
			end
		else
			npcHandler:say("Well, can I help you with something else?", npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	elseif npcHandler:getTopic(playerId) == 19 then
		if getMoneyCount(message) < 1 then
			npcHandler:say("Sorry, you do not have enough platinum coins.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			count[playerId] = getMoneyCount(message)
			npcHandler:say("So you would like me to change " .. count[playerId] * 100 .. " of your platinum coins \z
				into " .. count[playerId] .. " crystal coins for you?", npc, creature)
			npcHandler:setTopic(playerId, 20)
		end
	elseif npcHandler:getTopic(playerId) == 20 then
		if MsgContains(message, "yes") then
			if player:removeItem(3035, count[playerId] * 100) then
				player:addItem(3043, count[playerId])
				npcHandler:say("Here you are.", npc, creature)
			else
				npcHandler:say("Sorry, you do not have enough platinum coins.", npc, creature)
			end
		else
			npcHandler:say("Well, can I help you with something else?", npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "change crystal") then
		npcHandler:say("How many crystal coins would you like to change into platinum?", npc, creature)
		npcHandler:setTopic(playerId, 21)
	elseif npcHandler:getTopic(playerId) == 21 then
		if getMoneyCount(message) < 1 then
			npcHandler:say("Sorry, you do not have enough crystal coins.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			count[playerId] = getMoneyCount(message)
			npcHandler:say("So you would like me to change " .. count[playerId] .. " of your crystal coins \z
				into " .. count[playerId] * 100 .. " platinum coins for you?", npc, creature)
			npcHandler:setTopic(playerId, 22)
		end
	elseif npcHandler:getTopic(playerId) == 22 then
		if MsgContains(message, "yes") then
			if player:removeItem(3043, count[playerId]) then
				player:addItem(3035, count[playerId] * 100)
				npcHandler:say("Here you are.", npc, creature)
			else
				npcHandler:say("Sorry, you do not have enough crystal coins.", npc, creature)
			end
		else
			npcHandler:say("Well, can I help you with something else?", npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

keywordHandler:addKeyword({ "dawnport" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Yeah, well, some romantic at work there. \z
			Island was reached at dawn, new heroes and adventurers forthcoming, stuff like that.",
})
keywordHandler:addKeyword({ "change" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Ah, wonderful stuff! That and a bottle o' rum, o'course! Harrharr. \z
			You have some gold you want to deposit or withdraw, just tell me.",
})
keywordHandler:addKeyword({ "bank" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "You can deposit and withdraw money from your bank account here.",
})
keywordHandler:addKeyword({ "advanced" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Once you are on the Tibian mainland, you can access new functions of your bank account, \z
			such as changing money, transferring money to other players safely or taking part in house auctions.",
})
keywordHandler:addKeyword({ "name" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Abram Plunderpurse, at your service. <bows>",
})
keywordHandler:addKeyword({ "functions" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Here on Dawnport, I run the bank. I keep any gold you deposit safe, \z
			so you can't lose it when you're out fighting or dying, heh. \z
			Ask me for your balance to learn how much money you've already saved",
})
keywordHandler:addKeyword({ "rookgaard" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Arrr. Not a very profitable place.",
})
keywordHandler:addKeyword({ "job" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Arr! I'm a pira... er, I mean <cough> <cough> ... clerk. Banking clerk. \z
			That's what I am. You need somethin'? Bank business, p'raps?",
})
keywordHandler:addKeyword({ "mainland" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"Aye, Tibia is a vast world, my friend, with plenty of adventures, harbours, and loot! \z
			The Mainland is open to everyone; but there are many beautiful islands and more cities to explore, \z
			if you have premium rights and can use a ship.",
		"Once you have reached level 8 here on this isle, you can choose your definite vocation and leave for the Mainland.",
	},
})
keywordHandler:addKeyword({ "vocation" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "There's a choice of four: knight, sorcerer, paladin or druid.",
})
keywordHandler:addKeyword({ "transfer" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "I'm afraid this service is not available to you until you reach the World mainland.",
})
keywordHandler:addKeyword({ "inigo" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "He's an ol' trapper and knows his away around in Tibia, aye. \z
			Ask him how a thing works and he'll be sure to have an answer. ...",
})
keywordHandler:addKeyword({ "coltrayne" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Gloomy sort. Keeps glaring at me for some reason. Or maybe for no reason, harr. \z
			Formidable blacksmith, anyway. Sharpest sword blade I've seen in a long time.",
})
keywordHandler:addKeyword({ "garamond" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Fetching white beard, I hope I grow one in due time, would impress the younger folk no end! \z
			Knowing some sorcerer and druid spells like he does wouldn't come amiss, either. \z
			Go to him if you need mage spells.",
})
keywordHandler:addKeyword({ "hamish" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Could've used his talent to brew up some more explosive runes back in the sea fight against... \z
			ah well, you wouldn't know the name anyway. Gotta admit, his potions are good stuff.",
})
keywordHandler:addKeyword({ "richard" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "<shifts uneasily> Well, maybe I did come across his ship some time. In bad weather. \z
			And couldn't do a thing for those poor souls. And anyway, he swam ashore here. \z
			So it all worked out in the end, see.",
})
keywordHandler:addKeyword({ "mr morris" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "That's Mr Morris to you, friend. \z
			Go get yourself a useful thing to do and ask him about a quest, will you.",
})
keywordHandler:addKeyword({ "oressa" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Harrr, what a dame! Would like to buy her a pint one day. \z
			<leers> Unless she kills me with one of her icy looks first. Anyway, decent healer. \z
			Can help ya with choosing a vocation.",
})
keywordHandler:addKeyword({ "plunderpurse" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Aye, what about my name? You don't like it? Well, you don't have to wear it! \z
			And I am quite happy with that!",
})
keywordHandler:addKeyword({ "quest" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Not my line of trade, friend! Mr Morris next door will tell you what needs doin' around here.",
})
keywordHandler:addKeyword({ "ser tybald" }, StdModule.say, {
	npcHandler = npcHandler,
	text = " I could swear he looks like that old pal I met back on... \z
			ah well, much salt water passed my ship since then. \z
			If ye need a spell or two for a knight or paladin, he's the spell teacher to go to.",
})
keywordHandler:addKeyword({ "wentworth" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Arrr. We go wayyyy back, Keeran an' me. Best you ask him, I'm no good at details.",
})

npcHandler:setMessage(
	MESSAGE_GREET,
	"Welcome, young adventurer! Harr! {Deposit} your gold or {withdraw} \z
	your money from your bank account. I can also explain the functions of your {bank} account to ya."
)
npcHandler:setMessage(MESSAGE_FAREWELL, "Have a nice day.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Have a nice day.")

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)


npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)
npcConfig.shop = {

		{ itemName = "cowbell",  clientId = 21204,  sell  =  210 , buy =840}, 
		{ itemName = "execowtioner mask",  clientId = 21201,  sell  =  240 , buy =960}, 
		{ itemName = "giant pacifier",  clientId = 21199,  sell  =  170 , buy =680}, 
		{ itemName = "glob of glooth",  clientId = 21182,  sell  =  125 , buy =500}, 
		{ itemName = "glooth injection tube",  clientId = 21103,  sell  =  350 , buy =1400}, 
		{ itemName = "metal jaw",  clientId = 21193,  sell  =  260 , buy =1040}, 
		{ itemName = "metal toe",  clientId = 21198,  sell  =  430 , buy =1720}, 
		{ itemName = "mooh'tah shell",  clientId = 21202,  sell  =  110 , buy =440}, 
		{ itemName = "moohtant horn",  clientId = 21200,  sell  =  140 , buy =560}, 
		{ itemName = "necromantic rust",  clientId = 21196,  sell  =  390 , buy =1560}, 
		{ itemName = "poisoned fang",  clientId = 21195,  sell  =  130 , buy =520}, 
		{ itemName = "seacrest hair",  clientId = 21801,  sell  =  260 , buy =1040}, 
		{ itemName = "seacrest pearl",  clientId = 21747,  sell  =  400 , buy =1600}, 
		{ itemName = "seacrest scale",  clientId = 21800,  sell  =  150 , buy =600}, 
		{ itemName = "slime heart",  clientId = 21194,  sell  =  160 , buy =640}, 
		{ itemName = "slimy leaf tentacle",  clientId = 21197,  sell  =  320 , buy =1280}, 
		{ itemName = "black shield",  clientId = 3429,  sell  =  800 , buy =3200}, 
		{ itemName = "bonebreaker",  clientId = 7428,  sell  =  10000 , buy =40000}, 
		{ itemName = "dragon hammer",  clientId = 3322,  sell  =  2000 , buy =8000}, 
		{ itemName = "dreaded cleaver",  clientId = 7419,  sell  =  15000 , buy =60000}, 
		{ itemName = "giant sword",  clientId = 3281,  sell  =  17000 , buy =68000}, 
		{ itemName = "haunted blade",  clientId = 7407,  sell  =  8000 , buy =32000}, 
		{ itemName = "knight armor",  clientId = 3370,  sell  =  5000 , buy =20000}, 
		{ itemName = "knight axe",  clientId = 3318,  sell  =  2000 , buy =8000}, 
		{ itemName = "knight legs",  clientId = 3371,  sell  =  5000 , buy =20000}, 
		{ itemName = "mystic turban",  clientId = 3574,  sell  =  150 , buy =600}, 
		{ itemName = "onyx flail",  clientId = 7421,  sell  =  22000 , buy =88000}, 
		{ itemName = "ornamented axe",  clientId = 7411,  sell  =  20000 , buy =80000}, 
		{ itemName = "poison dagger",  clientId = 3299,  sell  =  50 , buy =200}, 
		{ itemName = "scimitar",  clientId = 3307,  sell  =  150 , buy =600}, 
		{ itemName = "skull staff",  clientId = 3324,  sell  =  6000 , buy =24000}, 
		{ itemName = "strange helmet",  clientId = 3373,  sell  =  500 , buy =2000}, 
		{ itemName = "titan axe",  clientId = 7413,  sell  =  4000 , buy =16000}, 
		{ itemName = "tower shield",  clientId = 3428,  sell  =  8000 , buy =32000}, 
		{ itemName = "vampire shield",  clientId = 3434,  sell  =  15000 , buy =60000}, 
		{ itemName = "warrior helmet",  clientId = 3369,  sell  =  5000 , buy =20000}, 
		{ itemName = "axe ring",  clientId = 3092,  sell  =  100 , buy =400}, 
		{ itemName = "club ring",  clientId = 3093,  sell  =  100 , buy =400}, 
		{ itemName = "garlic necklace",  clientId = 3083,  sell  =  50 , buy =200}, 
		{ itemName = "life crystal",  clientId = 4840,  sell  =  50 , buy =200}, 
		{ itemName = "magic light wand",  clientId = 3046,  sell  =  35 , buy =140}, 
		{ itemName = "mind stone",  clientId = 3062,  sell  =  100 , buy =400}, 
		{ itemName = "orb",  clientId = 3060,  sell  =  750 , buy =3000}, 
		{ itemName = "power ring",  clientId = 3050,  sell  =  50 , buy =200}, 
		{ itemName = "stealth ring",  clientId = 3049,  sell  =  200 , buy =800}, 
		{ itemName = "sword ring",  clientId = 3091,  sell  =  100 , buy =400}, 
		{ itemName = "wand of cosmic energy",  clientId = 3073,  sell  =  2000 , buy =8000}, 
		{ itemName = "wand of decay",  clientId = 3072,  sell  =  1000 , buy =4000}, 
		{ itemName = "wand of defiance",  clientId = 16096,  sell  =  6500 , buy =26000}, 
		{ itemName = "wand of draconia",  clientId = 8093,  sell  =  1500 , buy =6000}, 
		{ itemName = "wand of dragonbreath",  clientId = 3075,  sell  =  200 , buy =800}, 
		{ itemName = "wand of everblazing",  clientId = 16115,  sell  =  6000 , buy =24000}, 
		{ itemName = "wand of inferno",  clientId = 3071,  sell  =  3000 , buy =12000}, 
		{ itemName = "wand of starstorm",  clientId = 8092,  sell  =  3600 , buy =14400}, 
		{ itemName = "wand of voodoo",  clientId = 8094,  sell  =  4400 , buy =17600}, 
		{ itemName = "wand of vortex",  clientId = 3074,  sell  =  100 , buy =400}, 
		{ itemName = "crest of the deep seas",  clientId = 21892,  sell  =  10000 , buy =40000}, 
		{ itemName = "cowtana",  clientId = 21177,  sell  =  2500 , buy =10000}, 
		{ itemName = "gearwheel chain",  clientId = 21170,  sell  =  5000 , buy =20000}, 
		{ itemName = "glooth amulet",  clientId = 21183,  sell  =  2000 , buy =8000}, 
		{ itemName = "glooth axe",  clientId = 21180,  sell  =  1500 , buy =6000}, 
		{ itemName = "glooth blade",  clientId = 21179,  sell  =  1500 , buy =6000}, 
		{ itemName = "glooth cap",  clientId = 21164,  sell  =  7000 , buy =28000}, 
		{ itemName = "glooth club",  clientId = 21178,  sell  =  1500 , buy =6000}, 
		{ itemName = "glooth whip",  clientId = 21172,  sell  =  2500 , buy =10000}, 
		{ itemName = "mooh'tah plate",  clientId = 21166,  sell  =  6000 , buy =24000}, 
		{ itemName = "moohtant cudgel",  clientId = 21173,  sell  =  14000 , buy =56000}, 
		{ itemName = "metal bat",  clientId = 21171,  sell  =  9000 , buy =36000}, 
		{ itemName = "metal spats",  clientId = 21169,  sell  =  2000 , buy =8000}, 
		{ itemName = "mino lance",  clientId = 21174,  sell  =  7000 , buy =28000}, 
		{ itemName = "mino shield",  clientId = 21175,  sell  =  3000 , buy =12000}, 
		{ itemName = "rubber cap",  clientId = 21165,  sell  =  11000 , buy =44000}, 
		{ itemName = "heat core",  clientId = 21167,  sell  =  10000 , buy =40000}, 
		{ itemName = "alloy legs",  clientId = 21168,  sell  =  11000 , buy =44000}, 
		{ itemName = "execowtioner axe",  clientId = 21176,  sell  =  12000 , buy =48000}, 
		{ itemName = "angelic axe",  clientId = 7436,  sell  =  5000 , buy =20000}, 
		{ itemName = "blue robe",  clientId = 3567,  sell  =  10000 , buy =40000}, 
		{ itemName = "bonelord shield",  clientId = 3418,  sell  =  1200 , buy =4800}, 
		{ itemName = "boots of haste",  clientId = 3079,  sell  =  30000 , buy =120000}, 
		{ itemName = "broadsword",  clientId = 3301,  sell  =  500 , buy =2000}, 
		{ itemName = "butcher's axe",  clientId = 7412,  sell  =  18000 , buy =72000}, 
		{ itemName = "crown armor",  clientId = 3381,  sell  =  12000 , buy =48000}, 
		{ itemName = "crown helmet",  clientId = 3385,  sell  =  2500 , buy =10000}, 
		{ itemName = "crown legs",  clientId = 3382,  sell  =  12000 , buy =48000}, 
		{ itemName = "crown shield",  clientId = 3419,  sell  =  8000 , buy =32000}, 
		{ itemName = "crusader helmet",  clientId = 3391,  sell  =  6000 , buy =24000}, 
		{ itemName = "dragon lance",  clientId = 3302,  sell  =  9000 , buy =36000}, 
		{ itemName = "dragon shield",  clientId = 3416,  sell  =  4000 , buy =16000}, 
		{ itemName = "fire axe",  clientId = 3320,  sell  =  8000 , buy =32000}, 
		{ itemName = "glorious axe",  clientId = 7454,  sell  =  3000 , buy =12000}, 
		{ itemName = "guardian shield",  clientId = 3415,  sell  =  2000 , buy =8000}, 
		{ itemName = "ice rapier",  clientId = 3284,  sell  =  1000 , buy =4000}, 
		{ itemName = "noble armor",  clientId = 3380,  sell  =  900 , buy =3600}, 
		{ itemName = "obsidian lance",  clientId = 3313,  sell  =  500 , buy =2000}, 
		{ itemName = "phoenix shield",  clientId = 3439,  sell  =  16000 , buy =64000}, 
		{ itemName = "queen's sceptre",  clientId = 7410,  sell  =  20000 , buy =80000}, 
		{ itemName = "royal helmet",  clientId = 3392,  sell  =  30000 , buy =120000}, 
		{ itemName = "shadow sceptre",  clientId = 7451,  sell  =  10000 , buy =40000}, 
		{ itemName = "thaian sword",  clientId = 7391,  sell  =  16000 , buy =64000}, 
		{ itemName = "war hammer",  clientId = 3279,  sell  =  1200 , buy =4800}, 
		{ itemName = "ankh",  clientId = 3077,  sell  =  100 , buy =400}, 
		{ itemName = "dwarven ring",  clientId = 3097,  sell  =  100 , buy =400}, 
		{ itemName = "energy ring",  clientId = 3051,  sell  =  100 , buy =400}, 
		{ itemName = "glacial rod",  clientId = 16118,  sell  =  6500 , buy =26000}, 
		{ itemName = "hailstorm rod",  clientId = 3067,  sell  =  3000 , buy =12000}, 
		{ itemName = "life ring",  clientId = 3052,  sell  =  50 , buy =200}, 
		{ itemName = "moonlight rod",  clientId = 3070,  sell  =  200 , buy =800}, 
		{ itemName = "muck rod",  clientId = 16117,  sell  =  6000 , buy =24000}, 
		{ itemName = "mysterious fetish",  clientId = 3078,  sell  =  50 , buy =200}, 
		{ itemName = "necrotic rod",  clientId = 3069,  sell  =  1000 , buy =4000}, 
		{ itemName = "northwind rod",  clientId = 8083,  sell  =  1500 , buy =6000}, 
		{ itemName = "ring of healing",  clientId = 3098,  sell  =  100 , buy =400}, 
		{ itemName = "snakebite rod",  clientId = 3066,  sell  =  100 , buy =400}, 
		{ itemName = "springsprout rod",  clientId = 8084,  sell  =  3600 , buy =14400}, 
		{ itemName = "terra rod",  clientId = 3065,  sell  =  2000 , buy =8000}, 
		{ itemName = "time ring",  clientId = 3053,  sell  =  100 , buy =400}, 
		{ itemName = "underworld rod",  clientId = 8082,  sell  =  4400 , buy =17600}, 
		{ itemName = "butterfly ring",  clientId = 25698,  sell  =  2000 , buy =8000}, 
		{ itemName = "heavy blossom staff",  clientId = 25700,  sell  =  5000 , buy =20000}, 
		{ itemName = "wooden spellbook",  clientId = 25699,  sell  =  12000 , buy =48000}, 
		{ itemName = "wood cape",  clientId = 3575,  sell  =  5000 , buy =20000}, 
		{ itemName = "club",  clientId = 3270,  sell  =  1 , buy =4}, 
		{ itemName = "coat",  clientId = 3562,  sell  =  1 , buy =4}, 
		{ itemName = "jacket",  clientId = 3561,  sell  =  1 , buy =4}, 
		{ itemName = "dagger",  clientId = 3267,  sell  =  2 , buy =8}, 
		{ itemName = "leather boots",  clientId = 3552,  sell  =  2 , buy =8}, 
		{ itemName = "throwing knife",  clientId = 3298,  sell  =  2 , buy =8}, 
		{ itemName = "doublet",  clientId = 3379,  sell  =  3 , buy =12}, 
		{ itemName = "sickle",  clientId = 3293,  sell  =  3 , buy =12}, 
		{ itemName = "hand axe",  clientId = 3268,  sell  =  4 , buy =16}, 
		{ itemName = "leather helmet",  clientId = 3355,  sell  =  4 , buy =16}, 
		{ itemName = "bone club",  clientId = 3337,  sell  =  5 , buy =20}, 
		{ itemName = "rapier",  clientId = 3272,  sell  =  5 , buy =20}, 
		{ itemName = "small axe",  clientId = 3462,  sell  =  5 , buy =20}, 
		{ itemName = "wooden shield",  clientId = 3412,  sell  =  5 , buy =20}, 
		{ itemName = "axe",  clientId = 3274,  sell  =  7 , buy =28}, 
		{ itemName = "leather legs",  clientId = 3559,  sell  =  9 , buy =36}, 
		{ itemName = "short sword",  clientId = 3294,  sell  =  10 , buy =40}, 
		{ itemName = "studded club",  clientId = 3336,  sell  =  10 , buy =40}, 
		{ itemName = "leather armor",  clientId = 3361,  sell  =  12 , buy =48}, 
		{ itemName = "sabre",  clientId = 3273,  sell  =  12 , buy =48}, 
		{ itemName = "studded legs",  clientId = 3362,  sell  =  15 , buy =60}, 
		{ itemName = "soldier helmet",  clientId = 3375,  sell  =  16 , buy =64}, 
		{ itemName = "studded shield",  clientId = 3426,  sell  =  16 , buy =64}, 
		{ itemName = "chain helmet",  clientId = 3352,  sell  =  17 , buy =68}, 
		{ itemName = "bone sword",  clientId = 3338,  sell  =  20 , buy =80}, 
		{ itemName = "studded helmet",  clientId = 3376,  sell  =  20 , buy =80}, 
		{ itemName = "legion helmet",  clientId = 3374,  sell  =  22 , buy =88}, 
		{ itemName = "brass shield",  clientId = 3411,  sell  =  25 , buy =100}, 
		{ itemName = "chain legs",  clientId = 3558,  sell  =  25 , buy =100}, 
		{ itemName = "hatchet",  clientId = 3276,  sell  =  25 , buy =100}, 
		{ itemName = "studded armor",  clientId = 3378,  sell  =  25 , buy =100}, 
		{ itemName = "sword",  clientId = 3264,  sell  =  25 , buy =100}, 
		{ itemName = "brass helmet",  clientId = 3354,  sell  =  30 , buy =120}, 
		{ itemName = "mace",  clientId = 3286,   sell  =  30 , buy =120}, 
		{ itemName = "katana",  clientId = 3300,  sell  =  35 , buy =140}, 
		{ itemName = "swampling club",  clientId = 17824,  sell  =  40 , buy =160}, 
		{ itemName = "plate shield",  clientId = 3410,  sell  =  45 , buy =180}, 
		{ itemName = "brass legs",  clientId = 3372,  sell  =  49 , buy =196}, 
		{ itemName = "copper shield",  clientId = 3430,  sell  =  50 , buy =200}, 
		{ itemName = "crowbar",  clientId = 3304,  sell  =  50 , buy =200}, 
		{ itemName = "longsword",  clientId = 3285,  sell  =  51 , buy =204}, 
		{ itemName = "viking helmet",  clientId = 3367,  sell  =  66 , buy =264}, 
		{ itemName = "chain armor",  clientId = 3358,  sell  =  70 , buy =280}, 
		{ itemName = "scale armor",  clientId = 3377,  sell  =  75 , buy =300}, 
		{ itemName = "battle axe",  clientId = 3266,  sell  =  80 , buy =320}, 
		{ itemName = "steel shield",  clientId = 3409,  sell  =  80 , buy =320}, 
		{ itemName = "viking shield",  clientId = 3431,  sell  =  85 , buy =340}, 
		{ itemName = "battle shield",  clientId = 3413,  sell  =  95 , buy =380}, 
		{ itemName = "dwarven shield",  clientId = 3425,  sell  =  100 , buy =400}, 
		{ itemName = "morning star",  clientId = 3282,  sell  =  100 , buy =400}, 
		{ itemName = "plate legs",  clientId = 3557,  sell  =  115 , buy =460}, 
		{ itemName = "carlin sword",  clientId = 3283,  sell  =  118 , buy =472}, 
		{ itemName = "battle hammer",  clientId = 3305,  sell  =  120 , buy =480}, 
		{ itemName = "brass armor",  clientId = 3359,  sell  =  150 , buy =600}, 
		{ itemName = "iron helmet",  clientId = 3353,  sell  =  150 , buy =600}, 
		{ itemName = "spike sword",  clientId = 3271,  sell  =  240 , buy =960}, 
		{ itemName = "red lantern",  clientId = 10289,  sell  =  250 , buy =1000}, 
		{ itemName = "double axe",  clientId = 3275,  sell  =  260 , buy =1040}, 
		{ itemName = "steel helmet",  clientId = 3351,  sell  =  293 , buy =1172}, 
		{ itemName = "orcish axe",  clientId = 3316,  sell  =  350 , buy =1400}, 
		{ itemName = "halberd",  clientId = 3269,  sell  =  400 , buy =1600}, 
		{ itemName = "plate armor",  clientId = 3357,  sell  =  400 , buy =1600}, 
		{ itemName = "two handed sword",  clientId = 3265,  sell  =  450 , buy =1800}, 
		{ itemName = "fire sword",  clientId = 3280,  sell  =  1000 , buy =4000}, 
		{ itemName = "broken halberd",  clientId = 10418,  sell  =  100 , buy =400}, 
		{ itemName = "spiked iron ball",  clientId = 10408,  sell  =  100 , buy =400}, 
		{ itemName = "Broken Slicer",  clientId = 11661,  sell  =  120 , buy =480}, 
		{ itemName = "high guard's shoulderplates",  clientId = 10416,  sell  =  130 , buy =520}, 
		{ itemName = "zaogun's shoulderplates",  clientId = 10414,  sell  =  150 , buy =600}, 
		{ itemName = "warmaster's wristguards",  clientId = 10405,  sell  =  200 , buy =800}, 
		{ itemName = "cursed shoulder spikes",  clientId = 10410,  sell  =  320 , buy =1280}, 
		{ itemName = "draken wristbands",  clientId = 11659,  sell  =  430 , buy =1720}, 
		{ itemName = "twin hooks",  clientId = 10392,  sell  =  500 , buy =2000}, 
		{ itemName = "zaoan halberd",  clientId = 10406,  sell  =  500 , buy =2000}, 
		{ itemName = "wailing widow's necklace",  clientId = 10412,  sell  =  3000 , buy =12000}, 
		{ itemName = "zaoan shoes",  clientId = 10386,  sell  =  5000 , buy =20000}, 
		{ itemName = "drachaku",  clientId = 10391,  sell  =  10000 , buy =40000}, 
		{ itemName = "drakinata",  clientId = 10388,  sell  =  10000 , buy =40000}, 
		{ itemName = "zaoan armor",  clientId = 10384,  sell  =  14000 , buy =56000}, 
		{ itemName = "zaoan legs",  clientId = 10387,  sell  =  14000 , buy =56000}, 
		{ itemName = "sai",  clientId = 10389,  sell  =  16500 , buy =66000}, 
		{ itemName = "twiceslicer",  clientId = 11657,  sell  =  28000 , buy =112000}, 
		{ itemName = "zaoan sword",  clientId = 10390,  sell  =  30000 , buy =120000}, 
		{ itemName = "guardian boots",  clientId = 10323,  sell  =  35000 , buy =140000}, 
		{ itemName = "draken boots",  clientId = 4033,  sell  =  40000 , buy =160000}, 
		{ itemName = "zaoan helmet",  clientId = 10385,  sell  =  45000 , buy =180000}, 
		{ itemName = "Elite Draken Mail",  clientId = 11651,  sell  =  50000 , buy =200000}, 
		{ itemName = "amber with a bug",  clientId = 32624,  sell  =  41000 , buy =164000}, 
		{ itemName = "amber with a dragonfly",  clientId = 32625,  sell  =  56000 , buy =224000}, 
		{ itemName = "ancient coin",  clientId = 24390,  sell  =  350 , buy =1400}, 
		{ itemName = "bar of gold",  clientId = 14112,  sell  =  10000 , buy =40000}, 
		{ itemName = "black pearl",  clientId = 3027,  sell  =  280 , buy =1120}, 
		{ itemName = "soul orb",  clientId = 5944,  sell  =  25 , buy =100}, 
		{ itemName = "blue crystal shard",  clientId = 16119,  sell  =  1500 , buy =6000}, 
		{ itemName = "blue crystal splinter",  clientId = 16124,  sell  =  400 , buy =1600}, 
		{ itemName = "brown crystal splinter",  clientId = 16123,  sell  =  400 , buy =1600}, 
		{ itemName = "coral brooch",  clientId = 24391,  sell  =  750 , buy =3000}, 
		{ itemName = "crunor idol",  clientId = 30055,  sell  =  30000 , buy =120000}, 
		{ itemName = "cyan crystal fragment",  clientId = 16125,  sell  =  800 , buy =3200}, 
		{ itemName = "diamond",  clientId = 32770,  sell  =  15000 , buy =60000}, 
		{ itemName = "dragon figurine",  clientId = 30053,  sell  =  45000 , buy =180000}, 
		{ itemName = "eldritch crystal",  clientId = 36835,  sell  =  48000 , buy =192000}, 
		{ itemName = "fiery tear",  clientId = 39040,  sell  =  1070000 , buy =4280000}, 
		{ itemName = "gemmed figurine",  clientId = 24392,  sell  =  3500 , buy =14000}, 
		{ itemName = "giant amethyst",  clientId = 30061,  sell  =  60000 , buy =240000}, 
		{ itemName = "giant emerald",  clientId = 30060,  sell  =  90000 , buy =360000}, 
		{ itemName = "giant ruby",  clientId = 30059,  sell  =  70000 , buy =280000}, 
		{ itemName = "giant sapphire",  clientId = 30061,  sell  =  50000 , buy =200000}, 
		{ itemName = "giant shimmering pearl",  clientId = 281,  sell  =  3000 , buy =12000}, 
		{ itemName = "giant shimmering pearl",  clientId = 282,  sell  =  3000 , buy =12000}, 
		{ itemName = "giant topaz",  clientId = 32623,  sell  =  80000 , buy =320000}, 
		{ itemName = "gold ingot",  clientId = 9058,  sell  =  5000 , buy =20000}, 
		{ itemName = "gold nugget",  clientId = 3040,  sell  =  850 , buy =3400}, 
		{ itemName = "golden figurine",  clientId = 5799,  sell  =  3000 , buy =12000}, 
		{ itemName = "green crystal fragment",  clientId = 16127,  sell  =  800 , buy =3200}, 
		{ itemName = "green crystal shard",  clientId = 16121,  sell  =  1500 , buy =6000}, 
		{ itemName = "green crystal splinter",  clientId = 16122,  sell  =  400 , buy =1600}, 
		{ itemName = "hexagonal ruby",  clientId = 30180,  sell  =  30000 , buy =120000}, 
		{ itemName = "lion figurine",  clientId = 33781,  sell  =  10000 , buy =40000}, 
		{ itemName = "moonstone",  clientId = 32771,  sell  =  13000 , buy =52000}, 
		{ itemName = "onyx chip",  clientId = 22193,  sell  =  400 , buy =1600}, 
		{ itemName = "opal",  clientId = 22194,  sell  =  500 , buy =2000}, 
		{ itemName = "ornate locket",  clientId = 30056,  sell  =  18000 , buy =72000}, 
		{ itemName = "prismatic quartz",  clientId = 24962,  sell  =  450 , buy =1800}, 
		{ itemName = "rainbow querz",  clientId = 25737,  sell  =  500 , buy =2000}, 
		{ itemName = "red crystal fragment",  clientId = 16126,  sell  =  800 , buy =3200}, 
		{ itemName = "royal almandine",  clientId = 39038,  sell  =  460000 , buy =1840000}, 
		{ itemName = "shimmering beetles",  clientId = 25693,  sell  =  150 , buy =600}, 
		{ itemName = "skull coin",  clientId = 32583,  sell  =  12000 , buy =48000}, 
		{ itemName = "small amethyst",  clientId = 3033,  sell  =  200 , buy =800}, 
		{ itemName = "small diamond",  clientId = 3028,  sell  =  300 , buy =1200}, 
		{ itemName = "small emerald",  clientId = 3032,  sell  =  250 , buy =1000}, 
		{ itemName = "small enchanted amethyst",  clientId = 678,  sell  =  200 , buy =800}, 
		{ itemName = "small enchanted emerald",  clientId = 677,  sell  =  250 , buy =1000}, 
		{ itemName = "small enchanted ruby",  clientId = 676,  sell  =  250 , buy =1000}, 
		{ itemName = "small enchanted sapphire",  clientId = 675,  sell  =  250 , buy =1000}, 
		{ itemName = "small ruby",  clientId = 3030,  sell  =  250 , buy =1000}, 
		{ itemName = "small sapphire",  clientId = 3029,  sell  =  250 , buy =1000}, 
		{ itemName = "small topaz",  clientId = 9057,  sell  =  200 , buy =800}, 
		{ itemName = "tiger eye",  clientId = 24961,  sell  =  350 , buy =1400}, 
		{ itemName = "unicorn figurine",  clientId = 30054,  sell  =  50000 , buy =200000}, 
		{ itemName = "violet crystal shard",  clientId = 16120,  sell  =  1500 , buy =6000}, 
		{ itemName = "watermelon tourmaline",  clientId = 33780,  sell  =  230000 , buy =920000}, 
		{ itemName = "watermelon touraline slice",  clientId = 33779,  sell  =  30000 , buy =120000}, 
		{ itemName = "white silk flower",  clientId = 34008,  sell  =  9000 , buy =36000}, 
		{ itemName = "wedding ring",  clientId = 3004,  sell  =  100 , buy =400}, 
		{ itemName = "white pearl",  clientId = 3026,  sell  =  160 , buy =640}, 
		{ itemName = "orichalcum pearl",  clientId = 3026,  sell  =  80 , buy =320}, 
		{ itemName = "batwing hat",  clientId = 9103,  sell  =  8000 , buy =32000}, 
		{ itemName = "ethno coat",  clientId = 8064,  sell  =  200 , buy =800}, 
		{ itemName = "focus cape",  clientId = 8043,  sell  =  6000 , buy =24000}, 
		{ itemName = "jade hat",  clientId = 10451,  sell  =  9000 , buy =36000}, 
		{ itemName = "spellweavers rob",  clientId = 10438,  sell  =  12000 , buy =48000}, 
		{ itemName = "spirit cloak",  clientId = 8042,  sell  =  350 , buy =1400}, 
		{ itemName = "zaoan robe",  clientId = 10439,  sell  =  12000 , buy =48000}, 
		{ itemName = "spellbook of enlightenment",  clientId = 8072,  sell  =  4000 , buy =16000}, 
		{ itemName = "spellbook of lost souls",  clientId = 8075,  sell  =  19000 , buy =76000}, 
		{ itemName = "spellbook of mind control",  clientId = 8074,  sell  =  13000 , buy =52000}, 
		{ itemName = "spellbook of warding",  clientId = 8073,  sell  =  8000 , buy =32000}, 
		{ itemName = "albino plate",  clientId = 19358,  sell  =  1500 , buy =6000}, 
		{ itemName = "amber staff",  clientId = 7426,  sell  =  8000 , buy =32000}, 
		{ itemName = "ancient amulet",  clientId = 3025,  sell  =  200 , buy =800}, 
		{ itemName = "assassin dagger",  clientId = 7404,  sell  =  20000 , buy =80000}, 
		{ itemName = "bandana",  clientId = 5917,  sell  =  150 , buy =600}, 
		{ itemName = "beastslayer axe",  clientId = 3344,  sell  =  1500 , buy =6000}, 
		{ itemName = "beetle necklace",  clientId = 10457,  sell  =  1500 , buy =6000}, 
		{ itemName = "berserker",  clientId = 7403,  sell  =  40000 , buy =160000}, 
		{ itemName = "blacksteel sword",  clientId = 7406,  sell  =  6000 , buy =24000}, 
		{ itemName = "blessed sceptre",  clientId = 7429,  sell  =  40000 , buy =160000}, 
		{ itemName = "bone shield",  clientId = 3441,  sell  =  80 , buy =320}, 
		{ itemName = "bonelord helmet",  clientId = 3408,  sell  =  7500 , buy =30000}, 
		{ itemName = "brutetamer's staff",  clientId = 7379,  sell  =  1500 , buy =6000}, 
		{ itemName = "buckle",  clientId = 17829,  sell  =  7000 , buy =28000}, 
		{ itemName = "castle shield",  clientId = 3435,  sell  =  5000 , buy =20000}, 
		{ itemName = "chain bolter",  clientId = 8022,  sell  =  40000 , buy =160000}, 
		{ itemName = "chaos mace",  clientId = 7427,  sell  =  9000 , buy =36000}, 
		{ itemName = "cobra crown",  clientId = 11674,  sell  =  50000 , buy =200000}, 
		{ itemName = "coconut shoes",  clientId = 9017,  sell  =  500 , buy =2000}, 
		{ itemName = "composite hornbow",  clientId = 8027,  sell  =  25000 , buy =100000}, 
		{ itemName = "cranial basher",  clientId = 7415,  sell  =  30000 , buy =120000}, 
		{ itemName = "crocodile boots",  clientId = 3556,  sell  =  1000 , buy =4000}, 
		{ itemName = "crystal crossbow",  clientId = 16163,  sell  =  35000 , buy =140000}, 
		{ itemName = "crystal mace",  clientId = 3333,  sell  =  12000 , buy =48000}, 
		{ itemName = "crystal necklace",  clientId = 3008,  sell  =  400 , buy =1600}, 
		{ itemName = "crystal ring",  clientId = 3007,  sell  =  250 , buy =1000}, 
		{ itemName = "crystal sword",  clientId = 7449,  sell  =  600 , buy =2400}, 
		{ itemName = "crystalline armor",  clientId = 8050,  sell  =  16000 , buy =64000}, 
		{ itemName = "daramian mace",  clientId = 3327,  sell  =  110 , buy =440}, 
		{ itemName = "daramian waraxe",  clientId = 3328,  sell  =  1000 , buy =4000}, 
		{ itemName = "dark shield",  clientId = 3421,  sell  =  400 , buy =1600}, 
		{ itemName = "death ring",  clientId = 6299,  sell  =  1000 , buy =4000}, 
		{ itemName = "demon shield",  clientId = 3420,  sell  =  30000 , buy =120000}, 
		{ itemName = "demonbone amulet",  clientId = 3019,  sell  =  32000 , buy =128000}, 
		{ itemName = "demonrage sword",  clientId = 7382,  sell  =  36000 , buy =144000}, 
		{ itemName = "devil helmet",  clientId = 3356,  sell  =  1000 , buy =4000}, 
		{ itemName = "diamond sceptre",  clientId = 7387,  sell  =  3000 , buy =12000}, 
		{ itemName = "divine plate",  clientId = 8057,  sell  =  55000 , buy =220000}, 
		{ itemName = "djinn blade",  clientId = 3339,  sell  =  15000 , buy =60000}, 
		{ itemName = "doll",  clientId = 2991,  sell  =  200 , buy =800}, 
		{ itemName = "dragon scale mail",  clientId = 3386,  sell  =  40000 , buy =160000}, 
		{ itemName = "dragon slayer",  clientId = 7402,  sell  =  15000 , buy =60000}, 
		{ itemName = "dragonbone staff",  clientId = 7430,  sell  =  3000 , buy =12000}, 
		{ itemName = "dwarven armor",  clientId = 3397,  sell  =  30000 , buy =120000}, 
		{ itemName = "elvish bow",  clientId = 7438,  sell  =  2000 , buy =8000}, 
		{ itemName = "emerald bangle",  clientId = 3010,  sell  =  800 , buy =3200}, 
		{ itemName = "epee",  clientId = 3326,  sell  =  8000 , buy =32000}, 
		{ itemName = "flower dress",  clientId = 9015,  sell  =  1000 , buy =4000}, 
		{ itemName = "flower wreath",  clientId = 9013,  sell  =  500 , buy =2000}, 
		{ itemName = "fur boots",  clientId = 7457,  sell  =  2000 , buy =8000}, 
		{ itemName = "furry club",  clientId = 7432,  sell  =  1000 , buy =4000}, 
		{ itemName = "glacier amulet",  clientId = 815,  sell  =  1500 , buy =6000}, 
		{ itemName = "glacier kilt",  clientId = 823,  sell  =  11000 , buy =44000}, 
		{ itemName = "glacier mask",  clientId = 829,  sell  =  2500 , buy =10000}, 
		{ itemName = "glacier robe",  clientId = 824,  sell  =  11000 , buy =44000}, 
		{ itemName = "glacier shoes",  clientId = 819,  sell  =  2500 , buy =10000}, 
		{ itemName = "gold ring",  clientId = 3063,  sell  =  8000 , buy =32000}, 
		{ itemName = "golden armor",  clientId = 3360,  sell  =  20000 , buy =80000}, 
		{ itemName = "golden legs",  clientId = 3364,  sell  =  30000 , buy =120000}, 
		{ itemName = "goo shell",  clientId = 19372,  sell  =  4000 , buy =16000}, 
		{ itemName = "griffin shield",  clientId = 3433,  sell  =  3000 , buy =12000}, 
		{ itemName = "guardian halberd",  clientId = 3315,  sell  =  11000 , buy =44000}, 
		{ itemName = "hammer of wrath",  clientId = 3332,  sell  =  30000 , buy =120000}, 
		{ itemName = "headchopper",  clientId = 7380,  sell  =  6000 , buy =24000}, 
		{ itemName = "heavy mace",  clientId = 3340,  sell  =  50000 , buy =200000}, 
		{ itemName = "heavy machete",  clientId = 3330,  sell  =  90 , buy =360}, 
		{ itemName = "heavy trident",  clientId = 12683,  sell  =  2000 , buy =8000}, 
		{ itemName = "helmet of the lost",  clientId = 17852,  sell  =  2000 , buy =8000}, 
		{ itemName = "heroic axe",  clientId = 7389,  sell  =  30000 , buy =120000}, 
		{ itemName = "hibiscus dress",  clientId = 8045,  sell  =  3000 , buy =12000}, 
		{ itemName = "hieroglyph banner",  clientId = 12482,  sell  =  500 , buy =2000}, 
		{ itemName = "horn",  clientId = 19359,  sell  =  300 , buy =1200}, 
		{ itemName = "jade hammer",  clientId = 7422,  sell  =  25000 , buy =100000}, 
		{ itemName = "krimhorn helmet",  clientId = 7461,  sell  =  200 , buy =800}, 
		{ itemName = "lavos armor",  clientId = 8049,  sell  =  16000 , buy =64000}, 
		{ itemName = "leaf legs",  clientId = 9014,  sell  =  500 , buy =2000}, 
		{ itemName = "leopard armor",  clientId = 3404,  sell  =  1000 , buy =4000}, 
		{ itemName = "leviathan's amulet",  clientId = 9303,  sell  =  3000 , buy =12000}, 
		{ itemName = "light shovel",  clientId = 5710,  sell  =  300 , buy =1200}, 
		{ itemName = "lightning boots",  clientId = 820,  sell  =  2500 , buy =10000}, 
		{ itemName = "lightning headband",  clientId = 828,  sell  =  2500 , buy =10000}, 
		{ itemName = "lightning legs",  clientId = 822,  sell  =  11000 , buy =44000}, 
		{ itemName = "lightning pendant",  clientId = 816,  sell  =  1500 , buy =6000}, 
		{ itemName = "lightning robe",  clientId = 825,  sell  =  11000 , buy =44000}, 
		{ itemName = "lunar staff",  clientId = 7424,  sell  =  5000 , buy =20000}, 
		{ itemName = "magic plate armor",  clientId = 3366,  sell  =  90000 , buy =360000}, 
		{ itemName = "magma amulet",  clientId = 817,  sell  =  1500 , buy =6000}, 
		{ itemName = "magma boots",  clientId = 818,  sell  =  2500 , buy =10000}, 
		{ itemName = "magma coat",  clientId = 826,  sell  =  11000 , buy =44000}, 
		{ itemName = "magma legs",  clientId = 821,  sell  =  11000 , buy =44000}, 
		{ itemName = "magma monocle",  clientId = 827,  sell  =  2500 , buy =10000}, 
		{ itemName = "mammoth fur cape",  clientId = 7463,  sell  =  6000 , buy =24000}, 
		{ itemName = "mammoth fur shorts",  clientId = 7464,  sell  =  850 , buy =3400}, 
		{ itemName = "mammoth whopper",  clientId = 7381,  sell  =  300 , buy =1200}, 
		{ itemName = "mastermind shield",  clientId = 3414,  sell  =  50000 , buy =200000}, 
		{ itemName = "medusa shield",  clientId = 3436,  sell  =  9000 , buy =36000}, 
		{ itemName = "mercenary sword",  clientId = 7386,  sell  =  12000 , buy =48000}, 
		{ itemName = "model ship",  clientId = 2994,  sell  =  1000 , buy =4000}, 
		{ itemName = "mycological bow",  clientId = 16164,  sell  =  35000 , buy =140000}, 
		{ itemName = "mystic blade",  clientId = 7384,  sell  =  30000 , buy =120000}, 
		{ itemName = "naginata",  clientId = 3314,  sell  =  2000 , buy =8000}, 
		{ itemName = "nightmare blade",  clientId = 7418,  sell  =  35000 , buy =140000}, 
		{ itemName = "noble axe",  clientId = 7456,  sell  =  10000 , buy =40000}, 
		{ itemName = "norse shield",  clientId = 7460,  sell  =  1500 , buy =6000}, 
		{ itemName = "onyx pendant",  clientId = 22195,  sell  =  3500 , buy =14000}, 
		{ itemName = "orcish maul",  clientId = 7392,  sell  =  6000 , buy =24000}, 
		{ itemName = "oriental shoes",  clientId = 21981,  sell  =  15000 , buy =60000}, 
		{ itemName = "pair of iron fists",  clientId = 17828,  sell  =  4000 , buy =16000}, 
		{ itemName = "paladin armor",  clientId = 8063,  sell  =  15000 , buy =60000}, 
		{ itemName = "patched boots",  clientId = 3550,  sell  =  2000 , buy =8000}, 
		{ itemName = "pharaoh banner",  clientId = 12483,  sell  =  1000 , buy =4000}, 
		{ itemName = "pharaoh sword",  clientId = 3334,  sell  =  23000 , buy =92000}, 
		{ itemName = "pirate boots",  clientId = 5461,  sell  =  3000 , buy =12000}, 
		{ itemName = "pirate hat",  clientId = 6096,  sell  =  1000 , buy =4000}, 
		{ itemName = "pirate knee breeches",  clientId = 5918,  sell  =  200 , buy =800}, 
		{ itemName = "pirate shirt",  clientId = 6095,  sell  =  500 , buy =2000}, 
		{ itemName = "pirate voodoo doll",  clientId = 5810,  sell  =  500 , buy =2000}, 
		{ itemName = "platinum amulet",  clientId = 3055,  sell  =  2500 , buy =10000}, 
		{ itemName = "ragnir helmet",  clientId = 7462,  sell  =  400 , buy =1600}, 
		{ itemName = "relic sword",  clientId = 7383,  sell  =  25000 , buy =100000}, 
		{ itemName = "rift bow",  clientId = 22866,  sell  =  45000 , buy =180000}, 
		{ itemName = "rift crossbow",  clientId = 22867,  sell  =  45000 , buy =180000}, 
		{ itemName = "rift lance",  clientId = 22727,  sell  =  30000 , buy =120000}, 
		{ itemName = "rift shield",  clientId = 22726,  sell  =  50000 , buy =200000}, 
		{ itemName = "ring of the sky",  clientId = 3006,  sell  =  30000 , buy =120000}, 
		{ itemName = "royal axe",  clientId = 7434,  sell  =  40000 , buy =160000}, 
		{ itemName = "ruby necklace",  clientId = 3016,  sell  =  2000 , buy =8000}, 
		{ itemName = "ruthless axe",  clientId = 6553,  sell  =  45000 , buy =180000}, 
		{ itemName = "sacred tree amulet",  clientId = 9302,  sell  =  3000 , buy =12000}, 
		{ itemName = "sapphire hammer",  clientId = 7437,  sell  =  7000 , buy =28000}, 
		{ itemName = "scarab amulet",  clientId = 3018,  sell  =  200 , buy =800}, 
		{ itemName = "scarab shield",  clientId = 3440,  sell  =  2000 , buy =8000}, 
		{ itemName = "shockwave amulet",  clientId = 9304,  sell  =  3000 , buy =12000}, 
		{ itemName = "silver brooch",  clientId = 3017,  sell  =  150 , buy =600}, 
		{ itemName = "silver amulet", clientId = 3054, buy = 100, sell = 50, count = 200 },
		{ itemName = "silver dagger",  clientId = 3290,  sell  =  500 , buy =2000}, 
		{ itemName = "skull helmet",  clientId = 5741,  sell  =  40000 , buy =160000}, 
		{ itemName = "skullcracker armor",  clientId = 8061,  sell  =  18000 , buy =72000}, 
		{ itemName = "spiked squelcher",  clientId = 7452,  sell  =  5000 , buy =20000}, 
		{ itemName = "steel boots",  clientId = 3554,  sell  =  30000 , buy =120000}, 
		{ itemName = "swamplair armor",  clientId = 8052,  sell  =  16000 , buy =64000}, 
		{ itemName = "taurus mace",  clientId = 7425,  sell  =  500 , buy =2000}, 
		{ itemName = "tempest shield",  clientId = 3442,  sell  =  35000 , buy =140000}, 
		{ itemName = "terra amulet",  clientId = 814,  sell  =  1500 , buy =6000}, 
		{ itemName = "terra boots",  clientId = 813,  sell  =  2500 , buy =10000}, 
		{ itemName = "terra hood",  clientId = 830,  sell  =  2500 , buy =10000}, 
		{ itemName = "terra legs",  clientId = 812,  sell  =  11000 , buy =44000}, 
		{ itemName = "terra mantle",  clientId = 811,  sell  =  11000 , buy =44000}, 
		{ itemName = "the justice seeker",  clientId = 7390,  sell  =  40000 , buy =160000}, 
		{ itemName = "tortoise shield",  clientId = 6131,  sell  =  150 , buy =600}, 
		{ itemName = "vile axe",  clientId = 7388,  sell  =  30000 , buy =120000}, 
		{ itemName = "voodoo doll",  clientId = 3002,  sell  =  400 , buy =1600}, 
		{ itemName = "war axe",  clientId = 3342,  sell  =  12000 , buy =48000}, 
		{ itemName = "war horn",  clientId = 2958,  sell  =  8000 , buy =32000}, 
		{ itemName = "witch hat",  clientId = 9653,  sell  =  5000 , buy =20000}, 
		{ itemName = "wyvern fang",  clientId = 7408,  sell  =  1500 , buy =6000}, 
		{ itemName = "axe",  clientId = 3274,  sell  =  7 , buy =28}, 
		{ itemName = "battle axe",  clientId = 3266,  sell  =  80 , buy =320}, 
		{ itemName = "battle hammer",  clientId = 3305,  sell  =  120 , buy =480}, 
		{ itemName = "battle shield",  clientId = 3413,  sell  =  95 , buy =380}, 
		{ itemName = "bone club",  clientId = 3337,  sell  =  5 , buy =20}, 
		{ itemName = "bone sword",  clientId = 3338,  sell  =  20 , buy =80}, 
		{ itemName = "bow",  clientId = 3350,  sell  =  100 , buy =400}, 
		{ itemName = "brass armor",  clientId = 3359,  sell  =  150 , buy =600}, 
		{ itemName = "brass helmet",  clientId = 3354,  sell  =  30 , buy =120}, 
		{ itemName = "brass legs",  clientId = 3372,  sell  =  49 , buy =196}, 
		{ itemName = "brass shield",  clientId = 3411,  sell  =  25 , buy =100}, 
		{ itemName = "calopteryx cape",  clientId = 14086,  sell  =  15000 , buy =60000}, 
		{ itemName = "carapace shield",  clientId = 14088,  sell  =  32000 , buy =128000}, 
		{ itemName = "carlin sword",  clientId = 3283,  sell  =  118 , buy =472}, 
		{ itemName = "chain armor",  clientId = 3358,  sell  =  70 , buy =280}, 
		{ itemName = "chain helmet",  clientId = 3352,  sell  =  17 , buy =68}, 
		{ itemName = "chain legs",  clientId = 3558,  sell  =  25 , buy =100}, 
		{ itemName = "closed trap",  clientId = 3481,  sell  =  75 , buy =300}, 
		{ itemName = "club",  clientId = 3270,  sell  =  1 , buy =4}, 
		{ itemName = "coat",  clientId = 3562,  sell  =  1 , buy =4}, 
		{ itemName = "compound eye",  clientId = 14083,  sell  =  150 , buy =600}, 
		{ itemName = "copper shield",  clientId = 3430,  sell  =  50 , buy =200}, 
		{ itemName = "crawler head plating",  clientId = 14079,  sell  =  210 , buy =840}, 
		{ itemName = "crossbow",  clientId = 3349,  sell  =  120 , buy =480}, 
		{ itemName = "crowbar",  clientId = 3304,  sell  =  50 , buy =200}, 
		{ itemName = "dagger",  clientId = 3267,  sell  =  2 , buy =8}, 
		{ itemName = "deepling axe",  clientId = 13991,  sell  =  40000 , buy =160000}, 
		{ itemName = "deepling breaktime snack",  clientId = 14011,  sell  =  90 , buy =360}, 
		{ itemName = "deepling claw",  clientId = 14044,  sell  =  430 , buy =1720}, 
		{ itemName = "deepling guard belt buckle",  clientId = 14010,  sell  =  230 , buy =920}, 
		{ itemName = "deepling ridge",  clientId = 14041,  sell  =  360 , buy =1440}, 
		{ itemName = "deepling scales",  clientId = 14017,  sell  =  80 , buy =320}, 
		{ itemName = "deepling squelcher",  clientId = 14250,  sell  =  7000 , buy =28000}, 
		{ itemName = "deepling staff",  clientId = 13987,  sell  =  4000 , buy =16000}, 
		{ itemName = "deepling warts",  clientId = 14012,  sell  =  180 , buy =720}, 
		{ itemName = "deeptags",  clientId = 14013,  sell  =  290 , buy =1160}, 
		{ itemName = "depth calcei",  clientId = 13997,  sell  =  25000 , buy =100000}, 
		{ itemName = "depth galea",  clientId = 13995,  sell  =  35000 , buy =140000}, 
		{ itemName = "depth lorica",  clientId = 13994,  sell  =  30000 , buy =120000}, 
		{ itemName = "depth ocrea",  clientId = 13996,  sell  =  16000 , buy =64000}, 
		{ itemName = "depth scutum",  clientId = 13998,  sell  =  36000 , buy =144000}, 
		{ itemName = "double axe",  clientId = 3275,  sell  =  260 , buy =1040}, 
		{ itemName = "doublet",  clientId = 3379,  sell  =  3 , buy =12}, 
		{ itemName = "dung ball",  clientId = 14225,  sell  =  130 , buy =520}, 
		{ itemName = "dwarven shield",  clientId = 3425,  sell  =  100 , buy =400}, 
		{ itemName = "empty potion flask",  clientId = 283,  sell  =  5 , buy =20}, 
		{ itemName = "empty potion flask",  clientId = 284,  sell  =  5 , buy =20}, 
		{ itemName = "empty potion flask",  clientId = 285,  sell  =  5 , buy =20}, 
		{ itemName = "eye of a deepling",  clientId = 12730,  sell  =  150 , buy =600}, 
		{ itemName = "fire sword",  clientId = 3280,  sell  =  1000 , buy =4000}, 
		{ itemName = "fishing rod",  clientId = 3483,  sell  =  40 , buy =160}, 
		{ itemName = "grasshopper legs",  clientId = 14087,  sell  =  15000 , buy =60000}, 
		{ itemName = "guardian axe",  clientId = 14043,  sell  =  9000 , buy =36000}, 
		{ itemName = "halberd",  clientId = 3269,  sell  =  400 , buy =1600}, 
		{ itemName = "hand axe",  clientId = 3268,  sell  =  4 , buy =16}, 
		{ itemName = "hatchet",  clientId = 3276,  sell  =  25 , buy =100}, 
		{ itemName = "hive bow",  clientId = 14246,  sell  =  28000 , buy =112000}, 
		{ itemName = "hive scythe",  clientId = 14089,  sell  =  17000 , buy =68000}, 
		{ itemName = "iron helmet",  clientId = 3353,  sell  =  150 , buy =600}, 
		{ itemName = "jacket",  clientId = 3561,  sell  =  1 , buy =4}, 
		{ itemName = "katana",  clientId = 3300,  sell  =  35 , buy =140}, 
		{ itemName = "key to the drowned library",  clientId = 14009,  sell  =  330 , buy =1320}, 
		{ itemName = "kollos shell",  clientId = 14077,  sell  =  420 , buy =1680}, 
		{ itemName = "leather armor",  clientId = 3361,  sell  =  12 , buy =48}, 
		{ itemName = "leather boots",  clientId = 3552,  sell  =  2 , buy =8}, 
		{ itemName = "leather helmet",  clientId = 3355,  sell  =  4 , buy =16}, 
		{ itemName = "leather legs",  clientId = 3559,  sell  =  9 , buy =36}, 
		{ itemName = "legion helmet",  clientId = 3374,  sell  =  22 , buy =88}, 
		{ itemName = "longsword",  clientId = 3285,  sell  =  51 , buy =204}, 
		{ itemName = "mace",  clientId = 3286,  sell  =  30 , buy =120}, 
		{ itemName = "machete",  clientId = 3308,  sell  =  6 , buy =24}, 
		{ itemName = "morning star",  clientId = 3282,  sell  =  100 , buy =400}, 
		{ itemName = "necklace of the deep",  clientId = 13990,  sell  =  3000 , buy =12000}, 
		{ itemName = "orcish axe",  clientId = 3316,  sell  =  350 , buy =1400}, 
		{ itemName = "ornate chestplate",  clientId = 13993,  sell  =  60000 , buy =240000}, 
		{ itemName = "ornate crossbow",  clientId = 14247,  sell  =  12000 , buy =48000}, 
		{ itemName = "ornate legs",  clientId = 13999,  sell  =  40000 , buy =160000}, 
		{ itemName = "ornate mace",  clientId = 14001,  sell  =  42000 , buy =168000}, 
		{ itemName = "ornate shield",  clientId = 14000,  sell  =  42000 , buy =168000}, 
		{ itemName = "pick",  clientId = 3456,  sell  =  15 , buy =60}, 
		{ itemName = "plate armor",  clientId = 3357,  sell  =  400 , buy =1600}, 
		{ itemName = "plate legs",  clientId = 3557,  sell  =  115 , buy =460}, 
		{ itemName = "plate shield",  clientId = 3410,  sell  =  45 , buy =180}, 
		{ itemName = "rapier",  clientId = 3272,  sell  =  5 , buy =20}, 
		{ itemName = "rope",  clientId = 3003,  sell  =  15 , buy =60}, 
		{ itemName = "sabre",  clientId = 3273,  sell  =  12 , buy =48}, 
		{ itemName = "scale armor",  clientId = 3377,  sell  =  75 , buy =300}, 
		{ itemName = "scythe",  clientId = 3453,  sell  =  10 , buy =40}, 
		{ itemName = "short sword",  clientId = 3294,  sell  =  10 , buy =40}, 
		{ itemName = "shovel",  clientId = 3457,  sell  =  8 , buy =32}, 
		{ itemName = "sickle",  clientId = 3293,  sell  =  3 , buy =12}, 
		{ itemName = "small axe",  clientId = 3462,  sell  =  5 , buy =20}, 
		{ itemName = "soldier helmet",  clientId = 3375,  sell  =  16 , buy =64}, 
		{ itemName = "spear",  clientId = 3277,  sell  =  3 , buy =12}, 
		{ itemName = "spellsinger's seal",  clientId = 14008,  sell  =  280 , buy =1120}, 
		{ itemName = "spidris mandible",  clientId = 14082,  sell  =  450 , buy =1800}, 
		{ itemName = "spike sword",  clientId = 3271,  sell  =  240 , buy =960}, 
		{ itemName = "spitter nose",  clientId = 14078,  sell  =  340 , buy =1360}, 
		{ itemName = "steel helmet",  clientId = 3351,  sell  =  293 , buy =1172}, 
		{ itemName = "steel shield",  clientId = 3409,  sell  =  80 , buy =320}, 
		{ itemName = "studded armor",  clientId = 3378,  sell  =  25 , buy =100}, 
		{ itemName = "studded club",  clientId = 3336,  sell  =  10 , buy =40}, 
		{ itemName = "studded helmet",  clientId = 3376,  sell  =  20 , buy =80}, 
		{ itemName = "studded legs",  clientId = 3362,  sell  =  15 , buy =60}, 
		{ itemName = "studded shield",  clientId = 3426,  sell  =  16 , buy =64}, 
		{ itemName = "swampling club",  clientId = 17824,  sell  =  40 , buy =160}, 
		{ itemName = "swarmer antenna",  clientId = 14076,  sell  =  130 , buy =520}, 
		{ itemName = "sword",  clientId = 3264,  sell  =  25 , buy =100}, 
		{ itemName = "throwing knife",  clientId = 3298,  sell  =  2 , buy =8}, 
		{ itemName = "two handed sword",  clientId = 3265,  sell  =  450 , buy =1800}, 
		{ itemName = "vial",  clientId = 2874,  sell  =  5 , buy =20}, 
		{ itemName = "viking helmet",  clientId = 3367,  sell  =  66 , buy =264}, 
		{ itemName = "viking shield",  clientId = 3431,  sell  =  85 , buy =340}, 
		{ itemName = "war hammer",  clientId = 3279,  sell  =  470 , buy =1880}, 
		{ itemName = "warrior's axe",  clientId = 14040,  sell  =  11000 , buy =44000}, 
		{ itemName = "warrior's shield",  clientId = 14042,  sell  =  9000 , buy =36000}, 
		{ itemName = "waspoid claw",  clientId = 14080,  sell  =  320 , buy =1280}, 
		{ itemName = "waspoid wing",  clientId = 14081,  sell  =  190 , buy =760}, 
		{ itemName = "watch",  clientId = 2906,  sell  =  6 , buy =24}, 
		{ itemName = "wooden hammer",  clientId = 3459,  sell  =  15 , buy =60}, 
		{ itemName = "wooden shield",  clientId = 3412,  sell  =  5 , buy =20}, 
		{ itemName = "blue gem",  clientId = 3041,  sell  =  5000 , buy =20000}, 
		{ itemName = "golden mug",  clientId = 2903,  sell  =  250 , buy =1000}, 
		{ itemName = "green gem",  clientId = 3038,  sell  =  5000 , buy =20000}, 
		{ itemName = "red gem",  clientId = 3039,  sell  =  1000 , buy =4000}, 
		{ itemName = "violet gem",  clientId = 3036,  sell  =  10000 , buy =40000}, 
		{ itemName = "white gem",  clientId = 32769,  sell  =  12000 , buy =48000}, 
		{ itemName = "yellow gem",  clientId = 3037,  sell  =  1000 , buy =4000}, 
		{ itemName = "ring of blue plasma",  clientId = 23529,  sell  =  8000 , buy =32000}, 
		{ itemName = "ring of green plasma",  clientId = 23531,  sell  =  8000 , buy =32000}, 
		{ itemName = "ring of red plasma",  clientId = 23533,  sell  =  8000 , buy =32000}, 
		{ itemName = "collar of blue plasma",  clientId = 23542,  sell  =  6000 , buy =24000}, 
		{ itemName = "collar of green plasma",  clientId = 23543,  sell  =  6000 , buy =24000}, 
		{ itemName = "collar of red plasma",  clientId = 23544,  sell  =  6000 , buy =24000}, 
		{ itemName = "abomination's tail",  clientId = 36791,  sell  =  700000 , buy =2800000}, 
		{ itemName = "abomination's tongue",  clientId = 36793,  sell  =  900000 , buy =3600000}, 
		{ itemName = "abomination's eye",  clientId = 36792,  sell  =  650000 , buy =2600000}, 
		{ itemName = "afflicted strider head",  clientId = 36789,  sell  =  900 , buy =3600}, 
		{ itemName = "afflicted strider worms",  clientId = 36790,  sell  =  500 , buy =2000}, 
		{ itemName = "acorn",  clientId = 10296,  sell  =  10 , buy =40}, 
		{ itemName = "alptramun's toothbrush",  clientId = 29943,  sell  =  270000 , buy =1080000}, 
		{ itemName = "ancient belt buckle",  clientId = 24384,  sell  =  260 , buy =1040}, 
		{ itemName = "ancient liche bone",  clientId = 31588,  sell  =  28000 , buy =112000}, 
		{ itemName = "angel figurine",  clientId = 32589,  sell  =  36000 , buy =144000}, 
		{ itemName = "antlers",  clientId = 10297,  sell  =  50 , buy =200}, 
		{ itemName = "ape fur",  clientId = 5883,  sell  =  120 , buy =480}, 
		{ itemName = "apron",  clientId = 33933,  sell  =  1300 , buy =5200}, 
		{ itemName = "badger fur",  clientId = 903,  sell  =  15 , buy =60}, 
		{ itemName = "bamboo stick",  clientId = 11445,  sell  =  30 , buy =120}, 
		{ itemName = "banana sash",  clientId = 11511,  sell  =  55 , buy =220}, 
		{ itemName = "basalt fetish",  clientId = 17856,  sell  =  210 , buy =840}, 
		{ itemName = "basalt figurine",  clientId = 17857,  sell  =  160 , buy =640}, 
		{ itemName = "basalt core",  clientId = 43859,  sell  =  5800 , buy =23200}, 
		{ itemName = "basalt crumbs",  clientId = 43858,  sell  =  3000 , buy =12000}, 
		{ itemName = "bat decoration",  clientId = 6491,  sell  =  2000 , buy =8000}, 
		{ itemName = "bat wing",  clientId = 5894,  sell  =  50 , buy =200}, 
		{ itemName = "bashmu fang",  clientId = 36820,  sell  =  600 , buy =2400}, 
		{ itemName = "bashmu feather",  clientId = 36823,  sell  =  350 , buy =1400}, 
		{ itemName = "bashmu tongue",  clientId = 36821,  sell  =  400 , buy =1600}, 
		{ itemName = "bear paw",  clientId = 5896,  sell  =  100 , buy =400}, 
		{ itemName = "beast's nightmare-cushion",  clientId = 29946,  sell  =  630000 , buy =2520000}, 
		{ itemName = "bed of nails",  clientId = 25743,  sell  =  500 , buy =2000}, 
		{ itemName = "beer tap",  clientId = 32114,  sell  =  50 , buy =200}, 
		{ itemName = "beetle carapace",  clientId = 24381,  sell  =  200 , buy =800}, 
		{ itemName = "behemoth claw",  clientId = 5930,  sell  =  2000 , buy =8000}, 
		{ itemName = "black hood",  clientId = 9645,  sell  =  190 , buy =760}, 
		{ itemName = "black wool",  clientId = 11448,  sell  =  300 , buy =1200}, 
		{ itemName = "blazing bone",  clientId = 16131,  sell  =  610 , buy =2440}, 
		{ itemName = "blemished spawn abdomen",  clientId = 36779,  sell  =  550 , buy =2200}, 
		{ itemName = "blemished spawn head",  clientId = 36778,  sell  =  800 , buy =3200}, 
		{ itemName = "blemished spawn tail",  clientId = 36780,  sell  =  1000 , buy =4000}, 
		{ itemName = "bloated maggot",  clientId = 43856,  sell  =  5200 , buy =20800}, 
		{ itemName = "blood preservation",  clientId = 11449,  sell  =  320 , buy =1280}, 
		{ itemName = "blood tincture in a vial",  clientId = 18928,  sell  =  360 , buy =1440}, 
		{ itemName = "blooded worm",  clientId = 43857,  sell  =  4700 , buy =18800}, 
		{ itemName = "bloody dwarven beard",  clientId = 17827,  sell  =  110 , buy =440}, 
		{ itemName = "bloody pincers",  clientId = 9633,  sell  =  100 , buy =400}, 
		{ itemName = "bloody tears",  clientId = 32594,  sell  =  70000 , buy =280000}, 
		{ itemName = "blue glass plate",  clientId = 29345,  sell  =  60 , buy =240}, 
		{ itemName = "blue goanna scale",  clientId = 31559,  sell  =  230 , buy =920}, 
		{ itemName = "blue piece of cloth",  clientId = 5912,  sell  =  200 , buy =800}, 
		{ itemName = "boggy dreads",  clientId = 9667,  sell  =  200 , buy =800}, 
		{ itemName = "bola",  clientId = 17809,  sell  =  35 , buy =140}, 
		{ itemName = "bone fetish",  clientId = 17831,  sell  =  150 , buy =600}, 
		{ itemName = "bone shoulderplate",  clientId = 10404,  sell  =  150 , buy =600}, 
		{ itemName = "bone toothpick",  clientId = 24380,  sell  =  150 , buy =600}, 
		{ itemName = "bonecarving knife",  clientId = 17830,  sell  =  190 , buy =760}, 
		{ itemName = "bonelord eye",  clientId = 5898,  sell  =  80 , buy =320}, 
		{ itemName = "bones of zorvorax",  clientId = 24942,  sell  =  10000 , buy =40000}, 
		{ itemName = "bony tail",  clientId = 10277,  sell  =  210 , buy =840}, 
		{ itemName = "book of necromantic rituals",  clientId = 10320,  sell  =  180 , buy =720}, 
		{ itemName = "book of prayers",  clientId = 9646,  sell  =  120 , buy =480}, 
		{ itemName = "book page",  clientId = 28569,  sell  =  640 , buy =2560}, 
		{ itemName = "bowl of terror sweat",  clientId = 20204,  sell  =  500 , buy =2000}, 
		{ itemName = "brain head's giant neuron",  clientId = 32578,  sell  =  100000 , buy =400000}, 
		{ itemName = "brain head's left hemisphere",  clientId = 32579,  sell  =  90000 , buy =360000}, 
		{ itemName = "brain head's right hemisphere",  clientId = 32580,  sell  =  50000 , buy =200000}, 
		{ itemName = "brainstealer's brain",  clientId = 36795,  sell  =  300000 , buy =1200000}, 
		{ itemName = "brainstealer's brainwave",  clientId = 36796,  sell  =  440000 , buy =1760000}, 
		{ itemName = "brainstealer's tissue",  clientId = 36794,  sell  =  240000 , buy =960000}, 
		{ itemName = "bright bell",  clientId = 30324,  sell  =  220 , buy =880}, 
		{ itemName = "brimstone fangs",  clientId = 11702,  sell  =  380 , buy =1520}, 
		{ itemName = "brimstone shell",  clientId = 11703,  sell  =  210 , buy =840}, 
		{ itemName = "broken bell",  clientId = 30185,  sell  =  150 , buy =600}, 
		{ itemName = "broken crossbow",  clientId = 11451,  sell  =  30 , buy =120}, 
		{ itemName = "broken draken mail",  clientId = 11660,  sell  =  340 , buy =1360}, 
		{ itemName = "broken helmet",  clientId = 11453,  sell  =  20 , buy =80}, 
		{ itemName = "broken iks cuirass",  clientId = 40533,  sell  =  640 , buy =2560}, 
		{ itemName = "broken iks faulds",  clientId = 40531,  sell  =  530 , buy =2120}, 
		{ itemName = "broken iks headpiece",  clientId = 40532,  sell  =  560 , buy =2240}, 
		{ itemName = "broken iks sandals",  clientId = 40534,  sell  =  440 , buy =1760}, 
		{ itemName = "broken key ring",  clientId = 11652,  sell  =  8000 , buy =32000}, 
		{ itemName = "broken longbow",  clientId = 34161,  sell  =  130 , buy =520}, 
		{ itemName = "broken macuahuitl",  clientId = 40530,  sell  =  1000 , buy =4000}, 
		{ itemName = "broken ring of ending",  clientId = 12737,  sell  =  4000 , buy =16000}, 
		{ itemName = "broken shamanic staff",  clientId = 11452,  sell  =  35 , buy =140}, 
		{ itemName = "broken throwing axe",  clientId = 17851,  sell  =  230 , buy =920}, 
		{ itemName = "broken visor",  clientId = 20184,  sell  =  1900 , buy =7600}, 
		{ itemName = "brooch of embracement",  clientId = 34023,  sell  =  14000 , buy =56000}, 
		{ itemName = "brown piece of cloth",  clientId = 5913,  sell  =  100 , buy =400}, 
		{ itemName = "bunch of troll hair",  clientId = 9689,  sell  =  30 , buy =120}, 
		{ itemName = "bundle of cursed straw",  clientId = 9688,  sell  =  800 , buy =3200}, 
		{ itemName = "capricious heart",  clientId = 34138,  sell  =  2100 , buy =8400}, 
		{ itemName = "capricious robe",  clientId = 34145,  sell  =  1200 , buy =4800}, 
		{ itemName = "carniphila seeds",  clientId = 10300,  sell  =  50 , buy =200}, 
		{ itemName = "carnisylvan bark",  clientId = 36806,  sell  =  230 , buy =920}, 
		{ itemName = "carnisylvan finger",  clientId = 36805,  sell  =  250 , buy =1000}, 
		{ itemName = "carnivostrich feather",  clientId = 40586,  sell  =  630 , buy =2520}, 
		{ itemName = "carrion worm fang",  clientId = 10275,  sell  =  35 , buy =140}, 
		{ itemName = "cat's paw",  clientId = 5479,  sell  =  2000 , buy =8000}, 
		{ itemName = "cave chimera head",  clientId = 36787,  sell  =  1200 , buy =4800}, 
		{ itemName = "cave chimera leg",  clientId = 36788,  sell  =  650 , buy =2600}, 
		{ itemName = "cave devourer eyes",  clientId = 27599,  sell  =  550 , buy =2200}, 
		{ itemName = "cave devourer eyes",  clientId = 27599,  sell  =  550 , buy =2200}, 
		{ itemName = "cave devourer legs",  clientId = 27601,  sell  =  350 , buy =1400}, 
		{ itemName = "cave devourer maw",  clientId = 27600,  sell  =  600 , buy =2400}, 
		{ itemName = "centipede leg",  clientId = 10301,  sell  =  28 , buy =112}, 
		{ itemName = "chasm spawn abdomen",  clientId = 27603,  sell  =  240 , buy =960}, 
		{ itemName = "chasm spawn head",  clientId = 27602,  sell  =  850 , buy =3400}, 
		{ itemName = "chasm spawn tail",  clientId = 27604,  sell  =  120 , buy =480}, 
		{ itemName = "cheese cutter",  clientId = 17817,  sell  =  50 , buy =200}, 
		{ itemName = "cheesy figurine",  clientId = 17818,  sell  =  150 , buy =600}, 
		{ itemName = "cheesy membership card",  clientId = 35614,  sell  =  120000 , buy =480000}, 
		{ itemName = "chicken feather",  clientId = 5890,  sell  =  30 , buy =120}, 
		{ itemName = "chitinous mouth",  clientId = 27626,  sell  =  10000 , buy =40000}, 
		{ itemName = "cliff strider claw",  clientId = 16134,  sell  =  800 , buy =3200}, 
		{ itemName = "closed pocket sundial",  clientId = 43888,  sell  =  5000 , buy =20000}, 
		{ itemName = "cobra crest",  clientId = 31678,  sell  =  650 , buy =2600}, 
		{ itemName = "cobra tongue",  clientId = 9634,  sell  =  15 , buy =60}, 
		{ itemName = "colourful feather",  clientId = 11514,  sell  =  110 , buy =440}, 
		{ itemName = "colourful feathers",  clientId = 25089,  sell  =  400 , buy =1600}, 
		{ itemName = "colourful snail shell",  clientId = 25696,  sell  =  250 , buy =1000}, 
		{ itemName = "compass",  clientId = 10302,  sell  =  45 , buy =180}, 
		{ itemName = "compound eye",  clientId = 14083,  sell  =  150 , buy =600}, 
		{ itemName = "condensed energy",  clientId = 23501,  sell  =  260 , buy =1040}, 
		{ itemName = "coral branch",  clientId = 39406,  sell  =  360 , buy =1440}, 
		{ itemName = "corrupt naga scales",  clientId = 39415,  sell  =  570 , buy =2280}, 
		{ itemName = "corrupted flag",  clientId = 10409,  sell  =  700 , buy =2800}, 
		{ itemName = "countess sorrow's frozen tear",  clientId = 6536,  sell  =  50000 , buy =200000}, 
		{ itemName = "cow bell",  clientId = 32012,  sell  =  120 , buy =480}, 
		{ itemName = "crab man claws",  clientId = 40582,  sell  =  550 , buy =2200}, 
		{ itemName = "crab pincers",  clientId = 10272,  sell  =  35 , buy =140}, 
		{ itemName = "cracked alabaster vase",  clientId = 24385,  sell  =  180 , buy =720}, 
		{ itemName = "crawler head plating",  clientId = 14079,  sell  =  210 , buy =840}, 
		{ itemName = "crawler's essence",  clientId = 33982,  sell  =  3700 , buy =14800}, 
		{ itemName = "crown",  clientId = 33935,  sell  =  2700 , buy =10800}, 
		{ itemName = "cruelty's chest",  clientId = 33923,  sell  =  720000 , buy =2880000}, 
		{ itemName = "cruelty's claw",  clientId = 33922,  sell  =  640000 , buy =2560000}, 
		{ itemName = "cry-stal",  clientId = 39394,  sell  =  3200 , buy =12800}, 
		{ itemName = "crystal bone",  clientId = 23521,  sell  =  250 , buy =1000}, 
		{ itemName = "crystallized anger",  clientId = 23507,  sell  =  400 , buy =1600}, 
		{ itemName = "cultish mask",  clientId = 9638,  sell  =  280 , buy =1120}, 
		{ itemName = "cultish robe",  clientId = 9639,  sell  =  150 , buy =600}, 
		{ itemName = "cultish symbol",  clientId = 11455,  sell  =  500 , buy =2000}, 
		{ itemName = "curl of hair",  clientId = 36809,  sell  =  320000 , buy =1280000}, 
		{ itemName = "curious matter",  clientId = 23511,  sell  =  430 , buy =1720}, 
		{ itemName = "cursed bone",  clientId = 32774,  sell  =  6000 , buy =24000}, 
		{ itemName = "cursed shoulder spikes",  clientId = 10410,  sell  =  320 , buy =1280}, 
		{ itemName = "cyclops toe",  clientId = 9657,  sell  =  55 , buy =220}, 
		{ itemName = "damaged armor plates",  clientId = 28822,  sell  =  280 , buy =1120}, 
		{ itemName = "damaged worm head",  clientId = 27620,  sell  =  8000 , buy =32000}, 
		{ itemName = "damselfly eye",  clientId = 17463,  sell  =  25 , buy =100}, 
		{ itemName = "damselfly wing",  clientId = 17458,  sell  =  20 , buy =80}, 
		{ itemName = "dandelion seeds",  clientId = 25695,  sell  =  200 , buy =800}, 
		{ itemName = "dangerous proto matter",  clientId = 23515,  sell  =  300 , buy =1200}, 
		{ itemName = "dark bell",  clientId = 32596,  sell  =  310000 , buy =1240000}, 
		{ itemName = "dark obsidian splinter",  clientId = 43850,  sell  =  4400 , buy =17600}, 
		{ itemName = "dark rosary",  clientId = 10303,  sell  =  48 , buy =192}, 
		{ itemName = "darklight basalt chunk",  clientId = 43852,  sell  =  3800 , buy =15200}, 
		{ itemName = "darklight core",  clientId = 43853,  sell  =  4100 , buy =16400}, 
		{ itemName = "darklight matter",  clientId = 43851,  sell  =  5500 , buy =22000}, 
		{ itemName = "decayed finger bone",  clientId = 43846,  sell  =  5100 , buy =20400}, 
		{ itemName = "dead weight",  clientId = 20202,  sell  =  450 , buy =1800}, 
		{ itemName = "deepling breaktime snack",  clientId = 14011,  sell  =  90 , buy =360}, 
		{ itemName = "deepling claw",  clientId = 14044,  sell  =  430 , buy =1720}, 
		{ itemName = "deepling guard belt buckle",  clientId = 14010,  sell  =  230 , buy =920}, 
		{ itemName = "deepling ridge",  clientId = 14041,  sell  =  360 , buy =1440}, 
		{ itemName = "deepling scales",  clientId = 14017,  sell  =  80 , buy =320}, 
		{ itemName = "deepling warts",  clientId = 14012,  sell  =  180 , buy =720}, 
		{ itemName = "deeptags",  clientId = 14013,  sell  =  290 , buy =1160}, 
		{ itemName = "deepworm jaws",  clientId = 27594,  sell  =  500 , buy =2000}, 
		{ itemName = "deepworm spike roots",  clientId = 27593,  sell  =  650 , buy =2600}, 
		{ itemName = "deepworm spikes",  clientId = 27592,  sell  =  800 , buy =3200}, 
		{ itemName = "demon dust",  clientId = 5526,  sell  =  300 , buy =1200}, 
		{ itemName = "demon horn",  clientId = 5954,  sell  =  1000 , buy =4000}, 
		{ itemName = "demonic finger",  clientId = 12541,  sell  =  1000 , buy =4000}, 
		{ itemName = "demonic skeletal hand",  clientId = 9647,  sell  =  80 , buy =320}, 
		{ itemName = "demonic essence",  clientId = 6499,  sell  =  1000 , buy =4000}, 
		{ itemName = "diabolic skull",  clientId = 34025,  sell  =  19000 , buy =76000}, 
		{ itemName = "diremaw brainpan",  clientId = 27597,  sell  =  350 , buy =1400}, 
		{ itemName = "diremaw legs",  clientId = 27598,  sell  =  270 , buy =1080}, 
		{ itemName = "dirty turban",  clientId = 11456,  sell  =  120 , buy =480}, 
		{ itemName = "distorted heart",  clientId = 34142,  sell  =  2100 , buy =8400}, 
		{ itemName = "distorted robe",  clientId = 34149,  sell  =  1200 , buy =4800}, 
		{ itemName = "downy feather",  clientId = 11684,  sell  =  20 , buy =80}, 
		{ itemName = "dowser",  clientId = 19110,  sell  =  35 , buy =140}, 
		{ itemName = "dracola's eye",  clientId = 6546,  sell  =  50000 , buy =200000}, 
		{ itemName = "dracoyle statue",  clientId = 9034,  sell  =  5000 , buy =20000}, 
		{ itemName = "dragon blood",  clientId = 24937,  sell  =  700 , buy =2800}, 
		{ itemName = "dragon claw",  clientId = 5919,  sell  =  8000 , buy =32000}, 
		{ itemName = "dragon priest's wandtip",  clientId = 10444,  sell  =  175 , buy =700}, 
		{ itemName = "dragon tongue",  clientId = 24938,  sell  =  550 , buy =2200}, 
		{ itemName = "dragon's tail",  clientId = 11457,  sell  =  100 , buy =400}, 
		{ itemName = "draken sulphur",  clientId = 11658,  sell  =  550 , buy =2200}, 
		{ itemName = "draken wristbands",  clientId = 11659,  sell  =  430 , buy =1720}, 
		{ itemName = "dream essence egg",  clientId = 30005,  sell  =  205 , buy =820}, 
		{ itemName = "dung ball",  clientId = 14225,  sell  =  130 , buy =520}, 
		{ itemName = "earflap",  clientId = 17819,  sell  =  40 , buy =160}, 
		{ itemName = "elder bonelord tentacle",  clientId = 10276,  sell  =  150 , buy =600}, 
		{ itemName = "elven astral observer",  clientId = 11465,  sell  =  90 , buy =360}, 
		{ itemName = "elven hoof",  clientId = 18994,  sell  =  115 , buy =460}, 
		{ itemName = "elven scouting glass",  clientId = 11464,  sell  =  50 , buy =200}, 
		{ itemName = "elvish talisman",  clientId = 9635,  sell  =  45 , buy =180}, 
		{ itemName = "emerald tortoise shell",  clientId = 39379,  sell  =  2150 , buy =8600}, 
		{ itemName = "empty honey glass",  clientId = 31331,  sell  =  270 , buy =1080}, 
		{ itemName = "enchanted chicken wing",  clientId = 5891,  sell  =  20000 , buy =80000}, 
		{ itemName = "energy ball",  clientId = 23523,  sell  =  300 , buy =1200}, 
		{ itemName = "energy vein",  clientId = 23508,  sell  =  270 , buy =1080}, 
		{ itemName = "ensouled essence",  clientId = 32698,  sell  =  820 , buy =3280}, 
		{ itemName = "essence of a bad dream",  clientId = 10306,  sell  =  360 , buy =1440}, 
		{ itemName = "eye of a deepling",  clientId = 12730,  sell  =  150 , buy =600}, 
		{ itemName = "eye of a weeper",  clientId = 16132,  sell  =  650 , buy =2600}, 
		{ itemName = "eyeless devourer legs",  clientId = 36776,  sell  =  650 , buy =2600}, 
		{ itemName = "eyeless devourer maw",  clientId = 36775,  sell  =  420 , buy =1680}, 
		{ itemName = "eyeless devourer tongue",  clientId = 36777,  sell  =  900 , buy =3600}, 
		{ itemName = "eye of corruption",  clientId = 11671,  sell  =  390 , buy =1560}, 
		{ itemName = "fafnar symbol",  clientId = 31443,  sell  =  950 , buy =3800}, 
		{ itemName = "fairy wings",  clientId = 25694,  sell  =  200 , buy =800}, 
		{ itemName = "falcon crest",  clientId = 28823,  sell  =  650 , buy =2600}, 
		{ itemName = "fern",  clientId = 3737,  sell  =  20 , buy =80}, 
		{ itemName = "fiery heart",  clientId = 9636,  sell  =  375 , buy =1500}, 
		{ itemName = "fig leaf",  clientId = 25742,  sell  =  200 , buy =800}, 
		{ itemName = "figurine of bakragore",  clientId = 43963,  sell  =  5400000 , buy =21600000}, 
		{ itemName = "figurine of cruelty",  clientId = 34019,  sell  =  3100000 , buy =12400000}, 
		{ itemName = "figurine of greed",  clientId = 34021,  sell  =  2900000 , buy =11600000}, 
		{ itemName = "figurine of hatred",  clientId = 34020,  sell  =  2700000 , buy =10800000}, 
		{ itemName = "figurine of malice",  clientId = 34018,  sell  =  2800000 , buy =11200000}, 
		{ itemName = "figurine of megalomania",  clientId = 33953,  sell  =  5000000 , buy =20000000}, 
		{ itemName = "figurine of spite",  clientId = 33952,  sell  =  3000000 , buy =12000000}, 
		{ itemName = "fir cone",  clientId = 19111,  sell  =  25 , buy =100}, 
		{ itemName = "fish fin",  clientId = 5895,  sell  =  150 , buy =600}, 
		{ itemName = "flask of embalming fluid",  clientId = 11466,  sell  =  30 , buy =120}, 
		{ itemName = "flask of warrior's sweat",  clientId = 5885,  sell  =  10000 , buy =40000}, 
		{ itemName = "flotsam",  clientId = 39407,  sell  =  330 , buy =1320}, 
		{ itemName = "fox paw",  clientId = 27462,  sell  =  100 , buy =400}, 
		{ itemName = "frazzle skin",  clientId = 20199,  sell  =  400 , buy =1600}, 
		{ itemName = "frazzle tongue",  clientId = 20198,  sell  =  700 , buy =2800}, 
		{ itemName = "frost giant pelt",  clientId = 9658,  sell  =  160 , buy =640}, 
		{ itemName = "frosty ear of a troll",  clientId = 9648,  sell  =  30 , buy =120}, 
		{ itemName = "frosty heart",  clientId = 9661,  sell  =  280 , buy =1120}, 
		{ itemName = "frozen lightning",  clientId = 23519,  sell  =  270 , buy =1080}, 
		{ itemName = "fur shred",  clientId = 34164,  sell  =  200 , buy =800}, 
		{ itemName = "gauze bandage",  clientId = 9649,  sell  =  90 , buy =360}, 
		{ itemName = "geomancer's robe",  clientId = 11458,  sell  =  80 , buy =320}, 
		{ itemName = "geomancer's staff",  clientId = 11463,  sell  =  120 , buy =480}, 
		{ itemName = "ghastly dragon head",  clientId = 10449,  sell  =  700 , buy =2800}, 
		{ itemName = "ghostly tissue",  clientId = 9690,  sell  =  90 , buy =360}, 
		{ itemName = "ghoul snack",  clientId = 11467,  sell  =  60 , buy =240}, 
		{ itemName = "giant eye",  clientId = 10280,  sell  =  380 , buy =1520}, 
		{ itemName = "giant tentacle",  clientId = 27619,  sell  =  10000 , buy =40000}, 
		{ itemName = "girlish hair decoration",  clientId = 11443,  sell  =  30 , buy =120}, 
		{ itemName = "girtabilu warrior carapace",  clientId = 36971,  sell  =  520 , buy =2080}, 
		{ itemName = "gland",  clientId = 8143,  sell  =  500 , buy =2000}, 
		{ itemName = "glistening bone",  clientId = 23522,  sell  =  250 , buy =1000}, 
		{ itemName = "glob of acid slime",  clientId = 9054,  sell  =  25 , buy =100}, 
		{ itemName = "glob of mercury",  clientId = 9053,  sell  =  20 , buy =80}, 
		{ itemName = "glob of tar",  clientId = 9055,  sell  =  30 , buy =120}, 
		{ itemName = "gloom wolf fur",  clientId = 22007,  sell  =  70 , buy =280}, 
		{ itemName = "glowing rune",  clientId = 28570,  sell  =  350 , buy =1400}, 
		{ itemName = "goanna claw",  clientId = 31561,  sell  =  260 , buy =1040}, 
		{ itemName = "goanna meat",  clientId = 31560,  sell  =  190 , buy =760}, 
		{ itemName = "goblet of gloom",  clientId = 34022,  sell  =  12000 , buy =48000}, 
		{ itemName = "goblin ear",  clientId = 11539,  sell  =  20 , buy =80}, 
		{ itemName = "golden brush",  clientId = 25689,  sell  =  250 , buy =1000}, 
		{ itemName = "golden cheese wedge",  clientId = 35581,  sell  =  6000 , buy =24000}, 
		{ itemName = "golden dustbin",  clientId = 35579,  sell  =  7000 , buy =28000}, 
		{ itemName = "golden lotus brooch",  clientId = 21974,  sell  =  270 , buy =1080}, 
		{ itemName = "golden mask",  clientId = 31324,  sell  =  38000 , buy =152000}, 
		{ itemName = "golden skull",  clientId = 35580,  sell  =  9000 , buy =36000}, 
		{ itemName = "goosebump leather",  clientId = 20205,  sell  =  650 , buy =2600}, 
		{ itemName = "gore horn",  clientId = 39377,  sell  =  2900 , buy =11600}, 
		{ itemName = "gorerilla mane",  clientId = 39392,  sell  =  2750 , buy =11000}, 
		{ itemName = "gorerilla tail",  clientId = 39393,  sell  =  2650 , buy =10600}, 
		{ itemName = "grant of arms",  clientId = 28824,  sell  =  950 , buy =3800}, 
		{ itemName = "grappling hook",  clientId = 35588,  sell  =  150 , buy =600}, 
		{ itemName = "greed's arm",  clientId = 33924,  sell  =  950000 , buy =3800000}, 
		{ itemName = "green bandage",  clientId = 25697,  sell  =  180 , buy =720}, 
		{ itemName = "green dragon leather",  clientId = 5877,  sell  =  100 , buy =400}, 
		{ itemName = "green dragon scale",  clientId = 5920,  sell  =  100 , buy =400}, 
		{ itemName = "green glass plate",  clientId = 29346,  sell  =  180 , buy =720}, 
		{ itemName = "green piece of cloth",  clientId = 5910,  sell  =  200 , buy =800}, 
		{ itemName = "grimace",  clientId = 32593,  sell  =  120000 , buy =480000}, 
		{ itemName = "gruesome fan",  clientId = 34024,  sell  =  15000 , buy =60000}, 
		{ itemName = "guidebook",  clientId = 25745,  sell  =  200 , buy =800}, 
		{ itemName = "hair of a banshee",  clientId = 11446,  sell  =  350 , buy =1400}, 
		{ itemName = "half-digested piece of meat",  clientId = 10283,  sell  =  55 , buy =220}, 
		{ itemName = "half-digested stones",  clientId = 27369,  sell  =  40 , buy =160}, 
		{ itemName = "half-eaten brain",  clientId = 9659,  sell  =  85 , buy =340}, 
		{ itemName = "hand",  clientId = 33936,  sell  =  1450 , buy =5800}, 
		{ itemName = "hardened bone",  clientId = 5925,  sell  =  70 , buy =280}, 
		{ itemName = "harpoon of a giant snail",  clientId = 27625,  sell  =  15000 , buy =60000}, 
		{ itemName = "hatched rorc egg",  clientId = 18997,  sell  =  30 , buy =120}, 
		{ itemName = "haunted piece of wood",  clientId = 9683,  sell  =  115 , buy =460}, 
		{ itemName = "hazardous heart",  clientId = 34140,  sell  =  5000 , buy =20000}, 
		{ itemName = "hazardous robe",  clientId = 34147,  sell  =  3000 , buy =12000}, 
		{ itemName = "head",  clientId = 33937,  sell  =  3500 , buy =14000}, 
		{ itemName = "head many",  clientId = 33932,  sell  =  3200 , buy =12800}, 
		{ itemName = "headpecker beak",  clientId = 39387,  sell  =  2998 , buy =11992}, 
		{ itemName = "headpecker feather",  clientId = 39388,  sell  =  1300 , buy =5200}, 
		{ itemName = "heaven blossom",  clientId = 3657,  sell  =  50 , buy =200}, 
		{ itemName = "hellhound slobber",  clientId = 9637,  sell  =  500 , buy =2000}, 
		{ itemName = "hellspawn tail",  clientId = 10304,  sell  =  475 , buy =1900}, 
		{ itemName = "hemp rope",  clientId = 20206,  sell  =  350 , buy =1400}, 
		{ itemName = "hideous chunk",  clientId = 16140,  sell  =  510 , buy =2040}, 
		{ itemName = "high guard flag",  clientId = 10415,  sell  =  550 , buy =2200}, 
		{ itemName = "high guard shoulderplates",  clientId = 10416,  sell  =  130 , buy =520}, 
		{ itemName = "holy ash",  clientId = 17850,  sell  =  160 , buy =640}, 
		{ itemName = "holy orchid",  clientId = 5922,  sell  =  90 , buy =360}, 
		{ itemName = "honeycomb",  clientId = 5902,  sell  =  40 , buy =160}, 
		{ itemName = "horn of kalyassa",  clientId = 24941,  sell  =  10000 , buy =40000}, 
		{ itemName = "horoscope",  clientId = 18926,  sell  =  40 , buy =160}, 
		{ itemName = "huge shell",  clientId = 27621,  sell  =  15000 , buy =60000}, 
		{ itemName = "huge spiky snail shell",  clientId = 27627,  sell  =  8000 , buy =32000}, 
		{ itemName = "humongous chunk",  clientId = 16139,  sell  =  540 , buy =2160}, 
		{ itemName = "hunter's quiver",  clientId = 11469,  sell  =  80 , buy =320}, 
		{ itemName = "hydra head",  clientId = 10282,  sell  =  600 , buy =2400}, 
		{ itemName = "hydrophytes",  clientId = 39410,  sell  =  220 , buy =880}, 
		{ itemName = "ice flower",  clientId = 30058,  sell  =  370 , buy =1480}, 
		{ itemName = "ichgahal's fungal infestation",  clientId = 43964,  sell  =  900000 , buy =3600000}, 
		{ itemName = "incantation notes",  clientId = 18929,  sell  =  90 , buy =360}, 
		{ itemName = "infernal heart",  clientId = 34139,  sell  =  2100 , buy =8400}, 
		{ itemName = "infernal robe",  clientId = 34146,  sell  =  1200 , buy =4800}, 
		{ itemName = "inkwell",  clientId = 28568,  sell  =  720 , buy =2880}, 
		{ itemName = "instable proto matter",  clientId = 23516,  sell  =  300 , buy =1200}, 
		{ itemName = "iron ore",  clientId = 5880,  sell  =  500 , buy =2000}, 
		{ itemName = "ivory carving",  clientId = 33945,  sell  =  300 , buy =1200}, 
		{ itemName = "ivory comb",  clientId = 32773,  sell  =  8000 , buy =32000}, 
		{ itemName = "izcandar's snow globe",  clientId = 29944,  sell  =  180000 , buy =720000}, 
		{ itemName = "izcandar's sundial",  clientId = 29945,  sell  =  225000 , buy =900000}, 
		{ itemName = "jagged sickle",  clientId = 32595,  sell  =  150000 , buy =600000}, 
		{ itemName = "jaws",  clientId = 34014,  sell  =  3900 , buy =15600}, 
		{ itemName = "jewelled belt",  clientId = 11470,  sell  =  180 , buy =720}, 
		{ itemName = "jungle moa claw",  clientId = 39404,  sell  =  160 , buy =640}, 
		{ itemName = "jungle moa egg",  clientId = 39405,  sell  =  250 , buy =1000}, 
		{ itemName = "jungle moa feather",  clientId = 39403,  sell  =  140 , buy =560}, 
		{ itemName = "katex' blood",  clientId = 34100,  sell  =  210 , buy =840}, 
		{ itemName = "key to the drowned library",  clientId = 14009,  sell  =  330 , buy =1320}, 
		{ itemName = "kollos shell",  clientId = 14077,  sell  =  420 , buy =1680}, 
		{ itemName = "kongra's shoulderpad",  clientId = 11471,  sell  =  100 , buy =400}, 
		{ itemName = "lamassu hoof",  clientId = 31441,  sell  =  330 , buy =1320}, 
		{ itemName = "lamassu horn",  clientId = 31442,  sell  =  240 , buy =960}, 
		{ itemName = "lancer beetle shell",  clientId = 10455,  sell  =  80 , buy =320}, 
		{ itemName = "lancet",  clientId = 18925,  sell  =  90 , buy =360}, 
		{ itemName = "lavafungus head",  clientId = 36785,  sell  =  900 , buy =3600}, 
		{ itemName = "lavafungus ring",  clientId = 36786,  sell  =  390 , buy =1560}, 
		{ itemName = "lavaworm jaws",  clientId = 36771,  sell  =  1100 , buy =4400}, 
		{ itemName = "lavaworm spike roots",  clientId = 36769,  sell  =  600 , buy =2400}, 
		{ itemName = "lavaworm spikes",  clientId = 36770,  sell  =  750 , buy =3000}, 
		{ itemName = "legionnaire flags",  clientId = 10417,  sell  =  500 , buy =2000}, 
		{ itemName = "lion cloak patch",  clientId = 34162,  sell  =  190 , buy =760}, 
		{ itemName = "liodile fang",  clientId = 40583,  sell  =  480 , buy =1920}, 
		{ itemName = "lion crest",  clientId = 34160,  sell  =  270 , buy =1080}, 
		{ itemName = "lion seal",  clientId = 34163,  sell  =  210 , buy =840}, 
		{ itemName = "lion's mane",  clientId = 9691,  sell  =  60 , buy =240}, 
		{ itemName = "little bowl of myrrh",  clientId = 25697,  sell  =  500 , buy =2000}, 
		{ itemName = "lizard essence",  clientId = 11680,  sell  =  300 , buy =1200}, 
		{ itemName = "lizard heart",  clientId = 31340,  sell  =  530 , buy =2120}, 
		{ itemName = "lizard leather",  clientId = 5876,  sell  =  150 , buy =600}, 
		{ itemName = "lizard scale",  clientId = 5881,  sell  =  120 , buy =480}, 
		{ itemName = "longing eyes",  clientId = 27624,  sell  =  8000 , buy =32000}, 
		{ itemName = "lost basher's spike",  clientId = 17826,  sell  =  280 , buy =1120}, 
		{ itemName = "lost bracers",  clientId = 17853,  sell  =  140 , buy =560}, 
		{ itemName = "lost husher's staff",  clientId = 17848,  sell  =  250 , buy =1000}, 
		{ itemName = "lost soul",  clientId = 32227,  sell  =  120 , buy =480}, 
		{ itemName = "luminescent crystal pickaxe",  clientId = 32711,  sell  =  50 , buy =200}, 
		{ itemName = "luminous orb",  clientId = 11454,  sell  =  1000 , buy =4000}, 
		{ itemName = "lump of dirt",  clientId = 9692,  sell  =  10 , buy =40}, 
		{ itemName = "lump of earth",  clientId = 10305,  sell  =  130 , buy =520}, 
		{ itemName = "mad froth",  clientId = 17854,  sell  =  80 , buy =320}, 
		{ itemName = "magic sulphur",  clientId = 5904,  sell  =  8000 , buy =32000}, 
		{ itemName = "makara fin",  clientId = 39401,  sell  =  350 , buy =1400}, 
		{ itemName = "makara tongue",  clientId = 39402,  sell  =  320 , buy =1280}, 
		{ itemName = "malice's horn",  clientId = 33920,  sell  =  620000 , buy =2480000}, 
		{ itemName = "malice's spine",  clientId = 33921,  sell  =  850000 , buy =3400000}, 
		{ itemName = "malofur's lunchbox",  clientId = 30088,  sell  =  240000 , buy =960000}, 
		{ itemName = "mammoth tusk",  clientId = 10321,  sell  =  100 , buy =400}, 
		{ itemName = "mantassin tail",  clientId = 11489,  sell  =  280 , buy =1120}, 
		{ itemName = "manticore ear",  clientId = 31440,  sell  =  310 , buy =1240}, 
		{ itemName = "manticore tail",  clientId = 31439,  sell  =  220 , buy =880}, 
		{ itemName = "mantosaurus jaw",  clientId = 39386,  sell  =  2998 , buy =11992}, 
		{ itemName = "marsh stalker beak",  clientId = 17461,  sell  =  65 , buy =260}, 
		{ itemName = "marsh stalker feather",  clientId = 17462,  sell  =  50 , buy =200}, 
		{ itemName = "maxxenius head",  clientId = 29942,  sell  =  500000 , buy =2000000}, 
		{ itemName = "meat hammer",  clientId = 32093,  sell  =  60 , buy =240}, 
		{ itemName = "medal of valiance",  clientId = 31591,  sell  =  410000 , buy =1640000}, 
		{ itemName = "megalomania's essence",  clientId = 33928,  sell  =  1900000 , buy =7600000}, 
		{ itemName = "megalomania's skull",  clientId = 33925,  sell  =  1500000 , buy =6000000}, 
		{ itemName = "mercurial wing",  clientId = 39395,  sell  =  2500 , buy =10000}, 
		{ itemName = "milk churn",  clientId = 32011,  sell  =  100 , buy =400}, 
		{ itemName = "minotaur horn",  clientId = 11472,  sell  =  75 , buy =300}, 
		{ itemName = "minotaur leather",  clientId = 5878,  sell  =  80 , buy =320}, 
		{ itemName = "miraculum",  clientId = 11474,  sell  =  60 , buy =240}, 
		{ itemName = "moon compass",  clientId = 43739,  sell  =  5000 , buy =20000}, 
		{ itemName = "moon pin",  clientId = 43736,  sell  =  18000 , buy =72000}, 
		{ itemName = "morbid tapestry",  clientId = 34170,  sell  =  30000 , buy =120000}, 
		{ itemName = "morshabaal's brain",  clientId = 37613,  sell  =  5000000 , buy =20000000}, 
		{ itemName = "morshabaal's extract",  clientId = 37810,  sell  =  3250000 , buy =13000000}, 
		{ itemName = "mould heart",  clientId = 34141,  sell  =  2100 , buy =8400}, 
		{ itemName = "mould robe",  clientId = 34148,  sell  =  1200 , buy =4800}, 
		{ itemName = "mouldy powder",  clientId = 35596,  sell  =  200 , buy =800}, 
		{ itemName = "mr. punish's handcuffs",  clientId = 6537,  sell  =  50000 , buy =200000}, 
		{ itemName = "murcion's mycelium",  clientId = 43965,  sell  =  950000 , buy =3800000}, 
		{ itemName = "mutated bat ear",  clientId = 9662,  sell  =  420 , buy =1680}, 
		{ itemName = "mutated flesh",  clientId = 10308,  sell  =  50 , buy =200}, 
		{ itemName = "mutated rat tail",  clientId = 9668,  sell  =  150 , buy =600}, 
		{ itemName = "mystical hourglass",  clientId = 9660,  sell  =  700 , buy =2800}, 
		{ itemName = "naga archer scales",  clientId = 39413,  sell  =  340 , buy =1360}, 
		{ itemName = "naga arming",  clientId = 39411,  sell  =  390 , buy =1560}, 
		{ itemName = "naga earring",  clientId = 39412,  sell  =  380 , buy =1520}, 
		{ itemName = "naga warrior scales",  clientId = 39414,  sell  =  340 , buy =1360}, 
		{ itemName = "necromantic robe",  clientId = 11475,  sell  =  250 , buy =1000}, 
		{ itemName = "nettle blossom",  clientId = 10314,  sell  =  75 , buy =300}, 
		{ itemName = "nettle spit",  clientId = 11476,  sell  =  25 , buy =100}, 
		{ itemName = "nighthuner wing",  clientId = 39381,  sell  =  2000 , buy =8000}, 
		{ itemName = "noble amulet",  clientId = 31595,  sell  =  430000 , buy =1720000}, 
		{ itemName = "noble cape",  clientId = 31593,  sell  =  425000 , buy =1700000}, 
		{ itemName = "noble turban",  clientId = 11486,  sell  =  430 , buy =1720}, 
		{ itemName = "nose ring",  clientId = 5804,  sell  =  2000 , buy =8000}, 
		{ itemName = "odd organ",  clientId = 23510,  sell  =  410 , buy =1640}, 
		{ itemName = "ogre ear stud",  clientId = 22188,  sell  =  180 , buy =720}, 
		{ itemName = "ogre nose ring",  clientId = 22189,  sell  =  210 , buy =840}, 
		{ itemName = "old girtablilu carapace",  clientId = 36972,  sell  =  570 , buy =2280}, 
		{ itemName = "old royal diary",  clientId = 36808,  sell  =  220000 , buy =880000}, 
		{ itemName = "one of timira's many heads",  clientId = 39399,  sell  =  215000 , buy =860000}, 
		{ itemName = "orc leather",  clientId = 11479,  sell  =  30 , buy =120}, 
		{ itemName = "orc tooth",  clientId = 10196,  sell  =  150 , buy =600}, 
		{ itemName = "orcish gear",  clientId = 11477,  sell  =  85 , buy =340}, 
		{ itemName = "pair of hellflayer horns",  clientId = 22729,  sell  =  1300 , buy =5200}, 
		{ itemName = "pair of old bracers",  clientId = 32705,  sell  =  500 , buy =2000}, 
		{ itemName = "pale worm's scalp",  clientId = 32598,  sell  =  489000 , buy =1956000}, 
		{ itemName = "parder fur",  clientId = 39418,  sell  =  150 , buy =600}, 
		{ itemName = "parder tooth",  clientId = 39417,  sell  =  150 , buy =600}, 
		{ itemName = "patch of fine cloth",  clientId = 28821,  sell  =  1350 , buy =5400}, 
		{ itemName = "peacock feather fan",  clientId = 21975,  sell  =  350 , buy =1400}, 
		{ itemName = "pelvis bone",  clientId = 11481,  sell  =  30 , buy =120}, 
		{ itemName = "percht horns",  clientId = 30186,  sell  =  200 , buy =800}, 
		{ itemName = "perfect behemoth fang",  clientId = 5893,  sell  =  250 , buy =1000}, 
		{ itemName = "petrified scream",  clientId = 10420,  sell  =  250 , buy =1000}, 
		{ itemName = "phantasmal hair",  clientId = 32704,  sell  =  500 , buy =2000}, 
		{ itemName = "piece of archer armor",  clientId = 11483,  sell  =  20 , buy =80}, 
		{ itemName = "piece of crocodile leather",  clientId = 10279,  sell  =  15 , buy =60}, 
		{ itemName = "piece of dead brain",  clientId = 9663,  sell  =  420 , buy =1680}, 
		{ itemName = "piece of massacre's shell",  clientId = 6540,  sell  =  50000 , buy =200000}, 
		{ itemName = "piece of scarab shell",  clientId = 9641,  sell  =  45 , buy =180}, 
		{ itemName = "piece of swampling wood",  clientId = 17823,  sell  =  30 , buy =120}, 
		{ itemName = "piece of timira's sensors",  clientId = 39400,  sell  =  150000 , buy =600000}, 
		{ itemName = "piece of warrior armor",  clientId = 11482,  sell  =  50 , buy =200}, 
		{ itemName = "pieces of magic chalk",  clientId = 18930,  sell  =  210 , buy =840}, 
		{ itemName = "pig foot",  clientId = 9693,  sell  =  10 , buy =40}, 
		{ itemName = "pile of grave earth",  clientId = 11484,  sell  =  25 , buy =100}, 
		{ itemName = "pirat's tail",  clientId = 35573,  sell  =  180 , buy =720}, 
		{ itemName = "pirate coin",  clientId = 35572,  sell  =  110 , buy =440}, 
		{ itemName = "plagueroot offshoot",  clientId = 30087,  sell  =  280000 , buy =1120000}, 
		{ itemName = "plasma pearls",  clientId = 23506,  sell  =  250 , buy =1000}, 
		{ itemName = "plasmatic lightning",  clientId = 23520,  sell  =  270 , buy =1080}, 
		{ itemName = "poison gland",  clientId = 29348,  sell  =  210 , buy =840}, 
		{ itemName = "poison spider shell",  clientId = 11485,  sell  =  10 , buy =40}, 
		{ itemName = "poisonous slime",  clientId = 9640,  sell  =  50 , buy =200}, 
		{ itemName = "polar bear paw",  clientId = 9650,  sell  =  30 , buy =120}, 
		{ itemName = "pool of chitinous glue",  clientId = 20207,  sell  =  480 , buy =1920}, 
		{ itemName = "porcelain mask",  clientId = 25088,  sell  =  2000 , buy =8000}, 
		{ itemName = "powder herb",  clientId = 3739,  sell  =  10 , buy =40}, 
		{ itemName = "prehemoth claw",  clientId = 39383,  sell  =  2300 , buy =9200}, 
		{ itemName = "prehemoth horns",  clientId = 39382,  sell  =  3000 , buy =12000}, 
		{ itemName = "pristine worm head",  clientId = 27618,  sell  =  15000 , buy =60000}, 
		{ itemName = "protective charm",  clientId = 11444,  sell  =  60 , buy =240}, 
		{ itemName = "purified soul",  clientId = 32228,  sell  =  260 , buy =1040}, 
		{ itemName = "purple robe",  clientId = 11473,  sell  =  110 , buy =440}, 
		{ itemName = "quara bone",  clientId = 11491,  sell  =  500 , buy =2000}, 
		{ itemName = "quara eye",  clientId = 11488,  sell  =  350 , buy =1400}, 
		{ itemName = "quara pincers",  clientId = 11490,  sell  =  410 , buy =1640}, 
		{ itemName = "quara tentacle",  clientId = 11487,  sell  =  140 , buy =560}, 
		{ itemName = "quill",  clientId = 28567,  sell  =  1100 , buy =4400}, 
		{ itemName = "rare earth",  clientId = 27301,  sell  =  80 , buy =320}, 
		{ itemName = "ratmiral's hat",  clientId = 35613,  sell  =  150000 , buy =600000}, 
		{ itemName = "ravenous circlet",  clientId = 32597,  sell  =  220000 , buy =880000}, 
		{ itemName = "red dragon leather",  clientId = 5948,  sell  =  200 , buy =800}, 
		{ itemName = "red dragon scale",  clientId = 5882,  sell  =  200 , buy =800}, 
		{ itemName = "red goanna scale",  clientId = 31558,  sell  =  270 , buy =1080}, 
		{ itemName = "red hair dye",  clientId = 17855,  sell  =  40 , buy =160}, 
		{ itemName = "red piece of cloth",  clientId = 5911,  sell  =  300 , buy =1200}, 
		{ itemName = "rhindeer antlers",  clientId = 40587,  sell  =  680 , buy =2720}, 
		{ itemName = "rhino hide",  clientId = 24388,  sell  =  175 , buy =700}, 
		{ itemName = "rhino horn",  clientId = 24389,  sell  =  265 , buy =1060}, 
		{ itemName = "rhino horn carving",  clientId = 24386,  sell  =  300 , buy =1200}, 
		{ itemName = "ripptor claw",  clientId = 39389,  sell  =  2000 , buy =8000}, 
		{ itemName = "ripptor scales",  clientId = 39391,  sell  =  1200 , buy =4800}, 
		{ itemName = "rod",  clientId = 33929,  sell  =  2200 , buy =8800}, 
		{ itemName = "rogue naga scales",  clientId = 39416,  sell  =  570 , buy =2280}, 
		{ itemName = "roots",  clientId = 33938,  sell  =  1200 , buy =4800}, 
		{ itemName = "rope belt",  clientId = 11492,  sell  =  66 , buy =264}, 
		{ itemName = "rorc egg",  clientId = 18996,  sell  =  120 , buy =480}, 
		{ itemName = "rorc feather",  clientId = 18993,  sell  =  70 , buy =280}, 
		{ itemName = "rotten heart",  clientId = 31589,  sell  =  74000 , buy =296000}, 
		{ itemName = "rotten piece of cloth",  clientId = 10291,  sell  =  30 , buy =120}, 
		{ itemName = "rotten vermin ichor",  clientId = 43849,  sell  =  4500 , buy =18000}, 
		{ itemName = "rotten roots",  clientId = 43849,  sell  =  3800 , buy =15200}, 
		{ itemName = "sabretooth",  clientId = 10311,  sell  =  400 , buy =1600}, 
		{ itemName = "sabretooth fur",  clientId = 39378,  sell  =  2500 , buy =10000}, 
		{ itemName = "safety pin",  clientId = 11493,  sell  =  120 , buy =480}, 
		{ itemName = "sample of monster blood",  clientId = 27874,  sell  =  250 , buy =1000}, 
		{ itemName = "sandcrawler shell",  clientId = 10456,  sell  =  20 , buy =80}, 
		{ itemName = "scale of corruption",  clientId = 11673,  sell  =  680 , buy =2720}, 
		{ itemName = "scale of gelidrazah",  clientId = 24939,  sell  =  10000 , buy =40000}, 
		{ itemName = "scarab pincers",  clientId = 9631,  sell  =  280 , buy =1120}, 
		{ itemName = "scorpion tail",  clientId = 9651,  sell  =  25 , buy =100}, 
		{ itemName = "scroll of heroic deeds",  clientId = 11510,  sell  =  230 , buy =920}, 
		{ itemName = "scythe leg",  clientId = 10312,  sell  =  450 , buy =1800}, 
		{ itemName = "sea horse figurine",  clientId = 31323,  sell  =  42000 , buy =168000}, 
		{ itemName = "sea serpent scale",  clientId = 9666,  sell  =  520 , buy =2080}, 
		{ itemName = "seeds",  clientId = 647,  sell  =  150 , buy =600}, 
		{ itemName = "shaggy tail",  clientId = 10407,  sell  =  25 , buy =100}, 
		{ itemName = "shamanic hood",  clientId = 11478,  sell  =  45 , buy =180}, 
		{ itemName = "shamanic talisman",  clientId = 22184,  sell  =  200 , buy =800}, 
		{ itemName = "shark fins",  clientId = 35574,  sell  =  250 , buy =1000}, 
		{ itemName = "shimmering beetles",  clientId = 25686,  sell  =  150 , buy =600}, 
		{ itemName = "sight of surrender's eye",  clientId = 20183,  sell  =  3000 , buy =12000}, 
		{ itemName = "signet ring",  clientId = 31592,  sell  =  480000 , buy =1920000}, 
		{ itemName = "silencer claws",  clientId = 20200,  sell  =  390 , buy =1560}, 
		{ itemName = "silencer resonating chamber",  clientId = 20201,  sell  =  600 , buy =2400}, 
		{ itemName = "silken bookmark",  clientId = 28566,  sell  =  1300 , buy =5200}, 
		{ itemName = "silky fur",  clientId = 10292,  sell  =  35 , buy =140}, 
		{ itemName = "silver foxmouse coin",  clientId = 43733,  sell  =  11000 , buy =44000}, 
		{ itemName = "silver moon coin",  clientId = 43732,  sell  =  11000 , buy =44000}, 
		{ itemName = "silver hand mirror",  clientId = 32772,  sell  =  10000 , buy =40000}, 
		{ itemName = "single human eye",  clientId = 25696,  sell  =  1000 , buy =4000}, 
		{ itemName = "skeleton decoration",  clientId = 6525,  sell  =  3000 , buy =12000}, 
		{ itemName = "skull belt",  clientId = 11480,  sell  =  80 , buy =320}, 
		{ itemName = "skull fetish",  clientId = 22191,  sell  =  250 , buy =1000}, 
		{ itemName = "skull shatterer",  clientId = 17849,  sell  =  170 , buy =680}, 
		{ itemName = "skunk tail",  clientId = 10274,  sell  =  50 , buy =200}, 
		{ itemName = "slimy leg",  clientId = 27623,  sell  =  4500 , buy =18000}, 
		{ itemName = "small energy ball",  clientId = 23524,  sell  =  250 , buy =1000}, 
		{ itemName = "small flask of eyedrops",  clientId = 11512,  sell  =  95 , buy =380}, 
		{ itemName = "small notebook",  clientId = 11450,  sell  =  480 , buy =1920}, 
		{ itemName = "small oil lamp",  clientId = 2933,  sell  =  150 , buy =600}, 
		{ itemName = "small pitchfork",  clientId = 11513,  sell  =  70 , buy =280}, 
		{ itemName = "small treasure chest",  clientId = 35571,  sell  =  500 , buy =2000}, 
		{ itemName = "small tropical fish",  clientId = 39408,  sell  =  380 , buy =1520}, 
		{ itemName = "smoldering eye",  clientId = 39543,  sell  =  470000 , buy =1880000}, 
		{ itemName = "snake skin",  clientId = 9694,  sell  =  400 , buy =1600}, 
		{ itemName = "sniper gloves",  clientId = 5875,  sell  =  2000 , buy =8000}, 
		{ itemName = "solid rage",  clientId = 23517,  sell  =  310 , buy =1240}, 
		{ itemName = "some grimeleech wings",  clientId = 22730,  sell  =  1200 , buy =4800}, 
		{ itemName = "soul stone",  clientId = 5809,  sell  =  6000 , buy =24000}, 
		{ itemName = "spark sphere",  clientId = 23518,  sell  =  350 , buy =1400}, 
		{ itemName = "sparkion claw",  clientId = 23502,  sell  =  290 , buy =1160}, 
		{ itemName = "sparkion legs",  clientId = 23504,  sell  =  310 , buy =1240}, 
		{ itemName = "sparkion stings",  clientId = 23505,  sell  =  280 , buy =1120}, 
		{ itemName = "sparkion tail",  clientId = 23503,  sell  =  300 , buy =1200}, 
		{ itemName = "spectral gold nugget",  clientId = 32724,  sell  =  500 , buy =2000}, 
		{ itemName = "spectral silver nugget",  clientId = 32725,  sell  =  250 , buy =1000}, 
		{ itemName = "spellsinger's seal",  clientId = 14008,  sell  =  280 , buy =1120}, 
		{ itemName = "sphinx feather",  clientId = 31437,  sell  =  470 , buy =1880}, 
		{ itemName = "sphinx tiara",  clientId = 31438,  sell  =  360 , buy =1440}, 
		{ itemName = "spider fangs",  clientId = 8031,  sell  =  10 , buy =40}, 
		{ itemName = "spider silk",  clientId = 5879,  sell  =  100 , buy =400}, 
		{ itemName = "spidris mandible",  clientId = 14082,  sell  =  450 , buy =1800}, 
		{ itemName = "spiked iron ball",  clientId = 10408,  sell  =  100 , buy =400}, 
		{ itemName = "spirit container",  clientId = 5884,  sell  =  40000 , buy =160000}, 
		{ itemName = "spite's spirit",  clientId = 33926,  sell  =  840000 , buy =3360000}, 
		{ itemName = "spitter nose",  clientId = 14078,  sell  =  340 , buy =1360}, 
		{ itemName = "spooky blue eye",  clientId = 9642,  sell  =  95 , buy =380}, 
		{ itemName = "srezz' eye",  clientId = 34103,  sell  =  300 , buy =1200}, 
		{ itemName = "stalking seeds",  clientId = 39384,  sell  =  1800 , buy =7200}, 
		{ itemName = "star herb",  clientId = 3736,  sell  =  15 , buy =60}, 
		{ itemName = "stone herb",  clientId = 3735,  sell  =  20 , buy =80}, 
		{ itemName = "stone wing",  clientId = 10278,  sell  =  120 , buy =480}, 
		{ itemName = "stonerefiner's skull",  clientId = 27606,  sell  =  100 , buy =400}, 
		{ itemName = "strand of medusa hair",  clientId = 10309,  sell  =  600 , buy =2400}, 
		{ itemName = "strange proto matter",  clientId = 23513,  sell  =  300 , buy =1200}, 
		{ itemName = "strange talisman", clientId = 3045, buy = 100, sell = 30, count = 200 },
		{ itemName = "strange symbol",  clientId = 3058,  sell  =  200 , buy =800}, 
		{ itemName = "streaked devourer eyes",  clientId = 36772,  sell  =  500 , buy =2000}, 
		{ itemName = "streaked devourer legs",  clientId = 36774,  sell  =  600 , buy =2400}, 
		{ itemName = "streaked devourer maw",  clientId = 36773,  sell  =  400 , buy =1600}, 
		{ itemName = "striped fur",  clientId = 10293,  sell  =  50 , buy =200}, 
		{ itemName = "sulphider shell",  clientId = 39375,  sell  =  2200 , buy =8800}, 
		{ itemName = "sulphur powder",  clientId = 39376,  sell  =  1900 , buy =7600}, 
		{ itemName = "sun brooch",  clientId = 43737,  sell  =  18000 , buy =72000}, 
		{ itemName = "swamp grass",  clientId = 9686,  sell  =  20 , buy =80}, 
		{ itemName = "swampling moss",  clientId = 17822,  sell  =  20 , buy =80}, 
		{ itemName = "swarmer antenna",  clientId = 14076,  sell  =  130 , buy =520}, 
		{ itemName = "tail of corruption",  clientId = 11672,  sell  =  240 , buy =960}, 
		{ itemName = "tarantula egg",  clientId = 10281,  sell  =  80 , buy =320}, 
		{ itemName = "tarnished rhino figurine",  clientId = 24387,  sell  =  320 , buy =1280}, 
		{ itemName = "tattered piece of robe",  clientId = 9684,  sell  =  120 , buy =480}, 
		{ itemName = "telescope eye",  clientId = 33934,  sell  =  1600 , buy =6400}, 
		{ itemName = "tentacle of tentugly",  clientId = 35611,  sell  =  27000 , buy =108000}, 
		{ itemName = "tentacle piece",  clientId = 11666,  sell  =  5000 , buy =20000}, 
		{ itemName = "tentugly's eye",  clientId = 35610,  sell  =  52000 , buy =208000}, 
		{ itemName = "tentugly's jaws",  clientId = 35612,  sell  =  80000 , buy =320000}, 
		{ itemName = "terramite eggs",  clientId = 10453,  sell  =  50 , buy =200}, 
		{ itemName = "terramite legs",  clientId = 10454,  sell  =  60 , buy =240}, 
		{ itemName = "terramite shell",  clientId = 10452,  sell  =  170 , buy =680}, 
		{ itemName = "terrorbird beak",  clientId = 10273,  sell  =  95 , buy =380}, 
		{ itemName = "the handmaiden's protector",  clientId = 6539,  sell  =  50000 , buy =200000}, 
		{ itemName = "the imperor's trident",  clientId = 6534,  sell  =  50000 , buy =200000}, 
		{ itemName = "the plasmother's remains",  clientId = 6535,  sell  =  50000 , buy =200000}, 
		{ itemName = "thick fur",  clientId = 10307,  sell  =  150 , buy =600}, 
		{ itemName = "thorn",  clientId = 9643,  sell  =  100 , buy =400}, 
		{ itemName = "tiara",  clientId = 35578,  sell  =  11000 , buy =44000}, 
		{ itemName = "token of love",  clientId = 31594,  sell  =  440000 , buy =1760000}, 
		{ itemName = "tooth file",  clientId = 18924,  sell  =  60 , buy =240}, 
		{ itemName = "tooth of tazhadur",  clientId = 24940,  sell  =  10000 , buy =40000}, 
		{ itemName = "torn shirt",  clientId = 25744,  sell  =  250 , buy =1000}, 
		{ itemName = "trapped bad dream monster",  clientId = 20203,  sell  =  900 , buy =3600}, 
		{ itemName = "tremendous tyrant head",  clientId = 36783,  sell  =  930 , buy =3720}, 
		{ itemName = "tremendous tyrant shell",  clientId = 36784,  sell  =  740 , buy =2960}, 
		{ itemName = "troll green",  clientId = 3741,  sell  =  25 , buy =100}, 
		{ itemName = "trollroot",  clientId = 11515,  sell  =  50 , buy =200}, 
		{ itemName = "tunnel tyrant head",  clientId = 27595,  sell  =  500 , buy =2000}, 
		{ itemName = "tunnel tyrant shell",  clientId = 27596,  sell  =  700 , buy =2800}, 
		{ itemName = "turtle shell",  clientId = 5899,  sell  =  90 , buy =360}, 
		{ itemName = "tusk",  clientId = 3044,  sell  =  100 , buy =400}, 
		{ itemName = "two-headed turtle heads",  clientId = 39409,  sell  =  460 , buy =1840}, 
		{ itemName = "undead heart",  clientId = 10450,  sell  =  200 , buy =800}, 
		{ itemName = "undertaker fangs",  clientId = 39380,  sell  =  2700 , buy =10800}, 
		{ itemName = "unholy bone",  clientId = 10316,  sell  =  480 , buy =1920}, 
		{ itemName = "urmahlullus mane",  clientId = 31623,  sell  =  490000 , buy =1960000}, 
		{ itemName = "urmahlullus paws",  clientId = 31624,  sell  =  245000 , buy =980000}, 
		{ itemName = "urmahlullus tail",  clientId = 31622,  sell  =  210000 , buy =840000}, 
		{ itemName = "utua's poison",  clientId = 34101,  sell  =  230 , buy =920}, 
		{ itemName = "vampire dust",  clientId = 5905,  sell  =  100 , buy =400}, 
		{ itemName = "vampire teeth",  clientId = 9685,  sell  =  275 , buy =1100}, 
		{ itemName = "vampire's cape chain",  clientId = 18927,  sell  =  150 , buy =600}, 
		{ itemName = "varnished diremaw brainpan",  clientId = 36781,  sell  =  750 , buy =3000}, 
		{ itemName = "varnished diremaw legs",  clientId = 36782,  sell  =  670 , buy =2680}, 
		{ itemName = "veal",  clientId = 32009,  sell  =  40 , buy =160}, 
		{ itemName = "venison",  clientId = 18995,  sell  =  55 , buy =220}, 
		{ itemName = "vexclaw talon",  clientId = 22728,  sell  =  1100 , buy =4400}, 
		{ itemName = "vial of hatred",  clientId = 33927,  sell  =  737000 , buy =2948000}, 
		{ itemName = "vibrant heart",  clientId = 34143,  sell  =  2100 , buy =8400}, 
		{ itemName = "vibrant robe",  clientId = 34144,  sell  =  1200 , buy =4800}, 
		{ itemName = "violet glass plate",  clientId = 29347,  sell  =  2150 , buy =8600}, 
		{ itemName = "volatile proto matter",  clientId = 23514,  sell  =  300 , buy =1200}, 
		{ itemName = "warmaster's wristguards",  clientId = 10405,  sell  =  200 , buy =800}, 
		{ itemName = "warwolf fur",  clientId = 10318,  sell  =  30 , buy =120}, 
		{ itemName = "waspoid claw",  clientId = 14080,  sell  =  320 , buy =1280}, 
		{ itemName = "waspoid wing",  clientId = 14081,  sell  =  190 , buy =760}, 
		{ itemName = "weaver's wandtip",  clientId = 10397,  sell  =  250 , buy =1000}, 
		{ itemName = "werebadger claws",  clientId = 22051,  sell  =  160 , buy =640}, 
		{ itemName = "werebadger skull",  clientId = 22055,  sell  =  185 , buy =740}, 
		{ itemName = "werebear fur",  clientId = 22057,  sell  =  85 , buy =340}, 
		{ itemName = "werebear skull",  clientId = 22056,  sell  =  195 , buy =780}, 
		{ itemName = "wereboar hooves",  clientId = 22053,  sell  =  175 , buy =700}, 
		{ itemName = "wereboar tusks",  clientId = 22054,  sell  =  165 , buy =660}, 
		{ itemName = "werecrocodile tongue",  clientId = 43729,  sell  =  570 , buy =2280}, 
		{ itemName = "werefox tail",  clientId = 27463,  sell  =  200 , buy =800}, 
		{ itemName = "werehyaena nose",  clientId = 33943,  sell  =  220 , buy =880}, 
		{ itemName = "werehyaena talisman",  clientId = 33944,  sell  =  350 , buy =1400}, 
		{ itemName = "werepanther claw",  clientId = 43731,  sell  =  280 , buy =1120}, 
		{ itemName = "werewolf fangs",  clientId = 22052,  sell  =  180 , buy =720}, 
		{ itemName = "werewolf fur",  clientId = 10317,  sell  =  380 , buy =1520}, 
		{ itemName = "white piece of cloth",  clientId = 5909,  sell  =  100 , buy =400}, 
		{ itemName = "widow's mandibles",  clientId = 10411,  sell  =  110 , buy =440}, 
		{ itemName = "wild flowers",  clientId = 25691,  sell  =  120 , buy =480}, 
		{ itemName = "might ring", clientId = 3048, buy = 5000, sell = 1000, count = 20 },
		{ itemName = "dragon necklace", clientId = 3085, buy = 1000, sell = 100, count = 200 },
		{ itemName = "protection amulet", clientId = 3084, buy = 700, sell = 100, count = 250 },
		{ itemName = "wimp tooth chain",  clientId = 17847,  sell  =  120 , buy =480}, 
		{ itemName = "winged tail",  clientId = 10313,  sell  =  800 , buy =3200}, 
		{ itemName = "winter wolf fur",  clientId = 10295,  sell  =  20 , buy =80}, 
		{ itemName = "witch broom",  clientId = 9652,  sell  =  60 , buy =240}, 
		{ itemName = "withered pauldrons",  clientId = 27607,  sell  =  850 , buy =3400}, 
		{ itemName = "withered scalp",  clientId = 27608,  sell  =  900 , buy =3600}, 
		{ itemName = "wolf paw",  clientId = 5897,  sell  =  70 , buy =280}, 
		{ itemName = "wood",  clientId = 5901,  sell  =  5 , buy =20}, 
		{ itemName = "wool",  clientId = 10319,  sell  =  15 , buy =60}, 
		{ itemName = "worm sponge",  clientId = 43848,  sell  =  4200 , buy =16800}, 
		{ itemName = "writhing brain",  clientId = 32600,  sell  =  370000 , buy =1480000}, 
		{ itemName = "writhing heart",  clientId = 32599,  sell  =  185000 , buy =740000}, 
		{ itemName = "wyrm scale",  clientId = 9665,  sell  =  400 , buy =1600}, 
		{ itemName = "wyvern talisman",  clientId = 9644,  sell  =  265 , buy =1060}, 
		{ itemName = "yellow piece of cloth",  clientId = 5914,  sell  =  150 , buy =600}, 
		{ itemName = "yielowax",  clientId = 12742,  sell  =  600 , buy =2400}, 
		{ itemName = "yirkas' egg",  clientId = 34102,  sell  =  280 , buy =1120}, 
		{ itemName = "young lich worm",  clientId = 31590,  sell  =  25000 , buy =100000}, 
		{ itemName = "zaogun flag",  clientId = 10413,  sell  =  600 , buy =2400}, 
		{ itemName = "zaogun shoulderplates",  clientId = 10414,  sell  =  150 , buy =600}, 	
}

-- On buy npc shop message
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end
-- On sell npc shop message
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_TRADE, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end
-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType) end


-- npcType registering the npcConfig table
npcType:register(npcConfig)
