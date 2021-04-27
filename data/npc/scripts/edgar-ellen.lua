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

local voices = {
	{ text = 'Orshabaal was out of his maze to make us suffer for many days. In Calmera, a knight with blue beard from his hideout appeared. He fought bravely supported by mages, the demon ran and is gone for ages.' },
	{ text = 'A knight from Guardia needed Chayenne\'s key. His friend dropped the item on the floor, hoping no one would see. But, at the same moment, a man crossed their way and all the knight\'s dreams faded away.' },
	{ text = 'A knight from Candia was dining at Frodo\'s hut, devouring plates full of meat and whatnot. Suddenly, he was called to fight. He wanted to put his armor on but it was too tight.' },
	{ text = 'The druid entered a Premian pyramid intent on the kill, \'Oh, that djinn will die, it will!\' Down and up the stairs she hopped like a cat... When, Oops! She moved the wrong way, and died a drunk rat.' },
	{ text = 'Hoping to find a strange orc in his spawn, a Zaneran knight logged on before dawn. A sudden heart attack left him surprised as Sam\'s old backpack he had recognised.' },
	{ text = 'The world I shall save\', an Olympian knight proclaimed! But from a visit to the bar he could not abstain! He woke up in pain, it all was in vain. From Venorian beer he will forever refrain.' },
	{ text = 'During the dark and scary night, when others sleep he goes to fight, banishing demons, that feels right, purging the evil on the sight, fearlessly waiting for daylight, Zeluna\'s bravest elite knight.' },
	{ text = 'A druid from Celesta once talked with a girl, he even bought her a necklace with a huge white pearl. Every time he went home, without money and fame, I guess this girl is cursed, Aruda is the name.' },
	{ text = 'A story of a knight untold, on Rowana the dice she rolled. She lured players from afar. Who could resist a shining star? She promised gold and many items, then stole their heart with cunning kindness.' },
	{ text = 'Do you think it\'s just a game? Don\'t you fear the dragon\'s flame? If you are as brave as bright, if you do not stray from fight, you may want to hear tonight, the tale of Guardia\'s lonely knight.' },
	{ text = 'For a knight from Yanara 10,000 gold were a lot. So he ventured with a team into the desert to win that pot. He solved all the riddles, strongly willed. But on his journey home he sadly was killed.' },
	{ text = 'A great mage from Celesta went dungeon down deep, he was very brave but his wand was cheap. Among white skeletons one of them was red. Last what he saw were the words: \'You are dead!\'' },
	{ text = 'A young sorcerer born and raised on Astera when dragons were scary, it was that kind of era. Walking all the way to the city of Venore, he stole from the dwarven bridge nothing less than an iron ore.' },
	{ text = 'A druid from Eternia just bought his first boots of haste, to finally have his leather boots replaced. Catching a backpack of fish was now his dream, but he ended up swinging his new boots upstream.' },
	{ text = 'A sorcerer from Efidia took his horse and got it saddled, and set out for battle. His horse lost control and threw him into a hole. Now his team lost all hope, because he forgot to bring a rope.' },
	{ text = 'A knight in Guardia was feeling bored. He wanted to show a dragon lord the taste of his new carlin sword. To its lair then he did go. But before he saw his foe, he met his end by a one hit K.O.' },
	{ text = 'On Secura a confident knight levelled to main, 840 rats he had slain. \'I am going to kill dragons,\' he said while pounding his breastplate. The next thing he saw was: \'You have met a sad fate.\'' },
	{ text = 'One morning frosty fresh and nice, a knight was fishing on the ice. Catching some pikes for soup, but a dire penguin ate his loot. His angry wife said in the house: Now whole Beneva will laugh at us!' },
	{ text = 'A paladin slaying dragons on Antica\'s soil, when a lord charges on to make the adventurer\'s blood boil. It puts up a strong fight, but to no avail. It gets slain and drops a dragon scale mail!' },
	{ text = 'Through Rookgaard\'s sewer there swarmed no fewer than a hundred screeching rats. Wading through mud, and covered in blood, two young men fought back-to-back. To Trimera\'s end; a knight, and a friend.' }
}

npcHandler:addModule(VoiceModule:new(voices))

keywordHandler:addKeyword({'tibia'}, StdModule.say, {npcHandler = npcHandler, text = "Our world, our home, our very own plane of existence. We have to protect it, mind you. Underneath all the battles, challenges and monsters there still resides a majestic, yet vulnerable being. A mother to us all."})
keywordHandler:addKeyword({'king'}, StdModule.say, {npcHandler = npcHandler, text = "A king and a beggar know more than a king alone... ahem, except for King Tibianus. He most certainly would. All hail King Tibianus etc. etc."})
keywordHandler:addKeyword({'mission'}, StdModule.say, {npcHandler = npcHandler, text = "So, you're on a mission. Aren't we all? A quest to savour the important moments, the valuable memories? To fight for love and happiness, heroically and against all odds? Yes, we are indeed."})
keywordHandler:addKeyword({'quest'}, StdModule.say, {npcHandler = npcHandler, text = "So, you're on a mission. Aren't we all? A quest to savour the important moments, the valuable memories? To fight for love and happiness, heroically and against all odds? Yes, we are indeed."})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "Rather a calling. The weight of words is something not easily lifted by some, yet it can be a mighty weapon to others. ..."}) -- Need to add the rest in a second delayed msg --It is my duty to see to it that the words of mighty poets all over Tibia are spread and carried with the heart and prowess they deserve.

npcHandler:setMessage(MESSAGE_GREET, "This world is nothing without poetry, don't you think? It gives us hope, it envokes love. It's inciting and invigorating all the same.")
npcHandler:setMessage(MESSAGE_FAREWELL, " Goodbye and farewell, my friend.")
npcHandler:addModule(FocusModule:new())
