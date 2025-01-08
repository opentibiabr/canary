local soulpitArenaExitConfig = {
	arenaExit = Position(32375, 31153, 8),
	destination = Position(32373, 31158, 8),
}

local soulpitArenaExit = Action()

function soulpitArenaExit.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player then
		return false
	end
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	player:teleportTo(soulpitArenaExitConfig.destination)
end

soulpitArenaExit:position(soulpitArenaExitConfig.arenaExit)
soulpitArenaExit:register()
