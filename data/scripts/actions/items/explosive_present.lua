local explosivePresent = Action()

function explosivePresent.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	player:say("KABOOOOOOOOOOM!", TALKTYPE_MONSTER_SAY)
	player:getPosition():sendMagicEffect(CONST_ME_FIREAREA)
	player:addAchievement("Joke's on You")
	item:remove()
	return true
end

explosivePresent:id(906)
explosivePresent:register()
