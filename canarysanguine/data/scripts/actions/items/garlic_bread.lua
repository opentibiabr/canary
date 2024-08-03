local garlicBread = Action()

function garlicBread.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	player:say("After taking a small bite you decide that you don't want to eat that.", TALKTYPE_MONSTER_SAY)
	return true
end

garlicBread:id(8194)
garlicBread:register()
