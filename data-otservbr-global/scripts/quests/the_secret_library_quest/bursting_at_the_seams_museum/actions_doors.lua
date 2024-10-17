local doors = {
	[1] = { doorPosition = Position(33246, 32122, 8), storage = Storage.Quest.U11_80.TheSecretLibrary.MoTA.Questline, value = 2 },
	[2] = { doorPosition = Position(33208, 32071, 8), storage = Storage.Quest.U11_80.TheSecretLibrary.MoTA.LeverPermission, value = 1 },
	[3] = { doorPosition = Position(33208, 32074, 8), storage = Storage.Quest.U11_80.TheSecretLibrary.MoTA.LeverPermission, value = 1 },
	[4] = { doorPosition = Position(33341, 32117, 10), storage = Storage.Quest.U11_80.TheSecretLibrary.MoTA.FinalBasin, value = 1 },
	[5] = { doorPosition = Position(33344, 32120, 10), storage = Storage.Quest.U11_80.TheSecretLibrary.MoTA.SkullSample, value = 1 },
}

local actions_museum_doors = Action()

function actions_museum_doors.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	for _, p in pairs(doors) do
		if (item:getPosition() == p.doorPosition) and not (Tile(item:getPosition()):getTopCreature()) then
			if player:getStorageValue(p.storage) >= p.value then
				player:teleportTo(toPosition, true)
				item:transform(item.itemid + 1)
			else
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The door seems to be sealed against unwanted intruders.")
			end
		end
	end

	return true
end

actions_museum_doors:aid(4905)
actions_museum_doors:register()
