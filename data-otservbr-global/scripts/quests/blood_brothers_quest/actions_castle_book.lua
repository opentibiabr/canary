local bloodBrothersLibrary = Action()

function bloodBrothersLibrary.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.CastleBook) == 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The bookcase is empty.")
		return true
	end
	local manuscript = player:addItem(28483, 1)
	if manuscript then
		manuscript:setText([[II. 28th
Today my brothers and I are leaving from Carlin to find a new place for us and our families. None of the great Tibian cities have made us feel at home yet. There must be something else, and we will find it.
III. 5th
We've been at sea for a few days now. Time seems endless, and so does the ocean. We have supplies for 3 more weeks. Should we not find land within the next week we will cancel our expedition to make sure we get back home safely.
III. 8th
Still nothing... but the screams of seagulls and the sound of the waves... we are still hoping.
III. 10th
We've spotted land! It's still a day away, but it seems to be a really large island. Not only that, we can also make out tall towers in the distance. Strangely though, this city - or whatever it is - can't be found on our map, despite its obvious size.
III. 11th
We've arrived at the harbour of Yalahar, as the inhabitants call it. Obviously large parts of the city are destroyed and closed for the public. We will stay in a tavern tonight - finally, a bed again! - and then try to find a place to live in.
III. 14th
Finding a house seems to be harder than expected. The inner city of Yalahar which seems safe and rather wealthy has almost no place left, especially not for outsiders as us. Maybe we can live in one of the outer quarters, close to the city walls at least.
III. 18th
Lersatio found an unoccupied house not too far away from the centre. It is close to an alchemical lab. Maybe we can even find some work there. Things are looking great!
III. 20th
We've settled down and started the repair work on the house. This may take a while, but we are sending note to our families to come after us. Arthei's wife Kala insisted to come with us right from the start, so they are already together, but I am starting to miss my girl immensely. Oh sweet Melava, I hope you are well.
III. 21th
This place is not as good as it seemed. The closeness to the alchemical laboratories proves to be a constant menace and now I understand why they didn't want it in the centre. Frequent explosions are startling us during the whole day, and even at nighttime there is a lot of noise from the facilities. Due to these circumstances we will probably try to find another place, luckily we haven't put too much work into the house, yet. Also, our families won't come, yet.
III. 30th
Oh god... something horrible happened and I've not been able to write for a while... a week ago there was a HUGE explosion in the night... fire spread upon almost all houses nearby... we barely escaped the flames... my hands are burnt, because I pulled my brother out of the burning house and we all are still coughing grey substance... Boreth and Lersation got out with some scratches and burns, but otherwise we three are fine. It's just Arthei... he got burnt really badly... I barely recognise his face... Kala is sitting at his bed 24 hours a day with red swollen eyes and praying for his life. When she falls asleep in exhaustion we are keeping watch.
<from here on, all of the pages have been torn out, only the last page remains:>
THE FIRST DAY OF ETERNITY
I CAN SEE NOW. FOOLS. ALL OF YOU. HAHAHAHAHA.]])
	end
	player:setStorageValue(Storage.Quest.U8_4.BloodBrothers.CastleBook, 1)
	player:setStorageValue(Storage.Quest.U8_4.BloodBrothers.LibraryDoor, 1)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a torn book.")
	return true
end

bloodBrothersLibrary:uid(14043)
bloodBrothersLibrary:register()

