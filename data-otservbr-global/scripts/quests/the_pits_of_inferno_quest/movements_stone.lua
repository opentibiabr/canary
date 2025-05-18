local stone = MoveEvent()

function stone.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local stonePosition = Position(32849, 32282, 10)
	local stoneItem = Tile(stonePosition):getItemById(1791)
	local leverItem = Tile(Position(32850, 32268, 10)):getItemById(2773)
	if not stoneItem and leverItem then
		Game.createItem(1791, 1, stonePosition)
		leverItem:transform(2772)
		player:say("You hear a rumbling from far away.", TALKTYPE_MONSTER_SAY, false, player)
	end
	return true
end

stone:type("stepin")
stone:aid(4001)
stone:register()
