local function onSayRotate(player, words, param)
	local currentDir = player:getDirection()
	local nextDir = (currentDir + 1) % 4
	player:setDirection(nextDir)
	local dirNames = { [0] = "north", [1] = "east", [2] = "south", [3] = "west" }
	return true
end

local talkAction = TalkAction("!r")
talkAction:onSay(onSayRotate)
talkAction:groupType("normal")
talkAction:register()
