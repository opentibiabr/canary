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

keywordHandler:addKeyword({"business"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I am the leader of the Kuridai and the Az'irel of Ab'Dendriel. \z
				Humans would call it {sheriff}, executioner, or avenger."
	}
)
keywordHandler:addKeyword({"sheriff"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Sometimes people get imprisoned for some time. \z
				True criminals will be cast out and for committing the worst crimes offenders are thrown into the hellgate."
	}
)
keywordHandler:addKeyword({"executioner"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Sometimes people get imprisoned for some time. \z
				True criminals will be cast out and for committing the worst crimes offenders are thrown into the hellgate."
	}
)
keywordHandler:addKeyword({"avenger"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Sometimes people get imprisoned for some time. \z
				True criminals will be cast out and for committing the worst crimes offenders are thrown into the hellgate."
	}
)
keywordHandler:addKeyword({"hellgate"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "It was here among other structures, like the depot tower, before our people came here. \z
				It's secured by a sealed door."
	}
)
keywordHandler:addKeyword({"sealed"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "For safety we keep the door to the hellgate locked all times. I have the {keys} to open it when needed."
	}
)
keywordHandler:addKeyword({"door"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "For safety we keep the door to the hellgate locked all times. I have the {keys} to open it when needed."
	}
)
keywordHandler:addKeyword({"name"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Not that I like to talk to you, but I am Elathriel Shadowslayer."
	}
)
keywordHandler:addKeyword({"army"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "It's one of the more useful concepts we can learn from the other races."
	}
)
keywordHandler:addKeyword({"king"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "It's hard for some of my people to grasp the true concept of a strong leader."
	}
)
keywordHandler:addKeyword({"magic"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I mastered some battle spells."
	}
)
keywordHandler:addKeyword({"time"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I couldn't care less."
	}
)
keywordHandler:addKeyword({"eloise"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "A human weakling, not much more."
	}
)
keywordHandler:addKeyword({"tibianus"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "A human weakling, not much more."
	}
)
keywordHandler:addKeyword({"druid"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Druidic magic is too peaceful for my taste."
	}
)
keywordHandler:addKeyword({"sorcerer"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I have seen human sorcerers doing some impressive things ... before they died."
	}
)
keywordHandler:addKeyword({"dwarfs"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "We might use the shelter earth and hills provide us, but their obsession for metal is a waste of time."
	}
)
keywordHandler:addKeyword({"trolls"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Like all inferior races, they can be at least of use for something good. \z
				The other castes are just jealous of us making use of them."
	}
)
keywordHandler:addKeyword({"excalibug"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I still doubt it exists."
	}
)
keywordHandler:addKeyword({"ferumbras"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Even if he'd walk through the town above, the other castes would not see the necessity to follow OUR way."
	}
)
keywordHandler:addKeyword({"elves"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "My people are divided in castes in these times, until they comprehend \z
				that only the way of the Kuridai can save us all."
	}
)
keywordHandler:addKeyword({"cenath"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Arrogant bastards, but they wield quite powerful magic."
	}
)
keywordHandler:addKeyword({"teshial"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Dreamers are of no practical use. I don't mourn their demise."
	}
)
keywordHandler:addKeyword({"deraisim"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Confused cowards. For all their skill, they still tend to hide and run. What a waste."
	}
)
keywordHandler:addKeyword({"kuridai"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "We are the heart of the elven society. We forge, we build, and we don't allow our people to be pushed around."
	}
)
keywordHandler:addKeyword({"carlin"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "We watch this city and the actions of its inhabitants closely."
	}
)
keywordHandler:addKeyword({"venore"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "The merchants of venore provide us with some useful goods. \z
				Still I an convinced that they get more out of our bargain then we do."
	}
)
keywordHandler:addKeyword({"thais"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "The Thaian kingdom and we share some enemies, so it's only logical to cooperate in a few areas."
	}
)
keywordHandler:addKeyword({"carlin"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = ""
	}
)
keywordHandler:addKeyword({"offer"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I offer hardly anything except for knowledge of {spells}."
	}
)
keywordHandler:addKeyword({"buy"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I offer hardly anything except for knowledge of {spells}."
	}
)
keywordHandler:addKeyword({"sell"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I offer hardly anything except for knowledge of {spells}."
	}
)

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "key") then
		npcHandler:say("If you are that curious, do you want to buy a key for 5000 gold? \z
						Don't blame me if you get sucked in.", cid)
		npcHandler.topic[cid] = 1
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 1 then
			local player = Player(cid)
			if player:removeMoneyNpc(5000) then
				npcHandler:say("Here it is.", cid)
				local key = player:addItem(2089, 1)
				if key then
					key:setActionId(3012)
				end
			else
				npcHandler:say("Come back when you have enough money.", cid)
			end
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, "no") then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say("Believe me, it's better for you that way.", cid)
			npcHandler.topic[cid] = 0
		end
	end
	return true
end


-- Greeting message
keywordHandler:addGreetKeyword({"ashari"},
	{
		npcHandler = npcHandler,
		text = "Be greeted |PLAYERNAME|. What is your {business} near the {hellgate}?"
	}
)
--Farewell message
keywordHandler:addFarewellKeyword({"asgha thrazi"},
	{
		npcHandler = npcHandler,
		text = "Asha Thrazi, |PLAYERNAME|."
	}
)

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:setMessage(MESSAGE_GREET, "Be greeted |PLAYERNAME|. What is your {business} near the {hellgate}?")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Asha Thrazi, stranger!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Asha Thrazi, stranger!")

npcHandler:addModule(FocusModule:new())
