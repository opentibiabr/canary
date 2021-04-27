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
	{text = "Team up with others to defeat monsters!"},
	{text = "Get your gear and help us defend Dawnport against the monsters!"},
	{text = "Better weapons equal more damage - get yourself some gear right here!"},
	{text = "Gird youselves! Chain mail, bows, spears, swords - we've got it all!"},
	{text = "Skill comes with practice - get out there and kill some beasts!"}
}

npcHandler:addModule(VoiceModule:new(voices))

keywordHandler:addKeyword({'name'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Coltrayne Daggard. Just ask me for a trade to see the latest in chain mail and weapons."
	}
)
keywordHandler:addKeyword({'job'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I'm a blacksmith by trade. Want to keep our lads and lasses safe and equipped with a sharp blade, me."
	}
)
keywordHandler:addKeyword({'rookgaard'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "You mean to imply I am an inexperienced guardian? Get out of here."
	}
)
keywordHandler:addKeyword({'coltrayne'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = " Yes. You wish to trade I guess. At least, you look like you could use some good gear, kid."
	}
)
keywordHandler:addKeyword({'hamish'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Good at potions. Likes experimenting. Can kit you out with magical equipment for a hunt."
	}
)
keywordHandler:addKeyword({'inigo'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Gives newcomers hints how we do things here in Tibia. Don't know how to use something? Ask Inigo."
	}
)
keywordHandler:addKeyword({'garamond'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Don't have much to say about him. Barely know him. Seems a decent spell teacher for mages."
	}
)
keywordHandler:addKeyword({'ser tybald'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I'm sure I've seen his face before somewhere... \z
		never mind. Anyway, he's the knight and paladin spell teacher around here, letting you try them out for free. \z
		Don't underestimate the use of spells, even if you're not a mage."
	}
)
keywordHandler:addKeyword({'richard'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "He's just in the next shop to the left, selling food and equipment \z
		like ropes and shovels and fishing rods and such."
	}
)
keywordHandler:addKeyword({'mr morris'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "He had a plan, as usual. Came here, set up the outpost, managed everything. \z
		Looking for a task or quest? He's your man."
	}
)
keywordHandler:addKeyword({'oressa'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "She's our local healer. Downstairs in the temple and oracle room, that's where she is. \z
		Just say 'heal' or 'help' and she'll help ya if you really need it."
	}
)
keywordHandler:addKeyword({'plunderpurse'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Pirates and gold, you get the rest. Hoards gold now for young adventurers - \z
		keeps it safe while you go out hunting."
	}
)

npcHandler:setMessage(MESSAGE_GREET, "Hey there. Need some armor or weapon? Then ask me for a {trade}.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Yeah, bye..")

npcHandler:addModule(FocusModule:new())
