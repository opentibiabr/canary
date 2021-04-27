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


-- Travel
local function addTravelKeyword(keyword, destination)
	local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = 'Do you want to sail ' .. keyword:titleCase() .. '?'})
		travelKeyword:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = false, destination = destination})
		travelKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'We would like to serve you some time.', reset = true})
end

addTravelKeyword('ab\'dendriel', Position(32734, 31668, 6))
addTravelKeyword('edron', Position(33175, 31764, 6))
addTravelKeyword('venore', Position(32954, 32022, 6))
addTravelKeyword('darashia', Position(33289, 32480, 6))

-- Basic
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler,
	text = {
		"My name is Scrutinon. However, there are not many people calling my name nowadays. Not many captains even dare to land on this island. It is too close to {Quirefang}. ...",
		"Most of them do not know this island by that name. Some call it Demon Horn, others the Dragon's Tooth or the Gray Beach as none of them ever came closer than a fair distance. ...",
		"There are drifts and storms surrounding that place that are far too dangerous to navigate through even for the most versed captains. They often sail not closer than to this island here and drop off whoever dares to explore near this dreaded coast."
	}}
)
keywordHandler:addKeyword({'quirefang'}, StdModule.say, {npcHandler = npcHandler,
	text = {
		"This island is cleft. Go there only prepared or you will meet your end. The surface of this forgotten rock is a barren wasteland full of hostile creatures. ...",
		"Its visage is covered with holes and tunnels in which its leggy inhabitants are hiding. Its bowels filled with the strangest creatures, waiting to feast on whatever dares to disturb their hive. ...",
		"And you will find no shelter in Quirefang's black depths, where the creatures of the deep are fulfilling a dark prophecy. ...",
		"It is impossible to reach it by ship or boat. However, there was one before you. A {visitor} who found a way to enter the island."
	}}
)

npcHandler:addModule(FocusModule:new())
