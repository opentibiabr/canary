local stash = Action()

function stash.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	player:openStash()
	return true
end

stash:id(28750)
stash:register()
