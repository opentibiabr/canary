local mysterious = Action()

function mysterious.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	player:say("This metal egg seems to be locked by a strange mechanism. The time for it to reveal its contents has not yet come.", TALKTYPE_MONSTER_SAY)
end

mysterious:id(19065, 22739)
mysterious:register()
