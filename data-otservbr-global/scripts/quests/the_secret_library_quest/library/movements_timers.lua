local timers = {
	[1] = {position = Position(32616, 32529, 13), timer = Storage.Quest.U11_80.TheSecretLibrary.Library.MazzinorTime, toPosition = Position(32720, 32770, 10)},
	[2] = {position = Position(32464, 32654, 12), timer = Storage.Quest.U11_80.TheSecretLibrary.Library.LokathmorTime, toPosition = Position(32720, 32746, 10)},
	[3] = {position = Position(32662, 32713, 13), timer = Storage.Quest.U11_80.TheSecretLibrary.Library.GhuloshTime, toPosition = Position(32746, 32770, 10)},
	[4] = {position = Position(32660, 32736, 12), timer = Storage.Quest.U11_80.TheSecretLibrary.Library.GorzindelTime, toPosition = Position(32746, 32746, 10)},
}

local movements_library_timers = MoveEvent()

function movements_library_timers.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return false
	end

	local player = Player(creature:getId())

	for _, k in pairs(timers) do
		if position == k.position then
			if player:getStorageValue(k.timer) <= os.time() then
				player:teleportTo(k.toPosition)
			else
				player:teleportTo(fromPosition, true)
				player:sendCancelMessage('You are still exhausted from your last battle.')
			end
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		end
	end

	return true
end

movements_library_timers:aid(4950)
movements_library_timers:register()