local internalNpcName = "Jean Pierre"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 104
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

local ingredients = {
	[1] = {{3577, 2}, {8010, 20}, {8015, 1}, {8197, 1}, {3603, 5}, {2874, 2, 3}},
	[2] = {{7250, 2}, {3596, 2}, {8014, 1}, {3606, 2}, {3741, 1}, {2874, 1, 15}},
	[3] = {{4363, 1}, {8016, 3}, {3602, 5}, {3606, 2}, {3739, 1}, {3724, 5}},
	[4] = {{4330, 1}, {8013, 2}, {3586, 2}, {5096, 2}, {2874, 2, 14}, {3735, 1}},
	[5] = {{6574, 1}, {904, 1}, {3587, 2}, {2874, 2, 6}, {3738, 1}, {3736, 1}},
	[6] = {{3595, 2}, {3596, 2}, {3597, 2}, {8014, 2}, {8015, 1}, {8197, 1}, {3607, 1}, {3723, 20}, {3725, 5}},
	[7] = {{8016, 10}, {3607, 2}, {3741, 1}, {3740, 1}, {2874, 1, 43}, {3606, 2}},
	[8] = {{3582, 1}, {8011, 5}, {8015, 1}, {8017, 2}, {3594, 1}, {8016, 2}},
	[9] = {{3580, 1}, {7158, 1}, {7159, 1}, {3581, 5}, {3601, 2}, {3737, 1}},
	[10] = {{3595, 5}, {2874, 1, 6}, {8013, 1}, {3603, 10}, {3606, 2}, {3598, 10}, {841, 2}},
	[11] = {{2874, 5, 14}, {3725, 5}, {3724, 5}, {10329, 10}, {3581, 10}},
	[12] = {{10456, 5}, {2874, 2, 1}, {3595, 20}, {8010, 10}, {8016, 3}},
	[13] = {{6569, 3}, {3599, 3}, {6574, 2}, {6500, 15}, {6558, 1}},
	[14] = {{3606, 40}, {5096, 20}, {5902, 10}, {8758, 1}, {5942, 1}}
}

local function playerHasIngredients(creature)
	local player = Player(creature)
	local table = ingredients[player:getStorageValue(Storage.HotCuisineQuest.CurrentDish)]
	if table then
		for i = 1, #table do
			local itemCount = player:getItemCount(table[i][1], table[i][3] or -1)
			if itemCount < table[i][2] then
				itemCount = table[i][2] - itemCount
				return false
			end
		end
	end

	for i = 1, #table do
		player:removeItem(unpack(table[i]))
	end
	return true
