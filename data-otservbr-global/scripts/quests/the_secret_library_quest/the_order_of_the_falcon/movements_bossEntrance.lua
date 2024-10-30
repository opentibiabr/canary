local config = {
	entrance = Position(33310, 31325, 8),
	exit = Position(33329, 31333, 9),
}

local movements_falcon_bossEntrance = MoveEvent()

function movements_falcon_bossEntrance.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return false
	end

	local entrance = config.entrance
	local exit = config.exit

	if item:getActionId() == 4920 then
		if creature then
			if item:getPosition() == entrance then
				if creature:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.FalconBastion.KillingBosses) >= 5 then
					creature:teleportTo(Position(exit.x, exit.y - 2, exit.z), true)
				else
					creature:teleportTo(Position(entrance.x - 2, entrance.y, entrance.z), true)
				end
			elseif item:getPosition() == exit then
				creature:teleportTo(Position(entrance.x - 2, entrance.y, entrance.z), true)
			end
		end
	elseif item:getActionId() == 4921 then
		local blockedPositions = {
			Position(33328, 31352, 7),
			Position(33373, 31309, 7),
			Position(33382, 31294, 7),
			Position(33344, 31348, 7),
		}
		if creature then
			if isInArray(blockedPositions, position) then
				return true
			else
				if creature:canFightBoss("Grand Master Oberon") then
					creature:teleportTo(Position(33363, 31341, 9), true)
				else
					creature:teleportTo(fromPosition, true)
					creature:sendCancelMessage("You are still exhausted from your last battle.")
				end
			end
		end
	end

	return true
end

movements_falcon_bossEntrance:aid(4920, 4921)
movements_falcon_bossEntrance:register()
