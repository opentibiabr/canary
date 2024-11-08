--

local paper = Action()

function paper.onUse(player, item, frompos, item2, topos)
	if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Second.Investigating) == 2 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Documents were burnt here recently. Only the part of one scroll still lies in front of the chimney but it's too sooted to read.")
		player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Second.Investigating, 3)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already investigated this.")
	end
	return true
end

paper:uid(40030)
paper:register()

--

local paperScraps = Action()

function paperScraps.onUse(player, item, frompos, item2, topos)
	if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Second.Investigating) == 3 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Paper scraps lie scattered on the floor. It takes some time to put them back together. But it's only a badly written poem.")
		player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Second.Investigating, 4)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already investigated this.")
	end
	return true
end

paperScraps:uid(40031)
paperScraps:register()

--

local scrolls = Action()

function scrolls.onUse(player, item, frompos, item2, topos)
	if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Second.Investigating) == 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You examine the scrolls carefully. Those are orders from Rathleton for the Ambassador. No sign of treason here.")
		player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Second.Investigating, 2)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already investigated this.")
	end
	return true
end

scrolls:uid(40029)
scrolls:register()

--

local roofTop = MoveEvent()

function roofTop.onStepIn(player, item, frompos, item2, topos)
	if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Second.Investigating) == 4 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You find nothing in the Ambassador's house. If he's in fact a traitor he got rid of any evidence that could incriminate him.")
		player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Second.Investigating, 5)
	end
	return true
end

roofTop:aid(50307)
roofTop:register()
