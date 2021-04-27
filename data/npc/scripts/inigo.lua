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

local hints = {
	[1] = "If you don't know the meaning of an icon on the minimap, move the mouse cursor on it and wait a moment.",
	[2] = "If you seek more information, look at or click on objects near you, like wall signs, \z
		blackboards or books in book cases - many of them have useful information on {Tibia} or maybe \z
		even a quest you are doing. By the way, to receive more of my hints, just say {hints} again.",
	[3] = "If you want to attack a monster, simply click on it in your battle list. \z
		A red frame around a monster shows you are attacking it.",
	[4] = "If you already know where you want to go, click on the automap and your character \z
		will walk there automatically if the location is reachable and not too far away.",
	[5] = "Always have a {rope} with you! If you fall into a hole and are surrounded by {monsters}, \z
		quickly use the rope with the ropespot to get back up and out.",
	[6] = "'Capacity' restricts the amount of things you can carry with you. It raises with each level.",
	[7] = "Always have a look on your health bar. \z
		If you see that you do not regenerate health points anymore, eat something. ",
	[8] = "Always eat as much {food} as possible. \z
		This way, you'll regenerate health points for a longer period of time.",
	[9] = "After you have killed a monster, you have 10 seconds in which the corpse \z
		is not moveable and no one else but you can loot it.",
	[10] = "Be careful when you approach three or more {monsters} because you only can block the attacks of two! \z
		In such a situation, even a few salamanders can do severe damage or even kill you.",
	[11] = "There are many ways to gather {food}. Many creatures drop food but you can also pick blueberries or \z
		bake your own bread. If you have a {fishing rod} and worms in your inventory, you can also try to catch a fish.",
	[12] = "Baking bread is rather complex. First of all you need a scythe to harvest wheat. \z
		Then you use the wheat with a millstone to get flour. This can be be used on water to get dough, \z
		which can be used on an oven to bake bread. Use milk instead of water to get cake dough.",
	[13] = "{Dying} hurts! Better run away than risk your life. \z
		You are going to lose experience and skill points when you die. \z
		And anyone can loot your corpse if you are not blessed.",
	[14] = "When you switch to '{Offensive} {Fighting}', you deal out more damage but you also get hurt more easily.",
	[15] = "When you are on low health and need to run away from a monster, \z
		switch to '{Defensive} {Fighting}' and the monster will hit you less severely.",
	[16] = "Many creatures try to run away from you. Select 'Chase Opponent' to follow them.",
	[17] = "The deeper you enter a dungeon, the more dangerous it will be. \z
		Approach every dungeon with utmost care or an unexpected creature might kill you. \z
		This will result in losing experience and skill points.",
	[18] = "Due to the perspective, some objects in {Tibia} are not located at the spot they seem to appear \z
		(ladders, windows, lamps). Try clicking on the floor tile the object would lie on.",
	[19] = "Almost as important as a {rope} is a {shovel}. Many things can be dug out of the sand, and a pile \z
		of loose stones might hide a secret entrance. But if you go down an unknown hole, make sure you have a \z
		rope with you to get you out quickly if necessary!",
	[20] = "Stairs, ladders and dungeon entrances are marked as yellow dots on the automap.",
	[21] = "You can get {food} by killing animals or {monsters}. You can also pick blueberries or bake your own bread. \z
		If you are too lazy or own too much money, you can also buy food.",
	[22] = "Quest containers can be recognised easily. They don't open up regularly but display a message \z
		'You have found ....'. They can only be opened once.",
	[23] = "Better run away than risk to die. You'll lose experience and skill points each time you die.",
	[24] = "You can form a party by right-clicking on a player and selecting 'Invite to Party'. \z
		The party leader can also enable 'Shared Experience' by right-clicking on him- or herself.",
	[25] = "You can assign {spells}, the use of items, or random text to 'hotkeys'. You find them under 'Options'.",
	[26] = "You can also follow other {players}. Just right-click on the player and select 'Follow'.",
	[27] = "You can found a party with your friends by right-clicking on a player and selecting 'Invite to Party'. \z
		If you are invited to a party, right-click on yourself and select 'Join Party'.",
	[28] = "Only found parties with people you trust! You can attack people in your party without getting a {skull}. \z
		This is helpful for training your {skills}, \z
		but can be abused to kill people without having to fear negative consequences.",
	[29] = "The leader of a party has the option to distribute gathered experience among all {players} in the party. \z
		If you are the leader, right-click on yourself and select 'Enable Shared Experience'.",
	[30] = "If you see someone with a {skull} symbol next to their name, it means he or she has attacked \z
		or even killed another player. Be careful around such people, as their next target might be you.",
	[31] = "A brown frame around a player means he or she is in a {PvP} situation.",
	[32] = "To open or close {skills}, battle or VIP list, click on the corresponding button. \z
		The buttons are displayed to the left or right of your game window.",
	[33] = "If you want to trade an item with another player, right-click on the item and select \z
		'Trade with ...', then click on the player with whom you want to trade.",
	[34] = "Send private messages to other {players} by right-clicking on the player or the player's name and select \z
		'Message to ....'. You can also open a 'private message channel' and type in the name of the player.",
	[35] = "There is nothing more I can tell you. If you are still in need of some {hints}, I can repeat them for you."
}
local voices = {
	{text = "I know the ways and lays of Dawnport. Talk to me if you want to know more!"},
	{text = "Troll hair, wolf fur, lumps of dirt - bring them to me!"},
	{text = "Come to me if you need help!"},
	{text = "Hey there, young adventurer! Need a hint?"},
	{text = "You came through the portal? Talk to me!"},
	{text = "You're going out? Make sure you have a rope with you!"},
	{text = "Buying all sorts of creature products!"},
	{text = "You're looking thoughtful. Maybe I can help you?"}
}

