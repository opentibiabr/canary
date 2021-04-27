local whatFoolishCrate = Action()
function whatFoolishCrate.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid ~= 7481 then
		return false
	end

	if player:getStorageValue(Storage.WhatAFoolish.Questline) ~= 8 then
		return false
	end

	player:getPosition():sendMagicEffect(CONST_ME_SOUND_GREEN)
	player:say('Your innocent whistle will fool them all...', TALKTYPE_MONSTER_SAY)
	toPosition:sendMagicEffect(CONST_ME_BLOCKHIT)
	item:transform(item.itemid + 1)
	return true
end

whatFoolishCrate:id(7482)
whatFoolishCrate:register()