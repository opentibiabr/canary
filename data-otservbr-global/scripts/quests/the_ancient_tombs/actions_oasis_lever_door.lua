local doorPosition = Position(33122, 32765, 14)

local function revertCarrotAndLever(position, carrotPosition)
	local leverItem = Tile(position):getItemById(2773)
	if leverItem then
		leverItem:transform(2772)
	end

	local carrotItem = Tile(carrotPosition):getItemById(3595)
	if carrotItem then
		carrotItem:remove()
	end
end

local theAncientOasisLever = Action()
function theAncientOasisLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 1662 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You first must find the Carrot under one of the three hats to get the access!")		
		return true
	end

	if item.itemid ~= 2772 then
		return true
	end

	if math.random(3) == 1 then
		local hatPosition = Position(toPosition.x - 1, toPosition.y, toPosition.z)
		hatPosition:sendMagicEffect(CONST_ME_MAGIC_GREEN)
		doorPosition:sendMagicEffect(CONST_ME_MAGIC_GREEN)
		Game.createItem(3595, 1, hatPosition)
		player:setStorageValue(Storage.Quest.U7_4.TheAncientTombs.RahemosTreasure, 1)
	-- AID Door changer
		item:setActionId(12108)

	-- TEMPORARY SOLUTION / AID FOR THE DOOR MUST BE CHANGED FROM 1207 TO 1208 / It could also stay like this to make the mechanic to be more alike
	local doorItem = Tile(doorPosition):getItemById(1662)
		if doorItem then
			doorItem:setActionId(12108)
		end

		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You found the carrot! The door is open!")
		item:transform(2773)
		addEvent(revertCarrotAndLever, 4 * 1000, toPosition, hatPosition)
		return true
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You guessed wrong! Take this! Carrot changed now the Hat!")
	doAreaCombatHealth(player, COMBAT_PHYSICALDAMAGE, player:getPosition(), 0, -200, -200, CONST_ME_POFF)
	return true
end

theAncientOasisLever:aid(12107)
theAncientOasisLever:register()