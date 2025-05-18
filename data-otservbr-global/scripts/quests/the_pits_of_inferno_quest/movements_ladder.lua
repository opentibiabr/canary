local ladderPosition = Position(32854, 32321, 11)
local ladder = MoveEvent()

function ladder.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local ladderItem = Tile(ladderPosition):getItemById(5542)
	if not ladderItem then
		Game.createItem(5542, 1, ladderPosition)
		player:say("You hear a rumbling from far away.", TALKTYPE_MONSTER_SAY, false, player)
	end
	return item:transform(item.itemid - 1)
end

ladder:type("stepin")
ladder:uid(2002)
ladder:register()

ladder = MoveEvent()

function ladder.onStepOut(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local ladderItem = Tile(Position(32854, 32321, 11)):getItemById(5542)
	if ladderItem then
		ladderItem:remove()
		player:say("You hear a rumbling from far away.", TALKTYPE_MONSTER_SAY, false, player)
	end
	return item:transform(item.itemid + 1)
end

ladder:type("stepout")
ladder:uid(2002)
ladder:register()
