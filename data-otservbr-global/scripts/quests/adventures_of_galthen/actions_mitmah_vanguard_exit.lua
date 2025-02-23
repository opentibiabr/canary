local mitmahVanguardExitConfig = {
	arenaExit = Position(34068, 31418, 11),
	destination = Position(34053, 31431, 11),
}

local mitmahVanguardExit = Action()

function mitmahVanguardExit.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player then
		return false
	end
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	player:teleportTo(mitmahVanguardExitConfig.destination)
end

mitmahVanguardExit:position(mitmahVanguardExitConfig.arenaExit)
mitmahVanguardExit:register()
