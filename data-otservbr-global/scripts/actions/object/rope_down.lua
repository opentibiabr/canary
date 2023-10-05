local action = Action()

function action.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player then
		return false
	end
	player:teleportTo(Position(33394, 32650, 2))
end

action:position(Position(33395, 32651, 1))
action:register()
