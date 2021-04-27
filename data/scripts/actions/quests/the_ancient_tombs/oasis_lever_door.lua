local doorPosition = Position(33122, 32765, 14)

local function revertCarrotAndLever(position, carrotPosition)
	local leverItem = Tile(position):getItemById(1946)
	if leverItem then
		leverItem:transform(1945)
	end

	local carrotItem = Tile(carrotPosition):getItemById(2684)
	if carrotItem then
		carrotItem:remove()
	end
end

local theAncientOasisLever = Action()
function theAncientOasisLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 1243 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You first must find the Carrot under one of the three hats to get the access!')
		return true
	end

	if item.itemid ~= 1945 then
		return true
	end

	if math.random(3) == 1 then
		local hatPosition = Position(toPosition.x - 1, toPosition.y, toPosition.z)
		hatPosition:sendMagicEffect(CONST_ME_MAGIC_GREEN)
		doorPosition:sendMagicEffect(CONST_ME_MAGIC_GREEN)
		Game.createItem(2684, 1, hatPosition)

		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You found the carrot! The door is open!')
		item:transform(1946)
		addEvent(revertCarrotAndLever, 4 * 1000, toPosition, hatPosition)

		local doorItem = Tile(doorPosition):getItemById(1243)
		if doorItem then
			doorItem:transform(1244)
		end
		return true
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You guessed wrong! Take this! Carrot changed now the Hat!')
	doAreaCombatHealth(player, COMBAT_PHYSICALDAMAGE, player:getPosition(), 0, -200, -200, CONST_ME_POFF)
	return true
end

theAncientOasisLever:aid(12107)
theAncientOasisLever:register()