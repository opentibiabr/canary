local config = {
	farmineElevator = {
		Position(33061, 31527, 14), -- Elevator city stage 1
		Position(33061, 31527, 12), -- Elevator city stage 2
		Position(33061, 31527, 10), -- Elevator city stage 3
		Position(32993, 31547, 4), -- Elevator from outside the city
		Position(32991, 31539, 4), -- Elevator to flying carpet
		Position(32991, 31539, 1), -- Elevator to return from flying carpet
		Position(33055, 31527, 12), -- Elevator Stage 2 to the mines
		Position(33055, 31527, 10), -- Elevator Stage 3 to the mines
		Position(33065, 31489, 15), -- Elevator to return from the mines
	}
}
local TheNewFrontier = Storage.Quest.U8_54.TheNewFrontier

local farmineElevatorLevers = Action()

function farmineElevatorLevers.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 2773 then
		item:transform(2772)
		return true
	end

	if item.itemid == 2772 then
		local teleportTo = player:getPosition()
		if player:getPosition() == config.farmineElevator[1] or player:getPosition() == config.farmineElevator[2] or player:getPosition() == config.farmineElevator[3] then
			teleportTo = config.farmineElevator[4]
		elseif player:getPosition() == config.farmineElevator[4] and player:getStorageValue(TheNewFrontier.Questline) < 9 then
			teleportTo = config.farmineElevator[1] -- if Farmine is on Stage 1
		elseif player:getPosition() == config.farmineElevator[4]and player:getStorageValue(TheNewFrontier.Questline) >= 9 and player:getStorageValue(TheNewFrontier.Questline) < 19 then
			teleportTo = config.farmineElevator[2] -- if Farmine is on Stage 2
		elseif player:getPosition() == config.farmineElevator[4] and player:getStorageValue(TheNewFrontier.Questline) >= 19 then
			teleportTo = config.farmineElevator[3] -- if Farmine is on Stage 3
		elseif player:getPosition() == config.farmineElevator[5] then
			teleportTo = config.farmineElevator[6] -- if going to flying carpet
		elseif player:getPosition() == config.farmineElevator[6] then
			teleportTo = config.farmineElevator[5] -- if returning to flying carpet

		elseif player:getPosition() == config.farmineElevator[7] or player:getPosition() == config.farmineElevator[8] then
			teleportTo = config.farmineElevator[9] -- if going to the mines
		elseif player:getPosition() == config.farmineElevator[9] and player:getStorageValue(TheNewFrontier.Questline) < 19 then
			teleportTo = config.farmineElevator[7] -- if returning from mines to Farmine on Stage 2
		elseif player:getPosition() == config.farmineElevator[9] and player:getStorageValue(TheNewFrontier.Questline) >= 19 then
			teleportTo = config.farmineElevator[8] -- if returning from mines to Farmine on Stage 3

		end
		if player:getPosition() ~= teleportTo then
			item:transform(2773)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:teleportTo(teleportTo)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		else
			item:transform(2773)
			toPosition:sendMagicEffect(CONST_ME_POFF)
		end
	return true
	end
end

farmineElevatorLevers:aid(30002)
farmineElevatorLevers:register()
