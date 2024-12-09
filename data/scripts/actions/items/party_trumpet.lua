local partyTrumpet = Action()

function partyTrumpet.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	player:say("TOOOOOOT!", TALKTYPE_MONSTER_SAY)
	fromPosition:sendMagicEffect(CONST_ME_SOUND_BLUE)
	item:transform(6573)
	item:decay()
	return true
end

partyTrumpet:id(6572)
partyTrumpet:register()
