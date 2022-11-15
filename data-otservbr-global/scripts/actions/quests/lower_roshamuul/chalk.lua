local data = {}
local fineChalk = {
	{x = 33199, y = 31762, z = 4},
	{x = 33199, y = 31761, z = 4},
	{x = 33200, y = 31761, z = 4},
	{x = 33200, y = 31760, z = 4}
}

local lowerRoshamuulChalk = Action()
function lowerRoshamuulChalk.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local bucket = player:getItemById(2873, true, 0)
    if bucket == nil then
        return fromPosition:sendMagicEffect(CONST_ME_POFF)
    end
    if not data[player:getId()] then
        data[player:getId()] = 0
    end
	data[player:getId()] = data[player:getId()] + 1
	for a = 1, #fineChalk do
		if item:getPosition() == Position(fineChalk[a]) then
			bucket:transform(28468)
		elseif data[player:getId()] > 10 then
			bucket:transform(20054)
			data[player:getId()] = 0
		end
	end
	item:transform(20136)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You fill some of the fine chalk into a bucket.")
    return true
end

lowerRoshamuulChalk:id(20125)
lowerRoshamuulChalk:register()
