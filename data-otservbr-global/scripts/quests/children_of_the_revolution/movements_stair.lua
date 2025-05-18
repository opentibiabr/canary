local stairsPosition = Position(33265, 31116, 7)

local function revertStairs()
	Tile(stairsPosition):getItemById(8281):transform(566)
end

local stair = MoveEvent()

function stair.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	-- check if going upstairs
	if not Tile(position):getItemById(1977) then
		return true
	end

	local stairs = Tile(stairsPosition):getItemById(566)
	if stairs then
		stairs:transform(8281)
		addEvent(revertStairs, 5 * 30 * 1000)
	end

	player:say("The area around the gate is suspiciously quiet, you have a bad feeling about this.", TALKTYPE_MONSTER_SAY)
	if player:getStorageValue(Storage.Quest.U8_54.ChildrenOfTheRevolution.Mission05) == 1 then
		--Questlog, Children of the Revolution 'Mission 5: Phantom Army'
		player:setStorageValue(Storage.Quest.U8_54.ChildrenOfTheRevolution.Mission05, 2)
	end
	return true
end

stair:type("stepin")
stair:uid(3169)
stair:register()
