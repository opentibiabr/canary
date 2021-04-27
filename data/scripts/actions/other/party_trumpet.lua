local partyTrumpet = Action()

function partyTrumpet.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	item:transform(13578)
	item:decay()
	player:say("TOOOOOOT!", TALKTYPE_MONSTER_SAY)
	fromPosition:sendMagicEffect(CONST_ME_SOUND_BLUE)
	return true
end

partyTrumpet:id(6572)
partyTrumpet:register()
