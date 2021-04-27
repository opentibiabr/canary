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
	{text = "Health potions to refill your health in combat!"},
	{text = "Potions! Wand! Runes! Get them here!"},
	{text = "Pack of monsters give you trouble? Throw an area rune at them!"},
	{text = "Careful with that! That's a highly reactive potion you have there!"},
	{text = "Run out of mana or a little kablooie? Come to me to resupply!"}
}

npcHandler:addModule(VoiceModule:new(voices))

keywordHandler:addKeyword({'name'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Hamish MacGuffin, at your disposal."
	}
)
keywordHandler:addKeyword({'job'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I craft highly efficient runes, wands and potions - always handy when you're in a fight against monsters! \z
		Ask me for a trade to browse through my stock."
	}
)
keywordHandler:addKeyword({'rookgaard'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Nope. Doesn't sound familiar."
	}
)
keywordHandler:addKeyword({'coltrayne'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Never asked about his past. Seems it's a pretty gloomy one. \z
		But he's an excellent blacksmith and seems content enough with his work here."
	}
)
keywordHandler:addKeyword({'inigo'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Inigo taught me a trick or two since I joined Mr Morris' little crowd. \z
		Quite a nice old chap who's seen much of the world and knows his way around here. \z
		You should definitely ask him if you need help."
	}
)
keywordHandler:addKeyword({'garamond'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Can be quite feisty if you doubt his seniorship. \z
		<snorts> Knows a thing or two about spells, though. Useful knowledge."
	}
)
keywordHandler:addKeyword({'wentworth'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Keeran? He's a bit like Plunderpurse's shadow, isn't he? \z
		Loves numbers, but I believe underneath it all he always wanted to break out of his boring little job in the city."
	}
)
keywordHandler:addKeyword({'richard'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Seems good-natured enough a guy. Nimble with his hands, be it cooking or carpentering. \z
		Seems to want to keep his mind off something, so he's always busy fixing stuff or cooking something up."
	}
)
keywordHandler:addKeyword({'mr morris'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "If it wasn't for Mr Morris, maybe none of us would be alive. Or at least, none of us would be here. \z
		He's been everywhere and gathered some adventurers around him to investigate the secrets of Dawnport."
	}
)
keywordHandler:addKeyword({'oressa'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Our druid, down in the temple. Just appeared out of the blue one day. Keeps to herself. \z
		She must have some reason to stay with us rather than roam the bigger Mainland. Well, we all have our reasons."
	}
)
keywordHandler:addKeyword({'plunderpurse'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Now there's someone who has lived life to the full! Don't know though \z
		whether I should really believe that he's a clerk now."
	}
)

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if msgcontains(msg, "dawnport") then
		npcHandler:say(
			{
				"Small and deceptively friendly-looking island. Well, I used to study the plants and herbs here for my potions.",
				"Nowadays, I leave that to Oressa, she has a better way with that horrible wildlife here. \z
				I prefer to distil potions in the quiet of my lab. \z
				If you need some potions, runes or other magic equipment, ask for a trade."
			},
		cid, true, false, 200)
	elseif msgcontains(msg, "mainland") then
		npcHandler:say(
			{
				"Dawnport is not far off from the coast of the Tibian Mainland. Lots of cities, monsters, bandits, \z
				brigands, mean folk and people of low understanding with no sense of respect towards alchemical genius. \z
				<mutters to himself>",
				"Ahem. Once you're level 8, you should be experienced enough to choose your definite vocation and leave \z
				Dawnport for Main - and Tibia definitely needs more skilled adventurers to keep those monsters in check \z
				which roam our lands!"
			},
		cid, true, false, 200)
	elseif msgcontains(msg, "ser tybald") then
		npcHandler:say(
			{
				"I wish I had thought of changing my name to that of a hero. Would have smoothed my way no end!",
				"Anyway, whatever he was before he joined, Tybald now fits the bill of the legendary hero. \z
				He even has a crush on lady Oressa. Cute. <chuckles>"
			},
		cid, true, false, 200)
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hi there, fellow adventurer. \z
	What's your need? Say {trade} and we'll soon get you fixed up. Or ask me about potions, wands, or runes.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Use your runes wisely!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
