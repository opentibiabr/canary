local doors = {
	[1] = { doorPosition = Position(32962, 32674, 2), storage = Storage.Quest.U11_80.TheSecretLibrary.Asuras.FlammingOrchid, value = 1, level = 250 },
	[2] = { doorPosition = Position(32959, 32679, 2), storage = Storage.Quest.U11_80.TheSecretLibrary.Asuras.Questline, value = 1 },
}

local actions_asura_doors = Action()

function actions_asura_doors.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	for _, p in pairs(doors) do
		if (item:getPosition() == p.doorPosition) and not (Tile(item:getPosition()):getTopCreature()) then
			if player:getStorageValue(p.storage) >= p.value then
				if not p.level or (p.level and player:getLevel() >= p.level) then
					player:teleportTo(toPosition, true)
					item:transform(item.itemid + 1)
				else
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You do not have enough level.")
				end
			else
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The door seems to be sealed against unwanted intruders.")
			end
		end
	end

	return true
end

actions_asura_doors:aid(4911)
actions_asura_doors:register()
