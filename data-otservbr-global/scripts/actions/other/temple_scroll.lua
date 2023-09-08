local templeScroll = Action()

function templeScroll.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local inPz = player:getTile():hasFlag(TILESTATE_PROTECTIONZONE)
	local inFight = player:isPzLocked() or player:getCondition(CONDITION_INFIGHT, CONDITIONID_DEFAULT)
	if inPz or not inFight then
		player:teleportTo(getTownTemplePosition(player:getTown():getId()))
		item:remove()
		Position(fromPosition):sendMagicEffect(CONST_ME_TELEPORT)
	else
		player:sendCancelMessage("You can't use this when you're in a fight.")
		Position(fromPosition):sendMagicEffect(CONST_ME_POFF)
	end
	return true
end

templeScroll:id(25718)
templeScroll:register()
