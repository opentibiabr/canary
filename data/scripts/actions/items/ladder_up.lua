local ladderTable = Game.getLadderIds()

local ladder = Action()

function ladder.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if table.contains(ladderTable, item.itemid) then
		fromPosition:moveUpstairs()
	else
		fromPosition.z = fromPosition.z + 1
	end

	if player:isPzLocked() and Tile(fromPosition):hasFlag(TILESTATE_PROTECTIONZONE) then
		player:sendCancelMessage(RETURNVALUE_PLAYERISPZLOCKED)
		return true
	end

	player:teleportTo(fromPosition, true)
	return true
end

ladder:id(435, unpack(ladderTable))
ladder:register()
