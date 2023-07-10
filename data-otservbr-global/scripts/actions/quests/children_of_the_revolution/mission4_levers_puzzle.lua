local puzzlePositions = {
	[1] = Position(33352, 31126, 5),
	[2] = Position(33353, 31126, 5),
	[3] = Position(33354, 31126, 5),
	[4] = Position(33355, 31126, 5)
}
local function puzzle(position, itemId, itemTransform)
	if Tile(position):getItemById(itemId) then
		Tile(position):getItemById(itemId):transform(itemTransform)
	else
		Tile(position):getItemById(itemTransform):transform(itemId)
	end
end
local function revertLever(fromPosition)
	if Tile(fromPosition):getItemById(9126) then
		Tile(fromPosition):getItemById(9126):transform(9125)
	end
end
local childrenGrease = Action()
function childrenGrease.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.ChildrenoftheRevolution.Questline) == 14 then
		if fromPosition == Position(33349, 31123, 5) or fromPosition == Position(33349, 31124, 5) then
			puzzle(puzzlePositions[1], 9935, 9933)
			puzzle(puzzlePositions[2], 9936, 9937)
			puzzle(puzzlePositions[4], 9929, 9938)
		end
		if fromPosition == Position(33349, 31125, 5) then
			puzzle(puzzlePositions[3], 9939, 9934)
			puzzle(puzzlePositions[4], 9929, 9938)
		end
		if fromPosition == Position(33349, 31126, 5) then
			puzzle(puzzlePositions[2], 9936, 9937)
			puzzle(puzzlePositions[3], 9939, 9934)
		end
		if fromPosition == Position(33349, 31127, 5) then
			puzzle(puzzlePositions[1], 9935, 9933)
			puzzle(puzzlePositions[3], 9939, 9934)
		end
		if Tile(puzzlePositions[1]):getItemById(9933) and Tile(puzzlePositions[2]):getItemById(9936) and Tile(puzzlePositions[3]):getItemById(9939) and Tile(puzzlePositions[4]):getItemById(9938) then
			player:say("After a cracking noise a deep humming suddenly starts from somewhere below.", TALKTYPE_MONSTER_SAY)
			player:setStorageValue(Storage.ChildrenoftheRevolution.Questline, 17)
			player:setStorageValue(Storage.ChildrenoftheRevolution.Mission04, 5)
		end
		item:transform(item.itemid == 9125 and 9126 or 9125)
		if Tile(fromPosition):getItemById(9126) then
			addEvent(revertLever, 5000, fromPosition)
		end
		return true
	end
	return true
end
local positions = {
	{x = 33349, y = 31123, z = 5},
	{x = 33349, y = 31124, z = 5},
	{x = 33349, y = 31125, z = 5},
	{x = 33349, y = 31126, z = 5},
	{x = 33349, y = 31127, z = 5}
}

for index, value in pairs(positions) do
	childrenGrease:position(value)
end
childrenGrease:register()
