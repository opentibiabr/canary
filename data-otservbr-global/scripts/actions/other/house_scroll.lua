local houseScroll = Action()

function houseScroll.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local inPz = player:getTile():hasFlag(TILESTATE_PROTECTIONZONE)
	local inFight = player:isPzLocked() or player:getCondition(CONDITION_INFIGHT, CONDITIONID_DEFAULT)
	if inPz or not inFight then
		local house = player:getHouse()
		if not house then
			player:sendCancelMessage("You don't have a house.")
			return
		else
			player:teleportTo(house:getExitPosition())
		end
	end
	return true
end

houseScroll:id(400)
houseScroll:register()