npcHandler:addModule(VoiceModule:new(voices))
npcHandler:setMessage(MESSAGE_GREET, "You came through the {portal}! \z
	Though it must be different from where you came from, I'm sure you can help us. But first, I can {help} YOU.")

keywordHandler:addKeyword({"name"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Ah, back in the old days, I was called Inigo Verasquiriz, but I doubt my family would acknowledge me. \z
		Those that are still alive, that is."
	}
)
keywordHandler:addKeyword({"job"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I used to be a hunter and trapper, but these bones have grown weary. \z
		I now tan furs and hides and {trade} in creature products. And I can help you find your way if you need directions."
	}
)
keywordHandler:addKeyword({"tibia"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "That's where we are - the world of Tibia. \z
		We're on a small island called {Dawnport}, not far from the coast of the Tibian {Mainland}, to be precise."
	}
)
keywordHandler:addKeyword({"questing"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Oh, I can handle my tasks myself, thank you. \z
		If you are looking for something to do, you should go to Morris and ask him for quests. \z
		You can also help us fight {monsters}."
	}
)
keywordHandler:addKeyword({"people"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Well, the other fellows you see here, selling stuff and so forth. \z
		Say a name and I'll tell you what I know of him or her."
	}
)
keywordHandler:addKeyword({"monsters"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Marvellous specimen we have here on {Dawnport}! \z
		Just be careful when you go hunting them, {dying} hurts in {Tibia}! \z
		I will happily buy any creature products you may find."
	}
)
keywordHandler:addKeyword({"garamond"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Used to be a professor at the magic academy in Edron, I believe. \z
		Likes to see different places, so he joined our illustrous little group. \z
		Sells {sorcerer} and {druid} {spells} to our trainees."
	}
)
keywordHandler:addKeyword({"tybald"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I'm not sure that's his actual name, but I guess he has good reasons to stay incognito here. \z
		In any case, he's a formidable fighter and knows usefull {spells} for knights and paladins."
	}
)
keywordHandler:addKeyword({"richard"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Richard came here as a shipwrecked carpenter, and now sells {tools} and {food} to all adventurers. \z
		If you need a {rope} or {shovel}, {fishing rod} or some provisions for a hunt, you should trade with him!"
	}
)
keywordHandler:addKeyword({"knight"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Knights are close combat fighters, the toughest vocation of all. \z
		They usually wield melee weapons such as swords, axes or clubs."
	}
)
keywordHandler:addKeyword({"druid"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Druids are nature magicians. \z
		Their speciality is casting ice and earth magic, as well as providing healing for others."
	}
)
keywordHandler:addKeyword({"paladin"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Paladins are well-trained distance fighters and can cast holy magic. \z
		You will usually see them wearing bows or crossbows."
	}
)
keywordHandler:addKeyword({"sorcerer"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Sorcerers are elemental magicians. They have mastered fire, energy and death magic."
	}
)
keywordHandler:addKeyword({"tools"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "In {Tibia}, you can use different tools with your environment, or for quests. \z
		The most important tools are {rope} and {shovel}. \z
		A {fishing rod}'s also good when you need to eat, and are near a river or the sea."
	}
)
keywordHandler:addKeyword({"food"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Food is very important for your health and mana. \z
		If you are hurt in a fight with a monster, select 'USE' on food such as cheese, ham or meat to eat it. \z
		This will slowly refill your health and mana. Here at the outpost, you can buy food from {Richard}."
	}
)
keywordHandler:addKeyword({"fishing rod"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Use a fishing rod on a patch of water to see if you can catch fish! \z
		Eating is essential in {Tibia} - if you don't eat when you're hungry, you won't regenerate health or mana. \z
		So you should aways have some {food} with you."
	}
)

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if msgcontains(msg, "portal") then
		npcHandler:say(
			{
				"It seems to emanate a magical call or pulse that draws all sorts of creatures to it - no offense meant. \z
					When we first found it, we were flabbergasted - we thought maybe a mad sorcerer had built it, \z
					or a cult, to summon something evil. ...",
				"But we didn't find any conclusive hints. \z
					{Menesto} and a few others volunteered to guard the portal from the {monsters} of this isle. \z
					You say you came through it from your world! Astounding. ...",
				"You couldn't have chosen a better time. \z
					We really need help against the monsters that swarm this island, and the whole world of {Tibia}. \z
					If you're unsure on how to {help} exactly, I can give you directions."
			},
		cid, false, true, 10)
	elseif msgcontains(msg, "menesto") then
		npcHandler:say(
			{
				"Hasn't been with us for very long. Very interested in all things mystical, \z
					so Menesto was sent down to guard the strange crystal {portal} we found here. ...",
				"... But of course, you met him. ... So it really is a portal, and you came through it \z
					from another plane of existence! I never quite believed the tales of old, not really. \z
					But now... it's wonderful, truly wonderful. ...",
				"Well, if you have any questions as to THIS plane of existence, which we call {Tibia}, just ask me. \z
					I can give directions, {hints}, you name it. <winks at you>"
			},
		cid, false, true, 10)
	elseif msgcontains(msg, "play") then
		npcHandler:say(
			{
				"Our world {Tibia} is swarmed by many dangerous {monsters}, so {fighting} is something you will \z
					have to learn and master quickly. You can fight as a {sorcerer}, druid, {paladin} or {knight}. ...",
				"We need your help in keeping the monsters at bay - walk out of one of the four gates here, \z
					and you will receive one of the four {vocations} and its gear to try out and fight monsters. ...",
				"{Dawnport} is just a small, but dangerous island. You will have to reach level 8 at least and \z
					choose your definite vocation before you can leave for the {mainland}. To reach level 8, you \z
					will have to fight some monsters in order to progress. ... ",
				"Fighting is essential in Tibia, and though Dawnport is quite safe in comparison to the mainland, \z
					be careful not to die, as {dying} HURTS. ...",
				"If you have any other questions, tell me."
			},
		cid, false, true, 10)
	elseif msgcontains(msg, "combat") then
		npcHandler:say(
			{
				"There are many dangers in {Tibia}. You may have to defend yourself not only against {monsters}, \z
					but if {PvP} is allowed, against other {players}, too. ...",
				"To attack, click on your chosen target in the battle list. \z
					A red frame will show you which target you are currently attacking. ...",
				"To automatically follow your target, click on 'Chase Opponent' in your combat controls - the top left button. ...",
				"You can also define your attack and defense mode, by selecting {offensive}, {balanced} or {defensive} fighting."
			},
		cid, false, true, 10)
	elseif msgcontains(msg, "pvp") then
		npcHandler:say(
			{
				"Depending on the world you chose in {Tibia}, {players} may attack you at all times or only if you consent. ...",
				"On an Optional PvP world, PvP is only possible if both players consent to it; \z
					but on Open PvP or Hardcore PvP worlds, any player may always attack you, so be watchful. ...",
				"A brown frame around a player indicates he or she is in a PvP situation. \z
					A {skull} next to a player name means he or she attacked or killed another player. ...",
				"Here on {Dawnport}, PvP is not allowed inside the outpost, \z
					and not possible until you have reached level 8 at least. If you have any other questions, tell me."
			},
		cid, false, true, 10)
	elseif msgcontains(msg, "players") then
		npcHandler:say(
			{
				"To chat with other players, you can click on one of the chat channels and see who is posting in there. ...",
				"If you want to message a specific player, right-click on his or her name and select \z
					'Message to <player name>'. This will open up a chat channel where you can type in your message to him or her."
			},
		cid, false, true, 10)
	elseif msgcontains(msg, "npc") then
		npcHandler:say(
			{
				"NPC means someone like me or {Hamish} or {Coltrayne}, for example. \z
					You can easily discern us from {players} like you, because there is a speech bubble next to our {name}. ...",
				"We all have our different ways, but normally, addressing an NPC with 'hi' or \z
					'hello' will open a conversation. ...",
				"Some NPCs will have secret words that they react to that are not highlighted in their conversation. \z
					In that case, you need to type in your question. ...",
				"To do so, open the NPC Chat Channel and click on the empty space below the NPCs dialogue, and start typing. ...",
				"You can try this out by asking an NPC about their {job}, as this is a keyword most will react to. \z
					If you have any other questions, tell me."
			},
		cid, false, true, 10)
	elseif msgcontains(msg, "spells") then
		npcHandler:say(
			{
				"Every vocation has specific spells that can only be used if you have that vocation. \z
					Sorcerers and druids of course rely heavily on spells, while knights only have a few at their disposal. ...",
				"As an adventurer in training, you have a few spells at your disposal at the beginning, \z
					but more will become available as you progress. ...",
				"Once you're level 8, new spells become available upstairs at the spell trainers {Garamond} and {Tybald}. \z
					They can tell you more."
			},
		cid, false, true, 10)
	elseif msgcontains(msg, "shovel") then
		npcHandler:say(
			{
				"Second best thing to a rope - a shovel will reveal secret entrances buried \z
					under loose stone piles, or under sand, or earth... you will see! ...",
				"Shovels can be bought at {Richard}'s, like the other equipment, or food. \z
					If you don't have the money yet, go out and kill some {monsters} outside - \z
					and maybe you'll even find a shovel, who knows!"
			},
		cid, false, true, 10)
	elseif msgcontains(msg, "dawnport") then
		npcHandler:say(
			{
				"We found the island following a strange glow we saw at night, close before dawn. \z
					We were looking for a source of unknown, powerful magic, and it seemed that this island was its source. ...",
				"When we arrived, we found goblins, minotaurs, trolls and undead warring on this island. \z
					We wondered why. Then they seemed to reach an agreement, and settled down in the caves. \z
					We decided to investigate. ...",
				"That is when we found the strange crystal {portal}, through which you came. \z
					Perhaps this is why the {monsters} battle, but won't leave. ...",
				"It certainly is a place of power, so {Menesto}'s group was sent down to guard it. \z
					However, we are but few, so we need every help we can get to defend and maintain the outpost on this isle. ...",
				"That is why we need your help - choose the vocation that suits you, take up its arms and help us \z
					defend this place against the evil that wants to claim it! If you need any help in how to do these things, ask me."
			},
		cid, false, true, 10)
	elseif msgcontains(msg, "mainland") then
		npcHandler:say(
			{
				"The mainland harbours the most ancient cities of {Tibia}, and many dangers and adventures as well. \z
					When you have helped us defend {Dawnport}, and learned enough of the ways of Tibia to \z
					reach level 8 at least, you should leave for the mainland. ...",
				"There you can continue to battle evil - and believe me, there is much of that in our world, alas. <sigh> ...",
				"Premium adventurers can also sail to the many islands that surround the mainland, which offer many more dangers \z
					and mysteries to be explored; and you can do quests to ride mounts, and dress in a variety of new outfits."
			},
		cid, false, true, 10)
	elseif msgcontains(msg, "figthing") then
		npcHandler:say(
			{
				"Go through one of the open gates on this floor and you will be equipped with \z
					training weapons and {spells} of a specific vocation. ...",
				"There are four vocations in Tibia: {knight}, {druid}, {paladin} and {sorcerer}. \z
					Each one has its unique abilities, strengths and weaknesses. \z
					Just try them out to see which one suits you best. ...",
				"We need your help in our battle. Fight {monsters} to gain experience and better {skills}, \z
					until you reach level 8 at least. Make sure you always have not only a weapon, \z
					but a {rope} with you, as well! ...",
				"Once you reached level 8 or more, you have to choose one vocation as your definite vocation \z
					before you can leave for the Tibian {mainland}, where more dangers await you. ... ",
				"To choose your definite vocation, talk to {Oressa} downstairs in the {temple}. \z
					She can also heal you if you are severely wounded or poisoned - just say 'heal' or 'help' to her. ...",
				"If you have any other questions, tell me."
			},
		cid, false, true, 10)
	elseif msgcontains(msg, "vocations") then
		npcHandler:say(
			{
				"A vocation is your profession and chosen destiny, rolled into one. \z
					There are four vocations in {Tibia}: {knight}, {sorcerer}, {paladin} or {druid}. \z
					Each vocation has its unique special abilities with which to fight evil. ...",
				"You need to choose your vocation before you can leave {Dawnport} to go to the {Mainland}. \z
					But first, you have to gain enough experience to reach level 8 in order to do so. ...",
				"Once you've reached level 8 and want to choose your definite vocation, \z
					talk to {Oressa} downstairs in the temple. She can also heal you if you are hurt or poisoned. ...",
				"If you have any other questions, tell me."
			},
		cid, false, true, 10)
	elseif msgcontains(msg, "help") then
		npcHandler:say(
			{
				"I can give you directions how to {play}, some basic survival and {combat} tips, or explain {PvP}, ...",
				"I can also tell you how to talk with other {players} or {NPC}s, \z
					or can inform you about {questing} or {spells}. ...",
				"I also have a list of small {hints} if you prefer that, and can tell you something of the {people} here. \z
					Just tell me what you want to know. ...",
				"Oh, but first that help I mentioned - you should get yourself a {shovel}, friend. \z
					It will come in handy when you set about finding secret entrances to dungeons or hidden treasures - \z
					many useful things lie hidden beneath earth, sand or stones! "
			},
		cid, false, true, 10)
	elseif msgcontains(msg, "offensive") then
		npcHandler:say(
			{
				"Offensive {fighting} means you deal harder attacks, but have a weaker defense. \z
					Magical damage you deal is not affected by this. ...",
				"You should switch to offensive only if you want to finish off a monster quickly \z
					and are sure you can survive its harder attacks. \z
					I can also tell you something about {balanced} and {defensive} fighting."
			},
		cid, false, true, 10)
	elseif msgcontains(msg, "balanced") then
		npcHandler:say(
			{
				"Balanced {fighting} balances out your attack strength as well as your defense strength. \z
					Magical damage you deal is not affected by this. ...",
				"I can also tell you something about {offensive} and {defensive} fighting."
			},
		cid, false, true, 10)
	elseif msgcontains(msg, "defensive") then
		npcHandler:say(
			{
				"Defensive {fighting} increases your defense but reduces your attack strength. \z
					The magical damage you deal is not affected by this. ...",
				"I can also tell you something about {offensive} and {balanced} fighting."
			},
		cid, false, true, 10)
	elseif msgcontains(msg, "skull") then
		npcHandler:say(
			{
				"A white skull means that this player attacked and maybe killed another player without justification. ...",
				"A red skull means someone has killed many other {players}, while a black skull depicts \z
					someone on a serious killing spree - so watch out!"
			},
		cid, false, true, 10)
	elseif msgcontains(msg, "hamish") then
		npcHandler:say(
			{
				"Some sort of misguided genius, I think. Brilliant with potions and runes, \z
					but couldn't get on with his master or with the other students. \z
					Ran away and set up his own little lab, selling to travellers along the road. ...",
				"Was robbed and left for dead by some plunderers, when Morris found him. \z
					{Morris} patched him up and said he could use him, so Hamish came here. \z
					If you need a wand, rune or potion, Hamish's your man."
			},
		cid, false, true, 10)
	elseif msgcontains(msg, "coltrayne") then
		npcHandler:say(
			{
				"Coltrayne doesn't say much about himself. What I gathered from the 15 years \z
					I've known him is that he was raised by a blacksmith as a foundling. ...",
				"When a fire destroyed his foster family's home, he took up an unsteady life, always wandering around. \z
					Then he met {Morris} and decided to go adventuring with him."
			},
		cid, false, true, 10)
	elseif msgcontains(msg, "morris") then
		npcHandler:say(
			{
				"Ah, there are lots of stories about Morris. Likes to insist on the 'Mr'. Nobody knows his first name, \z
					and the telling goes that he has gambled with a demon and lost his first name to him. ...",
				"The demon is said to have set Morris free so he can reclaim him at the end of his life, \z
					meanwhile having fun watching Morris struggle through hardship and adventures. ...",
				"Anyway. One way or another, Morris picked us all up and gathered us here. \z
					Not sure that sending others on missions is really all it's about for him, \z
					but if you're looking for a quest, go ask Morris for one."
			},
		cid, false, true, 10)
	elseif msgcontains(msg, "skills") then
		npcHandler:say(
			{
				"Not your level, but your skill with your weapon determines how much damage you make. \z
					With a distance weapon like a bow, you {train} your distance {fighting} skill, \z
					with a sword your sword fighting, etc. ...",
				"Druids and sorcerers train their magic level by using their mana through {spells} and runes. \z
					Their wand or rod damage is not affected by their magic level. If you have any other questions, tell me."
			},
		cid, false, true, 10)
	elseif msgcontains(msg, "rope") then
		npcHandler:say(
			{
				"You should never leave without a rope. NEVER. A rope can save your life. \z
					I once fell down into a poison spider lair - without a rope, I wouldn't be standing here today! ...",
				"You can buy a rope over at {Richard}'s shop. \z
					If you don't have the money, kill and loot a few {monsters} - maybe one of them \z
					even has a rope with it, that sort of thing happens."
			},
		cid, false, true, 10)
	elseif msgcontains(msg, "oressa") then
		npcHandler:say(
			{
				"Our local healer. Don't know why that druid girl decided she wanted the unsteady life of an \z
					adventurer, but she's quite hardy, to tell the truth. I once saw her confront a polar bear.... \z
					but I'm getting carried away. ...",
				"If you need healing, go see her. Oressa can also help you decide if you want to \z
					choose your vocation to leave for the {Mainland}."
			},
		cid, false, true, 10)
	elseif msgcontains(msg, "temple") then
		npcHandler:say(
			{
				"When you die, you will be resurrected in the temple of the city you chose as your home. \z
					Temple {NPC}s, like {Oressa} here on {Dawnport}, can heal you if you're wounded or poisoned. \z
					Some special temple NPCs can also {bless} you. ...",
				"To be fully blessed, you should start the Pilgrimage of Ashes at a local guide in the \z
					harbour once you have reached the {mainland}."
			},
		cid, false, true, 10)
	elseif msgcontains(msg, "dying") then
		npcHandler:say(
			{
				"Don't be deceived by its sweet looks - {Tibia} is a rough world. \z
					If you die, you will lose skill and experience and perhaps even some items, \z
					and other {players} can rob your corpse. ...",
				"On the {Mainland}, you can buy blessings from {temple} {NPC}s to prevent item loss, \z
					but you will always lose some {skills} and experience, so be careful. ...",
				"Always have a {rope} with you, for a start. A rope is essential."
			},
		cid, false, true, 10)
	elseif msgcontains(msg, "druid spells") then
		npcHandler:say(
			{
				"Every vocation has specific {spells} that can only be used if you have that vocation. \z
					Sorcerers and druids of course rely heavily on spells, \z
					while knights only have a few at their disposal. ...",
				"As an adventurer in training, you have a few spells at your disposal at the beginning, \z
					but more will become available as you progress. ...",
				"Once you're level 8, new spells become available upstairs at the spell trainers {Garamond} and {Tybald}. \z
					They can tell you more."
			},
		cid, false, true, 10)
	elseif msgcontains(msg, "train") then
		npcHandler:say(
			{
				"Go through one of the open gates on this floor and you will be equipped with \z
					training weapons and {spells} of a specific vocation. ...",
				"There are four {vocations} in Tibia: {knight}, {sorcerer}, {paladin} or {druid}. \z
					Each one has its unique abilities, strengths and weaknesses. \z
					Just try them out to see which one suits you best. ...",
				"We need your help in our battle. \z
					Fight {monsters} to gain experience and better {skills}, until you reach level 8 at least. \z
					Make sure you always have not only a weapon, but a {rope} with you, as well! ...",
				"Once you reached level 8 or more, you have to choose one vocation as your definite \z
					vocation before you can leave for the Tibian {mainland}, where more dangers await you. ...",
				"To choose your definite vocation, talk to {Oressa} downstairs in the {temple}. \z
					She can also heal you if you are severely wounded or poisoned - just say 'heal' or 'help' to her. ...",
				"If you have any other questions, tell me."
			},
		cid, false, true, 10)
	elseif msgcontains(msg, "bless") then
		npcHandler:say(
			{
				"The blessings of the gods will protect you from item loss and alleviate the skill \z
					and experience loss when you die. \z
					But you will have to undertake the Pilgrimage of Ashes on the {mainland} to get the blessings. ...",
				"If you die in a fight from a monster's attack, your blessings will be lost, \z
					and you will have to get them again. ...",
				"There is also a blessing that will protect you specifically from losses in a {PvP} fight. \z
					This blessing you will need to get again when you have been killed in a PvP fight. ...",
				"Here on {Dawnport}, you are protected from losses in a PvP fight by the Adventurer's Blessing - \z
					unless you attack another player. If you attack another player or reach level 20, you will lose this blessing."
			},
		cid, false, true, 10)
	elseif msgcontains(msg, "hints") then
		for i = 0,35,1 do
			if i <= 35 then
				npcHandler:say({hints[i]})
			elseif i == 35 then
				i = 0
			end
		end

	elseif msgcontains(msg, "rookgaard") and player:getLevel() <= 9 then
		if Player.getAccountStorage(player, accountId, Storage.Dawnport.Mainland, true) == 1 then
			npcHandler:say("Hmmm. Long time I visited that isle. Not very exciting place. \z
			Why do you ask? Do you wish to go there?", cid)
			npcHandler.topic[cid] = 1
		else
			npcHandler:say(
				"I'm sorry, but I cannot let you go there, you'll get much better training here than on that ancient isle.", cid)
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, "yes") and npcHandler.topic[cid] == 1 then
		npcHandler:say({
			"Careful, careful, it's a one-way ticket only! \z
			You can never come back here if you leave now, and you will loso all your Dawnport equipment and products! ...",
			"Are you {SURE} you want to {LEAVE} Dawnport for ROOKGAARD?"
		}, cid, false, true, 10)
		npcHandler.topic[cid] = 2
	elseif npcHandler.topic[cid] == 2 and msgcontains(msg, "yes")
	or msgcontains(msg, "sure") or msgcontains(msg, "leave") then
		local town = Town(TOWNS_LIST.ROOKGAARD)
		player:setTown(town)
		-- Change to none vocation, convert magic level and skills and set proper stats
		player:changeVocation(VOCATION.ID.NONE)
		player:teleportTo(town:getTemplePosition())
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)

		local slots = {
			1, 2, 4, 5, 6, 7, 8, 9, 10
		}
		-- Cycle through the slots table and store the slot id in slot
		for index, value in pairs(slots) do
			-- Get the player's slot item and store it in item
			local item = player:getSlotItem(value)
			-- If the item exists meaning its not nil then continue
			if item and not table.contains({1987, 1988, 2050, 2461, 2651, 2649}, item:getId()) then
				item:remove()
			end
		end
		local container = player:getSlotItem(CONST_SLOT_BACKPACK)
		local toBeDeleted = {}
		local allowedIds = {
			1987, 2050, 2120, 2148
		}
		if container and container:getSize() > 0 then
			for i = 0, container:getSize() do
				if player:getMoney() > 1500 then
					player:removeMoney(math.abs(1500 - player:getMoney()))
				end
				local item = container:getItem(i)
				if item then
					if not table.contains(allowedIds, item:getId()) then
						toBeDeleted[#toBeDeleted + 1] = item.uid
					end
				end
			end
			if #toBeDeleted > 0 then
				for i, v in pairs(toBeDeleted) do
					local item = Item(v)
					if item then
						item:remove()
					end
				end
			end
		end
		player:addItem(2382, 1)
		player:addItem(1987, 1)
		player:addItem(2050, 1)
		player:addItem(2674, 1)
		player:addItem(2650, 1)
		npcHandler:say("Then so be it. I'm sorry to see you go, but if this is what you want, step this way... right. \z
		Now, cover your eyes... GO!", cid)
		npcHandler.topic[cid] = 0
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
