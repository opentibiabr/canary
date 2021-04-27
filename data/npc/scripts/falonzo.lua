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

keywordHandler:addKeyword(
	{"name"}, StdModule.say, { npcHandler = npcHandler,
	text = "I\'m professor Falonzo from the mage\'s guild." }
)

keywordHandler:addKeyword(
	{"job"}, StdModule.say, { npcHandler = npcHandler,
	text = "I\'m a researcher of scientific council of the mage guild and I came to that {place} to study this {anomaly}." }
)

keywordHandler:addKeyword(
	{"place"}, StdModule.say, { npcHandler = npcHandler,
	text = {
	"This {plane} is now inhabited by {intruders} and creatures that accidentally became {dragged} in. ...",
	"It is neither completely of our world nor is it still that disconnected and unreachable as it used to be. I fear it\'s only a harbinger of something more dangerous and more {sinister}."
	}}
)

keywordHandler:addKeyword(
	{"anomaly"}, StdModule.say, { npcHandler = npcHandler,
	text = {
	"Well, the whole place here is an anomaly so to say. You can hardly have missed the fact that you arrived here through a mystical gate. ...",
	"Well actually it\'s no gate at all but a rift in the fabric of nature. It is this minor {plane} trying to reconnect to our world."
	}}
)

keywordHandler:addKeyword(
	{"plane"}, StdModule.say, { npcHandler = npcHandler,
	text = "This is a lesser plane of tarnished, elemental fire that once belonged to the world that we know. It was despoiled in the wars of the gods and broke loose from our world. {Lost} and drifting through the void, without a connection to our plane." }
)

keywordHandler:addKeyword(
	{"intruders"}, StdModule.say, { npcHandler = npcHandler,
	text = "Infernalists were the first who found their way into this sphere. Hoping to tap its rotten power somehow. Yet this sphere created creatures of its own and draw others here from other planes." }
)

keywordHandler:addKeyword(
	{"dragged"}, StdModule.say, { npcHandler = npcHandler,
	text = {
	"This place became a fiery trap to certain beings with an affinity to fire. Somehow it reconnects randomly with the known world, to which it once belonged ...",
	"but also to other places that it shares some affinity with like hellish places of unspeakable evil that spawn infernal creatures."
	}}
)

keywordHandler:addKeyword(
	{"sinister"}, StdModule.say, { npcHandler = npcHandler,
	text = {
	"Something is tearing at the fabric of reality. I can\'t tell what is it but the {boundaries} between worlds are fading. ...",
	"A process that what watched for over a century but which has extremely grown in momentum over the last few years. Something is happening and it\'s for sure nothing good. ...",
	"Be it as it may, the plane trying to reconnect was only a side effect. It still might teach us about what is happening and it has for sure attracted some {attention} already."
	}}
)
keywordHandler:addAliasKeyword({'changed'})

keywordHandler:addKeyword(
	{"lost"}, StdModule.say, { npcHandler = npcHandler,
	text = "Well, that was how it used to be. Lost and without any connection to our world. But that was before things ... have {changed}." }
)

keywordHandler:addKeyword(
	{"boundaries"}, StdModule.say, { npcHandler = npcHandler,
	text = {
	"We know about other planes of existence but in all history it has never been as easy to reach them as it is now. ...",
	"Sometimes world seem to overlap and we can identify more and more such planes and worlds. More then we ever had imagined. All we can tell is, that something is changing. And not for the good."
	}}
)

keywordHandler:addKeyword(
	{"attention"}, StdModule.say, { npcHandler = npcHandler,
	text = "Such an anomaly can\'t go unnoticed for long. That lead to the presence to unwanted {intruders} and other entities were {dragged} into by the nature of the sphere." }
)

npcHandler:setMessage(MESSAGE_GREET, "Greetings, adventurer!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Well, bye then.")

npcHandler:addModule(FocusModule:new())
