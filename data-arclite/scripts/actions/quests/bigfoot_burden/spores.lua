local config = {
	[15817] = 15705,
	[15818] = 15706,
	[15819] = 15707,
	[15820] = 15708
}

local bigfootSpores = Action()
function bigfootSpores.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local spores = config[item.itemid]
	if not spores then
		return false
	end

	local sporeCount = player:getStorageValue(Storage.BigfootBurden.SporeCount)
	if sporeCount == 4 or player:getStorageValue(Storage.BigfootBurden.MissionSporeGathering) ~= 1 then
		return false
	end

	if target.itemid ~= spores then
		player:setStorageValue(Storage.BigfootBurden.SporeCount, 0)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have gathered the wrong spores. You ruined your collection.')
		item:transform(15817)
		toPosition:sendMagicEffect(CONST_ME_POFF)
		return true
	end

	player:setStorageValue(Storage.BigfootBurden.SporeCount, sporeCount + 1)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have gathered the correct spores.')
	item:transform(item.itemid + 1)
	toPosition:sendMagicEffect(CONST_ME_GREEN_RINGS)
	return true
end

bigfootSpores:id(15817,15818,15819,15820)
bigfootSpores:register()