local pages = {
	[14044] = {
		storage = Storage.Quest.U8_4.BloodBrothers.DiaryPage2,
		itemId = 641,
		text = [[<this is a ripped page, probably from a diary>
IV. 3rd
Arthei is not getting better... neither is he getting worse, his state has been the same for the last days. We have established a regular watch plan now during the night so that Kala can get some rest. I have not given up hope, yet, but things are not looking good. It is hard to believe that the poor creature in the bed is my brother. I fear that only a miracle can help him now.
IV. 5th
I cannot put into words yet what happened last night... and neither do I know whether it is good... or evil? I have to think about it...]],
	},
	[14045] = {
		storage = Storage.Quest.U8_4.BloodBrothers.DiaryPage3,
		itemId = 641,
		text = [[<this is a ripped page, probably from a diary>
IV. 7th
Everything is so strange... two nights ago the weirdest thing happened... I fell asleep during the night watch at my brother's bed, must have been only for a few minutes, but when I opened my eyes, I saw a black... being... hovering over Arthei's bed, getting closer and closer to him. I wanted to jump to my feet and scream, but I was unable to move. All I could do was dig my nails into my own flesh. Then suddenly, the being looked directly into my eyes. I remember thinking 'how strange', because the creature had no face and thus no eyes, yet I knew that it was looking at me. Then I couldn't bear the cold of its look anymore and passed out. I don't know what happened afterwards. All that matters now is that Arthei has recovered. And with recovered I mean that there is not a SCRATCH on him anymore. He is completely well, I'm not able to explain why, but I don't care. Kala is crying for joy, I think the black being wasn't evil, but a god.]],
	},
	[14046] = {
		storage = Storage.Quest.U8_4.BloodBrothers.DiaryPage4,
		itemId = 641,
		text = [[<this is a ripped page, probably from a diary>
IV. 8th
This is not good at all. At first we were all so happy about the miracle of Arthei's recovery that we didn't care about anything else, but now, some... side effects have appeared. Arthei has never looked as pale as now and he hardly speaks a single word. At least he still knows that we are his brothers, but he doesn't seem to recognise Kala, his wife. This is incredibly hard for her because she was really doing anything in her might to help him get better. And now that he is well again, he is very distant. He calls her 'that woman' and doesn't let her into his room. God, this is so bad. We are hoping that this is only a mood swing or some sort of amnesia that will pass over time...
IV. 12th
Kala is gone!! Oh, what horrible times are those. In her sadness, and confronted with Arthei's constant rejection, she must have left the house last night. She left almost all of her belongings. We are so worried about her... and hope so badly that she didn't decide to throw her life away as desperate as she has been. Arthei didn't even notice... and when we told him, he just shrugged his shoulders. She doesn't deserve this... she is such a sweet and caring woman. We have been looking all over the city for her - in the accessible parts that is - but couldn't find her. I will look for her later again.
IV. 13th
Kala remains missing... and Arthei seems to sneak out at night too, although he is always back in the mornings. I only noticed because I was getting up from my bed to fetch a mug of water, when I saw him closing the front door. What is he doing outside at this time? And, come to think about it, he has never left the house or even his room during daytime ever since he recovered. What has happened to him?]],
	},
	[14047] = {
		storage = Storage.Quest.U8_4.BloodBrothers.DiaryPage5,
		itemId = 641,
		text = [[<this is a ripped page, probably from a diary>
IV. 20th
Since we've moved into this house, we barely had any contact to the other citizens of Yalahar. However this has changed during the last week. People are getting suspicious of Arthei - some saw him after the explosion and know that his sudden recovery can't have happened in a natural way. And they are starting to talk... what makes matters worse is that some murders have occurred since Arthei's recovery. I don't know any details or what exactly was the cause for their death, but I can't stop thinking that Arthei might have something to do with it. His nightly excursions... the state he is in... and it seems that I'm not the only one who thinks that way. As I said... people are starting to talk...
IV. 22th
I don't know how long we can stay here. People whisper with each other and stare hatefully at Lersatio, Boreth and me when we cross the street. I really want to protect my brother, but I'm very scared.
IV. 25th
On the ocean again... this night, we were almost killed by a mob who banged at our door with the obvious intention to remove what they consider a threat to their lives. Well... I can't blame them... we pulled struggling Arthei out of the house and with us, and now we're out at sea on the small boat we arrived in. Luckily they didn't destroy it before they came for us. Please, let us find land... I guess that means back to square one.]],
	},
	[14048] = {
		storage = Storage.Quest.U8_4.BloodBrothers.DiaryPage6,
		itemId = 641,
		text = [[<this is a ripped page, probably from a diary>
IV. 26th
Finally, luck is on our side again! Just a few hours to the east we found another island - and it's beautiful! Grass, flowers, mountains in the distance and enough natural resources for a fresh start.
IV. 28th
Things are getting even better - on the hill east of the grassy area we found what seems to be an abandoned mansion. We spent some hours clearing all the spider webs and now it is quite a good place to stay in. Fate smiles on us! Ever since we found the mansion, Arthei has locked himself into one of the rooms, though. I hope that he will eventually recover in this peaceful environment.
V. 2nd
We made ourselves a home in the mansion and try to farm the land. I think if we can cultivate crops and vegetables, this place will be simply perfect for us.
IV. 10th
Not much success yet. The land is very dry, drier than it seemed when we arrived. We also haven't seen Arthei for a few days.
IV. 20th
This must be... a curse? The grass is withering... the water is getting muddy... even the hill seems stonier, although common sense tells me that this is not possible. What's going on here?]],
	},
	[14051] = {
		storage = Storage.Quest.U8_4.BloodBrothers.DiaryPage7,
		itemId = 641,
		text = [[<this is a ripped page, probably from a diary>
V. 25th
I'm incredibly tired. Each day we work until the sun sets, trying to farm the land but it seems impossible. I'm sure we all have lost a few pounds. Lersatio even had to disguise himself to sneak back into Yalahar and get some supplies. The water on the island is almost swampy now... the grass is brown almost everywhere.... the trees are losing their leaves... jagged stones have formed from the once green hill. We are not speaking of it often, but I know that my two brothers and I are thinking the same... it's a curse, and it sticks to Arthei.
VI. 2nd
Another week lost. Not much more to say.
VI. 5th
We have made a grave decision. We will deliver Arthei, the land and us from this curse. Tonight this will end. It has to end. It's our brother, but I'm sure that this decision will be the best for all of us.]],
	},
}

for uid, data in pairs(pages) do
	local action = Action()
	local pageData = data
	function action.onUse(player, item, fromPosition, target, toPosition, isHotkey)
		if player:getStorageValue(pageData.storage) == 1 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "It is empty.")
			return true
		end

		local reward = player:addItem(pageData.itemId, 1)
		if reward then
			reward:setText(pageData.text)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a piece of paper.")
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need more capacity or free inventory space to take this.")
			return true
		end

		player:setStorageValue(pageData.storage, 1)
		return true
	end
	action:uid(uid)
	action:register()
end
