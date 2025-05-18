local data = {}

local lowerRoshamuulGravel = Action()
function lowerRoshamuulGravel.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local bucket = player:getItemById(2873, true, 0)
	if bucket == nil then
		return fromPosition:sendMagicEffect(3)
	end

	if not data[player:getId()] then
		data[player:getId()] = 0
	end

	data[player:getId()] = data[player:getId()] + 1
	if data[player:getId()] > 10 then
		bucket:transform(20053)
		data[player:getId()] = 0
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You gather some fine gravel.")
	item:transform(20134)
	item:decay()
	return true
end

lowerRoshamuulGravel:id(20133)
lowerRoshamuulGravel:register()
