local timers = {
	[1] = { position = Position(32616, 32529, 13), timer = Storage.Quest.U11_80.TheSecretLibrary.Library.MazzinorTimer, toPosition = Position(32720, 32770, 10) },
	[2] = { position = Position(32464, 32654, 12), timer = Storage.Quest.U11_80.TheSecretLibrary.Library.LokathmorTimer, toPosition = Position(32720, 32746, 10) },
	[3] = { position = Position(32662, 32713, 13), timer = Storage.Quest.U11_80.TheSecretLibrary.Library.GhuloshTimer, toPosition = Position(32746, 32770, 10) },
	[4] = { position = Position(32660, 32736, 12), timer = Storage.Quest.U11_80.TheSecretLibrary.Library.GorzindelTimer, toPosition = Position(32746, 32746, 10) },
	[5] = { position = Position(32750, 32696, 10), toPosition = Position(32466, 32652, 12) },
	[6] = { position = Position(32755, 32729, 10), toPosition = Position(32664, 32711, 13) },
	[7] = { position = Position(32687, 32726, 10), toPosition = Position(32662, 32734, 12) },
	[8] = { position = Position(32724, 32728, 10), toPosition = Position(32618, 32527, 13) },
}

local movements_library_timers = MoveEvent()

function movements_library_timers.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return false
	end

	local player = Player(creature:getId())

	for _, k in pairs(timers) do
		if position == k.position then
			if not k.timer or player:getStorageValue(k.timer) <= os.time() then
				player:teleportTo(k.toPosition)
			else
				player:teleportTo(fromPosition, true)
				player:sendCancelMessage("You are still exhausted from your last battle.")
			end
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		end
	end

	return true
end

movements_library_timers:aid(4950)
movements_library_timers:register()
