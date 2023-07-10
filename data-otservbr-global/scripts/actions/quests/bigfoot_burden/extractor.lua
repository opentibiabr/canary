local bigfootExtractor = Action()
function bigfootExtractor.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local extractedCount = player:getStorageValue(Storage.BigfootBurden.ExtractedCount)
	if extractedCount == 7
			or player:getStorageValue(Storage.BigfootBurden.MissionRaidersOfTheLostSpark) ~= 1 then
		return false
	end

	if target.itemid == 16197 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This body is not ready yet.")
		return true
	end

	if target.itemid ~= 16194 then
		return false
	end

	player:setStorageValue(Storage.BigfootBurden.ExtractedCount, math.max(0, extractedCount) + 1)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You gathered a spark.')
	target:transform(16195)
	toPosition:sendMagicEffect(CONST_ME_ENERGYHIT)
	return true
end

bigfootExtractor:id(15696)
bigfootExtractor:register()