end
local function greetCallback(npc, creature)
	local player = Player(creature)
	local playerId = player:getId()

	if player:getStorageValue(Storage.HotCuisineQuest.QuestStart) < 1 then
		npcHandler:setMessage(MESSAGE_GREET, "Greetings, |PLAYERNAME|. What are you doing out here?")
	else
		npcHandler:setMessage(MESSAGE_GREET, "Hello there again, |PLAYERNAME|! I guess you're back for some cooking - let's get going then!")
	end
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "cook") then
		if player:getStorageValue(Storage.HotCuisineQuest.QuestStart) < 1 then
			npcHandler:say("Well, I'm not a simple cook. I travel the whole Tibian continent for the most artfully seasoned {recipes} and constantly develop new ones.", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, "recipe") or MsgContains(message, "menu") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("You're interested in my recipes? Well. They are not for sale, but if you want to become my {apprentice}, I'll share my knowledge with you.", npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
		if player:getStorageValue(Storage.HotCuisineQuest.QuestStart) == 1 then
			if player:getStorageValue(Storage.HotCuisineQuest.CurrentDish) == 1 then
				npcHandler:say({
					"The first dish we are going to prepare together is called {Rotworm Stew}. Now, don't be scared off. Of course we won't eat those nasty and dirty earth-crawlers! ...",
					"The name is just for the effect it has on people. <winks> Bring me the following ingredients and I'll show you how it's done. ...",
					"Two pieces of meat, two vials of beer, twenty potatoes, one onion, one bulb of garlic and five ounces of flour. Make sure that the ingredients are fresh and smell good."
				}, npc, creature)
				npcHandler:setTopic(playerId, 4)
			elseif player:getStorageValue(Storage.HotCuisineQuest.CurrentDish) == 2 then
				npcHandler:say({
					"The next dish we are going to prepare together is called {Hydra Tongue Salad}. The common hydra tongue is a pest plant with an surprisingly aromatic taste. ...",
					"We'll add some other vegetables and spices for the delicate and distinctive taste. Bring me the following ingredients and I'll show you how it's done. ...",
					"Two hydra tongue plants, two tomatoes, one cucumber, two eggs, one troll green and one vial of wine."
				}, npc, creature)
				npcHandler:setTopic(playerId, 6)
			elseif player:getStorageValue(Storage.HotCuisineQuest.CurrentDish) == 3 then
				npcHandler:say({
					"The next dish we are going to prepare together is called {Roasted Dragon Wings}. Oh, don't give me that look! Of course you don't have to bring a whole dragon up here. ...",
					"The 'dragon' part derives from the fiery afterburn of this meal, but the wings we use are much smaller, though similar in shape. Bring me the following ingredients and I'll show you how it's done. ...",
					"One fresh dead bat, three jalapeño peppers, five brown breads, two eggs, one powder herb and five red mushrooms."
				}, npc, creature)
				npcHandler:setTopic(playerId, 8)
			elseif player:getStorageValue(Storage.HotCuisineQuest.CurrentDish) == 4 then
				npcHandler:say({
					"The next dish we are going to prepare together is called {Tropical Fried Terrorbird}. You might have guessed it, we're not going to use a terrorbird. But! ...",
					"The dish is quite fried and tropical. Bring me the following ingredients and we're going to prepare it: One fresh dead chicken, two lemons, two oranges, two mangos, one stone herb and two vials of coconut milk."
				}, npc, creature)
				npcHandler:setTopic(playerId, 10)
			elseif player:getStorageValue(Storage.HotCuisineQuest.CurrentDish) == 5 then
				npcHandler:say({
					"The next dish we are going to prepare together is called {Banana Chocolate Shake}. After all those spicy dishes you should treat your guests with a sweet surprise. ...",
					"Bring me the following ingredients and we'll make one hell of a drink: one bar of chocolate, one cream cake, two bananas, two vials of milk, one sling herb and one star herb."
				}, npc, creature)
				npcHandler:setTopic(playerId, 12)
			elseif player:getStorageValue(Storage.HotCuisineQuest.CurrentDish) == 6 then
				npcHandler:say({
					"The next dish we are going to prepare together is called {Veggie Casserole}. This one is going to be your masterpiece so far, I'm telling you. ...",
					"It's also quite healthy! - Well, that's what I keep telling me when I eat the third serving, hehehe. Bring me the following ingredients and I'll show you how it's done. ...",
					"Two carrots, two tomatoes, two corncobs, two cucumbers, one onion, one bulb of garlic, one piece of cheese, twenty white mushrooms and five brown mushrooms."
				}, npc, creature)
				npcHandler:setTopic(playerId, 14)
			elseif player:getStorageValue(Storage.HotCuisineQuest.CurrentDish) == 7 then
				npcHandler:say({
					"The next dish we are going to prepare together is called {Filled Jalapeño Peppers}. It's a great snack and quite spicy, for those who like it hot. ...",
					"Bring me the following ingredients and I'll show you how it's done: Ten jalapeño peppers, two pieces of cheese, one troll green, one shadow herb, one vial of mead and two eggs."
				}, npc, creature)
				npcHandler:setTopic(playerId, 16)
			elseif player:getStorageValue(Storage.HotCuisineQuest.CurrentDish) == 8 then
				npcHandler:say({
					"The next dish we are going to prepare together is called {Blessed Steak}. <giggles> I'm sorry, I couldn't resist the pun with this one. ...",
					"Don't worry, there's no temple trip awaiting you. Just bring me the following: one piece of ham, five plums, one onion, two beetroots, one pumpkin and two jalapeño peppers."
				}, npc, creature)
				npcHandler:setTopic(playerId, 18)
			elseif player:getStorageValue(Storage.HotCuisineQuest.CurrentDish) == 9 then
				npcHandler:say({
					"The next dish we are going to prepare together is called {Northern Fishburger}. I hope you like fish, not everyone does. This one is a specialty I picked up in Svargrond. ...",
					"Bring me the following ingredients and I'll show you how it's done: one northern pike, one rainbow trout, one green perch, five shrimps, two rolls and one fern."
				}, npc, creature)
				npcHandler:setTopic(playerId, 20)
			elseif player:getStorageValue(Storage.HotCuisineQuest.CurrentDish) == 10 then
				npcHandler:say({
					"The last dish we are going to prepare together is called {Carrot Cake}. Yes, it's a real cake, we need a tasty desert to complete our cooking course. ...",
					"Bring me the following ingredients and I'll lead you through it: five carrots, one vial of milk, one lemon, ten ounces of flour, two eggs, ten cookies and two peanuts."
				}, npc, creature)
				npcHandler:setTopic(playerId, 22)
			elseif player:getStorageValue(Storage.HotCuisineQuest.CurrentDish) == 11 then
				npcHandler:say({
					"Yes, you heard that right! Even though I was laying sick on my divan for weeks, I have some new dishes for you. Ehem. Of course I couldn't have done it without my little helpers travelling around the world and discovering recipes. ...",
					"So... <rubs hands together> ... each good menu needs an amazing starter to awaken and stimulate all the little taste buds on your tongue. We're going to cook a nice portion of {Coconut Shrimp Bake}! ...",
					"This is an exotic rice dish with hints of mushrooms and shrimps, topped with sweet coconut goodness - brought to me by a beautiful druid lady a few days ago. My mouth starts watering already! ...",
					"... because of the dish, I mean, of course. Ehem. Bring me the following ingredients and we'll get started: Five vials of coconut milk, five brown mushrooms, five red mushrooms, ten rice balls and ten shrimps."
				}, npc, creature)
				npcHandler:setTopic(playerId, 24)
			elseif player:getStorageValue(Storage.HotCuisineQuest.CurrentDish) == 12 then
				npcHandler:say({
					"After this wonderful and tasty starter we're all set for a special dish I learnt from a brave adventurer who almost starved when he got lost in the mountains between Ankrahmun and Port Hope, or so he told me. ...",
					"Luckily, he was saved by nomads - can you imagine? - and they fed him a special local dish that's very cheap and easy to prepare, yet rich in vitamins and spending energy for hours. ...",
					"Now don't be shocked, but - they do put sandcrawlers in there. When I tried to prepare that dish at first, I was repelled by its awful appearance, but since it smelled so good I did take a sip and was pleasantly surprised of the great taste. ...",
					"According to the adventurer, this meal works well with any kind of vegetables or any kind of edible creepy-crawlers, depending on what the nomads get their hands on, but we'll stick to the original for now! ...",
					"Bring me the following ingredients - if you dare - and I'll show you the secret of {Blackjack}: Five sandcrawler shells, two vials of water, twenty carrots, ten potatoes and three jalapeño peppers."
				}, npc, creature)
				npcHandler:setTopic(playerId, 26)
			elseif player:getStorageValue(Storage.HotCuisineQuest.CurrentDish) == 13 then
				npcHandler:say({
					"Weren't you surprised by the great taste of our main dish? In case you still have some space left in your tummy, we're in for a sweet and fun dessert - but beware unwanted side effects! ...",
					"It was introduced to me by a fearless knight who invented this recipe rather by accident when a bottle of demonic blood broke in his backpack and spilled its contents over his bag of candy balls. ...",
					"Curiously, he tried one and red steam came out of his ears - but it tasted so great that he instantly popped another one in his mouth, and then another, and another. ...",
					"Each one seemed to cause a different effect and he was never really sure what the next one would do. Seems safer to be careful with them and not to eat them in dangerous situations! ...",
					"In any case, bring me the following ingredients and we'll make some {Demonic Candy Balls}, if you like: Three candies, three candy canes, two bars of chocolate, fifteen gingerbread men and one concentrated demonic blood."
				}, npc, creature)
				npcHandler:setTopic(playerId, 28)
			elseif player:getStorageValue(Storage.HotCuisineQuest.CurrentDish) == 14 then
				npcHandler:say({
					"Did you dare eat all of your Demonic Candy Balls...? Hehehe! Well, I almost forgot one of the most essential parts for a perfect dinner. A drink! I have one for you, almost a designer drink you could say. ...",
					"Its inventor seems to have done some scientific research in order to achieve his desired effect, which is - charging magical rings. You have to drink it while you're wearing one for a miraculous effect! ...",
					"Bring me the following ingredients and we'll get started: Fourty eggs, twenty mangos, ten honeycombs, one bottle of bug milk and one blessed wooden stake. ...",
					"Oh yes, I understand your worries about the eggs, but just make sure they're fresh and all should be fine for our {Sweet Mangonaise Elixir}!"
				}, npc, creature)
				npcHandler:setTopic(playerId, 30)
			end
		elseif player:getStorageValue(Storage.HotCuisineQuest.QuestStart) == 2 then
			npcHandler:say("You can now cook any dish you want from this list: {Rotworm Stew, Hydra Tongue Salad, Roasted Dragon Wings, Tropical Fried Terrorbird, Banana Chocolate Shake, Veggie Casserole, Filled Jalapeno Peppers, Blessed Steak, Northern Fishburger, Carrot Cake, Coconut Shrimp Bake, Blackjack, Demonic Candy Balls, Sweet Mangonaise Elixir}.", npc, creature)
		end
	elseif MsgContains(message, "apprentice") then
		if npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("Hmm. You look quite promising. Can't hurt to give it a try, I guess. Would you like to become my apprentice, |PLAYERNAME|?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 3 then
			npcHandler:say("Fine, young human. Ask me for a {recipe} anytime and I'll teach you what I know.", npc, creature)
			player:setStorageValue(Storage.HotCuisineQuest.QuestStart, 1)
			player:setStorageValue(Storage.HotCuisineQuest.CurrentDish, 1)
			player:setStorageValue(Storage.HotCuisineQuest.QuestLog, 1)
		elseif npcHandler:getTopic(playerId) == 5 then
			if playerHasIngredients(creature) then
				npcHandler:say({
					"Aah, so let's see! <prepares the food quickly while he explains it to you> We cook the meat in a large pot together with the chopped onion until it's separated from the bones. Now we also have a fine meat broth! ...",
					"Cut the potatoes into small pieces and add them to the pot. Add some flour to thicken the stew. Finally, spice it up with some garlic and add beer for the typical dwarvish taste! ...",
					"And voilà, we're done. I developed this recipe while talking to Maryza in the Jolly Axeman. She said to eat it when one's health is low. Enjoy!"
				}, npc, creature)
				player:setStorageValue(Storage.HotCuisineQuest.CurrentDish, 2)
				player:setStorageValue(Storage.HotCuisineQuest.QuestLog, 2)
				player:addItem(9079, 1)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("Make sure that you have all the ingredients, with you.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 7 then
			if playerHasIngredients(creature) then
				npcHandler:say({
					"Okay, here we go! <cuts the ingredients so fast that his hands seem almost blurry> This one is easy, just chop the hydra tongues, tomatoes and cucumber into tiny pieces. ...",
					"Now for the sauce - our base is wine, in which we mix the raw eggs until it got a nice smooth consistency. Add grinded troll green, whose flavour is quite similar to basil and shake the sauce in a mug. ...",
					"Pour it over the salad, and voilà, we're done! This is a Venorean recipe and very tasty. I recommend eating it when you're suffering from some kind of dangerous condition. Enjoy!"
				}, npc, creature)
				player:setStorageValue(Storage.HotCuisineQuest.CurrentDish, 3)
				player:setStorageValue(Storage.HotCuisineQuest.QuestLog, 3)
				player:addItem(9080, 1)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("Make sure that you have all the ingredients, with you.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 9 then
			if playerHasIngredients(creature) then
				npcHandler:say({
					"Let's get started! <starts grinding and chopping at amazing speed> The trick with this one is the crunchy crust around the wings. ...",
					"First, we grate the dry brown bread into very small crumbs and mix that with the two eggs. Add grinded peppers for the spicy taste and the powder herb for a hint of curry flavour. ...",
					"Carefully separate the bat wings, clean them of any possible hairs and coat them in our mixture. Roast them in a pan together with sliced mushrooms and serve. ...",
					"Voilà, we're done! This recipe is from the area around Thais and should help you protect yourself in your battles. Enjoy!"
				}, npc, creature)
				player:setStorageValue(Storage.HotCuisineQuest.CurrentDish, 4)
				player:setStorageValue(Storage.HotCuisineQuest.QuestLog, 4)
				player:addItem(9081, 1)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("Make sure that you have all the ingredients, with you.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 11 then
			if playerHasIngredients(creature) then
				npcHandler:say({
					"This is a recipe right from the jungles of Tiquanda! <grinds and chops during his talk> Grind the stone herb and mix it with the coconut milk, then bathe the chicken in it for a while. ...",
					"In the meantime, peel the oranges and mangos, chop them into pieces and add them to the mix. Take the chicken out of its bath and fry it, preferably over open fire. ...",
					"Take the fruits out of the spicy coconut milk and heat them on an oven. Once the chicken is fried, add the fruits and spray some squeezed lemon over it. ...",
					"Voilà, we're done! They say that this dish has magical abilities and can awaken secret powers in you during your battles. Enjoy!"
				}, npc, creature)
				player:setStorageValue(Storage.HotCuisineQuest.CurrentDish, 5)
				player:setStorageValue(Storage.HotCuisineQuest.QuestLog, 5)
				player:addItem(9082, 1)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("Make sure that you have all the ingredients, with you.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 13 then
			if playerHasIngredients(creature) then
				npcHandler:say({
					"Great! Let's get it done! <mixes and shakes faster than any human could> An easy one again, but you'll get right into holiday mood, like the Meriana beach dwellers I got that recipe from. ...",
					"Melt the chocolate in a hot-water bath and add the grinded herbs - did you know, those herbs have a flavour like cinnamon and vanilla, yummy! Keep at gentle heat and add the milk. ...",
					"Mash the banana and stir it really well into the chocolate-milk mixture. Gosh, do you smell that? Pure goodness! Now finally, we take just a bit of the creamcake and fold it in. ...",
					"Voilà, we're done! To be honest, I don't know what this drink does, but at least it makes me really happy. Drink together with a loved one and enjoy!"
				}, npc, creature)
				player:setStorageValue(Storage.HotCuisineQuest.CurrentDish, 6)
				player:setStorageValue(Storage.HotCuisineQuest.QuestLog, 6)
				player:addItem(9083, 1)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("Make sure that you have all the ingredients, with you.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 15 then
			if playerHasIngredients(creature) then
				npcHandler:say({
					"So let's start! <rubs hands together and chops the vegetables> This is a dish especially famous in the area around Ab'Dendriel! Chop the onions into little cubes and sweat them in a pan until they are glassy. ...",
					"Add garlic and mushrooms and fry gently until the mushrooms have shrunk up. Now, we add the peeled tomatoes and corn and have it all nicely cook together. ...",
					"Put in carrot pieces and cucumber at the very end, so they will stay crisp! Finally put the cheese over it like a little blanket have it melt on the oven until it's slightly brownish. ...",
					"And voilà, we're done! This dish will help you in your battles and supply you with enough power to hit really hard! Enjoy!"
				}, npc, creature)
				player:setStorageValue(Storage.HotCuisineQuest.CurrentDish, 7)
				player:setStorageValue(Storage.HotCuisineQuest.QuestLog, 7)
				player:addItem(9084, 1)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("Make sure that you have all the ingredients, with you.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 17 then
			if playerHasIngredients(creature) then
				npcHandler:say({
					"Okay! So after all of these heavy dishes, we're going to create a fast little snack. <starts preparing the peppers as he speaks> ...",
					"First of all, remove the top of the jalapeño peppers and clean their inside, so that you have space for the filling. Now for the filling, we grate the cheese and mix it with the mead and the eggs, until it has a nice consistency. ...",
					"We add the grinded herbs and blend it well. Push a spoonful in each jalapeño pepper until they are nicely stuffed. Now, we shortly fry the jalapeño peppers in a pan to heat them up. ...",
					"The filling will melt nicely, just be careful that it doesn't drip out! And voilà, we're done! ...",
					"This famous dish from Ankrahmun is quite hot and spicy, so only eat one at a time. It's also possible that you get the urge to run really fast afterwards. Enjoy!"
				}, npc, creature)
				player:setStorageValue(Storage.HotCuisineQuest.CurrentDish, 8)
				player:setStorageValue(Storage.HotCuisineQuest.QuestLog, 8)
				player:addItem(9085, 1)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("Make sure that you have all the ingredients, with you.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 19 then
			if playerHasIngredients(creature) then
				npcHandler:say({
					"Here we go! <pounds with his bare hands on the steak> This will break through the meat fibres, making our steak more tender for this fine Daramanian dish. ...",
					"It's easy to prepare, just chop and sweat the onions and add small pieces of pumpkin, beetroot, plums and peppers. Put the steak into the pan too to let it absorb some of the sweet and fruity flavour. ...",
					"Finally, remove the fruits and onions from the pan and fry the steak from both sides until it's crisp and crusty. Put on a plate and decorate with the fruit mix. ...",
					"The people of Darashia say that it has magical abilities and will help you if you feel totally drained. Enjoy!"
				}, npc, creature)
				player:setStorageValue(Storage.HotCuisineQuest.CurrentDish, 9)
				player:setStorageValue(Storage.HotCuisineQuest.QuestLog, 9)
				player:addItem(9086, 1)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("Make sure that you have all the ingredients, with you.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 21 then
			if playerHasIngredients(creature) then
				npcHandler:say({
					"Great! After all this meat, we shouldn't neglect to prepare some fish. <carefully removes heads, tails and bones from the fishes and peels shrimps at incredible speed> ...",
					"This easy dish from Svargrond is what you'd call fast food, but its outstanding taste justifies to put it in my book about {Hot Cuisine}. ...",
					"Simply cut the rolls in half, shortly fry one slice of each fish type, put in the shrimps and spice up with grinded fern, which, by the way, tastes slightly like dill. ...",
					"Nicely decorate it on a plate, and voilr, we're done already! Can't tell you much about the effects, but fishermen in Svargrond seem to love it. Enjoy!"
				}, npc, creature)
				player:setStorageValue(Storage.HotCuisineQuest.CurrentDish, 10)
				player:setStorageValue(Storage.HotCuisineQuest.QuestLog, 10)
				player:addItem(9088, 1)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("Make sure that you have all the ingredients, with you.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 23 then
			if playerHasIngredients(creature) then
				npcHandler:say({
					"So, now for our final dish - a grand dessert from the amazon girls at Carlin! <grates carrots during his explanations> ...",
					"It's easy as it can be - mix a normal cake dough with milk, flour and eggs, then add some cookie crumbs for the crunchy effect later on. ...",
					"Stir in the grated carrots and tiny peanut pieces and bake it for about thirty minutes! Now we'll make a great topping with sugar and lemon juice, pour it over the cake and decorate it. ...",
					"And voilà, we're done! The girls of Carlin swear that it sharpens their eyesight, at least for a while. I'm sure it will somehow aid you in your battles. Enjoy! ...",
					"Oh, which reminds me - my little apprentice, we are finished with our cooking course. I think you did great and if it was my decision, you could open your own tavern. ...",
					"But anyway, it's up to you what you make of your newly discovered skills! In case you forget my recipes, please feel free to take a copy of the cookbook upstairs. ...",
					"You can drop by and practice cooking those dishes, at least during the time that I'm at home. I promise that I will cook each dish once with you, but then I have to take care of my other apprentices. Cheers to you!"
				}, npc, creature)
				player:setStorageValue(Storage.HotCuisineQuest.CurrentDish, 11)
				player:setStorageValue(Storage.HotCuisineQuest.QuestLog, 11)
				player:setStorageValue(Storage.HotCuisineQuest.CookbookDoor, 1)
				player:addItem(10000, 1)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("Make sure that you have all the ingredients, with you.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 25 then
			if playerHasIngredients(creature) then
				npcHandler:say({
					"Yum! Just the thought of it makes me drool. <tosses the shrimps into a bowl and soaks them in coconut milk as he goes on chopping all mushrooms in the blink of an eye> ...",
					"I see you brought real Zaoan rice balls! That saves us a lot of time as we don't have to cook the rice anymore. Now we just flatten them out nice and medium thick on this baking tray. <squeezes and smoothes the rice piles with his fingers> ...",
					"In the meantime, our shrimps have absorbed some of the coconut milk and we can now add them on top of the rice. <spreads them evenly across the rice and pours the coconut milk from the bowl over the rice> ...",
					"Now we just need to add the mushrooms <tosses them all over the tray>, pour the rest of the coconut milk over it and put it into the oven! ...",
					"... dum di dum ... <waits> ...",
					"Aaaaaaand there you go! Sweet coconut goodness! And psst - the shrimps add some submarine flavour to this dish. You should definitely eat it while walking underwater and wearing a helmet of the deep. Just in case. Enjoy!"
				}, npc, creature)
				player:setStorageValue(Storage.HotCuisineQuest.CurrentDish, 12)
				player:setStorageValue(Storage.HotCuisineQuest.QuestLog, 13)
				player:addItem(11584, 1)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("Make sure that you have all the ingredients, with you.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 27 then
			if playerHasIngredients(creature) then
				npcHandler:say({
					"Awesome! Let's go! Let's start with preparing the sandcrawlers <starts boiling water on a stove and tosses the sandcrawler shells in there> ...",
					"I understand your scepticism, but believe me, all will be well! As you can see, they change colour from dark to light red, and that's when they also start turning soft. <stirs with one hand while he slices carrots and peppers with the other hand> ...",
					"Now add whole potatoes and let everything cook at high temperature until the potatoes are so soft they're basically falling apart. <mashes really fast, creating something of a dark brownish colour that doesn't really look tasty> ...",
					"Yes yes, I know, don't give me that look! You'll be surprised! Now just add the chopped carrots and chili for a healthy portion of vitamins and spices, keep stiring and mashing and let it simmer for about an hour. ...",
					"You're wondering why I chose a simple recipe like that for my famous menu? You'll know when you taste it! ...",
					"Heeeeeere you are - just a few spoons of this great stew make you so full that the bowl I give you will last for a long time until it's finally depleted. Enjoy!"
				}, npc, creature)
				player:setStorageValue(Storage.HotCuisineQuest.CurrentDish, 13)
				player:setStorageValue(Storage.HotCuisineQuest.QuestLog, 14)
				player:addItem(11586, 1)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("Make sure that you have all the ingredients, with you.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 29 then
			if playerHasIngredients(creature) then
				npcHandler:say({
					"Very nice! I'm ready for action! <quickly grabs all the candies, candy canes and gingerbread men and crushes them with amazing speed> ...",
					"After having crushed all those sweets, we need to melt the chocolate into a thick liquid... <creates a magical flame by snapping his fingers and melts the chocolate so fast over the sweets that it's amazing he didn't spill it everywhere> ...",
					"... and form little balls together with the sweets! <shapes candy balls about the size of rice balls faster and more perfectly than any mortal ever could> ...",
					"Now, carefully, we add the demonic blood... <and time seems to stand still as seemingly for the first time ever he does something slowly, pouring a single drop of concentrated demonic blood onto each ball> ...",
					"Here you go, but beware possible side effects! You never know for sure what will happen and so far all of those I tried had awesome effects, so of course I don't hope for nasty surprises! Enjoy!"
				}, npc, creature)
				player:setStorageValue(Storage.HotCuisineQuest.CurrentDish, 14)
				player:setStorageValue(Storage.HotCuisineQuest.QuestLog, 15)
				player:addItem(11587, 1)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("Make sure that you have all the ingredients, with you.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 31 then
			if playerHasIngredients(creature) then
				npcHandler:say({
					"Time to have a sweet drink! Let's pour the bug milk into my cauldron and heat it over fire until it's boiling... <starts slicing mangoes in the meantime> there! ...",
					"Now we're breaking all of the eggs into there - 1, 2, 10, 20, 40 <ticktickcrack> crumble the honeycombs and toss the sliced mangoes into the hot mix. ...",
					"Now we just have to let it simmer and stir using a blessed wooden stake <stirs so vigorously that you can barely see his arms anymore> for thirty minutes. ...",
					"By now, the power of the blessed wooden stake will have been transferred into our elixir, so let's put out the fire and let it cool down. ...",
					"<carefully pours the cooled elixir into a small bottle or glass> There! Its inventor said it had amazing effects on the ring you're wearing, as long as the ring is based on time, not on charges. Enjoy! ...",
					"And by the way... since those were all the recipes from this year and you cooked them so nicely, you may take the cookbook containing them from upstairs, if you like!"
				}, npc, creature)
				player:setStorageValue(Storage.HotCuisineQuest.QuestStart, 2)
				player:setStorageValue(Storage.HotCuisineQuest.CurrentDish, 15)
				player:setStorageValue(Storage.HotCuisineQuest.QuestLog, 16)
				player:addItem(11588, 1)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("Make sure that you have all the ingredients, with you.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		end
	--Dishes first time
	elseif MsgContains(message, "rotworm stew") then
		if npcHandler:getTopic(playerId) == 4 or player:getStorageValue(Storage.HotCuisineQuest.QuestStart) == 2 then
			npcHandler:say("Did you gather all necessary ingredients to cook Rotworm Stew with me?", npc, creature)
			player:setStorageValue(Storage.HotCuisineQuest.CurrentDish, 1)
			npcHandler:setTopic(playerId, 5)
		end
	elseif MsgContains(message, "hydra tongue salad") then
		if npcHandler:getTopic(playerId) == 6 or player:getStorageValue(Storage.HotCuisineQuest.QuestStart) == 2 then
			npcHandler:say("Did you gather all necessary ingredients to prepare a Hydra Tongue Salad with me?", npc, creature)
			player:setStorageValue(Storage.HotCuisineQuest.CurrentDish, 2)
			npcHandler:setTopic(playerId, 7)
		end
	elseif MsgContains(message, "roasted dragon wings") then
		if npcHandler:getTopic(playerId) == 8 or player:getStorageValue(Storage.HotCuisineQuest.QuestStart) == 2 then
			npcHandler:say("Did you gather all necessary ingredients to prepare Roasted Dragon Wings with me?", npc, creature)
			player:setStorageValue(Storage.HotCuisineQuest.CurrentDish, 3)
			npcHandler:setTopic(playerId, 9)
		end
	elseif MsgContains(message, "tropical fried terrorbird") then
		if npcHandler:getTopic(playerId) == 10 or player:getStorageValue(Storage.HotCuisineQuest.QuestStart) == 2 then
			npcHandler:say("Did you gather all necessary ingredients to prepare a Tropical Fried Terrorbird with me?", npc, creature)
			player:setStorageValue(Storage.HotCuisineQuest.CurrentDish, 4)
			npcHandler:setTopic(playerId, 11)
		end
	elseif MsgContains(message, "banana chocolate shake") then
		if npcHandler:getTopic(playerId) == 12 or player:getStorageValue(Storage.HotCuisineQuest.QuestStart) == 2 then
			npcHandler:say("Did you gather all necessary ingredients to make a Banana Chocolate Shake with me?", npc, creature)
			player:setStorageValue(Storage.HotCuisineQuest.CurrentDish, 5)
			npcHandler:setTopic(playerId, 13)
		end
	elseif MsgContains(message, "veggie casserole") then
		if npcHandler:getTopic(playerId) == 14 or player:getStorageValue(Storage.HotCuisineQuest.QuestStart) == 2 then
			npcHandler:say("Did you gather all necessary ingredients to cook a Veggie Casserole with me?", npc, creature)
			player:setStorageValue(Storage.HotCuisineQuest.CurrentDish, 6)
			npcHandler:setTopic(playerId, 15)
		end
	elseif MsgContains(message, "filled jalapeño peppers") then
		if npcHandler:getTopic(playerId) == 16 or player:getStorageValue(Storage.HotCuisineQuest.QuestStart) == 2 then
			npcHandler:say("Did you gather all necessary ingredients to prepare Filled Jalapeño Peppers with me?", npc, creature)
			player:setStorageValue(Storage.HotCuisineQuest.CurrentDish, 7)
			npcHandler:setTopic(playerId, 17)
		end
	elseif MsgContains(message, "blessed steak") then
		if npcHandler:getTopic(playerId) == 18 or player:getStorageValue(Storage.HotCuisineQuest.QuestStart) == 2 then
			npcHandler:say("Did you gather all necessary ingredients to prepare a Blessed Steak with me?", npc, creature)
			player:setStorageValue(Storage.HotCuisineQuest.CurrentDish, 8)
			npcHandler:setTopic(playerId, 19)
		end
	elseif MsgContains(message, "northern fishburger") then
		if npcHandler:getTopic(playerId) == 20 or player:getStorageValue(Storage.HotCuisineQuest.QuestStart) == 2 then
			npcHandler:say("Did you gather all necessary ingredients to make a Northern Fishburger with me?", npc, creature)
			player:setStorageValue(Storage.HotCuisineQuest.CurrentDish, 9)
			npcHandler:setTopic(playerId, 21)
		end
	elseif MsgContains(message, "carrot cake") then
		if npcHandler:getTopic(playerId) == 22 or player:getStorageValue(Storage.HotCuisineQuest.QuestStart) == 2 then
			npcHandler:say("Did you gather all necessary ingredients to bake a Carrot Cake with me?", npc, creature)
			player:setStorageValue(Storage.HotCuisineQuest.CurrentDish, 10)
			npcHandler:setTopic(playerId, 23)
		end
	elseif MsgContains(message, "coconut shrimp bake") then
		if npcHandler:getTopic(playerId) == 24 or player:getStorageValue(Storage.HotCuisineQuest.QuestStart) == 2 then
			npcHandler:say("Did you gather all necessary ingredients to prepare a Coconut Shrimp Bake with me?", npc, creature)
			player:setStorageValue(Storage.HotCuisineQuest.CurrentDish, 11)
			npcHandler:setTopic(playerId, 25)
		end
	elseif MsgContains(message, "blackjack") then
		if npcHandler:getTopic(playerId) == 26 or player:getStorageValue(Storage.HotCuisineQuest.QuestStart) == 2 then
			npcHandler:say("Did you gather all necessary ingredients to cook a Blackjack with me?", npc, creature)
			player:setStorageValue(Storage.HotCuisineQuest.CurrentDish, 12)
			npcHandler:setTopic(playerId, 27)
		end
	elseif MsgContains(message, "demonic candy ball") then
		if npcHandler:getTopic(playerId) == 28 or player:getStorageValue(Storage.HotCuisineQuest.QuestStart) == 2 then
			npcHandler:say("Did you gather all necessary ingredients to make Demonic Candy Balls with me?", npc, creature)
			player:setStorageValue(Storage.HotCuisineQuest.CurrentDish, 13)
			npcHandler:setTopic(playerId, 29)
		end
	--elseif MsgContains(message, "sweet mangonaise elixir") then
	--	if npcHandler:getTopic(playerId) == 30 or player:getStorageValue(Storage.HotCuisineQuest.QuestStart) == 2 then
		--	npcHandler:say("Did you gather all necessary ingredients to mix Sweet Mangonaise Elixir with me?", npc, creature)
		--	player:setStorageValue(Storage.HotCuisineQuest.CurrentDish, 14)
		--	npcHandler:setTopic(playerId, 31)
		--end
	elseif MsgContains(message, "no") then
		npcHandler:say("No?, come back when you are ready to cook.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
