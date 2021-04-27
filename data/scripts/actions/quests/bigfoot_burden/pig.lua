local bigfootPig = Action()
function bigfootPig.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid ~= 18341 then
		return false
	end

	local mushroomCount = player:getStorageValue(Storage.BigfootBurden.MushroomCount)
	if player:getStorageValue(Storage.BigfootBurden.MissionMushroomDigger) ~= 1 then
		return false
	end

	if mushroomCount == 3 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The little pig is stuffed and you better return it home.")
		return true
	end

	player:setStorageValue(Storage.BigfootBurden.MushroomCount, mushroomCount + 1)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The little pig happily eats the truffles.')
	target:transform(18218)
	toPosition:sendMagicEffect(CONST_ME_GROUNDSHAKER)
	return true
end

bigfootPig:id(18339)
bigfootPig:register()